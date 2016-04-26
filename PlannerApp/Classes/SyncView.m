//
//  SyncView.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncView.h"
#import "Settings.h"

@implementation SyncView
@synthesize googleCalendarService;
#import "GDataFeedCalendar.h"
#import "GDataWhen.h"
#import "GDataWhere.h"

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.contentSizeForViewInPopover=CGSizeMake(320, 400);
	appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	array_sync=[[NSMutableArray alloc]initWithObjects:@"Sync Normal",@"Replace Server Data",@"Replace this App Data",@"Merge",nil];
    UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    [doubleTap release];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    index=0;
    
    
    googleCalendarService = [[GDataServiceGoogleCalendar alloc] init];
    [googleCalendarService setUserAgent:@"Planner"];
    
    [googleCalendarService setUserCredentialsWithUsername:appdel.username
                                                 password:appdel.password]; 
    NSLog(@"%@  %@",appdel.username,appdel.password);
    section=0;
    datacntsec=0;
    arrFinalData=[[NSMutableArray alloc] init];
    
    data = [[NSMutableArray alloc] init];
}

- (IBAction)tapDetected:(UIGestureRecognizer *)sender{
    
    NSLog(@"tap");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissmissSync" object:self];
    // PlannerAppViewController *plannerOb=[[PlannerAppViewController alloc] init];
    
    //[plannerOb dissmissProgress:sender];
    
}
#pragma mark Utility methods for searching index paths.

- (NSDictionary *)dictionaryForIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section<[data count] )
        return [data objectAtIndex:indexPath.section];
    return nil;
}

- (NSMutableArray *)eventsForIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictionary = [self dictionaryForIndexPath:indexPath];
    if( dictionary )
        return [dictionary valueForKey:KEY_EVENTS];
    return nil;
}

- (GDataEntryCalendarEvent *)eventForIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *events = [self eventsForIndexPath:indexPath];
    if( events && indexPath.row<[events count] )
        return [events objectAtIndex:indexPath.row];
    return nil;
}

#pragma mark Google Data APIs

- (void)refresh{
    // Note: The next call returns a ticket, that could be used to cancel the current request if the user chose to abort early.
    // However since I didn't expose such a capability to the user, I don't even assign it to a variable.
    [data removeAllObjects];
    [googleCalendarService fetchCalendarFeedForUsername:appdel.username
                                               delegate:self
                                      didFinishSelector:@selector( calendarsTicket:finishedWithFeed: )
                                        didFailSelector:@selector( ticket:failedWithError: )];
}

- (void)calendarsTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedCalendar *)feed{
    int count = [[feed entries] count];
    for( int i=0; i<count; i++ ){
        GDataEntryCalendar *calendar = [[feed entries] objectAtIndex:i];
        
        // Create a dictionary containing the calendar and the ticket to fetch its events.
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        
        [dictionary setObject:calendar forKey:KEY_CALENDAR];
        [dictionary setObject:[[NSMutableArray alloc] init] forKey:KEY_EVENTS];
        if( [calendar ACLLink] )  // We can determine whether the calendar is under user's control by the existence of its ACL link.
            [dictionary setObject:KEY_EDITABLE forKey:KEY_EDITABLE];
        
        NSURL *feedURL = [[calendar alternateLink] URL];
        if( feedURL ){
            GDataQueryCalendar* query = [GDataQueryCalendar calendarQueryWithFeedURL:feedURL];
            
            // Currently, the app just shows calendar entries from 15 days ago to 31 days from now.
            // Ideally, we would instead use similar controls found in Google Calendar web interface, or even iCal's UI.
            NSDate *minDate = [NSDate date];  // From right now...
            GDataDateTime *updatedMinTime = [GDataDateTime dateTimeWithDate:minDate timeZone:[NSTimeZone systemTimeZone]];
            [query setMinimumStartTime:updatedMinTime];
            
            NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*90];  // ...to 90 days from now.
            GDataDateTime *updatedMaxTime = [GDataDateTime dateTimeWithDate:maxDate timeZone:[NSTimeZone systemTimeZone]];
            [query setMaximumStartTime:updatedMaxTime];
            
            [query setOrderBy:@"starttime"];  // http://code.google.com/apis/calendar/docs/2.0/reference.html#Parameters
            [query setIsAscendingOrder:YES];
            [query setShouldExpandRecurrentEvents:YES];
            
            GDataServiceTicket *ticket = [googleCalendarService fetchCalendarQuery:query
                                                                          delegate:self
                                                                 didFinishSelector:@selector( eventsTicket:finishedWithEntries: )
                                                                   didFailSelector:@selector( ticket:failedWithError: )];
            // I add the service ticket to the dictionary to make it easy to find which calendar each reply belongs to.
            [dictionary setObject:ticket forKey:KEY_TICKET];
            [data addObject:dictionary];
            [dictionary release];
        }
    }
    
    
    
    [self getInfoCalendar];
}

- (void)eventsTicket:(GDataServiceTicket *)ticket finishedWithEntries:(GDataFeedCalendarEvent *)feed{
    NSMutableDictionary *dictionary;
    for( int section1=0; section1<[data count]; section1++ ){
        NSMutableDictionary *nextDictionary = [data objectAtIndex:section1];
        GDataServiceTicket *nextTicket = [nextDictionary objectForKey:KEY_TICKET];
        if( nextTicket==ticket ){		// We've found the calendar these events are meant for...
            dictionary = nextDictionary;
            break;
        }
    }
    
    if( !dictionary )
        return;		// This should never happen.  It means we couldn't find the ticket it relates to.
    
    int count = [[feed entries] count];
    
    NSMutableArray *events = [dictionary objectForKey:KEY_EVENTS];
    for( int i=0; i<count; i++ ){
        GDataEntryCalendarEvent *event = [[feed entries] objectAtIndex:i];
        [events addObject:event];
    }
    
    
    
    NSURL *nextURL = [[feed nextLink] URL];
    if( nextURL ){
        NSLog( @"There are more events...  Fetching again." );
        GDataServiceTicket *ticket = [googleCalendarService fetchCalendarEventFeedWithURL:nextURL
                                                                                 delegate:self
                                                                        didFinishSelector:@selector( eventsTicket:finishedWithEntries: )   // Right back here...
                                                                          didFailSelector:@selector( ticket:failedWithError: )];
        // Update the ticket in the dictionary for the next batch.
        [dictionary setObject:ticket forKey:KEY_TICKET];
    }
    [self getInfoCalendar];
}

- (void)deleteCalendarEvent:(GDataEntryCalendarEvent *)calendarEvent{
    [googleCalendarService deleteCalendarEventEntry:calendarEvent
                                           delegate:self
                                  didFinishSelector:nil
                                    didFailSelector:@selector( ticket:failedWithError: )];
}

- (void)insertCalendarEvent:(GDataEntryCalendarEvent *)newEvent toCalendar:(GDataEntryCalendar *)calendar{
    [googleCalendarService fetchCalendarEventByInsertingEntry:newEvent
                                                   forFeedURL:[[calendar alternateLink] URL]
                                                     delegate:self
                                            didFinishSelector:@selector( insertTicket:finishedWithEntry: )
                                              didFailSelector:@selector( ticket:failedWithError: )];
}

- (void)insertTicket:(GDataServiceTicket *)ticket finishedWithEntry:(GDataEntryCalendarEvent *)entry{
    [self refresh];
}

- (void)updateCalendarEvent:(GDataEntryCalendarEvent *)newEvent toCalendar:(GDataEntryCalendar *)calendar{
    [googleCalendarService fetchCalendarEventEntryByUpdatingEntry:newEvent
                                                      forEntryURL:[[calendar alternateLink] URL]
                                                         delegate:self
                                                didFinishSelector:nil
                                                  didFailSelector:@selector( ticket:failedWithError: )];
}
-(void)getInfoCalendar{
    
    NSIndexPath *indexPath;
    //NSLog(@"data count %d",[data count]);
    if([data count]>=1){
        indexPath=[NSIndexPath indexPathForRow:index inSection:datacntsec];
    }
    
    
    NSArray *events = [self eventsForIndexPath:indexPath];
    if([events count]>0){
        index=0;
        datacntsec++;
        section=0;
    }
   
    
    // The DetailCell has two modes of display - either the typical record or a prompt for creating a new item
    
    for(int i=0;i<[events count];i++){
        
        GDataEntryCalendarEvent *event = [events objectAtIndex:i];
        GDataWhen *when = [[event objectsForExtensionClass:[GDataWhen class]] objectAtIndex:0];
        if( when ){
             NSLog(@"index is %d  sect count %d",index,datacntsec-1);
            GDataDateTime *dateTime = [when startTime];
            NSString *str = [NSString stringWithFormat:@"%@", [dateTime date]] ;
            GDataDateTime *dateTime1 = [when endTime];
            NSString *str1 = [NSString stringWithFormat:@"%@", [dateTime1 date]] ;
            NSLog(@"str is %@",str);
            NSLog(@"%@",[str substringToIndex:10]) ;
            NSLog(@"%@",[[event title] stringValue]);
            NSString *strTitle=[[event title] stringValue];
            
            
            
            NSMutableDictionary *dictAddCal=[[NSMutableDictionary alloc] init];
             [dictAddCal setObject:[NSString stringWithFormat:@"%@",str1] forKey:@"endtime"];
            [dictAddCal setObject:[NSString stringWithFormat:@"%@",str] forKey:@"starttime"];
            [dictAddCal setObject:[NSString stringWithFormat:@"%@",strTitle] forKey:@"title"];
           NSLog(@"dict is %@",dictAddCal);
            [arrFinalData addObject:[NSString stringWithFormat:@"%@",dictAddCal]];
            //[arrFinalData addObject:[NSString stringWithFormat:@"%@",str]];
            //[arrFinalData addObject:[NSString stringWithFormat:@"%@",strTitle]];
            NSLog(@"arr final data is %@",arrFinalData);
            
            if(dictAddCal!=nil){
                [dictAddCal removeAllObjects];
                [dictAddCal release];
                dictAddCal=nil;
            }
            index++;
            //[str substringWithRange:NSMakeRange( 11, 8)];
        }
        
        
        
        //cell.name.text = [[event title] stringValue];
        // Note: An event might have multiple locations.  We're only displaying the first one.
        
    }
  
    
}
- (void)ticket:(GDataServiceTicket *)ticket failedWithError:(NSError *)error{
    NSString *title, *msg;
    if( [error code]==kGDataBadAuthentication ){
        title = @"Authentication Failed";
        msg = @"Invalid username/password\n\nPlease go to the iPhone's settings to change your Google account credentials.";
    }else{
        // some other error authenticating or retrieving the GData object or a 304 status
        // indicating the data has not been modified since it was previously fetched
        title = @"Unknown Error";
        msg = [error localizedDescription];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    // [self getInfoCalendar];
    
    
}




/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [array_sync count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text=[array_sync objectAtIndex:indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self performSelector:@selector(refresh) withObject:self afterDelay:5.0];
     //[[NSNotificationCenter defaultCenter] postNotificationName:@"dissmissSync" object:self];
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end


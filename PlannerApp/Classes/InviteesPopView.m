//
//  InviteesPopView.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "InviteesPopView.h"



@implementation InviteesPopView
@synthesize strSID,strMID,strCID;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title =@"Invitees";
	self.contentSizeForViewInPopover=CGSizeMake(320, 460);
    appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication]delegate];
    arrListContacts=[[NSMutableArray alloc] init];
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Send Invitation" style:UIBarButtonItemStyleDone target:self action:@selector(sendInvitation)];
    
    
    [self.navigationItem setRightBarButtonItem:doneButton];
    [doneButton release];
    

    
}
-(void)viewWillAppear:(BOOL)animated{
     arrListContacts=[[NSMutableArray alloc] init];
     arrUID=[[NSMutableArray alloc] init];
}
-(void)sendInvitation{
    [self JSONDelegate];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{        
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 44)] autorelease]; // x,y,width,height
    
    UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];    
    reportButton.frame = CGRectMake(80.0, 0, 160.0, 40.0); // x,y,width,height
    [reportButton setTitle:@"Show Contacts" forState:UIControlStateNormal];
    [reportButton addTarget:self 
                     action:@selector(Click:)
           forControlEvents:UIControlEventTouchDown];        
    
    [headerView addSubview:reportButton];
    return headerView;    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrListContacts count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//btn.selected = TRUE;
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    
    cell.textLabel.text=[arrListContacts objectAtIndex:indexPath.row] ;
    // Configure the cell...
   
	
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
        
    
}

-(IBAction)Click:(id)sender
{
	ABPeoplePickerNavigationController *picker =
	
	[[ABPeoplePickerNavigationController alloc] init];
	
	picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
	[picker release];
	
}
- (void)peoplePickerNavigationControllerDidCancel:

(ABPeoplePickerNavigationController *)peoplePicker {
	
    [self dismissModalViewControllerAnimated:YES];
	
}



- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    
    
    ABMultiValueRef emails = ABRecordCopyValue(person, property);
    CFStringRef email = ABMultiValueCopyValueAtIndex(emails, identifier);
    NSLog( (NSString *) email);
    strEmail = (NSString *) email;
    [self dismissModalViewControllerAnimated:YES];
    
    [arrListContacts addObject:[NSString stringWithFormat:@"%@",strEmail]];
    
    [tblContact reloadData];
    [self findEmail];
    
    
    return NO;
}
-(void)findEmail{
    NSString *str;
    //http://openxcellaus.info/emainder/user_action.php?action=userlist
    str=[NSString stringWithFormat:@"%@/user_action.php?action=userlist",appdel.url];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchEmail:) andHandler:self];
    NSLog(@"%@",parser);
}
-(void)searchEmail:(NSDictionary*)dictionary{
    [AlertHandler hideAlert];
    NSLog(@"%@",dictionary);
    int flagemai=0;
    NSString *strUID;
    NSMutableArray *arrEmail=(NSMutableArray *)[dictionary valueForKey:@"users"];
    NSLog(@"%@",[arrEmail objectAtIndex:0]);
    for(int y=0;y<[arrEmail count];y++){
        if([[[arrEmail objectAtIndex:y] valueForKey:@"email"] isEqualToString:strEmail]){
            NSLog(@"found");
            flagemai=1;
            strUID=[[arrEmail objectAtIndex:y] valueForKey:@"uid"];
            [arrUID addObject:[NSString stringWithFormat:@"%@",strUID]];
            
        }
    }
    if(flagemai==1){
        //[self JSONDelegate:strEmail strid:strUID];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"The email address is not registered" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [arrListContacts removeLastObject];
        [alert show];
        [alert release];
        [tblContact reloadData];
    }
    
}
-(void)JSONDelegate
{
    
    http://openxcellaus.info/emainder/user_action.php?action=assign_task_multi&uid=1&auidstr=5,6,7&mtid=26
    NSLog(@"%@",arrUID);
    [AlertHandler showAlertForProcess];
    NSString *strid=@"";
    NSString *str;
    for(int i=0;i<[arrUID count];i++){
        strid=[strid stringByAppendingString:[NSString stringWithFormat:@"%@,",[arrUID objectAtIndex:i]]];
    }
    if ( [strid length] > 0)
        strid = [strid substringToIndex:[strid length] - 1];
    
    NSLog(@"strof id is %@",strid);

    NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
    if(strMID)
        str=[NSString stringWithFormat:@"%@/user_action.php?action=assign_task_multi&uid=%@&auidstr=%@&mtid=%@",appdel.url,str_id,strid,strMID];
    else
        str=[NSString stringWithFormat:@"%@/user_action.php?action=assign_sub_task_multi&uid=%@&auidstr=%@&stid=%@",appdel.url,str_id,strid,strSID];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchDelegate:) andHandler:self];
    NSLog(@"%@",parser);
    
	
}
-(void)searchDelegate:(NSDictionary*)dictionary
{
    [AlertHandler hideAlert];
    NSLog(@"%@",dictionary);
    NSMutableArray *arr=[dictionary valueForKey:@"msgs"];
    NSLog(@"%@",[arr objectAtIndex:0]);
    
    if([[[arr objectAtIndex:0] valueForKey:@"msg"] isEqualToString:@"task assigned successfull"] || [[[arr objectAtIndex:0] valueForKey:@"msg"] isEqualToString:@"sub task assigned successfull"]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Invitation Sent Successfully" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Task Cannot be assigned" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissPopOverViewHome" object:self]; 
    
}







/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
-(void)viewWillDisappear:(BOOL)animated{
    if(arrUID!=nil){
        [arrUID removeAllObjects];
        [arrUID release];
        arrUID=nil;
    }
    if(arrListContacts!=nil){
        [arrListContacts removeAllObjects];
        [arrListContacts release];
        arrListContacts=nil;
    }
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

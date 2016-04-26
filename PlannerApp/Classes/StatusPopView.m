//
//  StatusPopView.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StatusPopView.h"
#import "DAL.h"
#import "PlannerAppViewController.h"
#import "AlertHandler.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation StatusPopView
@synthesize tbcell,strID,strStid;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Status";
	//self.contentSizeForViewInPopover=CGSizeMake(320, 460);
	array=[[NSMutableArray alloc] initWithObjects:@"In Progress",@"Delegated",@"On Hold",@"Completed",nil];
    planner = [[PlannerAppViewController alloc] init];
    //imageArray=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"uncheck.jpg"],[UIImage imageNamed:@"images.jpg"],[UIImage imageNamed:@"images1.jpg"],[UIImage imageNamed:@"checksymbol.png"],[UIImage imageNamed:@"cancel.jpg"],nil];strStid	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication]delegate];
    imageArray =[[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"Ellipse 1.png"],[UIImage imageNamed:@"Ellipse.png"],[UIImage imageNamed:@"pause.png"],[UIImage imageNamed:@"checksymbol.png"],nil];
     dal=[[DAL alloc] initDatabase:@"Planner.sqlite"];
     retrieve=[[NSMutableArray alloc] init];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    
    
    [self.navigationItem setRightBarButtonItem:doneButton];
    [doneButton release];
    UIBarButtonItem *canButton=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    
    [self.navigationItem setLeftBarButtonItem:canButton];
    [canButton release];
}
-(void)cancel
{
        [self.navigationController popViewControllerAnimated:YES];
}
    




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 300);
   
    NSLog(@"id is %@",strID);
    NSLog(@"id is %@",strStid);
    if(strStid ){
        NSArray *arrStat=[[NSArray alloc] initWithObjects:@"status", nil];
        retrieve=[dal SelectQuery:@"tblSubTask" withColumn:arrStat withCondition:@"stid=" withColumnValue:[NSString stringWithFormat:@"%@",strStid]];
        NSLog(@"%@",retrieve);
    }
    
    else if(strID){
        NSArray *arrStat=[[NSArray alloc] initWithObjects:@"status", nil];
        retrieve=[dal SelectQuery:@"tblMainTask" withColumn:arrStat withCondition:@"mtid==" withColumnValue:[NSString stringWithFormat:@"%@",strID]];
        NSLog(@"%@",retrieve);
    }
   
    rowselection=[[[retrieve objectAtIndex:0] valueForKey:@"status"] intValue];
    

}
-(void)done{
    NSString *str=[NSString stringWithFormat:@"%d",rowselection];
    NSMutableDictionary *dictstat=[[NSMutableDictionary alloc] init];
    [dictstat setObject:[NSString stringWithFormat:@"%@",str] forKey:@"status"];
    if(strStid){
        [dal updateRecord:dictstat forID:@"stid=" inTable:@"tblSubTask" withValue:[NSString stringWithFormat:@"%@",strStid]];
    }
   
    else{
        [dal updateRecord:dictstat forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strID]];
    }
    if(dictstat!=nil){
        [dictstat removeAllObjects];
        [dictstat release];
        dictstat=nil;
    }
    if(rowselection==1){
        NSString *strimage=[NSString stringWithFormat:@"%d",rowselection];
        [[NSUserDefaults standardUserDefaults] setValue:strimage forKey:@"strimage"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        ABPeoplePickerNavigationController *picker =
        
        [[ABPeoplePickerNavigationController alloc] init];
        
        picker.peoplePickerDelegate = self;
        
        //[self.navigationController pushViewController:picker animated:YES];
        
        [self presentModalViewController:picker animated:YES];
        [picker release];
        
    }
    [self .navigationController popViewControllerAnimated:YES]; 
      

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
            
        }
    }
    if(flagemai==1){
        [self JSONDelegate:strEmail strid:strUID];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"The email address is not registered" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
}
-(void)JSONDelegate:(NSString *)email strid:(NSString *)strid
{
    
    
    [AlertHandler showAlertForProcess];
    NSString *str;
    NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
    if(strID)
    str=[NSString stringWithFormat:@"%@/user_action.php?action=assign_task&uid=%@&auid=%@&mtid=%@",appdel.url,str_id,strid,strID];
    else
        str=[NSString stringWithFormat:@"%@user_action.php?action=assign_sub_task&uid=%@&auid=%@&stid=%@",appdel.url,str_id,strid,strStid];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchDelegate:) andHandler:self];
    NSLog(@"%@",parser);
    
	
}
-(void)searchDelegate:(NSDictionary*)dictionary
{
    
    [AlertHandler hideAlert];
    NSLog(@"%@",dictionary);
    if([[dictionary valueForKey:@"msg"]isEqualToString:@"task already assigned"]){
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"The task has been already assigned" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if([[dictionary valueForKey:@"msg"]isEqualToString:@"task assigned successfull"] && [[dictionary valueForKey:@"status"] isEqualToString:@"Notification sent succesfully"]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Task Delegated Successfully" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissPopOverViewHome" object:self]; 
    
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
    return [array count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  	[[NSBundle mainBundle] loadNibNamed:@"StatusCustomCell" owner:self options:nil];
	cell=self.tbcell;
	self.tbcell=nil;
    //cell.textLabel.text=[array objectAtIndex:indexPath.row];
    // Configure the cell...
	//cell.image=[imageArray objectAtIndex:indexPath.row];
	name.text=[array objectAtIndex:indexPath.row];
	//imageV.image=[UIImage imageNamed:@"images.jpg"];
	imageV.image=[imageArray objectAtIndex:indexPath.row];
    if(indexPath.row==rowselection){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
         cell.accessoryType=UITableViewCellAccessoryNone;
    }
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
   if(appdel.sound==1){
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/smooth_button_click04.wav"];
    
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    //Use audio sevices to create the sound
    
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    
    //Use audio services to play the sound
    
    AudioServicesPlaySystemSound(soundID);  
   }
    rowselection=indexPath.row;
        [tableView reloadData];
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
    [retrieve release];
    retrieve=nil;
}


- (void)dealloc {
    [super dealloc];
}


@end


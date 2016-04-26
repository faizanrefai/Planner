//
//  PriorityPopView.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PriorityPopView.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation PriorityPopView
@synthesize strID,strStid,strCid;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Priority";
	//self.contentSizeForViewInPopover=CGSizeMake(320, 460);
	//pri_array =[[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",nil];
    
    appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication]delegate];
    pri_array=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"Acitical.png"],[UIImage imageNamed:@"BHigh.png"],[UIImage imageNamed:@"C.png"],nil];
    dal=[[DAL alloc] initDatabase:@"Planner.sqlite"];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePrio)];
    
    
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
    retrieveArr=[[NSMutableArray alloc] init];
    NSLog(@"id is %@",strID);
    NSLog(@"id is %@",strStid);
    if(strStid ){
        NSArray *arrStat=[[NSArray alloc] initWithObjects:@"priority", nil];
        retrieveArr=[dal SelectQuery:@"tblSubTask" withColumn:arrStat withCondition:@"stid=" withColumnValue:[NSString stringWithFormat:@"%@",strStid]];
        NSLog(@"%@",retrieveArr);
    }
    else if(strID){
        NSArray *arrStat=[[NSArray alloc] initWithObjects:@"priority", nil];
        retrieveArr=[dal SelectQuery:@"tblMainTask" withColumn:arrStat withCondition:@"mtid==" withColumnValue:[NSString stringWithFormat:@"%@",strID]];
        NSLog(@"%@",retrieveArr);
    }
    else if(strCid){
        NSArray *arrStat=[[NSArray alloc] initWithObjects:@"priority", nil];
        retrieveArr=[dal SelectQuery:@"tblCal" withColumn:arrStat withCondition:@"cid=" withColumnValue:[NSString stringWithFormat:@"%@",strCid]];
        NSLog(@"%@",retrieveArr);
    }
    rowselection=[[[retrieveArr objectAtIndex:0] valueForKey:@"priority"] intValue];
   
    
}
-(void)donePrio{
    NSString *str=[NSString stringWithFormat:@"%d",rowselection];
    NSMutableDictionary *dictstat=[[NSMutableDictionary alloc] init];
    [dictstat setObject:[NSString stringWithFormat:@"%@",str] forKey:@"priority"];
    if(strStid){
        [dal updateRecord:dictstat forID:@"stid=" inTable:@"tblSubTask" withValue:[NSString stringWithFormat:@"%@",strStid]];
    }
    else if(strCid){
        [dal updateRecord:dictstat forID:@"cid=" inTable:@"tblCal" withValue:[NSString stringWithFormat:@"%@",strCid]];
    }
    else{
        [dal updateRecord:dictstat forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strID]];
    }
    if(dictstat!=nil){
        [dictstat removeAllObjects];
        [dictstat release];
        dictstat=nil;
    }
    [self.navigationController popViewControllerAnimated:YES];

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
    return [pri_array count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.imageView.image=[pri_array objectAtIndex:indexPath.row];
    
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
    if(retrieveArr!=nil){
        [retrieveArr release];
        retrieveArr=nil;
    }

}


- (void)dealloc {
    [super dealloc];
    }


@end


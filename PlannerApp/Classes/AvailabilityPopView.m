//
//  AvailabilityPopView.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AvailabilityPopView.h"
#import "DAL.h"

@implementation AvailabilityPopView

@synthesize strMID,strSID,strCID;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title=@"Availability";
	dal=[[DAL alloc] initDatabase:@"Planner.sqlite"];
	array=[[NSMutableArray alloc] initWithObjects:@"Free",@"Busy",nil];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneFolder)];
    
    
    [self.navigationItem setRightBarButtonItem:doneButton];
    [doneButton release];
    
    UIBarButtonItem *canButton=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    
    [self.navigationItem setLeftBarButtonItem:canButton];
    [canButton release];
    
}

-(void)doneFolder{
    
   
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    NSString *strd;
    if(selectedIndex==0){
        strd=@"Free";
    }
    else{
        strd=@"Busy";
    }
    if(strMID){
    [dict setObject:[NSString stringWithFormat:@"%@",strd ]forKey:@"available"];
    [dal updateRecord:dict forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strMID]];
    }
    else if(strCID){
        [dict setObject:[NSString stringWithFormat:@"%@",strd ]forKey:@"avail"];
        [dal updateRecord:dict forID:@"cid=" inTable:@"tblCal" withValue:[NSString stringWithFormat:@"%@",strCID]];
    }
    else{
        [dict setObject:[NSString stringWithFormat:@"%@",strd ]forKey:@"available"];
        [dal updateRecord:dict forID:@"stid=" inTable:@"tblSubTask" withValue:[NSString stringWithFormat:@"%@",strSID]];
    }
    if(dict!=nil){
        [dict removeAllObjects];
        [dict release];
        dict=nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}






- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.contentSizeForViewInPopover=CGSizeMake(320, 120);
    NSMutableArray *ret=[[NSMutableArray alloc] init];
     NSArray *aaray=[[NSArray alloc] initWithObjects:@"available", nil];
    if(strMID){
       
        [ret addObject:[dal SelectQuery:@"tblMainTask" withColumn:aaray withCondition:@"mtid=" withColumnValue:[NSString stringWithFormat:@"%@",strMID]]];
        NSLog(@"%@",ret);
        if([ret count]!=0){
        if([[[[ret objectAtIndex:0] valueForKey:@"available"] objectAtIndex:0] isEqualToString:@"Free"]){
            selectedIndex=0;
        }
        
        else  if([[[[ret objectAtIndex:0] valueForKey:@"available"] objectAtIndex:0] isEqualToString:@"Busy"]){
            selectedIndex=1;
        }
                
        else{
            selectedIndex=3;
        }
        }
    }
    else if(strCID){
        NSArray *arre=[[NSArray alloc] initWithObjects:@"avail", nil];
        [ret addObject:[dal SelectQuery:@"tblCal" withColumn:arre withCondition:@"cid=" withColumnValue:[NSString stringWithFormat:@"%@",strCID]]];
        NSLog(@"%@",ret);
        if([ret count]!=0){
            if([[[[ret objectAtIndex:0] valueForKey:@"avail"] objectAtIndex:0] isEqualToString:@"Free"]){
                selectedIndex=0;
            }
            
            else  if([[[[ret objectAtIndex:0] valueForKey:@"avail"] objectAtIndex:0] isEqualToString:@"Busy"]){
                selectedIndex=1;
            }
            
            else{
                selectedIndex=3;
            }
        }
    }
    else{
        
        [ret addObject:[dal SelectQuery:@"tblSubTask" withColumn:aaray withCondition:@"stid=" withColumnValue:[NSString stringWithFormat:@"%@",strSID]]];
        if([ret count]!=0){
        if([[[[ret objectAtIndex:0] valueForKey:@"available"]objectAtIndex:0] isEqualToString:@"Free"]){
            selectedIndex=0;
        }
        else  if([[[[ret objectAtIndex:0] valueForKey:@"available"] objectAtIndex:0] isEqualToString:@"Busy"]){
            selectedIndex=1;
        }
        else{
            selectedIndex=3;
        }
        }
    }
    if(aaray!=nil){
        [aaray release];
        aaray=nil;
    }
    if(ret!=nil){
        [ret removeAllObjects];
        [ret release];
        ret=nil;
    }
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
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if(indexPath.row==selectedIndex){
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    cell.textLabel.text=[array objectAtIndex:indexPath.row];
    // Configure the cell...
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
    selectedIndex=indexPath.row;
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
}


- (void)dealloc {
    [super dealloc];
}


@end


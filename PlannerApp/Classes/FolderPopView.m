//
//  FolderPopView.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FolderPopView.h"
#import "PlannerAppAppDelegate.h"

@implementation FolderPopView
@synthesize folder_cell,strCID,strMID,strSID;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title=@"Folder";
	self.contentSizeForViewInPopover=CGSizeMake(320, 460);
	btn.selected = TRUE;
    
    appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    folderArray=[[NSMutableArray alloc] initWithObjects:@"Work",@"Family",@"Health",@"Personal",@"Finance",@"Shared",@"Urgent",@"Shopping", nil];
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneFolder)];
    
    
    [self.navigationItem setRightBarButtonItem:doneButton];
    [doneButton release];
    
    UIBarButtonItem *canButton=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    
    [self.navigationItem setLeftBarButtonItem:canButton];
    [canButton release];
    dal=[[DAL alloc] initDatabase:@"Planner.sqlite"];
}
-(void)doneFolder{
    NSLog(@"%@",folderArray);
    NSLog(@"%d",selectedIndex);
    NSMutableDictionary *dictSt=[[NSMutableDictionary alloc] init];
    if(selectedIndex==1){
        
        [dictSt setObject:@"12" forKey:@"scid"];
        
        [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strMID]];
        
    }
    else if(selectedIndex==0){
        [dictSt setObject:@"1" forKey:@"scid"];
        
        [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strMID]];
    }
    else if(selectedIndex==3){
        [dictSt setObject:@"6" forKey:@"scid"];
        
        [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strMID]];
    }
    else if(selectedIndex==2){
        [dictSt setObject:@"15" forKey:@"scid"];
        
        [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strMID]];
    }
    else if(selectedIndex==4){
        [dictSt setObject:@"20" forKey:@"scid"];
        
        [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strMID]];
    }
    else if(selectedIndex==5){
        [dictSt setObject:@"26" forKey:@"scid"];
        
        [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strMID]];
    }
    else if(selectedIndex==6){
        [dictSt setObject:@"27" forKey:@"scid"];
        
        [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strMID]];
    }
    else if(selectedIndex==7){
        [dictSt setObject:@"28" forKey:@"scid"];
        
        [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strMID]];
    }
    if(dictSt!=nil){
        [dictSt removeAllObjects];
        [dictSt release];
        dictSt=nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissPopOverViewHome" object:self];
    
}
-(void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)clickOnButton:(id)sender
{
	if(btn.selected == TRUE)
	{
		btn.selected = FALSE;
		[btn setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateNormal];
	}
	if(btn.selected == FALSE)
	{
		btn.selected = TRUE;
		//[btn setImage:[UIImage imageNamed:@"uncheck.jpg"] forState:UIControlStateNormal];
	}
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@",appdel.str_mcid);
    selectedIndex=[appdel.str_mcid intValue]-1;
    
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
    return [folderArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//btn.selected = TRUE;

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
   
    cell.textLabel.text=[folderArray objectAtIndex:indexPath.row];
    // Configure the cell...
   	if (indexPath.row==selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
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


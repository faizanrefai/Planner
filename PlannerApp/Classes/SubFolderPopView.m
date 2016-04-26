//
//  SubFolderPopView.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SubFolderPopView.h"
#import "DAL.h"

@implementation SubFolderPopView
@synthesize strMID,strSID,strCID;
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
    arrSubCat=[[NSMutableArray alloc] init];
    dal=[[DAL alloc] initDatabase:@"Planner.sqlite"];
    appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneFolder)];
    
    
    [self.navigationItem setRightBarButtonItem:doneButton];
    [doneButton release];
    
    UIBarButtonItem *canButton=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    
    [self.navigationItem setLeftBarButtonItem:canButton];
    [canButton release];
    
}
-(void)doneFolder{
    
    NSLog(@"%@",arrSubCat);
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    NSString *strd=[[arrSubCat objectAtIndex:selectedIndex ]valueForKey:@"scid"];
    [dict setObject:[NSString stringWithFormat:@"%@",strd ]forKey:@"scid"];
    [dal updateRecord:dict forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strMID]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissPopOverViewHome" object:self];
}
-(void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

	


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.contentSizeForViewInPopover=CGSizeMake(320, 320);
    NSLog(@"%@",appdel.str_mcid);
    
    NSLog(@"%d",selectedIndex);
    NSArray *arrcols=[[NSArray alloc] initWithObjects:@"titleCat",@"scid", nil];
   
    arrSubCat=[[dal SelectQuery:@"tblSubCat" withColumn:arrcols withCondition:@"mcid=" withColumnValue:[NSString stringWithFormat:@"%@",appdel.str_mcid]] retain];
    NSLog(@"%@",arrSubCat);
     NSLog(@"%@",strCID);
    for(int i=0;i<[arrSubCat count];i++){
      
        NSString *strtemp=[NSString stringWithFormat:@"%@",[[arrSubCat objectAtIndex:i]valueForKey:@"scid"]];
        
        if([strCID intValue]==[strtemp intValue]){
            selectedIndex=i;
        }
    }
    
    NSLog(@"%d",selectedIndex);
    NSLog(@"%@",strMID);
    NSLog(@"%@",strSID);
   
    
}
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
    return [arrSubCat count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//btn.selected = TRUE;
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    
    cell.textLabel.text=[[arrSubCat objectAtIndex:indexPath.row] valueForKey:@"titleCat"];
    // Configure the cell...
   	if (indexPath.row==selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
	
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
    selectedIndex=indexPath.row;
    
    [tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
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

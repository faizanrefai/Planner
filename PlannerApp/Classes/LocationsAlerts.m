//
//  LocationsAlerts.m
//  PlannerApp
//
//  Created by Openxcell on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationsAlerts.h"
#import "AddNewLocation.h"
@implementation LocationsAlerts

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{   
    [super viewDidLoad];
    [tblLocation setBackgroundView:nil];
//	self.contentSizeForViewInPopover=CGSizeMake(320, 460);
    appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication]delegate ];
    appdel.arrLocation=[[NSMutableArray alloc]initWithObjects:@"Location1",@"Location2", nil];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    if(appdel.str)
    [appdel.arrLocation addObject:[NSString stringWithFormat:@"%@",appdel.str]];
    NSLog(@"%@",appdel.arrLocation);
    [tblLocation reloadData];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(IBAction)addNewLocation:(id)sender{
    AddNewLocation *objAddNewLocation=[[AddNewLocation alloc]initWithNibName:@"AddNewLocation" bundle:nil];
    [self.navigationController pushViewController:objAddNewLocation animated:YES];
    [objAddNewLocation release];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [appdel.arrLocation count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text=[appdel.arrLocation objectAtIndex:indexPath.row];
    
   
    
    return cell;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end

//
//  StatusView.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StatusView.h"
#import "PlannerAppViewController.h"


@implementation StatusView


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.contentSizeForViewInPopover = CGSizeMake(200, 200);
	statusArray =[[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"Ellipse 1.png"],[UIImage imageNamed:@"Ellipse.png"],[UIImage imageNamed:@"pause.png"],[UIImage imageNamed:@"checksymbol.png"],nil];
    arrayText=[[NSArray alloc] initWithObjects:@"In Progress",@"Delegated",@"On Hold",@"Completed",nil];
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    return [statusArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the cell...
    cell.image=[statusArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[arrayText objectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
	NSString *strimage=[NSString stringWithFormat:@"%d",indexPath.row];
	[[NSUserDefaults standardUserDefaults] setValue:strimage forKey:@"strimage"];
	[[NSUserDefaults standardUserDefaults] synchronize];
    if(indexPath.row==1){
        ABPeoplePickerNavigationController *picker =
        
        [[ABPeoplePickerNavigationController alloc] init];
        
        picker.peoplePickerDelegate = self;
        
        //[self.navigationController pushViewController:picker animated:YES];
        
        [self presentModalViewController:picker animated:YES];
        [picker release];

    }
	else{
	UIImage *image=[statusArray objectAtIndex:indexPath.row];
	
        [planner CallMethod:image indexis:indexPath.row email:@""];
    }
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef emails = ABRecordCopyValue(person, property);
    CFStringRef email = ABMultiValueCopyValueAtIndex(emails, identifier);
    NSLog( (NSString *) email);
    //self.receiverEmail.text = (NSString *) email;
   [self dismissModalViewControllerAnimated:YES];
    UIImage *image=[statusArray objectAtIndex:1];
	
   
    
    [planner CallMethod:image indexis:1 email:(NSString *)email];
    return NO;
}

//- (BOOL)peoplePickerNavigationController:
//
//(ABPeoplePickerNavigationController *)peoplePicker
//
//      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
//	
//	       
//    
//    
//    
//    
//    NSArray* namestr = (NSArray *)ABRecordCopyValue(person,
//                                                      
//                                                      kABPersonEmailProperty);
//    NSLog(@"%@",namestr);
//    
//	
//    
//	
//    //[name release];
//	
//	[namestr release];
//	
//   	
//    [self dismissModalViewControllerAnimated:YES];
//	
//	
//	
//    return NO;
//	
//}
- (void)peoplePickerNavigationControllerDidCancel:

(ABPeoplePickerNavigationController *)peoplePicker {
	
    [self dismissModalViewControllerAnimated:YES];
	
}

-(void)setParent:(PlannerAppViewController *)ViewObj
{
	planner = [[PlannerAppViewController alloc] init];
	planner = ViewObj;
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
    arrayText=nil;
    statusArray=nil;
}


- (void)dealloc {
    [super dealloc];
    [arrayText release];
    [statusArray release];
}


@end


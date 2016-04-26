//
//  StatusPopView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAL.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PlannerAppViewController.h"
#import "PlannerAppAppDelegate.h"
@interface StatusPopView : UITableViewController<ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate> 
{
	NSMutableArray *imageArray;
	NSMutableArray *array;
	IBOutlet UITableViewCell *tbcell;
	IBOutlet UILabel *name;
	IBOutlet UIImageView *imageV;
    NSString *strMID;
    NSString *strStid;
    int rowselection;
    DAL *dal;
    NSMutableArray *retrieve;
    PlannerAppViewController *planner;
    PlannerAppAppDelegate *appdel;
    NSString *strEmail;
 
}
@property (nonatomic,retain)IBOutlet UITableViewCell *tbcell;
@property(nonatomic,retain)NSString *strID;

@property(nonatomic,retain)NSString *strStid;
-(void)CallMethod:(int)indexis email:(NSString *)email;
-(void)done;
-(void)findEmail;
-(void)JSONDelegate:(NSString *)email strid:(NSString *)strid;
@end

//
//  StatusView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppViewController.h"
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@class PlannerAppViewController;

@protocol StatusPickerDelegate
- (void)statusSelected:(NSString *)row;
@end
@interface StatusView : UITableViewController<ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate> 
{
	PlannerAppViewController *planner;
    id<StatusPickerDelegate> _delegate;
	NSMutableArray *statusArray;

	BOOL flagvalue;
    NSArray *arrayText;
}
@property (nonatomic, assign) id<StatusPickerDelegate> delegate;
@end




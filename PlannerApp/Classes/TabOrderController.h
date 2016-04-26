//
//  TabOrderController.h
//  PlannerApp
//
//  Created by Openxcell on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppViewController.h"
@class PlannerAppViewController;
@protocol TabOrderViewDelegate <NSObject>
- (void)addItemViewController:(PlannerAppViewController *)controller ReorderedArray:(NSMutableArray *)arr;
@end

@interface TabOrderController : UITableViewController<TabOrderViewDelegate>{
    NSMutableArray *arrTabOrder;
}
@property(nonatomic,retain)NSMutableArray *arrTabOrder;
@property (nonatomic, retain) id <TabOrderViewDelegate> delegate;

@end

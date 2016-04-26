//
//  PriorityView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppViewController.h"

@class PlannerAppViewController;
@interface PriorityView : UITableViewController 
{
	NSMutableArray *array;
    PlannerAppViewController *planner;
}
@property(nonatomic,retain)PlannerAppViewController *planner;

@end

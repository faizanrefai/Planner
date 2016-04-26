//
//  LocationAlertsIPhone.h
//  PlannerApp
//
//  Created by Openxcell on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppAppDelegate.h"
@interface LocationAlertsIPhone :UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *tblLocation;
    PlannerAppAppDelegate *appdel;
    //NSMutableArray *arrLocation;
}
-(IBAction)addNewLocation:(id)sender;
@end

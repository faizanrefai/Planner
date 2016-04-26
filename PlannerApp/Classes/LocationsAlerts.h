//
//  LocationsAlerts.h
//  PlannerApp
//
//  Created by Openxcell on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppAppDelegate.h"
@interface LocationsAlerts : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *tblLocation;
    PlannerAppAppDelegate *appdel;
    //NSMutableArray *arrLocation;
}
-(IBAction)addNewLocation:(id)sender;
@end

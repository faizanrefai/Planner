//
//  SyncSubViewIPhone.h
//  PlannerApp
//
//  Created by Openxcell on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppAppDelegate.h"
@interface SyncSubViewIPhone : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UITableView *tblSync;
    NSArray *arrSync;
    PlannerAppAppDelegate *appdel;
}
@end

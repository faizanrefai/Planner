//
//  LocationType.h
//  PlannerApp
//
//  Created by Openxcell on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppAppDelegate.h"
@class AddNewLocation;
@interface LocationType : UITableViewController{
    NSMutableArray *arrLocationType;
    AddNewLocation *objAdd;
    PlannerAppAppDelegate *appdel;
    

}
-(void)setParent:(AddNewLocation*)ViewObj;
@end

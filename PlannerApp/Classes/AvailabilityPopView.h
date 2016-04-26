//
//  AvailabilityPopView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAL.h"

@interface AvailabilityPopView : UITableViewController
{
	NSMutableArray *array;
    DAL *dal;
    int selectedIndex;
    NSString *strMID;
    NSString *strSID;
    NSString *strCID;
    
}
@property(nonatomic,retain)NSString *strMID;
@property(nonatomic,retain)NSString *strSID;
@property(nonatomic,retain) NSString *strCID;
@end

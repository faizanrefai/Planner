//
//  FolderView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCalendarMonthView.h"

@interface FolderView : UIViewController<UITableViewDelegate,UITableViewDataSource,TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource>
{
    IBOutlet UITableView *tbl;
    UIButton *workbtn;
	UIButton *personalbtn;
	UIButton *healthbtn;
	UIButton *familybtn;
	UIButton *financebtn;
    IBOutlet UIButton *taskbutton;
    
    BOOL personal_data;
	BOOL health_data;
	BOOL family_data;
	BOOL finance_data;
	BOOL work_data;
    
    NSMutableArray *work_array;
	NSMutableArray *personal_array;
	NSMutableArray *family_array;
	NSMutableArray *health_array;
	NSMutableArray *finance_array;

    IBOutlet UIView *view1;
    
    IBOutlet UIButton *editBtn;
    IBOutlet UISegmentedControl *segment;
    IBOutlet UIScrollView *scroll;

	IBOutlet UIView *view_cal;

    
}
-(IBAction)taskbuttonClicked:(id)sender;
-(IBAction)clickOnEditBtn:(id)sender;

@end

//
//  ProgressViewControllerIPhone.h
//  PlannerApp
//
//  Created by Openxcell on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressViewControllerIPhone : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
	IBOutlet UITableView *tblprogress;
	NSMutableArray *array_sections;
	NSMutableArray *array_cmplt;
	NSMutableArray *array_progress;
}
-(IBAction)goBack:(id)sender;

@end

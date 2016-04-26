//
//  ProgressViewController.h
//  PlannerApp
//
//  Created by Openxcell on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Progress_SubView.h"
#import "PCPieChart.h"
#import "DAL.h"
@interface ProgressViewController : UIViewController{
   
	
	
    NSMutableArray *arrPieChartData;
    DAL *dal;
    IBOutlet UIView *viewGraph;
    IBOutlet UIView *viewPie;
    IBOutlet UIButton *btnDueDate;
    IBOutlet UIButton *btnFolder;
    
    IBOutlet UIImageView *imgBackGround;
    IBOutlet UIImageView *imgProgress;
    IBOutlet UILabel *lbldueDate;
    IBOutlet UILabel *lblStatus;
    IBOutlet UIImageView *imgFeild;
    
    
}


-(IBAction)clickOnDue:(id)sender;
-(IBAction)clcikOnFolder:(id)sender;
-(void)drawPieChart;

-(void)getCount;
@end

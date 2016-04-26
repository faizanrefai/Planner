//
//  TapView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusPopView.h"
#import "PriorityPopView.h"
#import "RepeatsPopView.h"
#import "DelegatePopView.h"
#import "InviteesPopView.h"
#import "FolderPopView.h"
#import "AvailabilityPopView.h"
#import "NotePopView.h"
#import "SubFolderPopView.h"
#import "LocationPopView.h"
#import "LocationsAlerts.h"
#import "AlertsPopView.h"
#import "PlannerAppViewController.h"
#import "PlannerAppAppDelegate.h"
#import "DAL.h"

@interface TapView : UIViewController <UITableViewDelegate,UITableViewDelegate,UITextFieldDelegate>
{
    IBOutlet UITableView *tbl;
	NSMutableArray *array;
	UIPopoverController * ABPopoverVC;
	int i;
    UIButton *deleteBtn;
	PlannerAppViewController *plan;
    NSString *strTitle;
    NSString *str_mtid;
    NSString *str_stid;
    PlannerAppAppDelegate *appdel;
    int flagEdit;
    DAL *dal;
    UITextField *txt;
    NSString *strCid;
}
@property(nonatomic,retain) NSString *strCid;
@property(nonatomic,assign)int flagEdit;
@property(nonatomic,retain) NSString *str_mtid;
@property(nonatomic,retain) NSString *str_stid;
@property(nonatomic,retain) NSString *str_scid;
@property(nonatomic,retain) NSString *strTitle;
-(void)updateMain;
-(void)updateCalendar;
-(void)updateSub;
-(IBAction)clickOnDone:(id)sender;
-(IBAction)clickOnCancel:(id)sender;
-(IBAction)deleteTask:(id)sender;
-(void)JSON_updateSubTaskTitle;
-(void)JSON_updateMainTask;
@end

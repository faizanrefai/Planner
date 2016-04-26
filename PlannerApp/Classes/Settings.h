//
//  Settings.h
//  PlannerApp
//
//  Created by Openxcell on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppAppDelegate.h"
#import "LocationsAlerts.h"
#import "TabOrderController.h"
#import "GDataServiceGoogleCalendar.h"
#define KEY_CALENDAR @"calendar"
#define KEY_EVENTS @"events"
#define KEY_TICKET @"ticket"
#define KEY_EDITABLE @"editable"
@interface Settings : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITableView *tblLocation;
    PlannerAppAppDelegate *appdel;
    NSMutableArray *arrLoc;
    IBOutlet UILabel *lblSelLoc;
    IBOutlet UILabel *lblSync;
    IBOutlet UILabel *lblColr;
    IBOutlet UILabel *lbltab;
    
    IBOutlet UILabel *lblSorting;
    IBOutlet UILabel *lblSettings;
    IBOutlet UILabel *lblPush;
    IBOutlet UILabel *lblLocationAlert;
    
    
    IBOutlet UIButton *btnGoogle;
    IBOutlet UIButton *btnYahoo;
    IBOutlet UIButton *btnTodo;
    
    IBOutlet UIButton *btnPrio;
    IBOutlet UIButton *btnStat;
    
    
    IBOutlet UIButton *btnPink;
    IBOutlet UIButton *btnYellow;
    IBOutlet UIButton *btnBlue;
    IBOutlet UIButton *btnBlack;
    
    IBOutlet UIButton *btnSound;;
    
    IBOutlet UIButton *btnNotification;
  
    
    CGPoint startPoint;
    
    BOOL isNoti;
    NSMutableArray *arrTab;
    NSMutableArray *arrName;
    NSMutableArray *arrTabName;
    
    IBOutlet UIView *tabView;

    GDataServiceGoogleCalendar *googleCalendarService;
    
     NSMutableArray *data;
    int index;
    int section;
    int datacntsec;
    NSMutableArray *arrFinalData;
    
   
  
    
}
@property (nonatomic, retain) GDataServiceGoogleCalendar *googleCalendarService;
- (void)refresh;
- (void)insertCalendarEvent:(GDataEntryCalendarEvent *)newEvent toCalendar:(GDataEntryCalendar *)calendar;
- (void)updateCalendarEvent:(GDataEntryCalendarEvent *)newEvent toCalendar:(GDataEntryCalendar *)calendar;
-(IBAction)logOut:(id)sender;
-(IBAction)ClickDrop:(id)sender;
-(IBAction)addNewLocation:(id)sender;
-(IBAction)clickGoogle:(id)sender;
-(IBAction)clickYahoo:(id)sender;
-(IBAction)clickTodo:(id)sender;
-(IBAction)clickPrio:(id)sender;
-(IBAction)clickStat:(id)sender;
-(IBAction)clickBlack:(id)sender;
-(IBAction)clickYellow:(id)sender;
-(IBAction)clickBlue:(id)sender;
-(IBAction)clickPink:(id)sender;
-(IBAction)clickNotification:(id)sender;
-(IBAction)clickSound:(id)sender;
-(void)getInfoCalendar;
@end

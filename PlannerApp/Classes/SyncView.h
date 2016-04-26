//
//  SyncView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlannerAppAppDelegate.h"
#import "GDataServiceGoogleCalendar.h"
#define KEY_CALENDAR @"calendar"
#define KEY_EVENTS @"events"
#define KEY_TICKET @"ticket"
#define KEY_EDITABLE @"editable"
@interface SyncView : UITableViewController 
{
	NSMutableArray *array_sync;
    NSMutableArray *data;
    NSMutableArray *arrFinalData;
    int index;
    int section;
    int datacntsec;
    
    PlannerAppAppDelegate *appdel;
    GDataServiceGoogleCalendar *googleCalendarService;
}

@property (nonatomic, retain) GDataServiceGoogleCalendar *googleCalendarService;
- (void)refresh;
- (void)insertCalendarEvent:(GDataEntryCalendarEvent *)newEvent toCalendar:(GDataEntryCalendar *)calendar;
- (void)updateCalendarEvent:(GDataEntryCalendarEvent *)newEvent toCalendar:(GDataEntryCalendar *)calendar;
-(void)getInfoCalendar;
@end

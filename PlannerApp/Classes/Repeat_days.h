//
//  Repeat_days.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepeatsPopView.h"
#import "DAL.h"
@class RepeatsPopView;

@protocol RepeatsPopViewDelegate <NSObject>
- (void)addItemViewController:(RepeatsPopView *)controller didFinishEnteringItem:(NSString *)item;
@end

@interface Repeat_days : UITableViewController <RepeatsPopViewDelegate>
{
	NSMutableArray *day_array;
	RepeatsPopView *pop;
    NSMutableArray *selectedObjects;
    NSString  *SelectedDays;
    int selectedIndex;
    DAL *dal;
    NSString *strMID;
    NSString *strSID;
    NSMutableDictionary *dictValues;
    NSString *strTitle;
    
    
}
- (void)scheduleNotificationWithItem:(NSDictionary*)item;
@property(nonatomic,retain)NSString *strSID;
@property(nonatomic,retain) NSString *strMID;
@property(nonatomic,retain)NSString  *SelectedDays;
@property (nonatomic, retain) id <RepeatsPopViewDelegate> delegate;

@end

//
//  RepeatsPopView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repeat_days.h"


@interface RepeatsPopView : UIViewController <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
	IBOutlet UITextField *repeat_text;
	IBOutlet UITextField *start_text;
	IBOutlet UITextField *after_text;
	IBOutlet UITextField *on_text;
	IBOutlet UITextField *repeatsON;
	BOOL isRepeat;
	CGFloat animatedDistance;

	UIPopoverController *pop_repeat;
	IBOutlet UIDatePicker *picker; 
	
	IBOutlet UIButton *btn_never;
	IBOutlet UIButton *btn_on;
	IBOutlet UIButton *btn_after;
	
	IBOutlet UIButton *btn_mon;
	IBOutlet UIButton *btn_tue;
	IBOutlet UIButton *btn_wed;
	IBOutlet UIButton *btn_thu;
	IBOutlet UIButton *btn_fri;
	IBOutlet UIButton *btn_sat;
	IBOutlet UIButton *btn_sun;
	
	IBOutlet UIToolbar *tool;
    IBOutlet UIPickerView *picker_text;
    NSMutableArray *day_array;
    int k;
    
    
    IBOutlet UIView *staticView;
    IBOutlet UIView *repeatsOn;
    IBOutlet UIView *repeatsEvery;
    IBOutlet UIView *viewYear;
    IBOutlet UIPickerView *pickerRepeat;
	
	
}
@property (nonatomic,retain)IBOutlet UITextField *repeat_text;
@property (nonatomic,retain)IBOutlet UITextField *start_text;
@property (nonatomic,retain)IBOutlet UITextField *after_text;
@property (nonatomic,retain)IBOutlet UITextField *on_text;


-(void)CallMehtod:(NSString *)str;
-(IBAction)showdate:(id)sender;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

-(IBAction)clickOnDone:(id)sender;


-(IBAction)neverClicked:(id)sender;
-(IBAction)onClicked:(id)sender;
-(IBAction)afterClicked:(id)sender;

-(IBAction)monClicked:(id)sender;
-(IBAction)tueClicked:(id)sender;
-(IBAction)wedClicked:(id)sender;
-(IBAction)thuClicked:(id)sender;
-(IBAction)friClicked:(id)sender;
-(IBAction)satClicked:(id)sender;
-(IBAction)sunClicked:(id)sender;


@end

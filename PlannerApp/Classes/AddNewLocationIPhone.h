//
//  AddNewLocationIPhone.h
//  PlannerApp
//
//  Created by Openxcell on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppAppDelegate.h"
@interface AddNewLocationIPhone : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    CGFloat animatedDistance;
	UITextField *txtType;
	UITextField *txtCategory;
	
    UIPopoverController *popView;
    PlannerAppAppDelegate *appdel;
    IBOutlet UITableView *tblLocation;
    NSArray *array;
    NSMutableArray *arrType;
    
    UIActionSheet *actionSheetType;
    UIActionSheet *actionSheetCat;
    
	UIButton *btnAdd;
    UITextField *txtName;
    UITextField *txtDistance;
    UITextField *txtAddress;
    IBOutlet UIPickerView *pickerType;
    IBOutlet UIPickerView *pickerCat;
}
-(void)CallMehtod:(NSString *)str;
-(IBAction)addLocation:(id)sender;@end

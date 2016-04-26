//
//  AddNewLocation.h
//  PlannerApp
//
//  Created by Openxcell on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppAppDelegate.h"
#import "LocationType.h"
@interface AddNewLocation : UIViewController<UIPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    LocationType *objLocatiobType;
    CGFloat animatedDistance;
	UITextField *txtType;
	UITextField *txtCategory;
	UITextField *txtfield;
	
	//    IBOutlet UITextField *txtName;
	//    IBOutlet UITextField *txtAddress;
	//    IBOutlet UITextField *txtDistance;
    UIPopoverController *popView;
    PlannerAppAppDelegate *appdel;
    IBOutlet UITableView *tblLocation;
    NSMutableArray *array;
    
    UITextField *txt;
    UIActionSheet *actionSheetCBrand;
    IBOutlet UIPickerView *pickerType;
	UIButton *btn;
    NSString *strStr;
   
    
}
-(void)CallMehtod:(NSString *)str;
-(IBAction)addLocation:(id)sender;
-(IBAction)backButton:(id)sender;
@end
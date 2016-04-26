//
//  RegisterPage.h
//  PlannerApp
//
//  Created by openxcell tech.. on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginPage.h"
#import "JSONParser.h"
#import "PlannerAppAppDelegate.h"

@interface RegisterPage : UIViewController<UITextFieldDelegate,UITabBarDelegate,UITableViewDataSource>
{
   
    IBOutlet UITextField *txt_pwd;
    IBOutlet UITextField *txt_emailid;
    IBOutlet UIButton *btnCheckMark;;
    BOOL isCheck;
    PlannerAppAppDelegate *appdel;
    BOOL emailstatus;
    IBOutlet UIButton *btnMale;
    IBOutlet UIButton *btnFemale;
    NSMutableArray *arrGender;
    NSArray *arrAge;
    IBOutlet UITableView *tblAge;
    IBOutlet UILabel *lblAge;
    int terms;
    IBOutlet UIImageView *imgBack;

}
-(IBAction)clickDrop:(id)sender;
-(IBAction)clickMale:(id)sender;
-(IBAction)clickFemale:(id)sender;
-(IBAction)ClickOnRegister:(id)sender;
-(IBAction)ClickOnCancel:(id)sender;
-(IBAction)ClickonCheckMark:(id)sender;
-(void)JSON;
- (BOOL)validateEmailWithString:(NSString*)email11;

@end

//
//  LoginPage.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppViewController.h"
#import "RegisterPage.h"
#import "JSONParser.h"
#import "PlannerAppAppDelegate.h"
@interface LoginPage : UIViewController<UITextFieldDelegate,UIPopoverControllerDelegate>
{
	IBOutlet UITextField *txt_username;
    IBOutlet UITextField *txt_password;
    PlannerAppAppDelegate *appdel;
    IBOutlet UIButton *btnCheck;
    BOOL isCheck;
    int flag;
    UIPopoverController *popover_tap;
    IBOutlet UIButton *btnFb;
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnReg;
    IBOutlet UIImageView *imgLoginBG;
}

-(void)playSoundOnButtonClick;
-(IBAction)ClickOnLogin:(id)sender;
-(IBAction)ClickOnRegister:(id)sender;
-(IBAction)ClickOnFacebook:(id)sender;
-(IBAction)ClickonCheck:(id)sender;
-(void)JSON;
@end

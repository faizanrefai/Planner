//
//  DelegatePopView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import <Foundation/Foundation.h>
#import "PlannerAppViewController.h"
#import "PlannerAppAppDelegate.h"
#import "DAL.h"
@interface DelegatePopView : UIViewController <ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
	IBOutlet UILabel *name;
    PlannerAppAppDelegate *appdel;
    NSString *strEmail;
    NSString *strMID;
    NSString *strSID;
    DAL *dal;
    MFMailComposeViewController *mail;
}
-(IBAction)Click:(id)sender;
@property(nonatomic,retain) NSString *strMID;
@property(nonatomic,retain) NSString *strSID;
-(void)findEmail;
-(void)JSONDelegate:(NSString *)email strid:(NSString *)strid;
@end

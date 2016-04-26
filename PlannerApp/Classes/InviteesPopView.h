//
//  InviteesPopView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "JSONParser.h"
#import "AlertHandler.h"
#import "PlannerAppAppDelegate.h"
@interface InviteesPopView : UIViewController<UITableViewDataSource,UITableViewDelegate,ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate>
{
    NSString *strMID;
    NSString *strSID;
    NSString *strCID;
    PlannerAppAppDelegate *appdel;
    NSString *strEmail;
    IBOutlet UITableView *tblContact;
    NSMutableArray *arrListContacts;
    NSMutableArray *arrUID;
}
@property(nonatomic,retain)NSString *strMID;
@property(nonatomic,retain)NSString *strSID;
@property(nonatomic,retain)NSString *strCID;
-(IBAction)Click:(id)sender;
-(void)JSONDelegate;
-(void)findEmail;
@end

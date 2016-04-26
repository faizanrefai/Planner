//
//  FolderPopView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppAppDelegate.h"
#import "DAL.h"
@interface FolderPopView : UITableViewController 
{
	NSMutableArray *folderArray;
	IBOutlet UITableViewCell *folder_cell;
	IBOutlet UILabel *lbl;
	IBOutlet UIButton *btn;
    int selectedIndex;
    PlannerAppAppDelegate *appdel;
    DAL *dal;
    NSString *strMID;
    NSString *strSID;
    NSString *strCID;
}


@property (nonatomic,retain) IBOutlet UITableViewCell *folder_cell;
@property(nonatomic,retain)NSString *strMID;
@property(nonatomic,retain)NSString *strSID;
@property(nonatomic,retain)NSString *strCID;
-(IBAction)clickOnButton:(id)sender;
@end

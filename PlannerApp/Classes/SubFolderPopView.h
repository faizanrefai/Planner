//
//  SubFolderPopView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppAppDelegate.h"
#import "DAL.h"
@interface SubFolderPopView : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    PlannerAppAppDelegate *appdel;
    int selectedIndex;
    NSMutableArray *arrSubCat;
    DAL *dal;
    IBOutlet UITableView *tblSubCat;
    NSString *strMID;
    NSString *strSID;
    NSString *strCID;
}
@property(nonatomic,retain)NSString *strMID;
@property(nonatomic,retain)NSString *strSID;
@property(nonatomic,retain)NSString *strCID;
@end

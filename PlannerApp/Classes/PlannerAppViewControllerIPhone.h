//
//  PlannerAppViewControllerIPhone.h
//  PlannerApp
//
//  Created by Openxcell on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FbGraph.h"
#import "PlannerAppAppDelegate.h"
#import "TapView.h"
#import "DAL.h"
@interface PlannerAppViewControllerIPhone : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>{
    
  
    DAL *dal;
    NSMutableArray *retrivedata;
    FbGraph *fbGraph;
    PlannerAppAppDelegate *appdel;
	
    MFMailComposeViewController *mail;
	NSString *feedPostId;
    
    
    //var for indent outdent
    IBOutlet UITableView *table;
    int sectionOUt;
    int row;
    int index;
    int i;
    
    NSMutableDictionary *dictForRows;
    CGFloat animatedDistance;
    
    NSMutableArray *arrayOfSection;
    
	IBOutlet UITextField *txt;
	NSMutableDictionary *dic_txt;
	IBOutlet UITableViewCell *tvcell;
	
	
	NSMutableArray *arr_tag;
	
	int tagbtn;
    NSMutableDictionary *dictSection;
    int sectioncell;
    int rowcell;
    UITextField *textHeader;
    NSString *strTextHeader;
}
@property(nonatomic,retain)IBOutlet UITableViewCell *tvcell;

-(IBAction)btninDent:(id)sender;
-(IBAction)btnAdd:(id)sender;
-(IBAction)btnOutDent:(id)sender;
-(void)getMeButtonPressed;
@end

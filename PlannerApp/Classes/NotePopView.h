//
//  NotePopView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAL.h"
#import "PlannerAppAppDelegate.h"
@interface NotePopView : UIViewController<UITextViewDelegate> {
    NSString *strStid;
    NSString *strMtid;
    DAL *dal;
    IBOutlet UITextView *txtView;
    PlannerAppAppDelegate *appdel;
    NSString *strCid;
    
}
-(IBAction)clickOnDone:(id)sender;
@property(nonatomic,retain)NSString *strCid;
@property(nonatomic,retain) NSString *strStid;
@property(nonatomic,retain)NSString *strMtid;
@end

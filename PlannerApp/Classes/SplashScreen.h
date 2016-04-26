//
//  SplashScreen.h
//  PlannerApp
//
//  Created by Openxcell on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlannerAppAppDelegate.h"
@interface SplashScreen : UIViewController{
    PlannerAppAppDelegate *appdel;
    IBOutlet UIImageView *splashScreen;
}
-(void)callMethod;
@end

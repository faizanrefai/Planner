//
//  Progress_SubView.h
//  PlannerApp
//
//  Created by openxcell tech.. on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Progress_SubView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *array;
    UILabel *txtType;
    IBOutlet UITableView *tbl;
}

@end

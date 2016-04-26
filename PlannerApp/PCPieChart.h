/**
 * Copyright (c) 2011 Muh Hon Cheng
 * Created by honcheng on 28/4/11.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2011	Muh Hon Cheng
 * @version
 * 
 */

#import <UIKit/UIKit.h>
#import "PCPieChart.h"

@interface PCPieComponent : NSObject
{
    float value, startDeg, endDeg;
    NSString *title;
    UIColor *colour;
    
}
@property (nonatomic, assign) float value, startDeg, endDeg;
@property (nonatomic, retain) UIColor *colour;
@property (nonatomic, retain) NSString *title;


- (id)initWithTitle:(NSString*)_title value:(float)_value;
+ (id)pieComponentWithTitle:(NSString*)_title value:(float)_value;
@end


#define PCColorFinance [UIColor colorWithRed:252.0/255.0 green:207/255.0 blue:101/255.0 alpha:1.0]
#define PCColorFamily [UIColor colorWithRed:205.0/255.0 green:235.0/255.0 blue:169.0/255.0 alpha:1.0]
#define PCColorHealth [UIColor colorWithRed:235.0/255.0 green:197.0/255.0 blue:238.0/255.0 alpha:1.0]
#define PCColorPersonal [UIColor colorWithRed:238.0/255.0 green:199/255.0 blue:197/255.0 alpha:1.0]
#define PCColorWork [UIColor colorWithRed:179.0/255.0 green:202.0/255.0 blue:220.0/255.0 alpha:1.0]
#define PCColorShared [UIColor colorWithRed:194.0/255.0 green:174.0/255.0 blue:139.0/255.0 alpha:1.0]
#define PCColorUrgent [UIColor colorWithRed:253.0/255.0 green:114.0/255.0 blue:95.0/255.0 alpha:1.0]
#define PCColorShopping [UIColor colorWithRed:255.0/255.0 green:229.0/255.0 blue:198.0/255.0 alpha:1.0]
#define PCColorDefault [UIColor colorWithRed:255.0/255.0 green:229.0/255.0 blue:198.0/255.0 alpha:1.0]

@interface PCPieChart : UIView {
    NSMutableArray *components;
    int diameter;
	UIFont *titleFont, *percentageFont;
	BOOL showArrow, sameColorLabel;
}
@property (nonatomic, assign) int diameter;
@property (nonatomic, retain) NSMutableArray *components;
@property (nonatomic, retain) UIFont *titleFont, *percentageFont;
@property (nonatomic, assign) BOOL showArrow, sameColorLabel;

@end

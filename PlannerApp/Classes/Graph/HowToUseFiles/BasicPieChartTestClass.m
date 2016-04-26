//
//  BasicPieChartTestClass.m
//  MIMChartLib
//
//  Created by Mac Mac on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BasicPieChartTestClass.h"




@implementation BasicPieChartTestClass

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
}

-(void)createLabelWithText:(NSString *)text AtLocation:(CGRect)rect
{
    UILabel *a=[[UILabel alloc]initWithFrame:rect];
    [a setBackgroundColor:[UIColor clearColor]];
    [a setText:text];
    [a setTextAlignment:UITextAlignmentCenter];
    [a setTextColor:[UIColor blackColor]];
    [a setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [a setMinimumFontSize:8];
    [self.view addSubview:a];
    
}

- (void)viewDidLoad
{
    
    self.title=@"BASIC PIE CHARTS";
    
    /************************************************************************************************/
    /*                                                                                              */
    /*          Default Look                                                                        */
    /*                                                                                              */
    /************************************************************************************************/
    
    myPieChart=[[BasicPieChart alloc]initWithFrame:CGRectMake(5, 5, 220, 240)];
    myPieChart.delegate=self;  
    [myPieChart drawPieChart];
    [self.view addSubview:myPieChart];
    
    
    [self createLabelWithText:@"Default Look" AtLocation:CGRectMake(5, 225, 220, 20)];
    
    
    /************************************************************************************************/
    /*                                                                                              */
    /*          SET YOUR OWN BORDER WIDTH AND BORDER COLOR                                          */
    /*                                                                                              */
    /************************************************************************************************/
    
    myPieChart=[[BasicPieChart alloc]initWithFrame:CGRectMake(225, 5, 220, 240)];
    myPieChart.delegate=self;  
    myPieChart.borderWidth=2.0;
    myPieChart.borderColor=[MIMColorClass colorWithComponent:@"139,69,19"];
    [myPieChart drawPieChart];
    [self.view addSubview:myPieChart];
    
    [self createLabelWithText:@"Set Border Properties" AtLocation:CGRectMake(225, 225, 220, 20)];
    
    /************************************************************************************************/
    /*                                                                                              */
    /*          SET NO BORDER                                                                      */
    /*                                                                                              */
    /************************************************************************************************/
    
    myPieChart=[[BasicPieChart alloc]initWithFrame:CGRectMake(445, 5, 220, 240)];
    myPieChart.delegate=self;  
    myPieChart.borderWidth=0.0;
    [myPieChart drawPieChart];
    [self.view addSubview:myPieChart];
    
    [self createLabelWithText:@"No Borders" AtLocation:CGRectMake(445, 225, 220, 20)];
    
    /************************************************************************************************/
    /*                                                                                              */
    /*          SET GLOSS                                                                           */
    /*                                                                                              */
    /************************************************************************************************/
    
    myPieChart1=[[BasicPieChart alloc]initWithFrame:CGRectMake(5, 240, 220, 240)];
    myPieChart1.delegate=self;  
    myPieChart1.glossEffect=YES;
    myPieChart1.borderWidth=0.3;
    [myPieChart1 drawPieChart];
    [self.view addSubview:myPieChart1];
    
    [self createLabelWithText:@"Gloss Effect" AtLocation:CGRectMake(5, 465, 220, 20)];
    
    
    myPieChart1=[[BasicPieChart alloc]initWithFrame:CGRectMake(225, 240, 220, 240)];
    myPieChart1.delegate=self;  
    myPieChart1.glossEffect=NO;
    myPieChart1.borderWidth=0.3;
    [myPieChart1 drawPieChart];
    [self.view addSubview:myPieChart1];
    
    [self createLabelWithText:@"Without Gloss Effect" AtLocation:CGRectMake(225, 465, 220, 20)];
    
    
    /************************************************************************************************/
    /*                                                                                              */
    /*  USING TINTS                                                                                 */
    /*                                                                                              */
    /************************************************************************************************/
    
    myPieChart2=[[BasicPieChart alloc]initWithFrame:CGRectMake(5, 480, 220, 240)];
    myPieChart2.delegate=self;  
    myPieChart2.glossEffect=YES;
    myPieChart2.borderWidth=0.4;
    myPieChart2.tint=GREENTINT;
    [myPieChart2 drawPieChart];
    [self.view addSubview:myPieChart2];
    
    
    [self createLabelWithText:@"Inbuilt GREEN tint+ Gloss" AtLocation:CGRectMake(5, 705, 220, 20)];
    
    myPieChart2=[[BasicPieChart alloc]initWithFrame:CGRectMake(225, 480, 220, 240)];
    myPieChart2.delegate=self;  
    myPieChart2.glossEffect=YES;
    myPieChart2.borderWidth=0.3;
    myPieChart2.tint=REDTINT;
    [myPieChart2 drawPieChart];
    [self.view addSubview:myPieChart2];
    
    [self createLabelWithText:@"Inbuilt RED tint+ Gloss" AtLocation:CGRectMake(225, 705, 220, 20)];
    
    myPieChart2=[[BasicPieChart alloc]initWithFrame:CGRectMake(445, 480, 220, 240)];
    myPieChart2.delegate=self;  
    myPieChart2.glossEffect=YES;
    myPieChart2.borderWidth=0.3;
    myPieChart2.tint=BEIGETINT;
    [myPieChart2 drawPieChart];
    [self.view addSubview:myPieChart2];
    
    [self createLabelWithText:@"Inbuilt BEIGE tint+ Gloss" AtLocation:CGRectMake(445, 705, 220, 20)];
    
    myPieChart2=[[BasicPieChart alloc]initWithFrame:CGRectMake(5, 720, 220, 240)];
    myPieChart2.delegate=self;  
    myPieChart2.glossEffect=NO;
    myPieChart2.borderWidth=0.3;
    myPieChart2.tint=REDTINT;
    [myPieChart2 drawPieChart];
    [self.view addSubview:myPieChart2];
    
    [self createLabelWithText:@"Inbuilt RED tint" AtLocation:CGRectMake(5, 940, 220, 20)];
    
    
    
    /************************************************************************************************/
    /*                                                                                              */
    /*  USING GRADIENTS                                                                                 */
    /*                                                                                              */
    /************************************************************************************************/
  
    
    
    
    myPieChart3=[[BasicPieChart alloc]initWithFrame:CGRectMake(225, 720, 220, 240)];
    myPieChart3.delegate=self;  
    myPieChart3.glossEffect=NO;
    myPieChart3.borderWidth=0.3;
    [myPieChart3 drawPieChart];
    [self.view addSubview:myPieChart3];
    
    [self createLabelWithText:@"Gradients" AtLocation:CGRectMake(225, 940, 220, 20)];
    
    myPieChart3=[[BasicPieChart alloc]initWithFrame:CGRectMake(445, 720, 220, 240)];
    myPieChart3.delegate=self;  
    myPieChart3.glossEffect=YES;
    myPieChart3.borderWidth=0.3;
    [myPieChart3 drawPieChart];
    [self.view addSubview:myPieChart3];
    
    [self createLabelWithText:@"Gradients+ Gloss" AtLocation:CGRectMake(445, 940, 220, 20)];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - PIECHART Delegate methods

-(float)radiusForPie:(id)pieChart
{
    return 100.0;
}


-(NSArray *)colorsForPie:(id)pieChart
{
    NSArray *colorsArray;
    
//    MIMColorClass *color1=[MIMColorClass colorWithComponent:@"179,164,132"];
//    MIMColorClass *color2=[MIMColorClass colorWithComponent:@"186,118,62"];
//    MIMColorClass *color3=[MIMColorClass colorWithComponent:@"168,170,113"];
//    MIMColorClass *color4=[MIMColorClass colorWithComponent:@"178,65,76"];
//    MIMColorClass *color5=[MIMColorClass colorWithComponent:@"81,110,122"];

//    MIMColorClass *color1=[MIMColorClass colorWithComponent:@"142,76,91"];
//    MIMColorClass *color2=[MIMColorClass colorWithComponent:@"211,191,131"];
//    MIMColorClass *color3=[MIMColorClass colorWithComponent:@"158,138,110"];
//    MIMColorClass *color4=[MIMColorClass colorWithComponent:@"160,153,94"];
//    MIMColorClass *color5=[MIMColorClass colorWithComponent:@"203,196,170"];

    if(pieChart==myPieChart1)
    {

        
        MIMColorClass *color1=[MIMColorClass colorWithComponent:@"137,215,234"];
        MIMColorClass *color2=[MIMColorClass colorWithComponent:@"239,95,100"];
        MIMColorClass *color3=[MIMColorClass colorWithComponent:@"127,186,140"];
        MIMColorClass *color4=[MIMColorClass colorWithComponent:@"247,144,187"];
        MIMColorClass *color5=[MIMColorClass colorWithComponent:@"249,219,122"];
        
        
        colorsArray=[NSArray arrayWithObjects:color1,color5,color2,color3,color4, nil];
    }
    else if(pieChart == myPieChart)
    {
        
        MIMColorClass *color1=[MIMColorClass colorWithComponent:@"144,139,39"];
        MIMColorClass *color2=[MIMColorClass colorWithComponent:@"208,195,135"];
        MIMColorClass *color3=[MIMColorClass colorWithComponent:@"182,119,48"];
        MIMColorClass *color4=[MIMColorClass colorWithComponent:@"183,142,50"];
        MIMColorClass *color5=[MIMColorClass colorWithComponent:@"99,73,56"];

        
        
        colorsArray=[NSArray arrayWithObjects:color1,color5,color2,color3,color4, nil];
    
    }
    else
        return nil;
    
    return colorsArray;
    
}


-(NSArray *)valuesForPie:(id)pieChart
{    
    return [NSArray arrayWithObjects:@"40000",@"21000",@"24000",@"11000",@"15000",nil];  
    
}



//GRADIENT 

-(NSArray *)gradientsForPie:(id)pieChart
{

  
    if (pieChart==myPieChart3) {
        
        CGFloat BGLocations[2] = { 0.0, 1.0 };
        CGFloat BgComponents[12] = { 0.564,0.727,0.621 , 1.0,  // Start color
            0.792, 0.823, 0.764 , 1.0}; // End color
        CGColorSpaceRef BgRGBColorspace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient1 = CGGradientCreateWithColorComponents(BgRGBColorspace, BgComponents, BGLocations, 2);
        
        
        
        CGFloat BGLocations2[2] = { 0.0, 1.0 };
        CGFloat BgComponents2[12] = {0.286,0.713,0.945 , 1.0,  // Start color
            0.8,0.913,0.984, 1.0}; // End color
        CGGradientRef gradient2 = CGGradientCreateWithColorComponents(BgRGBColorspace, BgComponents2, BGLocations2, 2);
        
        
        
//        CGFloat BGLocations3[2] = { 0.0, 1.0 };
//        CGFloat BgComponents3[12] = {0.921,0.776,0.807 , 1.0,  // Start color
//            1.0,0.917,0.936 , 1.0}; // End color
//        CGGradientRef gradient3 = CGGradientCreateWithColorComponents(BgRGBColorspace, BgComponents3, BGLocations3, 2);
//        
        
        
        CGFloat BGLocations3[2] = { 0.0, 1.0 };
        CGFloat BgComponents3[12] = {0.290,0.07,0.552 , 1.0,  // Start color
            0.696,0.554,0.8 , 1.0}; // End color
        CGGradientRef gradient3 = CGGradientCreateWithColorComponents(BgRGBColorspace, BgComponents3, BGLocations3, 2);

        
        CGFloat BGLocations4[2] = { 0.0, 1.0 };
        CGFloat BgComponents4[12] = {0.607,0.380,0.0 , 1.0,  // Start color
            0.866,0.788,0.650, 1.0}; // End color
        CGGradientRef gradient4 = CGGradientCreateWithColorComponents(BgRGBColorspace, BgComponents4, BGLocations4, 2);
        
        
        
        CGFloat BGLocations5[2] = { 0.0, 1.0 };
        CGFloat BgComponents5[12] = { 0.933,0.666,0 , 1.0,  // Start color
            1.0,1.0,0.858, 1.0}; // End color
        CGGradientRef gradient5 = CGGradientCreateWithColorComponents(BgRGBColorspace, BgComponents5, BGLocations5, 2);
        
        
        
        NSArray *g=[NSArray arrayWithObjects:gradient1,gradient2,gradient3,gradient4,gradient5,nil];
        
        return g;
        
    }
    
    return nil;
    
}


-(BOOL)GlossEffect
{
    return YES;
}

@end

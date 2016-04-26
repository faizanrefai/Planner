//
//  ProgressViewController.m
//  PlannerApp
//
//  Created by Openxcell on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgressViewController.h"
#import "PlannerAppViewController.h"
#import "WEPopoverController.h"
#import "TestClassFragmented.h"
#import "BarTestClass.h"
#import "GroupBarTestClass.h"
#import "DAL.h"
@implementation ProgressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        dal=[[DAL alloc] initDatabase:@"Planner.sqlite"];
        arrPieChartData=[[NSMutableArray alloc] init];
        BarTestClass *rootController=[[BarTestClass alloc]init]; 
        //GroupBarTestClass *rootController=[[GroupBarTestClass alloc]init];
        //[self.view addSubview:rootController.view];
        [viewGraph addSubview:rootController.view];
        //[self drawPieChart];
        //[self.view addSubview:rootController.view];
       
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"transp-background.png"]];
   
   self.contentSizeForViewInPopover=CGSizeMake(678, 780);
   // self.contentSizeForViewInPopover=CGSizeMake(600, 600);
	   	
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
     self.navigationController.navigationBarHidden=TRUE;

    UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    [doubleTap release];
    [self.view bringSubviewToFront:btnFolder];
    [self.view bringSubviewToFront:btnDueDate];
    //[self.view bringSubviewToFront:viewGraph];
    //[self.view bringSubviewToFront:viewPie];
    [self getCount];
    [self drawPieChart];
    viewGraph.hidden=FALSE;
    viewPie.hidden=TRUE;
    if(UIInterfaceOrientationLandscapeLeft==self.interfaceOrientation || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        self.contentSizeForViewInPopover=CGSizeMake(700, 600);
        self.view.frame=CGRectMake(0, 0, 700, 600);
        imgBackGround.frame=CGRectMake(0, 0, 700, 620);
        imgProgress.frame=CGRectMake(280, 20, 118, 34);
        imgFeild.frame=CGRectMake(70, 59, 560, 51);
        
        btnDueDate.frame=CGRectMake(90, 65, 40, 40);
        lbldueDate.frame=CGRectMake(130, 72, 133, 21);
        
        btnFolder.frame=CGRectMake(420, 65, 40, 40);
        lblStatus.frame=CGRectMake(460, 72, 133, 21);
        
        viewGraph.frame=CGRectMake(0, 25, 550, 500);
        viewPie.frame=CGRectMake(80, 10, 550, 612);
        
    }
    else{
        self.contentSizeForViewInPopover=CGSizeMake(768, 780);
        self.view.frame=CGRectMake(0, 0, 768, 780);
        imgBackGround.frame=CGRectMake(-20, -17, 692, 850);
        imgProgress.frame=CGRectMake(280, 18, 118, 34);
        imgFeild.frame=CGRectMake(59, 59, 560, 51);
        
        btnDueDate.frame=CGRectMake(79, 62, 40, 40);
        lbldueDate.frame=CGRectMake(127, 70, 133, 21);
        
        btnFolder.frame=CGRectMake(421, 62, 40, 40);
        lblStatus.frame=CGRectMake(470, 70, 133, 21);
    
       viewGraph.frame=CGRectMake(15, 25, 597, 700);
        
        viewPie.frame=CGRectMake(50, 84, 550, 612);
    }

    
     
    


}
-(IBAction)clickOnDue:(id)sender{
    if([btnFolder isSelected]){
        [btnFolder setSelected:NO];
        [btnDueDate setSelected:YES];
      
       
        viewPie.hidden=TRUE;
        viewGraph.hidden=FALSE;
        BarTestClass *rootController=[[BarTestClass alloc]init];
        [viewGraph addSubview:rootController.view];
    }
    
}
-(IBAction)clcikOnFolder:(id)sender{
    if([btnDueDate isSelected]){
        [btnDueDate setSelected:NO];
        [btnFolder setSelected:YES];
        viewGraph.hidden=TRUE;
        viewPie.hidden=FALSE;
        //[self drawPieChart];
       
        
    }
  
}
-(void)drawPieChart{
    //[self.view setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    //[self.titleLabel setText:@"Pie Chart"];
    
    
    int height = [viewPie bounds].size.width/3*2.; // 220;
    int width = [viewPie bounds].size.width; //320;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([viewPie bounds].size.width-width)/2,([viewPie bounds].size.height-height)/2,width,height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [pieChart setSameColorLabel:YES];
    
    [viewPie addSubview:pieChart];
    [pieChart release];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        pieChart.titleFont = [UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
        
        pieChart.percentageFont = [UIFont fontWithName:@"HelenBgCondensed-Bold" size:30];
    }
  
    NSMutableArray *components = [NSMutableArray array];
    for (int i=0; i<[arrPieChartData count]; i++)
    {
        //NSDictionary *item = [[sampleInfo objectForKey:@"data"] objectAtIndex:i];
       // PCPieComponent *component = [PCPieComponent pieComponentWithTitle:[item objectForKey:@"title"] value:[[item objectForKey:@"value"] floatValue]];
        
        PCPieChart *component=[PCPieComponent pieComponentWithTitle:[[arrPieChartData objectAtIndex:i]valueForKey:@"title"] value:[[[arrPieChartData objectAtIndex:i]valueForKey:@"value"]floatValue] ];
        
        [components addObject:component];
       
        
        NSLog(@"components %@",components);
        
        if (i==0)
        {
            [component setColour:PCColorWork];
        }
        else if (i==1)
        {
            [component setColour:PCColorFamily];
        }
        else if (i==2)
        {
            [component setColour:PCColorHealth];
        }
        else if (i==3)
        {
            [component setColour:PCColorPersonal];
        }
        else if (i==4)
        {
            [component setColour:PCColorFinance];
        }
        
        else if (i==5)
        {
            [component setColour:PCColorShared];
        }
        else if (i==6)
        {
            [component setColour:PCColorUrgent];
        }
        else if (i==7)
        {
            [component setColour:PCColorShopping];
        }
    }
    [pieChart setComponents:components];
}
- (IBAction)tapDetected:(UIGestureRecognizer *)sender{
   
    NSLog(@"tap");
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissmissProgress" object:self];
      
}
-(void)getCount{
    
    NSMutableDictionary *dictget,*dictSubTaskGet;
    NSString *strID;
    for(int m=1;m<=8;m++){
         NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        strID=[NSString stringWithFormat:@"%d",m];
        dictget=nil;
        dictget=[dal executeDataSet:[NSString stringWithFormat:@"select fi.title,fi.mtid,fi.position from tblMainTask fi inner join tblSubCat ii on ii.scid = fi.scid where ii.mcid=%@",strID]];
        
        int counta=0;
        for(int y=1;y<=[dictget count];y++){
            NSString *strMtid=[[dictget valueForKey:[NSString stringWithFormat:@"Table%d",y]]valueForKey:@"mtid" ] ; 
            NSLog(@"%@",strMtid);
            dictSubTaskGet=[dal executeDataSet:[NSString stringWithFormat:@"select fi.title,fi.stid,fi.position from tblSubTask fi inner join tblMainTask ii on ii.mtid = fi.mtid where ii.mtid=%@",strMtid]];
            counta+=[dictSubTaskGet count];
        }
      
        
        if([strID isEqualToString:@"1"]){
            
            [dict setObject:[NSString stringWithFormat:@"%d",[dictget count]+counta] forKey:@"value"];
            [dict setObject:@"Work" forKey:@"title"];
            [arrPieChartData addObject:dict];
            [dict release];
        }
        
        
        if([strID isEqualToString:@"2"]){
            [dict setObject:[NSString stringWithFormat:@"%d",[dictget count]+counta] forKey:@"value"];
            [dict setObject:@"Family" forKey:@"title"];
            [arrPieChartData addObject:dict];
            [dict release];

        }
        if([strID isEqualToString:@"3"]){
            [dict setObject:[NSString stringWithFormat:@"%d",[dictget count]+counta] forKey:@"value"];
            [dict setObject:@"Health" forKey:@"title"];
            [arrPieChartData addObject:dict];
            [dict release];

        }
        if([strID isEqualToString:@"4"]){
            [dict setObject:[NSString stringWithFormat:@"%d",[dictget count]+counta] forKey:@"value"];
            [dict setObject:@"Personal" forKey:@"title"];
            [arrPieChartData addObject:dict];
            [dict release];
        }
        if([strID isEqualToString:@"5"]){
            [dict setObject:[NSString stringWithFormat:@"%d",[dictget count]+counta] forKey:@"value"];
            [dict setObject:@"Finance" forKey:@"title"];
            [arrPieChartData addObject:dict];
            [dict release];

        }
        if([strID isEqualToString:@"6"]){
            [dict setObject:[NSString stringWithFormat:@"%d",[dictget count]+counta] forKey:@"value"];
            [dict setObject:@"Shared" forKey:@"title"];
            [arrPieChartData addObject:dict];
            [dict release];
        }
        if([strID isEqualToString:@"7"]){
            [dict setObject:[NSString stringWithFormat:@"%d",[dictget count]+counta] forKey:@"value"];
            [dict setObject:@"Urgent" forKey:@"title"];
            [arrPieChartData addObject:dict];
            [dict release];
        }
        if([strID isEqualToString:@"8"]){
            [dict setObject:[NSString stringWithFormat:@"%d",[dictget count]+counta] forKey:@"value"];
            [dict setObject:@"Shopping" forKey:@"title"];
            [arrPieChartData addObject:dict];
            [dict release];
        }
    }
    NSLog(@"%@",arrPieChartData);
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    btnDueDate=nil;
    btnFolder=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark Orientation
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if(UIInterfaceOrientationLandscapeLeft==self.interfaceOrientation || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        self.contentSizeForViewInPopover=CGSizeMake(900, 900);
        self.view.frame=CGRectMake(0, 0, 900, 900);
        imgBackGround.frame=CGRectMake(0, 0, 900, 700);
        imgProgress.frame=CGRectMake(400, 18, 118, 34);
        imgFeild.frame=CGRectMake(165, 59, 560, 51);
        btnDueDate.frame=CGRectMake(185, 62, 40, 40);
        lbldueDate.frame=CGRectMake(235, 70, 133, 21);
        
        btnFolder.frame=CGRectMake(509, 62, 40, 40);
        lblStatus.frame=CGRectMake(549, 70, 133, 21);
        viewGraph.frame=CGRectMake(50, 25, 597, 600);
        viewPie.frame=CGRectMake(100, 60, 550, 612);
        
    }
    else{
       // self.contentSizeForViewInPopover=CGSizeMake(768, 780);
        //self.view.frame=CGRectMake(0, 0, 678, 780);
        //imgBackGround.frame=CGRectMake(-20, -17, 692, 850);
        imgProgress.frame=CGRectMake(280, 18, 118, 34);
        imgFeild.frame=CGRectMake(59, 59, 560, 51);
        
        btnDueDate.frame=CGRectMake(79, 62, 40, 40);
        lbldueDate.frame=CGRectMake(235, 70, 133, 21);
        
        btnFolder.frame=CGRectMake(127, 62, 40, 40);
        lblStatus.frame=CGRectMake(470, 70, 133, 21);
        
        viewGraph.frame=CGRectMake(15, 25, 597, 700);
        
        viewPie.frame=CGRectMake(50, 84, 550, 612);
    }
    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
        

	return YES;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return @"Completed Tasks";
        //return @"Last Up";
    }
	else if(section == 1)
	{
		return @"Tasks in Progress";
	}
    else if(section == 2){
        return @"No Action";
    }
	else if(section == 3) {
		return @"Added";
	}

}
*/

// Customize the appearance of table view cells.
@end

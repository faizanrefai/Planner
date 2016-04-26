

//  PlannerAppViewController.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//	
//jckothari53@yahoo.com
#import "LoginPage.h"
#import "PlannerAppViewController.h"
#import "StatusView.h"
#import "PriorityView.h"
#import "AlertHandler.h"
#import "TapView.h"
#import "Settings.h"
#import "TabOrderController.h"
#import "NSString+Extensions.h"
#import "LocationPop.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MAEvent.h"
#import "AddEvent.h"
@implementation PlannerAppViewController
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;

#define kCellIdentifier @"DropTableCell"
#define kCellHeight 44
#define kNavBarHeight 30
#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]
@synthesize table1,table2;
@synthesize popover_progress;
@synthesize addBtn,popover_tap;
@synthesize tbl2Cell,category_cell,popOver_settings,popOver_Location;
@synthesize fbGraph,feedPostId,btnShrink,txtMain,cellCalendar,lblTime,txtTask,btnSettings;


@interface PlannerAppViewController(PrivateMethods)
@property (readonly) MAEvent *event;
@end
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

#pragma  mark VIEWDID

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
    lblCatTitle.text=@"All Work";
    
    
    appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication]delegate ];
    NSLog(@"%@",appdel.strLoginID);
    appdel.str_mcid=@"1";
    NSLog(@"Fonts : %@",[UIFont fontNamesForFamilyName:@"Helen Bg Condensed"]);
    [btnWork setSelected:YES];
    arrTime=[[NSArray alloc] initWithObjects:@"6 AM",@"7 AM",@"8 AM",@"9 AM",@"10 AM",@"11 AM",@"12 PM",@"1 PM",@"2 PM",@"3 PM",@"4 PM",@"5 PM",@"6 PM",@"7 PM",@"8 PM",@"9 PM",@"10 PM",@"11 PM",@"12 AM", nil];
    //All Allocations
    //sub cat
    arrsubCatTitle=[[NSMutableArray alloc] init];
    arrScid=[[NSMutableArray alloc] init];

    //main cat
    arr_maintask=[[NSMutableArray alloc]init];
    dictForRows=[[NSMutableDictionary alloc] init];
    arrayOfSection=[[NSMutableArray alloc]init];
    arrOfArrow=[[NSMutableArray alloc] init];
    
    
    dic_txt=[[NSMutableDictionary alloc]init];
    dictMainTask=[[NSMutableDictionary alloc]init];
    dictArrow=[[NSMutableDictionary alloc]init];
        
    //dictSection=[[NSMutableDictionary alloc]init];
    dic_image=[[NSMutableDictionary alloc]init];
    dic_priorityimage=[[NSMutableDictionary alloc] init];
    arrSuBTaskID=[[NSMutableArray alloc] init];
    arr_subtasktitle=[[NSMutableArray alloc] init];
   
    dictSubTaskID=[[NSMutableDictionary alloc] init];
    arr_tagNew=[[NSMutableArray alloc]init];
    
    arrCalText=[[NSMutableArray alloc] init];
   
    arrSearch=[[NSMutableArray alloc] init];
    dal=[[DAL alloc] initDatabase:@"Planner.sqlite"];
    
    [view_cal bringSubviewToFront:btnProgress];
    [scroll bringSubviewToFront:btnProgress];
    [self.view bringSubviewToFront:btnProgress];
    
    
    
    	
}
-(void)viewWillAppear:(BOOL)animated
{
    isCalAdd=FALSE;
    dailyView.hidden=TRUE;
    [btnWork setBackgroundImage:[UIImage imageNamed:@"Work-Active-.png"] forState:UIControlStateNormal];
    [btnSettings setSelected:NO];
    [btnProgress setSelected:NO];
    [btnMail setSelected:NO];
    [btnShared setSelected:NO];
    [btnInfo setSelected:NO];
     
    viewCalendarTbl.hidden=TRUE;
    lblDay.hidden=TRUE;
    lblDate.hidden=TRUE;
    lblMonth.hidden=TRUE;
    lblStatus.hidden=FALSE;
    lblPriority.hidden=FALSE;
    lblCatTitle.hidden=FALSE;
    rowsCnt=0;
	btnDel.hidden=TRUE;
    sectionOUt=-1;
    row=0;
    i=-1;
    flagStart=1;
    isEdit=0;
    flag=0;
    allFlag=0;
    appdel.isTaskOrEvent=@"0";
    tblCalendar.hidden=YES;
    lineVIew1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, table2.frame.size.height+40)];
    [lineVIew1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]]];
    lineView2 = [[UIView alloc] initWithFrame:CGRectMake(45, 0, 1, table2.frame.size.height+40)];
    [lineView2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]]];
    lineView3 = [[UIView alloc] initWithFrame:CGRectMake(90, 0, 1, table2.frame.size.height+40)];
    [lineView3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]]];
    lineView4 = [[UIView alloc] initWithFrame:CGRectMake(465, 0, 1, table2.frame.size.height+40)];
    [lineView4 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]]];
    lineView5 = [[UIView alloc] initWithFrame:CGRectMake(489, 0, 1, table2.frame.size.height+40)];
    [lineView5 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]]];
    
    UIView *lineViewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, table2.frame.size.width, 1)];
    [lineViewTop setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]]];
    
    
    UIView *linetop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, table2.frame.size.width, 1)];
    [linetop setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]]];

    lineCal1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, tblCalendar.frame.size.height)];
    [lineCal1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]]];
    lineCal2 = [[UIView alloc] initWithFrame:CGRectMake(45, 0, 1, tblCalendar.frame.size.height)];
    [lineCal2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]]];
    lineCal3 = [[UIView alloc] initWithFrame:CGRectMake(465, 0, 1, tblCalendar.frame.size.height)];
    [lineCal3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]]];
    
    
    lastLine = [[UIView alloc] initWithFrame:CGRectMake(489, 0, 1, tblCalendar.frame.size.height+40)];
    [lastLine setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]]];
      
    UIView *linetopCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tblCalendar.frame.size.width, 1)];
    [linetopCal setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]]];

  
    [table2 addSubview:lineViewTop];
    [table2 addSubview:lineVIew1];
    [table2 addSubview:lineView2];
    [table2 addSubview:lineView3];
    [table2 addSubview:lineView4];
    [table2 addSubview:lineView5];
    
    [tblCalendar addSubview:lineCal1];
    [tblCalendar addSubview:lineCal2];
    [tblCalendar addSubview:lineCal3];
    [tblCalendar addSubview:lastLine];
    [tblCalendar addSubview:linetopCal];
    
    
    
    
   table2.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]];
   tblCalendar.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line.png"]];
    
    scroll.hidden=TRUE;
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBarHidden=TRUE;
    lblStatus.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
    lblPriority.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
    lblCatTitle.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:24];
    if([appdel.strLoginID isEqualToString:@"1"]){
        /*Facebook Application ID*/
       
         NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"fbtoken"];
        if(str_id && ![str_id isEqualToString:@""])
        {
            [self JSONMainCategory];
        }
        else{
            
            NSString *client_id = @"130902823636657";
            self.fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
            [fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
                                 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins,email"];
            
            
        }
        
        
    }
   
    else{
        [self JSONMainCategory];
    }
   
    isIndent=0;
	k=0;
	
    
	
    
	
	table1.editing=NO;
	    
	
     srcData=[[NSMutableArray alloc] initWithObjects:@"right1 ",@"right 2", nil];
     dstData=[[NSMutableArray alloc] initWithObjects:@"right3 ",@"right 4", nil];
    //tblSearch.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"table1newbg.png"]];
    //table2.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgTable2.png"]];
    //tblCalendar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgTable2.png"]];
       
    
    [self setMainTabs];
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft && self.interfaceOrientation==UIInterfaceOrientationLandscapeRight){
         [btnWork setFrame:CGRectMake(btnWork.frame.origin.x+15+134, 60,35 , 45)];
    }
    else{
        [btnWork setFrame:CGRectMake(btnWork.frame.origin.x+15, 60,35 , 45)];
    }

    //[btnWork setFrame:CGRectMake(btnWork.frame.origin.x+15, 60,35 , 45)];
    [self setLeftImgOnly:1];
    if([lblWork1.text intValue]>=10){
         lblWork1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    }
    else{
    lblWork1=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 10, 10)];
    
    }
     lblWork1.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
    
     [lblWork addSubview:lblWork1];   
    lblPer=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 10, 10)];
    
    [lblPersonal addSubview:lblPer];
    
    lblfami=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 10, 10)];
    [lblFamily addSubview:lblfami];
  
    lblhealt=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 10, 10)];
    [lblHealth addSubview:lblhealt];
   
    lblFin=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 10, 10)];
    [lblFinance addSubview:lblFin];
    
    lblShar=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 10, 10)];
    [lblShared addSubview:lblShar];
   
    lblUrge=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 10, 10)];
    [lblUrgent addSubview:lblUrge];
    
    
    lblShop=[[UILabel alloc] initWithFrame:CGRectMake(5, 2, 10, 10)];
    [lblShopping addSubview:lblShop];
    [lblWork1 setTextColor:[UIColor whiteColor]];
   
    
    lblWork1.backgroundColor=[UIColor clearColor];
    [lblPer setTextColor:[UIColor whiteColor]];
    
    lblPer.backgroundColor=[UIColor clearColor];
    lblfami.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    [lblfami setTextColor:[UIColor whiteColor]];
    lblPer.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    
    lblfami.backgroundColor=[UIColor clearColor];
    [lblhealt setTextColor:[UIColor whiteColor]];
    lblhealt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblhealt.backgroundColor=[UIColor clearColor];
    [lblFin setTextColor:[UIColor whiteColor]];
    lblFin.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblFin.backgroundColor=[UIColor clearColor];
    [lblShar setTextColor:[UIColor whiteColor]];
    lblShar.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShar.backgroundColor=[UIColor clearColor];
    [lblUrge setTextColor:[UIColor whiteColor]];
    lblUrge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblUrge.backgroundColor=[UIColor clearColor];
    [lblShop setTextColor:[UIColor whiteColor]];
    lblShop.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShop.backgroundColor=[UIColor clearColor];
    UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    [doubleTap release];
    
    
    
    showExtrasSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipeRight:)];
    showExtrasSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [table2 addGestureRecognizer:showExtrasSwipe];
    [showExtrasSwipe setDelegate:self];
    [showExtrasSwipe release];
    
    showExtrasLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipeLeft:)];
    showExtrasSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [table2 addGestureRecognizer:showExtrasLeft];
    [showExtrasLeft setDelegate:self];
    [showExtrasLeft release];
    
    
    
    
    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    [tblCalendar addGestureRecognizer:swiperight];
    [swiperight setDelegate:self];
    [swiperight release];
    
    UISwipeGestureRecognizer *swipeleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
    [tblCalendar addGestureRecognizer:swipeleft];
    [swipeleft setDelegate:self];
    [swipeleft release];
    
        
   
       
//   panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
//    
//    [self.view addGestureRecognizer:panGesture];
//    [panGesture setDelegate:self];
//    [panGesture release];
    
    
//    panCal = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
//    
//    [tblCalendar addGestureRecognizer:panCal];
//    [panCal setDelegate:self];
//    [panCal release];
    
  
    //[self setupDestinationTableWithFrame:CGRectMake(14, 128, 220, 828)];
    
    longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self 
                                               action:@selector(handlePanning:)];
    longPress.minimumPressDuration = 0.2;
    [self.view addGestureRecognizer:longPress];
    [longPress release];
    
    [self changeColor];
    

   

 
}

-(void)changeColor{
    NSString *strColor=[[NSUserDefaults standardUserDefaults]valueForKey:@"color"];
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        imgFrame.frame=CGRectMake(0, -20, 1024, 768);
        
        if([strColor isEqualToString:@"yellow"]){
            imgFrame.image=[UIImage imageNamed:@"landscape-back_Beige.png"];
        }
        else if([strColor isEqualToString:@"pink"]){
            imgFrame.image=[UIImage imageNamed:@"landscape-back_Pink.png"];
        }
        else if([strColor isEqualToString:@"blue"]){
            imgFrame.image=[UIImage imageNamed:@"landscape-back_Blue.png"];
        }
        else{
            imgFrame.image=[UIImage imageNamed:@"landscape-black.png"];
        }
    }
    else{
         imgFrame.frame=CGRectMake(0, 0, 768, 1004);
    if([strColor isEqualToString:@"yellow"]){
        imgFrame.image=[UIImage imageNamed:@"Background-frame_Beige.png"];
    }
    else if([strColor isEqualToString:@"pink"]){
        imgFrame.image=[UIImage imageNamed:@"Background-frame pink.png"];
    }
    else if([strColor isEqualToString:@"blue"]){
        imgFrame.image=[UIImage imageNamed:@"Background-frame-Blue.png"];
    }
    else{
        imgFrame.image=[UIImage imageNamed:@"Background-frame.png"];
    }
    }
}

-(void)setMainTabs{
    if (!arrtab) {
        arrtab=[[NSMutableArray alloc] init];
        
    }
    if([arrtab count]==0 || !arrtab){
        [arrtab addObject:@"Work"];
        [arrtab addObject:@"Personal"];
        [arrtab addObject:@"Family"];
        [arrtab addObject:@"Health"];
        [arrtab addObject:@"Finance"];
        [arrtab addObject:@"Shared"];
        [arrtab addObject:@"Urgent"];
        [arrtab addObject:@"Shopping"];
    }
//    }else
//    {
//        
//        arrtab= [[NSUserDefaults standardUserDefaults] objectForKey:@"tab"];  
//    }
    
    
    //NSLog(@"arr is %@",arrtab);
    int x=233;
    int y=44;
    int width=68;
    int height=67;
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeRight || self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        x=x+134;
    }
    else{
        x=233;
    }
    for(int p=0;p<[arrtab count];p++){
        
        if([[arrtab objectAtIndex:p] isEqualToString:@"Work"]){
            btnWork.frame=CGRectMake(x, y, width, height);
            
            //lblWork.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
            
            if(p==0){
                //[btnWork setFrame:CGRectMake(btnWork.frame.origin.x+15, 60,35 , 45)];
                lblWork.frame=CGRectMake(btnWork.frame.origin.x+68-20, 50, 15, 15);
            }
            else if(p==7){
                lblWork.frame=CGRectMake(btnWork.frame.origin.x+68-25, 50, 15, 15);
            }
            else{
                lblWork.frame=CGRectMake(btnWork.frame.origin.x+68-20, 50, 15, 15);
            }
            
            
        }
        else if([[arrtab objectAtIndex:p] isEqualToString:@"Personal"]){
            btnPersonal.frame=CGRectMake(x, y, width, height);
          
            if(p==0){
                lblPersonal.frame=CGRectMake(btnPersonal.frame.origin.x+68-20, 50, 15, 15);
            }
            else if(p==7){
                lblPersonal.frame=CGRectMake(btnPersonal.frame.origin.x+68-25, 50, 15, 15);
            }
            else{
                lblPersonal.frame=CGRectMake(btnPersonal.frame.origin.x+68-20, 50, 15, 15);
            }
            
            //lblPersonal.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
            
            
        }
        else if([[arrtab objectAtIndex:p] isEqualToString:@"Family"]){
            btnFamily.frame=CGRectMake(x, y, width, height);
            if(p==0){
                lblFamily.frame=CGRectMake(btnFamily.frame.origin.x+68-20, 50, 15, 15);
            }
            else if(p==7){
                lblFamily.frame=CGRectMake(btnFamily.frame.origin.x+68-25, 50, 15, 15);
            }
            else{
                lblFamily.frame=CGRectMake(btnFamily.frame.origin.x+68-20, 50, 15, 15);
            }
            
            //lblFamily.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
            
            
            
        }
        else if([[arrtab objectAtIndex:p] isEqualToString:@"Health"]){
            btnHealth.frame=CGRectMake(x, y, width, height);
            if(p==0){
                lblHealth.frame=CGRectMake(btnHealth.frame.origin.x+68-20, 50, 15, 15);
            }
            else if(p==7){
                lblHealth.frame=CGRectMake(btnHealth.frame.origin.x+68-25, 50, 15, 15);
            }
            else{
                lblHealth.frame=CGRectMake(btnHealth.frame.origin.x+68-20, 50, 15, 15);
            }
            
            //lblHealth.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
            
        }
        else if([[arrtab objectAtIndex:p] isEqualToString:@"Finance"]){
            btnFinance.frame=CGRectMake(x, y, width, height);
            if(p==0){
                lblFinance.frame=CGRectMake(btnFinance.frame.origin.x+68-20, 50, 15, 15);
            }
            else if(p==7){
                lblFinance.frame=CGRectMake(btnFinance.frame.origin.x+68-25, 50, 15, 15);
            }
            else{
                lblFinance.frame=CGRectMake(btnFinance.frame.origin.x+68-20, 50, 15, 15);
            }
            //lblFinance.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
            
            
        }
        else if([[arrtab objectAtIndex:p] isEqualToString:@"Shared"]){
            btnShared.frame=CGRectMake(x, y, width, height);
            if(p==0){
                lblShared.frame=CGRectMake(btnShared.frame.origin.x+68-20, 50, 15, 15);
            }
            else if(p==7){
                lblShared.frame=CGRectMake(btnShared.frame.origin.x+68-25, 50, 15, 15);
            }
            else{
                lblShared.frame=CGRectMake(btnShared.frame.origin.x+68-20, 50, 15, 15);
            }
            //lblShared.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
            
            
            
        }
        else if([[arrtab objectAtIndex:p] isEqualToString:@"Urgent"]){
            btnUrgent.frame=CGRectMake(x, y, width, height);
            if(p==0){
                lblUrgent.frame=CGRectMake(btnUrgent.frame.origin.x+68-20, 50, 15, 15);
            }
            else if(p==7){
                lblUrgent.frame=CGRectMake(btnUrgent.frame.origin.x+68-25, 50, 15, 15);
            }
            else{
                lblUrgent.frame=CGRectMake(btnUrgent.frame.origin.x+68-20, 50, 15, 15);
            }
            //lblUrgent.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
            
            
            
        }
        else if([[arrtab objectAtIndex:p] isEqualToString:@"Shopping"]){
            btnShopping.frame=CGRectMake(x, y, width, height);
            if(p==0){
                lblShopping.frame=CGRectMake(btnShopping.frame.origin.x+68-20, 50, 15, 15);
            }
            else if(p==7){
                lblShopping.frame=CGRectMake(btnShopping.frame.origin.x+68-25, 50, 15, 15);
            }
            else{
                lblShopping.frame=CGRectMake(btnShopping.frame.origin.x+68-20, 50, 15, 15);
            }
            //lblShopping.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
            
        }
        else{
            
        }
        x=x+66;  
        // height=height+68;
        
    }

}

-(void)JSONFacebook
{
    

    [AlertHandler showAlertForProcess];
    NSString *str;
    str=[NSString stringWithFormat:@"%@/user_action.php?action=FbLogin&email=%@",appdel.url,appdel
         .strLoginID];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchfaceBook:) andHandler:self];
    NSLog(@"%@",parser);
    
	
}
-(void)searchfaceBook:(NSDictionary*)dictionary
{
    
    NSLog(@"%@",dictionary);
    
    allFlag=10;
    alertFlag=1;
    NSString *str=[dictionary valueForKey:@"uid"];
    
    [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self JSONMainCategory];
    
}	


#pragma mark Json Main Category
-(void)JSONMainCategory
{
   
 
    [AlertHandler showAlertForProcess];
    
    
    NSString *str;
    NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
  //  http://openxcellaus.info/emainder
    
    str=[NSString stringWithFormat:@"%@/retrieve_data.php?type=main_category&userid=%@",appdel.url,str_id];
    
    
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchResultMainCat:) andHandler:self];
    NSLog(@"%@",parser);
	
}
-(void)searchResultMainCat:(NSDictionary*)dictionary
{
   
    NSLog(@"%@",dictionary);
   
    
    alertFlag=1;
    NSMutableArray *arrCountMaintask=[[NSMutableArray alloc] initWithArray:[[dictionary valueForKey:@"main_category_list"]valueForKey:@"sub_cat_count"]];
    NSLog(@"%@",arrCountMaintask);
   // NSLog(@"unique work %@",[arrCountMaintask valueForKey:@"sub_cat_count"]);
    lblWork1.text=[NSString stringWithFormat:@"%@",[arrCountMaintask objectAtIndex:0]];
    lblPer.text=[NSString stringWithFormat:@"%@",[arrCountMaintask objectAtIndex:3]];
    lblfami.text=[NSString stringWithFormat:@"%@",[arrCountMaintask objectAtIndex:1]];
    lblhealt.text=[NSString stringWithFormat:@"%@",[arrCountMaintask objectAtIndex:2]];
    lblFin.text=[NSString stringWithFormat:@"%@",[arrCountMaintask objectAtIndex:4]];
    lblShar.text=[NSString stringWithFormat:@"%@",[arrCountMaintask objectAtIndex:5]];
    lblUrge.text=[NSString stringWithFormat:@"%@",[arrCountMaintask objectAtIndex:6]];
    lblShop.text=[NSString stringWithFormat:@"%@",[arrCountMaintask objectAtIndex:7]];
   
    
    NSMutableArray *arrDb;
    arrDb=(NSMutableArray *)[dictionary valueForKey:@"main_category_list"];

    NSLog(@"arr db %@",arrDb);
    for(int y=0;y<[arrDb count];y++){
    [dal insertRecord:[arrDb objectAtIndex:y]inTable:@"tblMainTaskCount"];
    
    }
    
   
    [self JSON];
      
    
    if(arrCountMaintask!=nil){
        [arrCountMaintask removeAllObjects];
        [arrCountMaintask release];
        arrCountMaintask=nil;
    }
    
}	

#pragma mark JSON Category

-(void)JSON_insert
{
    
    NSString *str;
    NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
    
    http://www.openxcellaus.info/emainder/insert_data.php?type=main_task&title=MyFinalLAstTaskkkkk123123&userid=1&parent_id=1&status=yes&priority=medium
    str=[NSString stringWithFormat:@"%@/insert_data.php?type=main_task&title=MyFinalLAstTaskkkkk123123&userid=1&parent_id=1&status=yes&priority=medium",appdel.url];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchResultInsert:) andHandler:self];
    
    NSLog(@"%@",parser);
	
}
-(void)searchResultInsert:(NSDictionary*)dictionary
{
    
    
    
    
    
    NSLog(@"%@",dictionary);
    
       
}	

-(void)JSON
{
        
    NSString *str;
    NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];

   
    str=[NSString stringWithFormat:@"%@/retrieve_data.php?type=sub_category&userid=%@",appdel.url,str_id];
  
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchResult:) andHandler:self];
    
    NSLog(@"%@",parser);
	
}
-(void)searchResult:(NSDictionary*)dictionary
{
   
    
    
        
    
    NSLog(@"%@",dictionary);
    
    NSMutableArray *arrDbtemp;
    arrDbtemp=(NSMutableArray *)[dictionary valueForKey:@"sub_category_list"];
    NSMutableDictionary *dictfff=[[NSMutableDictionary alloc] init];
   
    for(int h=0;h<[arrDbtemp count];h++){
        [dictfff removeAllObjects];
//        
        
        [dictfff setObject:[[arrDbtemp objectAtIndex:h] valueForKey:@"title"]forKey:@"titleCat"] ;
        [dictfff setObject:[[arrDbtemp objectAtIndex:h] valueForKey:@"mcid"]forKey:@"mcid"];
        [dictfff setObject:[[arrDbtemp objectAtIndex:h] valueForKey:@"scid"]forKey:@"scid"];
        [dictfff setObject:[[arrDbtemp objectAtIndex:h] valueForKey:@"userid"]forKey:@"userid"];
        [dictfff setObject:[NSString stringWithFormat:@"%d",h] forKey:@"postionCat"];
        NSLog(@"%@",dictfff);
                
       
        
        [dal insertRecord:dictfff inTable:@"tblSubCat"];
    }

        
    
    if(dictfff!=nil){
        [dictfff removeAllObjects];
        [dictfff release];
        dictfff=nil;
    }
    
    [self JSON_maintaskRetrive];
       
          
    
    
   

    
}	
-(void)JSON_maintaskRetrive
{
    
    
    
    
    NSString *str;
    NSLog(@"%@",appdel.url);
    
    // appdel.url=@"http://openxcellaus.info/emainder";
    
    NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
        
    
    str=[NSString stringWithFormat:@"%@/retrieve_data.php?type=main_task&userid=%@",appdel.url,str_id];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchResultMainTaskRet:) andHandler:self];
    NSLog(@"%@",parser);
}

-(void)searchResultMainTaskRet:(NSDictionary*)dictionary
{
    
    
    alertFlag=0;
    NSLog(@"%@",dictionary);
    NSMutableArray *arrDb;
    arrDb=(NSMutableArray *)[dictionary valueForKey:@"main_task_list"];
    NSMutableDictionary *dicthello=[[[NSMutableDictionary alloc] init] autorelease];
    NSLog(@"arr db %@",arrDb);
    for(int y=0;y<[arrDb count];y++){
        [dicthello removeAllObjects];
        dicthello=[arrDb objectAtIndex:y];
      
        [dicthello setObject:[NSString stringWithFormat:@"%d",y] forKey:@"position"];
       
        NSLog(@"%@",dicthello);
        [dal insertRecord:dicthello inTable:@"tblMainTask"];
        
    }

    [self JSON_subtaskRetrive];
       
   
   
}
-(void)JSON_subtaskRetrive
{
    
   
   
    NSString *str;
    NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
    
    //NSString *str_sub = [[NSUserDefaults standardUserDefaults]valueForKey:@"str_mtid"];
    
    str=[NSString stringWithFormat:@"%@/retrieve_data.php?type=sub_task&userid=%@",appdel.url,str_id];
    
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchResultSubTaskRet:) andHandler:self];
    NSLog(@"%@",parser);
}
-(void)searchResultSubTaskRet:(NSDictionary*)dictionary
{
    [AlertHandler hideAlert];
    NSLog(@"%@",dictionary);
    NSMutableArray *arrDb;
    arrDb=(NSMutableArray *)[dictionary valueForKey:@"sub_task_list"];
    
    NSLog(@"arr db %@",arrDb);
   
    for(int y=0;y<[arrDb count];y++){
        
        
        [dal insertRecord:[arrDb objectAtIndex:y] inTable:@"tblSubTask"];
        
    }
     NSMutableDictionary *dicjjj=[[NSMutableDictionary alloc] init];
    for(int g=0;g<[arrDb count];g++){
        [dicjjj removeAllObjects];
        [dicjjj setObject:[NSString stringWithFormat:@"%d",g] forKey:@"position"];
        NSLog(@"dicjjjj %@",dicjjj);
        [dal updateRecord:dicjjj forID:@"stid=" inTable:@"tblSubTask" withValue:[NSString stringWithFormat:@"%@",[[arrDb objectAtIndex:g] valueForKey:@"stid"]                                                                 ]];
    }
    if(dicjjj!=nil){
        [dicjjj removeAllObjects];
        [dicjjj release];
        dicjjj=nil;
    }
    flagStart=1;
    [self getSubCat];
   
}
#pragma mark Get
-(void)getSubCat{
    
    NSArray *arr=[[NSArray alloc] initWithObjects:@"scid",@"titleCat", nil];
    NSMutableArray *arrnew=[dal SelectQuery:@"tblSubCat" withColumn:arr withCondition:@"mcid=" withColumnValue:[NSString stringWithFormat:@"%@ order by postionCat",appdel.str_mcid]];
   
    
    [arrScid removeAllObjects];
    [arrsubCatTitle removeAllObjects];
    for(int m=0;m<[arrnew count];m++){
        [arrScid addObject:[[arrnew objectAtIndex:m]objectForKey:@"scid"]];
        [arrsubCatTitle addObject:[[arrnew objectAtIndex:m]objectForKey:@"titleCat"]];
    }
    if(arr!=nil){
        
        
        arr=nil;
        [arr release];
    }
   
    [table1 reloadData];
    if(flagStart==1){
        flagStart=0;
        alertFlag=1;
        str_scid=[arrScid objectAtIndex:0];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [table1 cellForRowAtIndexPath:indexPath];
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Active side line.png"]] autorelease];
        cell.textLabel.highlightedTextColor = [UIColor colorWithRed:61.0/255.0 green:109/255.0 blue:149/255.0 alpha:1];
        
        [table1 selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
        isOpen=FALSE;
        [self getAllMainTask];
        
    }
        
}
-(void) getAllMainTask{
    NSMutableDictionary *dictget;
    NSString *strSort = [[NSUserDefaults standardUserDefaults]valueForKey:@"sort"];
    if([strSort isEqualToString:@"status"]){
        dictget=[dal executeDataSet:[NSString stringWithFormat:@"select fi.title, fi.status,fi.priority,fi.child,fi.sub_task_count,fi.mtid,fi.position from tblMainTask fi inner join tblSubCat ii on ii.scid = fi.scid where ii.mcid=%@ order by fi.status",appdel.str_mcid]];
    }
    else if([strSort isEqualToString:@"priority"]){
         dictget=[dal executeDataSet:[NSString stringWithFormat:@"select fi.title, fi.status,fi.priority,fi.child,fi.sub_task_count,fi.mtid,fi.position from tblMainTask fi inner join tblSubCat ii on ii.scid = fi.scid where ii.mcid=%@ order by fi.priority",appdel.str_mcid]];
    }
    else{
        
       dictget=[dal executeDataSet:[NSString stringWithFormat:@"select fi.title, fi.status,fi.priority,fi.child,fi.sub_task_count,fi.mtid,fi.position from tblMainTask fi inner join tblSubCat ii on ii.scid = fi.scid where ii.mcid=%@ order by fi.position",appdel.str_mcid]];
    }
     NSLog(@"%@",dictget);
    NSMutableArray *arrGet=[[NSMutableArray alloc] init];
    for(int m=1;m<=[dictget count];m++){
        [arrGet addObject:[dictget valueForKey:[NSString stringWithFormat:@"Table%d",m]]];
    }
    
    NSLog(@"%@",arrGet);
    
    [dictMainTask removeAllObjects];
    [dictForRows removeAllObjects];
    [dic_txt removeAllObjects];
    NSLog(@"%@",arrGet);
    
    for(int m=0;m<[arrGet count];m++){
        [dic_txt setObject:[[arrGet objectAtIndex:m]objectForKey:@"title"] forKey:[NSString stringWithFormat:@"%d^0",m]];
        [dictMainTask setObject:[[arrGet objectAtIndex:m]objectForKey:@"title"] forKey:[NSString stringWithFormat:@"%d^%d",m,0]];
        //[dictArrow setObject:[[arrGet objectAtIndex:m]objectForKey:@"child"] forKey:[NSString stringWithFormat:@"%d^%d",m,0]];
        [dictSubTaskID setObject:[[arrGet objectAtIndex:m]objectForKey:@"mtid"] forKey:[NSString stringWithFormat:@"%d^%d",m,0]];
        if(i==100){
            
        }
        else{
            [dictForRows setObject:@"1" forKey:[NSString stringWithFormat:@"%d^%d",m,0]];
        }
        UIImage *image=[UIImage imageNamed:@"btnkeep.png"];
        NSData* pictureData = UIImagePNGRepresentation(image);
        if(pictureData)
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^0",m]];
        [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^0",m]];
        
    }
    NSLog(@"%@",dictMainTask);
    for(int h=0;h<[arrGet count];h++){
        if([[[arrGet objectAtIndex:h] objectForKey:@"status"] isEqualToString:@"0"]){
            UIImage *image=[UIImage imageNamed:@"Ellipse 1.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
            //[dic_image setObject:[arrStatus objectAtIndex:h] forKey:[NSString stringWithFormat:@"%d^%d",tagbtn-1,h]];
        }
        else if([[[arrGet objectAtIndex:h] objectForKey:@"status"] isEqualToString:@"1"]){
            UIImage *image=[UIImage imageNamed:@"Ellipse.png"];
            NSData* pictureData =UIImagePNGRepresentation(image);
            
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
        }
        else if([[[arrGet objectAtIndex:h] objectForKey:@"status"] isEqualToString:@"2"]){
            UIImage *image=[UIImage imageNamed:@"pause.png"];
            NSData* pictureData =UIImagePNGRepresentation(image);
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
            
        }
        else if([[[arrGet objectAtIndex:h] objectForKey:@"status"] isEqualToString:@"3"]){
            UIImage *image=[UIImage imageNamed:@"checksymbol.png"];
            NSData* pictureData =UIImagePNGRepresentation(image);
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
            
        }
        else{
            UIImage *image=[UIImage imageNamed:@"btnkeep.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
        }
    }
    
    
    for(int h=0;h<[arrGet count];h++){
        if([[[arrGet objectAtIndex:h] objectForKey:@"priority"] isEqualToString:@"0"]){
            UIImage *image=[UIImage imageNamed:@"Acitical.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
            
        }
        else if([[[arrGet objectAtIndex:h] objectForKey:@"priority"] isEqualToString:@"1"]){
            UIImage *image=[UIImage imageNamed:@"BHigh.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            
            [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
        }
        else if([[[arrGet objectAtIndex:h] objectForKey:@"priority"] isEqualToString:@"2"]){
            UIImage *image=[UIImage imageNamed:@"C.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            if(pictureData)
                [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
        }
        else{
            UIImage *image=[UIImage imageNamed:@"btnkeep.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
        }
    }
    
    if(!isOpen){           
        [arr_tagNew removeAllObjects];
        for(int h=0;h<[arrGet count];h++)
        {
            i=5;
            [arr_tagNew addObject:[NSString stringWithFormat:@"%d",0]];
            
        }
        
    }
    else{
        
    }
    i=5;
    
    NSLog(@"%@",arr_tagNew);
    
    
   
   
   
    rowsCnt=0;
   
    
    
    tagbtn=0;
    for(int p=0;p<[arrGet count];p++){
        
        
        int arrow=[self getsubTask:[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^0",p]]];
        NSLog(@"%d",arrow);
        if(arrow>=1){
            [dictArrow setObject:@"1" forKey:[NSString stringWithFormat:@"%d^0",p]];
        }
        else{
            [dictArrow setObject:@"0"forKey:[NSString stringWithFormat:@"%d^0",p]];
        }
        tagbtn++;
    }
    
    if(arrGet!=nil){
        [arrGet removeAllObjects];
        [arrGet release];
        arrGet=nil;
    }
    NSLog(@"%@",dictForRows);
    NSLog(@"%@",dic_txt);
     NSLog(@"Sections %d",[dictMainTask count]);
   
     [self getCount];
    if([dictMainTask count]==0){
        table2.editing=FALSE;
        lineVIew1.frame=CGRectMake(0, 0, 1, 760);
        lineView2.frame=CGRectMake(45, 0, 1, 760);
        lineView3.frame=CGRectMake(90, 0, 1, 760);
        lineView4.frame=CGRectMake(465, 0, 1, 760);
        int add=0;
        if(self.interfaceOrientation==UIInterfaceOrientationLandscapeRight || self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
            add=134;
        }
        else{
            add=0;
        }
        lblStatus.frame=CGRectMake(249+add, 171, 46, 21);
        lblPriority.frame=CGRectMake(295+add, 171, 46, 21);
        [editBtn2 setImage:[UIImage imageNamed:@"Edit.png"] forState:UIControlStateNormal];
        
    }
    [table2 reloadData];
    //[self CallMe];
    //[self performSelector:@selector(CallMe) withObject:nil afterDelay:5];
   
   
}
-(void)CallMe{
    
    [table2 reloadData];
}
-(void)getMainTask{
    
    
    
    NSArray *arr1=[[NSArray alloc]initWithObjects:@"sub_task_count",@"title",@"child",@"mtid",@"status",@"priority",@"position", nil];
    NSMutableArray *arrGet1;
     NSString *strSort = [[NSUserDefaults standardUserDefaults]valueForKey:@"sort"];
    if([strSort isEqualToString:@"status"]){
       arrGet1=(NSMutableArray *)[dal executeDataSet:[NSString stringWithFormat:@"select sub_task_count,title,child,mtid,status,priority,position from tblMainTask  where scid=%@ order by status",str_scid]];
    }
    else if([strSort isEqualToString:@"priority"]){
        arrGet1=(NSMutableArray *)[dal executeDataSet:[NSString stringWithFormat:@"select sub_task_count,title,child,mtid,status,priority,position from tblMainTask  where scid=%@ order by priority",str_scid]];
    }
    else{
        
        arrGet1=(NSMutableArray *)[dal executeDataSet:[NSString stringWithFormat:@"select sub_task_count,title,child,mtid,status,priority,position from tblMainTask  where scid=%@ order by position",str_scid]];
    }
    
    
    
   
   
    NSMutableArray *arrGet=[[NSMutableArray alloc] init];
    for(int y=0;y<[arrGet1 count];y++){
        [arrGet addObject:[arrGet1 valueForKey:[NSString stringWithFormat:@"Table%d",y+1]]];
    }
    //arrGet=[dal SelectQuery:@"tblMainTask" withColumn:arr1 withCondition:@"scid=" withColumnValue:[NSString stringWithFormat:@"%@",str_scid]];
   
        
    
    [dictMainTask removeAllObjects];
  
   
    for(int m=0;m<[arrGet count];m++){
        [dic_txt setObject:[[arrGet objectAtIndex:m] objectForKey:@"title"] forKey:[NSString stringWithFormat:@"%d^0",m]];
        [dictMainTask setObject:[[arrGet objectAtIndex:m]objectForKey:@"title"] forKey:[NSString stringWithFormat:@"%d^%d",m,0]];
        //[dictArrow setObject:[[arrGet objectAtIndex:m]objectForKey:@"child"] forKey:[NSString stringWithFormat:@"%d^%d",m,0]];
        [dictSubTaskID setObject:[[arrGet objectAtIndex:m]objectForKey:@"mtid"] forKey:[NSString stringWithFormat:@"%d^%d",m,0]];
        if(i==100){
            
        }
        else{
            [dictForRows setObject:@"1" forKey:[NSString stringWithFormat:@"%d^%d",m,0]];
        }
        UIImage *image=[UIImage imageNamed:@"btnkeep.png"];
        NSData* pictureData = UIImagePNGRepresentation(image);
        if(pictureData)
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^0",m]];
        [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^0",m]];
        
    }
    NSLog(@"%@",dictMainTask);
    for(int h=0;h<[arrGet count];h++){
        if([[[arrGet objectAtIndex:h] objectForKey:@"status"] isEqualToString:@"0"]){
            UIImage *image=[UIImage imageNamed:@"Ellipse 1.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
            //[dic_image setObject:[arrStatus objectAtIndex:h] forKey:[NSString stringWithFormat:@"%d^%d",tagbtn-1,h]];
        }
        else if([[[arrGet objectAtIndex:h] objectForKey:@"status"] isEqualToString:@"1"]){
            UIImage *image=[UIImage imageNamed:@"Ellipse.png"];
            NSData* pictureData =UIImagePNGRepresentation(image);
            
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
        }
        else if([[[arrGet objectAtIndex:h] objectForKey:@"status"] isEqualToString:@"2"]){
            UIImage *image=[UIImage imageNamed:@"pause.png"];
            NSData* pictureData =UIImagePNGRepresentation(image);
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
            
        }
        else if([[[arrGet objectAtIndex:h] objectForKey:@"status"] isEqualToString:@"3"]){
            UIImage *image=[UIImage imageNamed:@"checksymbol.png"];
            NSData* pictureData =UIImagePNGRepresentation(image);
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
            
        }
        else{
            UIImage *image=[UIImage imageNamed:@"btnkeep.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
        }
    }
    
    
    for(int h=0;h<[arrGet count];h++){
        if([[[arrGet objectAtIndex:h] objectForKey:@"priority"] isEqualToString:@"0"]){
            UIImage *image=[UIImage imageNamed:@"Acitical.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
            
        }
        else if([[[arrGet objectAtIndex:h] objectForKey:@"priority"] isEqualToString:@"1"]){
            UIImage *image=[UIImage imageNamed:@"BHigh.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            
            [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
        }
        else if([[[arrGet objectAtIndex:h] objectForKey:@"priority"] isEqualToString:@"2"]){
            UIImage *image=[UIImage imageNamed:@"C.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            if(pictureData)
                [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
        }
        else{
            UIImage *image=[UIImage imageNamed:@"btnkeep.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",h,0]];
        }
    }
    
    if(!isOpen){           
    [arr_tagNew removeAllObjects];
    for(int h=0;h<[arrGet count];h++)
    {
        i=5;
        [arr_tagNew addObject:[NSString stringWithFormat:@"%d",0]];
                
    }
                
    }
    else{
        
    }
    i=5;
            
    NSLog(@"%@",arr_tagNew);
    
    
    
    [self getCount];
    
    
   

    if(arr1!=nil){
        [arr1 release];
        arr1=nil;
    }
    tagbtn=0;
    for(int p=0;p<[arrGet count];p++){
        
      
        int arrow=[self getsubTask:[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^0",p]]];
        NSLog(@"%d",arrow);
        if(arrow>=1){
        [dictArrow setObject:@"1" forKey:[NSString stringWithFormat:@"%d^0",p]];
        }
        else{
            [dictArrow setObject:@"0"forKey:[NSString stringWithFormat:@"%d^0",p]];
        }
        tagbtn++;
    }
    if(arrGet!=nil){
        [arrGet removeAllObjects];
        [arrGet release];
        arrGet=nil;
    }
    rowsCnt=0;
    NSLog(@"%@",dictForRows);
    NSLog(@"%@",dic_txt);
    NSLog(@"%@",dictMainTask);
    if([dictMainTask count]==0){
        table2.editing=FALSE;
        int add=0;
        if(self.interfaceOrientation==UIInterfaceOrientationLandscapeRight || self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
            add=134;
        }
        else{
            add=0;
        }

        lineVIew1.frame=CGRectMake(0, 0, 1, 760);
        lineView2.frame=CGRectMake(45, 0, 1, 760);
        lineView3.frame=CGRectMake(90, 0, 1, 760);
        lineView4.frame=CGRectMake(465, 0, 1, 760);
        lblStatus.frame=CGRectMake(249+add, 171, 46, 21);
        lblPriority.frame=CGRectMake(295+add, 171, 46, 21);
         [editBtn2 setImage:[UIImage imageNamed:@"Edit.png"] forState:UIControlStateNormal];
    }
    [table2 reloadData];

    
    
}
-(int)getsubTask:(NSString *)mtid{
    NSArray *arr1=[[NSArray alloc]initWithObjects:@"stid",@"title",@"priority",@"position",@"status", nil];
    NSMutableArray *arrRet;
    arrRet=[dal SelectQuery:@"tblSubTask" withColumn:arr1 withCondition:@"mtid= " withColumnValue:[NSString stringWithFormat:@"%@ order by position",mtid]];
    NSLog(@"arrer %@",arrRet);
    NSLog(@"tagbtn %d",tagbtn);
     
    if([arrRet count]==0){
        return 0;
    }
    for(int y=1;y<=[arrRet count];y++)
    {
        [dic_txt setObject:[NSString stringWithFormat:@"%@",[[arrRet objectAtIndex:y-1]objectForKey:@"title"]] forKey:[NSString stringWithFormat:@"%d^%d",tagbtn,y]];
        
        [dictSubTaskID setObject:[[arrRet objectAtIndex:y-1]objectForKey:@"stid"] forKey:[NSString stringWithFormat:@"%d^%d",tagbtn,y]];
    }
    
    
    [dictForRows setObject:[NSString stringWithFormat:@"%d",[arrRet count]+1] forKey:[NSString stringWithFormat:@"%d^0",tagbtn]];
    
    for(int h=1;h<=[arrRet count];h++){
        if([[[arrRet objectAtIndex:h-1] objectForKey:@"status"] isEqualToString:@"0"]){
            UIImage *image=[UIImage imageNamed:@"Ellipse 1.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",tagbtn,h]];
            
        }
        else if([[[arrRet objectAtIndex:h-1] objectForKey:@"status"] isEqualToString:@"1"]){
            UIImage *image=[UIImage imageNamed:@"Ellipse.png"];
            NSData* pictureData =UIImagePNGRepresentation(image);
            
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",tagbtn,h]];
        }
        else if([[[arrRet objectAtIndex:h-1] objectForKey:@"status"] isEqualToString:@"2"]){
            UIImage *image=[UIImage imageNamed:@"pause.png"];
            NSData* pictureData =UIImagePNGRepresentation(image);
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",tagbtn,h]];
            
        }
        else if([[[arrRet objectAtIndex:h-1] objectForKey:@"status"] isEqualToString:@"3"]){
            UIImage *image=[UIImage imageNamed:@"checksymbol.png"];
            NSData* pictureData =UIImagePNGRepresentation(image);
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",tagbtn,h]];
            
        }
        else{
            UIImage *image=[UIImage imageNamed:@"btnkeep.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            [dic_image setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",tagbtn,h]];
        }
    }
    
    
    for(int h=1;h<=[arrRet count];h++){
        if([[[arrRet objectAtIndex:h-1] objectForKey:@"priority"] isEqualToString:@"0"]){
            UIImage *image=[UIImage imageNamed:@"Acitical.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",tagbtn,h]];
            
        }
        else if([[[arrRet objectAtIndex:h-1] objectForKey:@"priority"] isEqualToString:@"1"]){
            UIImage *image=[UIImage imageNamed:@"BHigh.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            
            [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",tagbtn,h]];
        }
        else if([[[arrRet objectAtIndex:h-1] objectForKey:@"priority"] isEqualToString:@"2"]){
            UIImage *image=[UIImage imageNamed:@"C.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            if(pictureData)
                [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",tagbtn,h]];
        }
        else{
            UIImage *image=[UIImage imageNamed:@"btnkeep.png"];
            NSData* pictureData = UIImagePNGRepresentation(image);
            [dic_priorityimage setObject:pictureData forKey:[NSString stringWithFormat:@"%d^%d",tagbtn,h]];
        }
    }
    rowsCnt=0;
    NSLog(@"arrert count %d",[arrRet count]);
    
    return [arrRet count];
    

}
-(void)getCalendar{
    
    
    
    NSArray *arr=[[NSArray alloc] initWithObjects:@"cid",@"title",@"date",@"datedate",@"priority", nil];
    NSMutableArray *arrDates;
    arrDates=[dal SelectQuery:@"tblCal" withColumn:arr withCondition:@"date=" withColumnValue:[NSString stringWithFormat:@"'%@%@'",lblDate.text,lblMonth.text]];
    // NSMutableArray *arr=[[dal SelectWithStar:@"tblSubCat"] retain];
    NSLog(@"arr dates %@",arrDates);
    [arrCalText removeAllObjects];
   
    for(int a1=0;a1<[arrDates count];a1++){
        
        [arrCalText addObject:[arrDates objectAtIndex:a1]];
        
    }
    NSLog(@"%@",arrCalText);
    calIndex=0;
    isCalAdd=FALSE;
    
    //[self performSelector:@selector(relodataEvents) withObject:self afterDelay:0.5];
    
    [tblCalendar reloadData];

    
}
-(void)relodataEvents{
    [tblCalendar reloadData];
}
#pragma mark Insert
-(void)insertMainTask{
    NSMutableDictionary *dictTemp=[[NSMutableDictionary alloc] init];
    NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
   
    NSString *strZ=@"0";
    NSString *firstCapChar = [[strMainTaskTitle substringToIndex:1] capitalizedString];
    NSString *cappedString = [strMainTaskTitle stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
   
    int dupFlag=0;
   
    for(int u=0;u<[dictMainTask count];u++){
        for(int p=0;p<[[dictForRows valueForKey:[NSString stringWithFormat:@"%d^0",u]] intValue];p++){
            if([[dic_txt valueForKey:[NSString stringWithFormat:@"%d^%d",u,p]]isEqualToString:[NSString stringWithFormat:@"%@",cappedString]]){
                 dupFlag=1;
                //txtmainfld.text=@"";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!!" message:[NSString stringWithFormat:@"%@ Already Exists.",cappedString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                [alert release];
               
                
               
            }
                
        }
    }
    if(dupFlag==0){
    NSMutableDictionary *dictre;
    dictre=   [dal executeDataSet:[NSString stringWithFormat:@"select max(position) from tblMainTask"]];
        NSLog(@"str scid==%@",str_scid);
    NSLog(@"%@",[dictre valueForKey:@"Table1"]);
    NSLog(@"%@",[[dictre valueForKey:@"Table1"] valueForKey:@"max(position)"]);
    int cnt=[[[dictre valueForKey:@"Table1"]valueForKey:@"max(position)"] intValue];
    [dictTemp setObject:[NSString stringWithFormat:@"%d",cnt+1] forKey:@"position"];
    [dictTemp setObject:[NSString stringWithFormat:@"%@",cappedString] forKey:@"title"];
    [dictTemp setObject:[NSString stringWithFormat:@"%@",str_scid ] forKey:@"scid"];
    [dictTemp setObject:@"0" forKey:@"status"];
    [dictTemp setObject:@"2" forKey:@"priority"];
    [dictTemp setObject:[NSString stringWithFormat:@"%@",str_id] forKey:@"userid"];
    [dictTemp setObject:[NSString stringWithFormat:@"%@",strZ] forKey:@"child"];
    [dictTemp setObject:[NSString stringWithFormat:@"%@",strZ] forKey:@"sub_task_count"];
    //[dictTemp setObject:[NSString stringWithFormat:@"%@",appdel.str_mcid] forKey:@"mcid"];
    NSLog(@"%@",dictTemp);
    [dal insertRecord:dictTemp inTable:@"tblMainTask"];
   
        
    NSLog(@"%@",[arrScid objectAtIndex:0]);
    
   

    [arr_tagNew addObject:[NSString stringWithFormat:@"%d",0]];
    
    }
    
    if(dictTemp!=nil){
        [dictTemp removeAllObjects];
        [dictTemp release];
        dictTemp=nil;
    }

    isOpen=TRUE;
    if(isEdit==0){
        [self getAllMainTask];
    }
    else{
        [self getMainTask];
    }
   [self performSelector:@selector(CallMe) withObject:nil afterDelay:0.3];
}
-(void)insertSubCat{
    NSMutableDictionary *dictTemp=[[NSMutableDictionary alloc] init];
    NSString *firstCapChar = [[strSubCatTitle substringToIndex:1] capitalizedString];
    NSString *cappedString = [strSubCatTitle stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    int flagDup=0;
    for(int m=0;m<[arrsubCatTitle count];m++){
        if([cappedString isEqualToString:[arrsubCatTitle objectAtIndex:m]]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!!" message:[NSString stringWithFormat:@"%@ Already Exists.",cappedString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //txt_category.text=@"";
            flagDup=1;
            [alert show];
            [alert release];
        }
    }
    if(flagDup==0){
          
        NSMutableDictionary *dictre;
        dictre=   [dal executeDataSet:[NSString stringWithFormat:@"select max(position) from tblMainTask"]];
        
        
        int cnt=[[[dictre valueForKey:@"Table1"]valueForKey:@"max(position)"] intValue];
        [dictTemp setObject:[NSString stringWithFormat:@"%d",cnt+1] forKey:@"postionCat"];
        NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
        [dictTemp setObject:[NSString stringWithFormat:@"%@",cappedString] forKey:@"titleCat"];
        [dictTemp setObject:[NSString stringWithFormat:@"%@",appdel.str_mcid ] forKey:@"mcid"];
        [dictTemp setObject:[NSString stringWithFormat:@"%@",str_id] forKey:@"userid"];
            
        NSLog(@"%@",dictTemp);
        [dal insertRecord:dictTemp inTable:@"tblSubCat"];
    }    
    strSubCatTitle=@"";
    if(dictTemp!=nil){
        [dictTemp removeAllObjects];
        [dictTemp release];
        dictTemp=nil;
    }
    [self getSubCat];
    [self performSelector:@selector(CallMeForCat) withObject:nil afterDelay:0.3];
    
    
}
-(void)CallMeForCat{
    [table1 reloadData];
}
#pragma mark Update
-(void)updateStatusMain{
    NSMutableDictionary *dica=[[NSMutableDictionary alloc] init];
    NSString *strstatus = [[NSUserDefaults standardUserDefaults]valueForKey:@"strimage"];
    
    NSLog(@"str stat is %@",strstatus);
    
    [dica setObject:[NSString stringWithFormat:@"%@",strstatus] forKey:@"status"];
    [dal updateRecord:dica forID:@"mtid="inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",str_mtid] ];
    if(dica!=nil){
        [dica removeAllObjects];
        [dica release];
        dica=nil;
    }
    isOpen=TRUE;
    if(isEdit==0){
        [self getAllMainTask];
    }
    else{
        [self getMainTask];
    }
}
-(void)updatePriorityMain{
    NSMutableDictionary *dica=[[NSMutableDictionary alloc] init];
    NSString *strstatus = [[NSUserDefaults standardUserDefaults]valueForKey:@"strimage_priority"];
    
    NSLog(@"str stat is %@",strstatus);

    [dica setObject:[NSString stringWithFormat:@"%@",strstatus] forKey:@"priority"];
    [dal updateRecord:dica forID:@"mtid="inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",str_mtid] ];
    if(dica!=nil){
        [dica removeAllObjects];
        [dica release];
        dica=nil;
    }
    isOpen=TRUE;
    if(isEdit==0){
        [self getAllMainTask];
    }
    else{
        [self getMainTask];
    }
}
-(void)updateStatusSub{
    NSMutableDictionary *dica=[[NSMutableDictionary alloc] init];
    NSString *strstatus = [[NSUserDefaults standardUserDefaults]valueForKey:@"strimage"];
    
    NSLog(@"str stat is %@",strstatus);
    
    [dica setObject:[NSString stringWithFormat:@"%@",strstatus] forKey:@"status"];
    [dal updateRecord:dica forID:@"stid="inTable:@"tblSubTask" withValue:[NSString stringWithFormat:@"%@",str_stid] ];
    if(dica!=nil){
        [dica removeAllObjects];
        [dica release];
        dica=nil;
    }
    isOpen=TRUE;
    if(isEdit==0){
        [self getAllMainTask];
    }
    else{
        [self getMainTask];
    }
}
-(void)updatePrioritySub{
    NSMutableDictionary *dica=[[NSMutableDictionary alloc] init];
    NSString *strstatus = [[NSUserDefaults standardUserDefaults]valueForKey:@"strimage_priority"];
    
    NSLog(@"str stat is %@",strstatus);
    
    [dica setObject:[NSString stringWithFormat:@"%@",strstatus] forKey:@"priority"];
    [dal updateRecord:dica forID:@"stid="inTable:@"tblSubTask" withValue:[NSString stringWithFormat:@"%@",str_stid] ];
    if(dica!=nil){
        [dica removeAllObjects];
        [dica release];
        dica=nil;
    }
    isOpen=TRUE;
    if(isEdit==0){
        [self getAllMainTask];
    }
    else{
        [self getMainTask];
    }
}
-(void)updatePriCal{
    NSMutableDictionary *dica=[[NSMutableDictionary alloc] init];
    NSString *strstatus = [[NSUserDefaults standardUserDefaults]valueForKey:@"strimage_priority"];
    
    NSLog(@"str stat is %@",strstatus);
    
    [dica setObject:[NSString stringWithFormat:@"%@",strstatus] forKey:@"priority"];
    [dal updateRecord:dica forID:@"cid="inTable:@"tblCal" withValue:[NSString stringWithFormat:@"%@",str_cid] ];
    if(dica!=nil){
        [dica removeAllObjects];
        [dica release];
        dica=nil;
    }
    [self getCalendar];
}
#pragma mark Delete
-(void)deleteSubCat{
    [dal deleteFromTable:@"tblSubCat" WhereField:@"scid=" Condition:[NSString stringWithFormat:@"%@",str_scid]];
    [dal deleteFromTable:@"tblMainTask" WhereField:@"scid=" Condition:[NSString stringWithFormat:@"%@",str_scid]];
    [self getSubCat];
}
-(void)deleteMainTask{
    NSLog(@"%@",str_mtid);
  [dal deleteFromTable:@"tblMainTask" WhereField:@"mtid=" 
           Condition:[NSString stringWithFormat:@"%@",str_mtid]];
    [dal
     deleteFromTable:@"tblSubTask" WhereField:@"mtid=" Condition:[NSString stringWithFormat:@"%@",str_mtid]];
    isOpen=TRUE;
    NSLog(@"tag in del %@",arr_tagNew);
    [arr_tagNew removeObjectAtIndex:sectionOUt];
    [self getCount];
    if(isEdit==0){
        [self getAllMainTask];
    }
    else{
    [self getMainTask];
    }
}
-(void)deleteSubtask{
    NSLog(@"%@",str_stid);
    [dal deleteFromTable:@"tblSubTask" WhereField:@"stid=" Condition:[NSString stringWithFormat:@"%@",str_stid]];
    isOpen=TRUE;
    if(isEdit==0){
        [self getAllMainTask];
    }
    else{
        [self getMainTask];
    }
    
   
}
#pragma mark count
-(void)getCount{
    
   
   
    
    
    
    NSMutableDictionary *dictget,*dictSubTaskGet;
    NSString *strID;
    for(int m=1;m<=8;m++){
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
    NSLog(@"%@",dictget);
    
    if([strID isEqualToString:@"1"]){
        lblWork1.text=[NSString stringWithFormat:@"%d",[dictget count]+counta];
        if([lblWork1.text intValue]>=10){
            lblWork1.frame=CGRectMake(2, 0, 15, 15);
            
            lblWork1.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
            
            
        }
        else{
            lblWork1.frame=CGRectMake(5, 2, 10, 10);
            lblWork1.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
        }
    }
    
    else{
        if([lblWork1.text intValue]>=10){
            lblWork1.frame=CGRectMake(4, 2, 10, 10);
            
            lblWork1.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
            
            
        }
        else{
            lblWork1.frame=CGRectMake(5, 2, 10, 10);
            lblWork1.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
        }
    }
  if([strID isEqualToString:@"2"]){
        lblfami.text=[NSString stringWithFormat:@"%d",[dictget count]+counta];
        if([lblfami.text intValue]>=10){
            lblfami.frame=CGRectMake(2, 0, 15, 15);
            
            lblfami.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
            
            
        }
        else{
            lblfami.frame=CGRectMake(5, 2, 10, 10);
            lblfami.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
        }
    }
  else{
      if([lblfami.text intValue]>=10){
          lblfami.frame=CGRectMake(4, 2, 10, 10);
          
          lblfami.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
          
          
      }
      else{
          lblfami.frame=CGRectMake(5, 2, 10, 10);
          lblfami.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
      }
  }
   if([strID isEqualToString:@"3"]){
        lblhealt.text=[NSString stringWithFormat:@"%d",[dictget count]+counta];
        if([lblhealt.text intValue]>=10){
            lblhealt.frame=CGRectMake(2, 0, 15, 15);
            
            lblhealt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
            
            
        }
        else{
            lblhealt.frame=CGRectMake(5, 2, 10, 10);
            lblhealt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
        }
    }
   else{
       if([lblhealt.text intValue]>=10){
           lblhealt.frame=CGRectMake(4, 2, 10, 10);
           
           lblhealt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
           
           
       }
       else{
           lblhealt.frame=CGRectMake(5, 2, 10, 10);
           lblhealt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
       }
   }
    if([strID isEqualToString:@"4"]){
        lblPer.text=[NSString stringWithFormat:@"%d",[dictget count]+counta];
        if([lblPer.text intValue]>=10){
            lblPer.frame=CGRectMake(2, 0, 15, 15);
            
            lblPer.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
            
            
        }
        else{
            lblPer.frame=CGRectMake(5, 2, 10, 10);
            lblPer.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
        }
    }
    else{
        if([lblPer.text intValue]>=10){
            lblPer.frame=CGRectMake(4, 2, 10, 10);
            
            lblPer.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
            
            
        }
        else{
            lblPer.frame=CGRectMake(5, 2, 10, 10);
            lblPer.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
        }
    }
    if([strID isEqualToString:@"5"]){
        lblFin.text=[NSString stringWithFormat:@"%d",[dictget count]+counta];
        if([lblFin.text intValue]>=10){
            lblFin.frame=CGRectMake(2, 0, 15, 15);
            
            lblFin.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
            
            
        }
        else{
            lblFin.frame=CGRectMake(5, 2, 10, 10);
            lblFin.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
        }
    }
    else{
        if([lblFin.text intValue]>=10){
            lblFin.frame=CGRectMake(4, 2, 10, 10);
            
            lblFin.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
            
            
        }
        else{
            lblFin.frame=CGRectMake(5, 2, 10, 10);
            lblFin.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
        }
    }
    if([strID isEqualToString:@"6"]){
        lblShar.text=[NSString stringWithFormat:@"%d",[dictget count]+counta];
        if([lblShar.text intValue]>=10){
            lblShar.frame=CGRectMake(2, 0, 15, 15);
            
            lblShar.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
            
            
        }
        else{
            lblShar.frame=CGRectMake(5, 2, 10, 10);
            lblShar.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
        }
    }
    else{
        if([lblShar.text intValue]>=10){
            lblShar.frame=CGRectMake(4, 2, 10, 10);
            
            lblShar.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
            
            
        }
        else{
            lblShar.frame=CGRectMake(5, 2, 10, 10);
            lblShar.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
        }
    }
   if([strID isEqualToString:@"7"]){
        lblUrge.text=[NSString stringWithFormat:@"%d",[dictget count]+counta];
        if([lblUrge.text intValue]>=10){
            lblUrge.frame=CGRectMake(2, 0, 15, 15);
            
            lblUrge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
            
            
        }
        else{
            lblUrge.frame=CGRectMake(5, 2, 10, 10);
            lblUrge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
        }
    }
   else{
       if([lblUrge.text intValue]>=10){
           lblUrge.frame=CGRectMake(4, 2, 10, 10);
           
           lblUrge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
           
           
       }
       else{
           lblUrge.frame=CGRectMake(5, 2, 10, 10);
           lblUrge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
       }
   }
    if([strID isEqualToString:@"8"]){
        lblShop.text=[NSString stringWithFormat:@"%d",[dictget count]+counta];
        if([lblShop.text intValue]>=10){
            lblShop.frame=CGRectMake(2, 0, 15, 15);
            
            lblShop.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
            
            
        }
        else{
            lblShop.frame=CGRectMake(5, 2, 10, 10);
            lblShop.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
        }
    }
    
    else{
        if([lblShop.text intValue]>=10){
            lblShop.frame=CGRectMake(4, 2, 10, 10);
            
            lblShop.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
            
            
        }
        else{
            lblShop.frame=CGRectMake(5, 2, 10, 10);
            lblShop.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
        }
    }
    }
}
#pragma mark Daily View
-(IBAction)clcikOnDailyView:(id)sender{
    if([dailyView isSelected]){
        [dailyView setSelected:NO];
        appdel.isTaskOrEvent=@"2";
        tblCalendar.hidden=FALSE;
        viewCalendarTbl.hidden=TRUE;
        [self getCalendar];
    }
    else{
        [dailyView setSelected:YES];
        appdel.isTaskOrEvent=@"3";
        MADayView *dayView = (MADayView *) viewCalendarTbl;
        dayView.autoScrollToFirstEvent = YES;
        dayView.delegate=self;
        dayView.dataSource=self;
        tblCalendar.hidden=TRUE;
        viewCalendarTbl.hidden=FALSE;
    }
   
    
   // [self dayView:dayView eventsForDate:[NSDate date]];
}
- (void)viewDidAppear:(BOOL)animated {
	
	
	
}
#pragma mark graph Api
- (void)fbGraphCallback:(id)sender {
	
    [AlertHandler hideAlert];
    
	if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) ) {
		
		NSLog(@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful....");
		
		//restart the authentication process.....
        
		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
							 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins,email"];
		
	} else {
		//pop a message letting them know most of the info will be dumped in the log
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note" message:@"For the simplest code, I've written all output to the 'Debugger Console'." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		//[alert show];
		[alert release];
		
		NSLog(@"------------>CONGRATULATIONS<------------, You're logged into Facebook...  Your oAuth token is:  %@", fbGraph.accessToken);
       
        
        [[NSUserDefaults standardUserDefaults] setValue:fbGraph.accessToken forKey:@"fbtoken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self getMeButtonPressed];
        
		
	}
	
}
-(void)getMeButtonPressed {
	FbGraphResponse *fb_graph_response = [fbGraph doGraphGet:@"me" withGetVars:nil];
	NSLog(@"getMeButtonPressed:  %@", fb_graph_response.htmlResponse);
    NSDictionary *dictionary=[fb_graph_response.htmlResponse JSONValue];
    
    NSLog(@"%@",[dictionary valueForKey:@"email"]);
     appdel.strLoginID=[dictionary valueForKey:@"email"];
    NSLog(@"%@",appdel.strLoginID);
    
    
    [self JSONFacebook];
             
    
   
    }
#pragma mark TOPBar
-(IBAction)btninDent:(id)sender{
    
    
    
    isIndent=1;
    
    i=100;
    tagbtn=sectionOUt;
    NSString *strArrow=[dictArrow valueForKey:[NSString stringWithFormat:@"%d^0",sectionOUt]];
    if(index==0 && sectionOUt>=1 && strArrow!=0)
    {
        [self playSoundOnButtonClick];
        [arr_tagNew replaceObjectAtIndex:sectionOUt-1 withObject:@"1"];
        [arr_tagNew removeObjectAtIndex:sectionOUt];
        NSString *strin=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^0",sectionOUt]];
        NSString *strUp=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^0",sectionOUt-1]];
        NSString *strTitle=[dic_txt valueForKey:[NSString stringWithFormat:@"%d^0",sectionOUt]];
        NSMutableArray *arr=[[NSMutableArray alloc] initWithObjects:@"status",@"priority", nil];
        NSMutableArray *arrRet;
        arrRet=[dal SelectQuery:@"tblMainTask" withColumn:arr withCondition:@"mtid=" withColumnValue:[NSString stringWithFormat:@"%@",strin]];  
        NSLog(@"%@",arr);
        NSString *strStat=[[arrRet objectAtIndex:0] valueForKey:@"status"];
        NSString *strpri=[[arrRet objectAtIndex:0] valueForKey:@"priority"];
        [dal deleteFromTable:@"tblMainTask" WhereField:@"mtid=" Condition:[NSString stringWithFormat:@"%@",strin] ];
        NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
        NSMutableDictionary *dictad=[[NSMutableDictionary alloc] init];
        [dictad setObject:[NSString stringWithFormat:@"%@",strTitle] forKey:@"title"];
        [dictad setObject:[NSString stringWithFormat:@"%@",strStat] forKey:@"status"];
        [dictad setObject:[NSString stringWithFormat:@"%@",strpri ] forKey:@"priority"];
        [dictad setObject:[NSString stringWithFormat:@"%@",strUp] forKey:@"mtid"];
        [dictad setObject:[NSString stringWithFormat:@"%@",str_id] forKey:@"userid"];
        [dal insertRecord:dictad inTable:@"tblSubTask"];
        NSMutableDictionary *dicter=[[NSMutableDictionary alloc] init];
        [dicter setObject:@"1" forKey:@"child"];
        [dal updateRecord:dicter forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strUp]];
        isOpen=TRUE;
        if(arr!=nil){
            [arr removeAllObjects];
            [arr release];
            arr=nil;
        }
        if(dictad!=nil){
            [dictad removeAllObjects];
            [dictad release];
            dictad=nil;
        }
        if(dicter!=nil){
            [dicter removeAllObjects];
            [dicter release];
            dicter=nil;
        }
        if(isEdit==0){
            [self getAllMainTask];
        }
        else{
            [self getMainTask];
        }

    
        reodered=0;
    
    
    
    
}
}
-(IBAction)btnOutDent:(id)sender{
    NSLog(@"%d",index);
    NSLog(@"%d",sectionOUt);
    
    str_stid=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",sectionOUt,index]];
    NSLog(@"%@",str_stid);
    if(index!=0 ){
        swipeYES=1;
       
        [self playSoundOnButtonClick];
        NSMutableDictionary *dictscid;
        dictscid=[dal executeDataSet:[NSString stringWithFormat:@"select scid from tblMainTask where mtid=%@",[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^0",sectionOUt]]]];
        NSLog(@"%@",dictscid);
        NSString *strscid=[[dictscid valueForKey:@"Table1"] valueForKey:@"scid"];
        NSString *strin=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",sectionOUt,index]];
        
        NSString *strTitle=[dic_txt valueForKey:[NSString stringWithFormat:@"%d^%d",sectionOUt,index]];
        NSMutableArray *arr=[[NSMutableArray alloc] initWithObjects:@"status",@"priority", nil];
        NSMutableArray *arrRet;
        arrRet=[dal SelectQuery:@"tblSubTask" withColumn:arr withCondition:@"stid=" withColumnValue:[NSString stringWithFormat:@"%@",strin]];  
        //NSLog(@"%@",arrRet);
        NSString *strStat=[[arrRet objectAtIndex:0] valueForKey:@"status"];
        NSString *strpri=[[arrRet objectAtIndex:0] valueForKey:@"priority"];
        [dal deleteFromTable:@"tblSubTask" WhereField:@"stid=" Condition:[NSString stringWithFormat:@"%@",strin] ];
        NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
        NSMutableDictionary *dictad=[[NSMutableDictionary alloc] init];
        NSMutableDictionary *dictre;
        dictre=   [dal executeDataSet:[NSString stringWithFormat:@"select max(position) from tblMainTask"]];
        
        //NSLog(@"%@",[dictre valueForKey:@"Table1"]);
        //NSLog(@"%@",[[dictre valueForKey:@"Table1"] valueForKey:@"max(position)"]);
        int cnt=[[[dictre valueForKey:@"Table1"]valueForKey:@"max(position)"] intValue];
        [dictad setObject:[NSString stringWithFormat:@"%d",cnt+1] forKey:@"position"];
        
        [dictad setObject:[NSString stringWithFormat:@"%@",strTitle] forKey:@"title"];
        [dictad setObject:[NSString stringWithFormat:@"%@",strStat] forKey:@"status"];
        [dictad setObject:[NSString stringWithFormat:@"%@",strpri ] forKey:@"priority"];
        [dictad setObject:[NSString stringWithFormat:@"%@",strscid] forKey:@"scid"];
        [dictad setObject:[NSString stringWithFormat:@"%@",str_id] forKey:@"userid"];
        [dal insertRecord:dictad inTable:@"tblMainTask"];
        if([[dictForRows valueForKey:[NSString stringWithFormat:@"%d^0",sectionOUt]]isEqualToString:@"2"])
        {
            [arr_tagNew replaceObjectAtIndex:sectionOUt withObject:@"0"];
            
        }
        [arr_tagNew addObject:@"0"];
        // NSLog(@"%@",dictForRows);
        // NSLog(@"%@",arr_tagNew);
        if(arr!=nil){
            [arr release];
            arr=nil;
        }
        if(dictad!=nil){
            [dictad removeAllObjects];
            [dictad release];
            dictad=nil;
        }
        isOpen=TRUE;
        if(isEdit==0){
            [self getAllMainTask];
        }
        else{
            [self getMainTask];
        }
        

        
        
    }
    
    reodered=0;
    
}
-(IBAction)btnAdd:(id)sender{
	
    [self playSoundOnButtonClick];
    if(!isCalendar){
    NSLog(@"%d",rowsCnt);
    //for adding a new main task;
    reodered=100;
    isCalAdd=FALSE;
    if([dictMainTask count]==0){
            lineVIew1.frame=CGRectMake(0, 0, 1, 760);
            lineView2.frame=CGRectMake(45, 0, 1, 760);
            lineView3.frame=CGRectMake(90, 0, 1, 760);
            lineView4.frame=CGRectMake(465, 0, 1, 760);
        int add=0;
        if(self.interfaceOrientation==UIInterfaceOrientationLandscapeRight || self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
            add=134;
        }
        else{
            add=0;
        }

            lblStatus.frame=CGRectMake(249+add, 171, 46, 21);
            lblPriority.frame=CGRectMake(295+add, 171, 46, 21);
            table2.editing=FALSE;
    }
    [table2 reloadData];
    }
    else{
        isCalAdd=TRUE;
        calIndex=1;
        [tblCalendar reloadData];
        
//        AddEvent *addEvent=[[AddEvent alloc]initWithNibName:@"AddEvent" bundle:nil];
//        
//        
//        
//        popover_Event = [[UIPopoverController alloc] initWithContentViewController:addEvent];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissSubtask:) name:@"dissmissSync"  object:popover_Event.contentViewController];
//        popover_Event.delegate = self;
//        
//        [popover_Event presentPopoverFromRect:CGRectMake(80,150,300, 400) inView:viewCalendarTbl permittedArrowDirections:0 animated:YES];
//        [addEvent release];
        
        //[popover_Event release];
       
    }
    
    
    
    
    reodered=0;
   

}



-(IBAction)topBarEdit:(id)sender
{

     [self playSoundOnButtonClick];
    if(table2.editing)
    {
        [super setEditing:NO animated:NO]; 
		[self.table2 setEditing:NO animated:NO];
        
        btnDel.hidden=TRUE;
        panGesture.enabled=YES;
        table2.hidden=FALSE;
        rowsCnt=0;
        rowsCnt=0;
        longPress.enabled=YES;
        
		[self.table2 reloadData];
		[editBtn2 setSelected:NO];
        [editBtn2 setImage:[UIImage imageNamed:@"Edit.png"] forState:UIControlStateNormal];
        
        lineVIew1.frame=CGRectMake(0, 0, 1, 760);
        lineView2.frame=CGRectMake(45, 0, 1, 760);
        lineView3.frame=CGRectMake(90, 0, 1, 760);
        lineView4.frame=CGRectMake(465, 0, 1, 760);
        int add=0;
        if(self.interfaceOrientation==UIInterfaceOrientationLandscapeRight || self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
            add=134;
        }
        else{
            add=0;
        }

        lblStatus.frame=CGRectMake(249+add, 171, 46, 21);
        lblPriority.frame=CGRectMake(295+add, 171, 46, 21);
    }
    else
    {
        
        
        table2.hidden=FALSE;
        panGesture.enabled=NO;
        longPress.enabled=NO;
        [super setEditing:YES animated:YES]; 
        if([dictMainTask count]!=0){
            table2.editing=FALSE;
            lineVIew1.frame=CGRectMake(35, 0, 1, 760);
            lineView2.frame=CGRectMake(80, 0, 1, 760);
            lineView3.frame=CGRectMake(120, 0, 1, 760);
            lineView4.frame=CGRectMake(450, 0, 1, 760);
          
            int add=0;
            if(self.interfaceOrientation==UIInterfaceOrientationLandscapeRight || self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
                add=134;
            }
            else{
                add=0;
            }

            lblPriority.frame=CGRectMake(326+add, 171, 46, 21);
              lblStatus.frame=CGRectMake(283+add, 171, 46, 21);
            [editBtn2 setImage:[UIImage imageNamed:@"DoneNormal2.png"] forState:UIControlStateNormal];
            
        }
        else{
             [editBtn2 setImage:[UIImage imageNamed:@"Edit.png"] forState:UIControlStateNormal];
        }
        
        
		[self.table2 setEditing:YES animated:YES];
        btnDel.hidden=FALSE;
              rowsCnt=0;
        [self.table2 reloadData];
		[editBtn2 setSelected:YES];
        
    }
}
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 0;
    
}

- (IBAction)swipeDetected:(UIGestureRecognizer *)sender 
{
    btnDel.hidden=FALSE;
}
-(IBAction)DeleteMainTask:(id)sender 
{UIButton *button=(UIButton *)sender;
	int tagofhead=button.tag;
    
    str_mtid=[arr_maintask objectAtIndex:tagofhead-1];
    NSLog(@"%@str:",str_mtid);
    [self deleteMainTask];
}
-(void)setRightImgOnly:(int)number{
    if([[arrtab objectAtIndex:number] isEqualToString:@"Work"]  ){
      
        [btnWork setBackgroundImage:[UIImage imageNamed:@"workR.png"] forState:UIControlStateNormal];
        
        
        
        
    }
    else if([[arrtab objectAtIndex:number] isEqualToString:@"Personal"] ){
        
        [btnPersonal setBackgroundImage:[UIImage imageNamed:@"personalR.png"] forState:UIControlStateNormal];
        
        
        
    }
    if([[arrtab objectAtIndex:number] isEqualToString:@"Family"] ){
        
        [btnFamily setBackgroundImage:[UIImage imageNamed:@"familyR.png"] forState:UIControlStateNormal];
        
        
        
    }
    if([[arrtab objectAtIndex:number] isEqualToString:@"Health"] ){
       
        [btnHealth setBackgroundImage:[UIImage imageNamed:@"healthR.png"] forState:UIControlStateNormal];
        
        
    }
    if([[arrtab objectAtIndex:number] isEqualToString:@"Finance"] ){
       
        [btnFinance setBackgroundImage:[UIImage imageNamed:@"financeR.png"] forState:UIControlStateNormal];
        
        
    }
    if([[arrtab objectAtIndex:number] isEqualToString:@"Shared"]){
       
        [btnShared setBackgroundImage:[UIImage imageNamed:@"sharedL.png"] forState:UIControlStateNormal];
        
        
    }
    if([[arrtab objectAtIndex:number] isEqualToString:@"Urgent"] ){
       
        [btnUrgent setBackgroundImage:[UIImage imageNamed:@"urgentR.png"] forState:UIControlStateNormal];
        
        
        
    }
    if([[arrtab objectAtIndex:number] isEqualToString:@"Shopping"] ){
        
        [btnShopping setBackgroundImage:[UIImage imageNamed:@"shoppingR.png"] forState:UIControlStateNormal];
        
    }
    
   

}
-(void)setLeftImgOnly:(int)number{
    if([[arrtab objectAtIndex:number] isEqualToString:@"Work"]  ){
        
        [btnWork setBackgroundImage:[UIImage imageNamed:@"workL.png"] forState:UIControlStateNormal];
        
        
        
        
    }
    else if([[arrtab objectAtIndex:number] isEqualToString:@"Personal"] ){
        
        [btnPersonal setBackgroundImage:[UIImage imageNamed:@"personalL.png"] forState:UIControlStateNormal];
        
        
        
    }
    if([[arrtab objectAtIndex:number] isEqualToString:@"Family"] ){
        
        [btnFamily setBackgroundImage:[UIImage imageNamed:@"familyL.png"] forState:UIControlStateNormal];
        
        
        
    }
    if([[arrtab objectAtIndex:number] isEqualToString:@"Health"] ){
        
        [btnHealth setBackgroundImage:[UIImage imageNamed:@"healthL.png"] forState:UIControlStateNormal];
        
        
    }
    if([[arrtab objectAtIndex:number] isEqualToString:@"Finance"] ){
        
        [btnFinance setBackgroundImage:[UIImage imageNamed:@"financeL.png"] forState:UIControlStateNormal];
        
        
    }
    if([[arrtab objectAtIndex:number] isEqualToString:@"Shared"]){
        
        [btnShared setBackgroundImage:[UIImage imageNamed:@"sharedR.png"] forState:UIControlStateNormal];
        
        
    }
    if([[arrtab objectAtIndex:number] isEqualToString:@"Urgent"] ){
        
        [btnUrgent setBackgroundImage:[UIImage imageNamed:@"urgentL.png"] forState:UIControlStateNormal];
        
        
        
    }
    if([[arrtab objectAtIndex:number] isEqualToString:@"Shopping"] ){
        
        [btnShopping setBackgroundImage:[UIImage imageNamed:@"shoppingL.png"] forState:UIControlStateNormal];
        
    }

}

#pragma mark Side Clicks
-(IBAction)clickOnWork:(id)sender
{
    lblCatTitle.text=@"All Works";
    
    
    if(![btnWork isSelected]){
    [lblWork setImage:[UIImage imageNamed:@"Active-number.png"]];
    [lblFamily setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFinance setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblPersonal setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShared setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShopping setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblUrgent setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblHealth setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [btnWork setSelected:YES];
    [btnFamily setSelected:NO];
    [btnFinance setSelected:NO];
    [btnHealth setSelected:NO];
    [btnPersonal setSelected:NO]; 
    [btnShared setSelected:NO];
    [btnShopping setSelected:NO];
    [btnUrgent setSelected:NO]; 
    

    [self memoryRelease];
    appdel.str_mcid=@"1";
    flagStart=1;
    [self setButtons];
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Work"]){
            
            [btnWork setFrame:CGRectMake(btnWork.frame.origin.x+15, 60, 35, 45)];
            
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }
   
        
    [self getSubCat];
    }
    else{
        
    }

    [btnWork setBackgroundImage:[UIImage imageNamed:@"Work-Active-.png"] forState:UIControlStateNormal];
    
    
    lblPer.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblhealt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblFin.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShar.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblUrge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShop.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
	
}
-(IBAction)clickOnFamily:(id)sender
{
    lblCatTitle.text=@"All Family";
    if(![btnFamily isSelected]){
        
    
    [lblWork setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFamily setImage:[UIImage imageNamed:@"Active-number.png"]];
    [lblFinance setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblPersonal setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShared setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShopping setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblUrgent setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblHealth setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [btnWork setSelected:NO];
    [btnFamily setSelected:YES];
    [btnFinance setSelected:NO];
    [btnHealth setSelected:NO];
    [btnPersonal setSelected:NO]; 
    [btnShared setSelected:NO];
    [btnShopping setSelected:NO];
    [btnUrgent setSelected:NO];    
    appdel.str_mcid=@"2";
	flagStart=1;
    [self memoryRelease];
    [self setButtons];
    NSLog(@"%f %f",btnFamily.frame.origin.x,btnFamily.frame.origin.y);
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Family"]){
            NSLog(@"%d",233+aa*68+15);
            [btnFamily setFrame:CGRectMake(btnFamily.frame.origin.x+15, 60, 35, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }

     [self getSubCat];
        
    
 }
    else{
        
        }
    [btnFamily setBackgroundImage:[UIImage imageNamed:@"Active-Family.png"] forState:UIControlStateNormal];
    lblWork1.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblPer.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblhealt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblFin.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShar.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblUrge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShop.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
   // lblfami.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
   
    
}

-(IBAction)clickOnPersonal:(id)sender
{
    lblCatTitle.text=@"All Personal";
    

    if(![btnPersonal isSelected]){
    [lblWork setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFamily setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFinance setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblPersonal setImage:[UIImage imageNamed:@"Active-number.png"]];
    [lblShared setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShopping setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblUrgent setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblHealth setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    
    [btnWork setSelected:NO];
    [btnFamily setSelected:NO];
    [btnFinance setSelected:NO];
    [btnHealth setSelected:NO];
    [btnPersonal setSelected:YES]; 
    [btnShared setSelected:NO];
    [btnShopping setSelected:NO];
    [btnUrgent setSelected:NO]; 
    
    flagStart=1;
    appdel.str_mcid=@"4";
    [self memoryRelease];
    [self setButtons];
   
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Personal"]){
            [btnPersonal setFrame:CGRectMake(btnPersonal.frame.origin.x+10, 60, 45, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }

     [self getSubCat];

	
    }
    else{
        
    }
    [btnPersonal setBackgroundImage:[UIImage imageNamed:@"Personal-Active.png"] forState:UIControlStateNormal];
    lblWork1.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    //lblPer.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
    lblhealt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblFin.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShar.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblUrge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShop.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblfami.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    
}




-(IBAction)clickOnHealth:(id)sender
{
    lblCatTitle.text=@"All Health";
    if(![btnHealth isSelected]){
    [lblWork setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFamily setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFinance setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblPersonal setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShared setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShopping setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblUrgent setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblHealth setImage:[UIImage imageNamed:@"Active-number.png"]];

    
    [btnWork setSelected:NO];
    [btnFamily setSelected:NO];
    [btnFinance setSelected:NO];
    [btnHealth setSelected:YES];
    [btnPersonal setSelected:NO]; 
    [btnShared setSelected:NO];
    [btnShopping setSelected:NO];
    [btnUrgent setSelected:NO];   
//    [btnHealth setImage:[UIImage imageNamed:@"Active Health.png"] forState:UIControlStateNormal];
    flagStart=1;
	 [self memoryRelease];
    appdel.str_mcid=@"3";
    [self setButtons];
	for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Health"]){
            [btnHealth setFrame:CGRectMake(btnHealth.frame.origin.x+15, 60, 35, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }

     [self getSubCat];
    }
    else{
        
    }
    [btnHealth setBackgroundImage:[UIImage imageNamed:@"Active-Health-.png"] forState:UIControlStateNormal];
    lblWork1.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblPer.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    //lblhealt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
    lblFin.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShar.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblUrge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShop.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblfami.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
}

-(IBAction)clickOnFinance:(id)sender
{
	lblCatTitle.text=@"All Finance";
    if(![btnFinance isSelected]){
    [lblWork setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFamily setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFinance setImage:[UIImage imageNamed:@"Active-number.png"]];
    [lblPersonal setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShared setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShopping setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblHealth setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblUrgent setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    
    [btnWork setSelected:NO];
    [btnFamily setSelected:NO];
    [btnFinance setSelected:YES];
    [btnHealth setSelected:NO];
    [btnPersonal setSelected:NO]; 
    [btnShared setSelected:NO];
    [btnShopping setSelected:NO];
    [btnUrgent setSelected:NO];  
    
    [self memoryRelease];
    flagStart=1;
    appdel.str_mcid=@"5";
	[self setButtons];
    [self setButtons];
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Finance"]){
            [btnFinance setFrame:CGRectMake(btnFinance.frame.origin.x+15, 60, 35, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }

     [self getSubCat];
    }
    else{
        
    }

    [btnFinance setBackgroundImage:[UIImage imageNamed:@"Active-Finance.png"] forState:UIControlStateNormal];
    lblWork1.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblPer.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblhealt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    //lblFin.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
    lblShar.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblUrge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShop.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblfami.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
}

-(IBAction)clickOnShare:(id)sender
{
    lblCatTitle.text=@"All Shared";
    if(![btnShared isSelected]){
    [lblWork setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFamily setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFinance setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblPersonal setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShared setImage:[UIImage imageNamed:@"Active-number.png"]];
    [lblShopping setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblHealth setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblUrgent setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
   
    [btnWork setSelected:NO];
    [btnFamily setSelected:NO];
    [btnFinance setSelected:NO];
    [btnHealth setSelected:NO];
    [btnPersonal setSelected:NO]; 
    [btnShared setSelected:YES];
    [btnShopping setSelected:NO];
    [btnUrgent setSelected:NO];
    flagStart=1;
    appdel.str_mcid=@"6";
    [self memoryRelease];
    [self setButtons];
       for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Shared"]){
            [btnShared setFrame:CGRectMake(btnShared.frame.origin.x+15, 60, 35, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }

     [self getSubCat];
    }
    else{
        
    }
    [btnShared setBackgroundImage:[UIImage imageNamed:@"Active-Shared.png"] forState:UIControlStateNormal];
    lblWork1.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblPer.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblhealt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblFin.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    //lblShar.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
    lblUrge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShop.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblfami.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];

}
-(IBAction)clickonUrgent:(id)sender
{
   
    lblCatTitle.text=@"All Urgent";
    if(![btnUrgent isSelected]){
    [lblWork setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFamily setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFinance setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblPersonal setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShared setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShopping setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblHealth setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblUrgent setImage:[UIImage imageNamed:@"Active-number.png"]];
    
    [btnWork setSelected:NO];
    [btnFamily setSelected:NO];
    [btnFinance setSelected:NO];
    [btnHealth setSelected:NO];
    [btnPersonal setSelected:NO]; 
    [btnShared setSelected:NO];
    [btnShopping setSelected:NO];
    [btnUrgent setSelected:YES];    
    flagStart=1;
    appdel.str_mcid=@"7";
    [self memoryRelease];
    [self setButtons];
    [self setButtons];
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Urgent"]){
            [btnUrgent setFrame:CGRectMake(btnUrgent.frame.origin.x+15, 60, 35, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }

     [self getSubCat];
    }
    else{
        
    }
    [btnUrgent setBackgroundImage:[UIImage imageNamed:@"Active-Urgent.png"] forState:UIControlStateNormal];
    lblWork1.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblPer.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblhealt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblFin.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShar.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    //lblUrge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
    lblShop.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblfami.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];

}
-(IBAction)clickOnShop:(id)sender
{
    lblCatTitle.text=@"All Shopping";
    if(![btnShopping isSelected]){
    [lblWork setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFamily setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblFinance setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblPersonal setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShared setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblShopping setImage:[UIImage imageNamed:@"Active-number.png"]];
    [lblUrgent setImage:[UIImage imageNamed:@"Nonactive-number.png"]];
    [lblHealth setImage:[UIImage imageNamed:@"Nonactive-number.png"]];

    
    [btnWork setSelected:NO];
    [btnFamily setSelected:NO];
    [btnFinance setSelected:NO];
    [btnHealth setSelected:NO];
    [btnPersonal setSelected:NO]; 
    [btnShared setSelected:NO];
    [btnShopping setSelected:YES];
    [btnUrgent setSelected:NO];    
    flagStart=1;
    appdel.str_mcid=@"8";
    [self memoryRelease];
    
    [self setButtons];
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Shopping"]){
            [btnShopping setFrame:CGRectMake(btnShopping.frame.origin.x+10, 60, 40, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }

     [self getSubCat];
    }
    else{
        
    }
    [btnShopping setBackgroundImage:[UIImage imageNamed:@"Active-shopping.png"] forState:UIControlStateNormal];
    lblWork1.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblPer.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblhealt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblFin.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblShar.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    lblUrge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];
    //lblShop.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:12];
    lblfami.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:10];

}
/*
-(IBAction)clickOnDone:(id)sender
{
	taskbutton.hidden=FALSE;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	
	donebtn.hidden=TRUE;
	workbtn.hidden=TRUE;
	personalbtn.hidden=TRUE;
	familybtn.hidden=TRUE;
	healthbtn.hidden=TRUE;
	financebtn.hidden=TRUE;
	view3.frame=CGRectMake(718, 0, 43, 1024);
    [UIView commitAnimations];
}
*/


#pragma mark Bottom Bar Clicks
-(IBAction)clickOnSettings:(id)sender{
     [self playSoundOnButtonClick];
    NSLog(@"%@",arrtab);
    [[NSUserDefaults standardUserDefaults] setObject:arrtab forKey:@"tab"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [btnSettings setSelected:YES];
    [btnProgress setSelected:NO];
    [btnMail setSelected:NO];
    [btnSync setSelected:NO];
    [btnInfo setSelected:NO];
    Settings *objSettings=[[Settings alloc]initWithNibName:@"Settings" bundle:nil];
  
    UINavigationController *navCont=[[UINavigationController alloc] initWithRootViewController:objSettings];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissSettings:) name:@"dissmissSetting"  object:popOver_settings.contentViewController];
    self.popOver_settings = [[[WEPopoverController alloc] initWithContentViewController:navCont] autorelease];
    
    [self.popOver_settings presentPopoverFromRect:CGRectMake(63,955,678, 780)
                                           inView:self.view 
                         permittedArrowDirections:UIPopoverArrowDirectionDown
                                         animated:YES];
    [objSettings release];
}

-(IBAction)clickOnSync:(id)sender{
     [self playSoundOnButtonClick];
    [btnSettings setSelected:NO];
    [btnProgress setSelected:NO];
    [btnMail setSelected:NO];
    [btnSync setSelected:YES];
    [btnInfo setSelected:NO];

	SyncView *sync=[[SyncView alloc]initWithNibName:@"SyncView" bundle:nil];
    
    
     
	popover_sync = [[UIPopoverController alloc] initWithContentViewController:sync];
	 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissSync:) name:@"dissmissSync"  object:popover_sync.contentViewController];
	popover_sync.delegate = self;
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        [popover_sync presentPopoverFromRect:CGRectMake(240+134,688,100, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    else{
	[popover_sync presentPopoverFromRect:CGRectMake(240,942,100, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
    [sync release];
}

-(IBAction)clickOnProgress:(id)sender
{
     [self playSoundOnButtonClick];
    if(![btnProgress isSelected]){
    [btnSettings setSelected:NO];
    [btnProgress setSelected:YES];
    [btnMail setSelected:NO];
    [btnSync setSelected:NO];
    [btnInfo setSelected:NO];
    ProgressViewController *progress=[[ProgressViewController alloc] initWithNibName:@"ProgressViewController" bundle:nil];
    
  
    
    UINavigationController *navCont=[[UINavigationController alloc] initWithRootViewController:progress];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissProgress:) name:@"dissmissProgress"  object:popover_progress.contentViewController];
    
    self.popover_progress = [[[WEPopoverController alloc] initWithContentViewController:navCont] autorelease];
        if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight){
              //self.contentSizeForViewInPopover=CGSizeMake(650, 600);
            [self.popover_progress presentPopoverFromRect:CGRectMake(45+128,900,700, 600)
                                                   inView:self.view 
                                 permittedArrowDirections:UIPopoverArrowDirectionDown
                                                 animated:YES];
          
        }
        else{
             //self.contentSizeForViewInPopover=CGSizeMake(100, 200);
            
            [self.popover_progress presentPopoverFromRect:CGRectMake(70,955,678, 780)
                                                   inView:self.view 
                                 permittedArrowDirections:UIPopoverArrowDirectionDown
                                                 animated:YES];
        
        }
   
    
    [progress release];
    }
    else{
        [btnProgress setSelected:NO];
    }
   
}
-(IBAction)clickOnInfo:(id)sender{
     [self playSoundOnButtonClick];
    [btnSettings setSelected:NO];
    [btnProgress setSelected:NO];
    [btnMail setSelected:NO];
    [btnSync setSelected:NO];
//    [btnInfo setSelected:YES];
//  
//    
//    InfoViewController *objInfo=[[InfoViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
//   
//   [self.navigationController pushViewController:objInfo animated:YES];
//    [objInfo release];
}
-(IBAction)clickOnMail:(id)sender
{
     [self playSoundOnButtonClick];
    [btnSettings setSelected:NO];
    [btnProgress setSelected:NO];
    [btnMail setSelected:YES];
    [btnSync setSelected:NO];
    [btnInfo setSelected:NO];
	mail=[[MFMailComposeViewController alloc]init];
	mail.mailComposeDelegate=self;
    
	[mail setToRecipients:[NSArray arrayWithObjects:@"email@email.com",nil]];
	NSString *str=[NSString stringWithFormat:@"hello"];
	[mail setSubject:str];
	[mail setMessageBody:@"Message of email" isHTML:YES];
	[self presentModalViewController:mail animated:YES];
	//self.view=firstResponder;
	[mail resignFirstResponder];
	[mail respondsToSelector:@selector(set:)];
	[mail release];
	
}
	
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
	{   
		// Notifies users about errors associated with the interface
		switch (result)
		{
			case MFMailComposeResultCancelled:
				NSLog(@"Result: canceled");
				break;
			case MFMailComposeResultSaved:
				NSLog(@"Result: saved");
				break;
			case MFMailComposeResultSent:
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result" message:@"Mail Sent Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
				[alert show];
				[alert release];
			}
				break;
			case MFMailComposeResultFailed:
				NSLog(@"Result: failed");
				break;
			default:
			NSLog(@"Result: not sent");
				break;
		}
		[self dismissModalViewControllerAnimated:YES];
        [btnMail setSelected:NO];
        
	}
	



#pragma mark popover
-(void)dismissPopOverViewHome:(id)sender
{
    [popover dismissPopoverAnimated:YES];
    isStatus = NO;
}

-(void)dismissPopOverViewHome2:(id)sender
{
    [popover2 dismissPopoverAnimated:YES];
    isPriority = NO;
}
-(void)dissmissProgress:(id)sender{
    [self.popover_progress dismissPopoverAnimated:YES];
    self.popover_progress = nil;
    [btnProgress setSelected:NO];
    
}
-(void)dissmissSettings:(id)sender{
    
    if([popOver_settings isPopoverVisible]){
    arrtab= [[NSUserDefaults standardUserDefaults] objectForKey:@"tab"];
    [popOver_settings dismissPopoverAnimated:YES];
    popOver_settings=nil;
        [self setMainTabs];
        [self setButtons];
        [self setActiveButton];
    }
    if([appdel.str isEqualToString:@"100"]){
        appdel.str=@"23";
        LoginPage *loginObj=[[LoginPage alloc] initWithNibName:@"LoginPage" bundle:nil];
        [self.navigationController pushViewController:loginObj animated:YES];
        [loginObj release];
    }
    [btnSettings setSelected:NO];
    [self changeColor];
}
-(void)dissmissSync:(id)sender{
    [btnSync setSelected:NO];
    [popover_sync dismissPopoverAnimated:YES];
}
-(void)dismissSubtask:(id)sender{
    
    
    [popover_Event dismissPopoverAnimated:YES];
    
    //[self JSON_subtaskRetrive];
}
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
//{
//	if(popoverController == popover)
//	{
//    if(!isStatus) {
//        isStatus = YES;
//    }
//    else {
//        isStatus = NO;
//    }
//	}
//	else if(popoverController == popover2){
//		if(!isPriority) {
//			isPriority = YES;
//		}
//		else {
//			isPriority = NO;
//		}
//		
//	}
//    
//   
//    [popover_progress dismissPopoverAnimated:YES];
//
//}
#pragma Mark Click POp
-(IBAction)clickOnstatusBtn:(id)sender event:(id)event
{
    [self playSoundOnStatusPrio];
	UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
	NSIndexPath *clickedButtonPath = [table2 indexPathForCell:clickedCell];
	int rows=clickedButtonPath.row;
    int section1=clickedButtonPath.section;
    index=clickedButtonPath.row;
    
       if(rows<=[dictSubTaskID count]-1){
           
        str_mtid=[[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",section1,rows]] retain];
        str_stid=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",section1,rows]];
        NSLog(@"%@",str_mtid);
        strOfSubtask=[dic_txt valueForKey:[NSString stringWithFormat:@"%d^%d",section1,rows]] ;
        str_stid=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",section1,rows]] ;
        NSString *str_tag=[NSString stringWithFormat:@"%d%d",rows,section1];
        // int row1=[str_tag intValue];
        //NSLog(@"Row %d",row1);
        //statusBtn.tag=row1;
        //	NSString *str_row=[NSString stringWithFormat:@"%d",row1];
        [[NSUserDefaults standardUserDefaults] setValue:str_tag forKey:@"str_tag"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        tagbtn=section1;
           row=rows;
		
        
        if(!isStatus) {
            StatusView *status = [[StatusView alloc] initWithNibName:@"StatusView" bundle:nil];
            [status setParent:self];
            
            popover = [[UIPopoverController alloc] initWithContentViewController:status];
            popover.delegate = self;
            //	NSLog(@"%d",i);
            //if(i == 1)
            
            NSSet *touches = [event allTouches];
            UITouch *touch = [touches anyObject];
            
            
            CGPoint currentTouchPosition = [touch locationInView:self.view];
            
            
           // [popover presentPopoverFromRect:CGRectMake(currentTouchPosition.x,currentTouchPosition.y-45,100,100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            [popover presentPopoverFromRect:CGRectMake(currentTouchPosition.x-10, clickedCell.frame.origin.y+220, 10, 10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            
            
            
            isStatus = YES;
            [[NSNotificationCenter defaultCenter] 
             addObserver:self
             selector:@selector(dismissPopOverViewHome:)
             name:@"dismissPopOverViewHome"
             object:popover.contentViewController];
        }
        else
        {
            [popover dismissPopoverAnimated:YES];
            isStatus = NO;
        }
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry"
                                                      message:@"Please Enter Sub Task To Set Status" 
                                                     delegate:self 
                                            cancelButtonTitle:nil 
                                            otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
    }
    
   	
}


-(IBAction)clickOnpriorityBtn:(id)sender event:(id)event
{
    [self playSoundOnStatusPrio];
    UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
	NSIndexPath *clickedButtonPath = [table2 indexPathForCell:clickedCell];
	int rows=clickedButtonPath.row;
    int section1=clickedButtonPath.section;
    if(rows<=[dictSubTaskID count]-1){
        row=rows;
    
    str_mtid=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",section1,rows]];
        
    str_stid=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",section1,rows]];
    NSLog(@"%@",str_stid);
    strOfSubtask=[dic_txt valueForKey:[NSString stringWithFormat:@"%d^%d",section1,rows]] ;

    NSString *strtag=[NSString stringWithFormat:@"%d%d",rows,section1];
    // int row1=[str_tag intValue];
	//NSLog(@"Row %d",row1);
	//statusBtn.tag=row1;
    //	NSString *str_row=[NSString stringWithFormat:@"%d",row1];
	[[NSUserDefaults standardUserDefaults] setValue:strtag forKey:@"strtag"];
	[[NSUserDefaults standardUserDefaults] synchronize];

    btnpriority=(UIButton *)sender;

	if(!isPriority) {
        PriorityView *priority = [[PriorityView alloc] initWithNibName:@"PriorityView" bundle:nil];
        [priority setParent:self];
        tagbtn=section1;
        popover2 = [[UIPopoverController alloc] initWithContentViewController:priority];
        popover2.delegate = self;
		//NSLog(@"%d",i);
        NSSet *touches = [event allTouches];
        UITouch *touch = [touches anyObject];
        CGPoint currentTouchPosition = [touch locationInView:self.view];

        [popover2 presentPopoverFromRect:CGRectMake(currentTouchPosition.x, clickedCell.frame.origin.y+215, 10, 10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];

			isPriority = YES;
        [[NSNotificationCenter defaultCenter] 
         addObserver:self
         selector:@selector(dismissPopOverViewHome2:)
         name:@"dismissPopOverViewHome2"
         object:popover2.contentViewController];
    }
    
    else
    {
        [popover2 dismissPopoverAnimated:YES];
        isPriority = NO;
    }}
   	
}
-(IBAction)clickPriorityCal:(id)sender event:(id)event{
    [self playSoundOnStatusPrio];
    UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
	NSIndexPath *clickedButtonPath = [tblCalendar indexPathForCell:clickedCell];
	int rows=clickedButtonPath.row;
   
    
        btnPriorityCal=(UIButton *)sender;
        
            str_cid=[[arrCalText objectAtIndex:rows] valueForKey:@"cid"];
            PriorityView *priority = [[PriorityView alloc] initWithNibName:@"PriorityView" bundle:nil];
            [priority setParent:self];
           
            popover2 = [[UIPopoverController alloc] initWithContentViewController:priority];
            popover2.delegate = self;
            //NSLog(@"%d",i);
            NSSet *touches = [event allTouches];
            UITouch *touch = [touches anyObject];
            CGPoint currentTouchPosition = [touch locationInView:self.view];
            
            [popover2 presentPopoverFromRect:CGRectMake(currentTouchPosition.x, clickedCell.frame.origin.y+235, 10, 10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            
			isPriority = YES;
            [[NSNotificationCenter defaultCenter] 
             addObserver:self
             selector:@selector(dismissPopOverViewHome2:)
             name:@"dismissPopOverViewHome2"
             object:popover2.contentViewController];
                
          
}
-(IBAction)clickOnLocation:(id)sender event:(id)event{
    [self playSoundOnButtonClick];
    UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
	
    
    LocationPop *objLoc = [[LocationPop alloc] initWithNibName:@"LocationPop" bundle:nil];
    
    
    UINavigationController *navCont=[[UINavigationController alloc] initWithRootViewController:objLoc];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissmissSettings:) name:@"dissmissSetting"  object:popOver_settings.contentViewController];
    self.popOver_Location = [[[WEPopoverController alloc] initWithContentViewController:navCont] autorelease];
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.view];
    
    [self.popOver_Location presentPopoverFromRect:CGRectMake(currentTouchPosition.x, clickedCell.frame.origin.y+270, 10, 10) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    
    [objLoc release];
}
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
	return YES;
}

-(void)CallMethod:(UIImage *)image indexis:(int)indexis email:(NSString *)email
{
	
    //NSData* pictureData = UIImagePNGRepresentation(image);
//    NSString* pictureDataString = [[NSString alloc] initWithData:pictureData encoding:NSUnicodeStringEncoding];
//
   
    //[dic_image setObject:pictureData forKey:strim];
   
	//[btn setImage:image forState:UIControlStateNormal];
    strEmail=email;
    [popover dismissPopoverAnimated:YES];
    if(row==0){
        [self updateStatusMain];
    }
    else{
    [self updateStatusSub];
    }
    if(indexis==1){
        //http://openxcellaus.info/emainder/user_action.php?action=assign_task&uid=10&auid=47&mtid=27
        NSLog(@"%@",email);
        if(![email isEqualToString:@""])
        [self findEmail];
    }
}
-(void)findEmail{
    NSString *str;
    http://openxcellaus.info/emainder/user_action.php?action=userlist
    str=[NSString stringWithFormat:@"%@/user_action.php?action=userlist",appdel.url];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchEmail:) andHandler:self];
    NSLog(@"%@",parser);
}
-(void)searchEmail:(NSDictionary*)dictionary{
    [AlertHandler hideAlert];
    NSLog(@"%@",dictionary);
    int flagemai=0;
    NSString *strUID;
    NSMutableArray *arrEmail=(NSMutableArray *)[dictionary valueForKey:@"users"];
    NSLog(@"%@",[arrEmail objectAtIndex:0]);
    for(int y=0;y<[arrEmail count];y++){
        if([[[arrEmail objectAtIndex:y] valueForKey:@"email"] isEqualToString:strEmail]){
            NSLog(@"found");
            flagemai=1;
            strUID=[[arrEmail objectAtIndex:y] valueForKey:@"uid"];
            
        }
    }
    if(flagemai==1){
        [self JSONDelegate:strEmail strid:strUID];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"The email address is not registered" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
}
-(void)JSONDelegate:(NSString *)email strid:(NSString *)strid
{
    
    
    [AlertHandler showAlertForProcess];
    NSString *str;
    NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
    if(index==0){
    str=[NSString stringWithFormat:@"%@/user_action.php?action=assign_task&uid=%@&auid=%@&mtid=%@",appdel.url,str_id,strid,str_mtid];
    }
    else{
        str=[NSString stringWithFormat:@"%@/user_action.php?action=assign_sub_task&uid=%@&auid=%@&stid=%@",appdel.url,str_id,strid,str_stid];
    }
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchDelegate:) andHandler:self];
    NSLog(@"%@",parser);
    
	
}
-(void)searchDelegate:(NSDictionary*)dictionary
{
    [AlertHandler hideAlert];
    NSLog(@"%@",dictionary);
    if([[dictionary valueForKey:@"msg"]isEqualToString:@"task already assigned"]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"The task has been already assigned" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
    }
    else if([[dictionary valueForKey:@"msg"]isEqualToString:@"task assigned successfull"] && [[dictionary valueForKey:@"status"] isEqualToString:@"Notification sent succesfully"]){
        [arr_tagNew addObject:@"0"];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Task Delegated Successfully" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
         
        [alert show];
        [alert release];
    }
    else if([[dictionary valueForKey:@"msg"]isEqualToString:@"sub task assigned successfull"] && [[dictionary valueForKey:@"status"] isEqualToString:@"Notification sent succesfully"]){
        [arr_tagNew addObject:@"0"];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Task Delegated Successfully" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    
    
    
}
-(void)CallMethodPriority:(UIImage *)image
{
  //  [priorityBtn setImage:image forState:UIControlStateNormal];
    //NSData *pictureData=UIImagePNGRepresentation(image);
    NSString *strim=[[NSUserDefaults standardUserDefaults]valueForKey:@"strtag"];
    NSLog(@"%@",strim);
   // [dic_priorityimage setObject:pictureData forKey:strim];
      [popover2 dismissPopoverAnimated:YES];
    if(isCalendar){
        [self updatePriCal];
    }
    else{
        if(row==0){
            [self updatePriorityMain];
        }
        else
            [self updatePrioritySub];
    }
}

-(IBAction)clickOnEditBtn:(id)sender
{
    [self playSoundOnButtonClick];
	if(table1.editing)
	{ 
        
        imgCalList.hidden=NO;
        panGesture.enabled=YES;
        btnCal.enabled=YES;
        btnList.enabled=YES;
		[super setEditing:NO animated:NO]; 
		[self.table1 setEditing:NO animated:NO];
		[self.table1 reloadData];
		[editBtn setSelected:NO];
        [editBtn setImage:[UIImage imageNamed:@"editNormal.png"] forState:UIControlStateNormal];
	}
	else
	{
        
       
      
        imgCalList.hidden=YES;
        panGesture.enabled=NO;
        btnCal.enabled=NO;
        btnList.enabled=NO;
        [editBtn setImage:[UIImage imageNamed:@"DoneNormal.png"] forState:UIControlStateNormal];
		[super setEditing:YES animated:YES]; 
		[self.table1 setEditing:YES animated:YES];
		[self.table1 reloadData];
		[editBtn setSelected:YES];
	}
}
#pragma mark Search
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(appdel.sound==1){
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/smooth_button_click01.wav"];
    
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    //Use audio sevices to create the sound
    
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    
    //Use audio services to play the sound
    
    AudioServicesPlaySystemSound(soundID);
    }
    if(textField==txtSearch){
    tblSearch.hidden = NO;
    table1.hidden=YES;
    NSString *substring = [NSString stringWithString:txtSearch.text];
    substring = [substring  stringByReplacingCharactersInRange:range withString:string];
        if(![substring isEqualToString:@""]){
    [self searchAutocompleteEntriesWithSubstring:substring];
        }
        else{
            [arrSearch removeAllObjects];
            [tblSearch reloadData];
        }
    return YES;
    }
    else{
        return YES;
    }
}
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    
    [arrSearch removeAllObjects];
    NSMutableDictionary *dictSearch=[[NSMutableDictionary alloc] init];
    NSLog(@"%@ %@",txtSearch.text,substring);
   // dictSearch=[dal executeDataSet:[NSString stringWithFormat:@"SELECT DISTINCT d.title,c.title,d.scid FROM tblMainTask d LEFT OUTER JOIN tblSubCat c on c.scid = d.scid WHERE(d.title LIKE '%@%%' OR c.title LIKE '%@%%')",substring,substring]];
   
    dictSearch=[dal executeDataSet:[NSString stringWithFormat:@"SELECT c.titleCat,d.title,d.scid,c.scid FROM tblMainTask d,tblSubCat c  on c.scid = d.scid  WHERE d.title LIKE '%@%%' OR c.titleCat LIKE '%@%%' AND c.mcid=%@",substring,substring,appdel.str_mcid]];
   
    NSLog(@"%@",[[dictSearch valueForKey:@"title"] valueForKey:@"table1"]);
    
    
    for(int m=1;m<=[dictSearch count];m++){
        [arrSearch addObject:[dictSearch valueForKey:[NSString stringWithFormat:@"Table%d",m]]];
    }
    if([dictSearch count]==0){
        [dictSearch setObject:@"           No results                  " forKey:@"title"];
        [dictSearch setObject:@"" forKey:@"titleCat"];
        [arrSearch addObject:dictSearch];
    }
   
    
    
       [tblSearch reloadData];
}

#pragma mark gesture recognizer
//-(void)tap
- (IBAction)tapDetected:(UIGestureRecognizer *)sender 
{
    if([popover_tap isPopoverVisible]){
        if(appdel.sound==1){
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/smoothbutton2.wav"];
    
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    //Use audio sevices to create the sound
    
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    
    //Use audio services to play the sound
    
    AudioServicesPlaySystemSound(soundID);
        
        }}
    if([popOver_settings isPopoverVisible]){
        arrtab= [[NSUserDefaults standardUserDefaults] objectForKey:@"tab"];
        [popOver_settings dismissPopoverAnimated:YES];
       
        [self setMainTabs];
         [self setButtons];
        [self setActiveButton];
    }
    if([popOver_Location isPopoverVisible]){
        [popOver_Location dismissPopoverAnimated:YES];
    }
    if( txtmainfld){
    if([txtmainfld isFirstResponder])
    [txtmainfld resignFirstResponder];
    
    }
   
    CGPoint p = [sender locationInView:table2];
    NSIndexPath *indexPath = [table2 indexPathForRowAtPoint:p];
    CGPoint d=[sender locationInView:tblCalendar];
 
    NSLog(@"%f %f",p.x,p.y/54);
    if(p.y/54 >[arr_tagNew count] && p.x>0 && p.y/54<[arr_tagNew count]+1 && [appdel.isTaskOrEvent isEqualToString:@"0"])
    [self btnAdd:self];
    else if(d.y/54>[arrCalText count] && d.x>0 && d.y/54<[arrCalText count]+1 && [appdel.isTaskOrEvent isEqualToString:@"1"])
    [self btnAdd:self];
    
    NSLog(@"%d %d",indexPath.section,indexPath.row);
    
	[popover dismissPopoverAnimated:YES];
    [popover2 dismissPopoverAnimated:YES];
    [popover_progress dismissPopoverAnimated:YES];
    
    [popover_sync dismissPopoverAnimated:YES];
    [popover_tap dismissPopoverAnimated:YES];
    [btnProgress setSelected:NO];
	[btnSync setSelected:NO];
    [btnInfo setSelected:NO];
    [btnSettings setSelected:NO];

}
-(IBAction)hidePopView:(id)sender
{
     	
    //TapView *tap= [[TapView alloc] init];
    [btnProgress setImage:[UIImage imageNamed:@"progressNon.png"] forState:UIControlStateNormal];
  
//    if(tap.flagEdit==0){
//        [dic_txt removeObjectForKey:[NSString stringWithFormat:@"%d^%d",sectionOUt,index]];
//        [dic_txt setObject:tap.strTitle forKey:[NSString stringWithFormat:@"%d^%d",sectionOUt,index]];
//        [table2 reloadData];
//    }
    [popover_tap dismissPopoverAnimated:YES];
   // [self getMainTask];
    
   
    
}

-(void)dismissPopOverViewHome3:(id)sender
{
    if([popover_tap isPopoverVisible]){
        if(appdel.sound==1){
        NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/smoothbutton2.wav"];
        
        SystemSoundID soundID;
        
        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        
        //Use audio sevices to create the sound
        
        AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
        
        //Use audio services to play the sound
        
        AudioServicesPlaySystemSound(soundID); 
        }
    [popover_tap dismissPopoverAnimated:YES];
    }
    isOpen=TRUE;
    if(appdel.tagFlag==1 && [lblCatTitle.text isEqualToString:@"All Work"]){
        [arr_tagNew addObject:@"0"];
        appdel.tagFlag=0;
    }
    if(isEdit==0){
        [self getAllMainTask];
    }
    else{
        
        [self getMainTask];
    }
    if([appdel.isTaskOrEvent isEqualToString:@"1"]){
        [self getCalendar];
    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if(textField==txtSearch){
        table1.hidden=FALSE;
        tblSearch.hidden=TRUE;
        txtSearch.text=@"";
        str_searchID=@"";
    }
    [textField resignFirstResponder];
    return YES;
}


#pragma mark End methods
-(IBAction)endOfSearch:(UITextField *)sender{
    [txtSearch resignFirstResponder];
    table1.hidden=FALSE;
    tblSearch.hidden=TRUE;
    txtSearch.text=@"";
    str_searchID=@"";
}
-(IBAction)endOfCal:(UITextField *)sender{
    UITextField *txt1=(UITextField *)sender;
    NSLog(@"%@",txt1.text);
    NSLog(@"%d",txt1.tag);
    if(txt1.text.length>0){
    NSString *firstCapChar = [[txt1.text substringToIndex:1] capitalizedString];
    NSString *cappedString = [txt1.text stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
 
    NSMutableDictionary *dicm=[[NSMutableDictionary alloc] init];
    [dicm setObject:[NSString stringWithFormat:@"%@%@",lblDate.text,lblMonth.text] forKey:@"date"];
   
    [dicm setObject:[NSString stringWithFormat:@"%@",str_id] forKey:@"uid"];
    [dicm setObject:[NSString stringWithFormat:@"%@",cappedString] forKey:@"title"];
    [dicm setObject:[NSString stringWithFormat:@"%@",currentDate] forKey:@"datedate"];
    [dicm setObject:@"2" forKey:@"priority"];
    int dup=0;
    if(![txt1.text isEqualToString:@""]){
        for(int y=0;y<[arrCalText count];y++)
        {
        if([cappedString isEqualToString:[arrCalText objectAtIndex:y]])
        {
            dup=1;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!!" message:[NSString stringWithFormat:@"%@ Already Exists.",cappedString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
        }
        }
        if(dup==0){
        [dal insertRecord:dicm inTable:@"tblCal"];
        }
    }
    if(dicm!=nil){
        [dicm removeAllObjects];
        [dicm release];
        dicm=nil;
    }
    isCalAdd=FALSE;
    [self getCalendar];
    }
}

-(IBAction)endOfMain:(UITextField *)sender{
    
    UITextField *txt1=(UITextField *)sender;
    NSLog(@"%@",txt1.text);
    if([txt1.text isEqualToString:@""]){
        reodered=0;
        [table2 reloadData];
    }
    else{
        reodered=0;
        strMainTaskTitle=txt1.text;
        [self insertMainTask];
    }
}
-(IBAction)textHeaderEnd:(UITextField *)sender{
    UITextField *newTxt=(UITextField *)sender;
    textHeader.text=newTxt.text;
   
    NSString *str=[NSString stringWithFormat:@"%@",newTxt.text];
    NSLog(@"%@",str);
   
    int a=newTxt.tag-1;
    NSLog(@"text feild tag is %d",a);
    //[dictSection setObject:str forKey:[NSString stringWithFormat:@"%d",a]];
    //NSLog(@"%@",dictSection);
    str_mtid=[arr_maintask objectAtIndex:rowcell];
    NSLog(@"main task id is%@",str_mtid);
    strMainTaskTitle=str;
   
   
    
    if(rowcell>[arr_maintask count]-1){
        
                
        
        [self insertMainTask];
    }
    else{
        if([str isEqualToString:[arrayOfSection objectAtIndex:a]]){
            
        }
        else{
            str_mtid=[arr_maintask objectAtIndex:a];
            [self JSON_updateMainTask];
        }
    }

    
    
    
}

-(IBAction)category_txtType:(UITextField *)sender
{
    
        
  
    UITextField *newTxt=(UITextField *)sender;
    txt_category.text=newTxt.text;
    NSIndexPath *indexPath1;
    UITableViewCell *cell = (UITableViewCell *)[[newTxt superview] superview];
    
    indexPath1=[table1 indexPathForCell:cell];
    rowcell=indexPath1.row;
    
    strSubCatTitle=txt_category.text;
    if(rowcell>[arrsubCatTitle count]-1){
    
        if([strSubCatTitle isEqualToString:@""] || [strSubCatTitle isEqualToString:@"Enter"]){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry!!!"
                                                          message:@"Please enter a title" 
                                                         delegate:self 
                                                cancelButtonTitle:@"Ok" 
                                                otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else{
            
             [self insertSubCat];
        }
    
   
        
   
   }
    else if(rowcell==0 && [arrsubCatTitle count]==0){
        
        if([strSubCatTitle isEqualToString:@""] || [strSubCatTitle isEqualToString:@"Enter"]){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry!!!"
                                                          message:@"Please enter a title" 
                                                         delegate:self 
                                                cancelButtonTitle:@"Ok" 
                                                otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else{
            [self insertSubCat];
        }
    }
    else{
        if([txt_category.text isEqualToString:[arrsubCatTitle objectAtIndex:rowcell]]){
            txt_category.text=@"";
        }
        else{
          str_scid=[arrScid objectAtIndex:rowcell];
            
            NSMutableDictionary *dictUpdate=[[NSMutableDictionary alloc] init];
            [dictUpdate setValue:[NSString stringWithFormat:@"%@",strSubCatTitle] forKey:@"titleCat"];
            NSLog(@"%@",dictUpdate);
            [dal updateRecord:dictUpdate forID:@"scid=" inTable:@"tblSubCat" withValue:[NSString stringWithFormat:@"%@",str_scid]];
            strSubCatTitle=@"";
            
            if(dictUpdate!=nil){
                [dictUpdate removeAllObjects];
                [dictUpdate release];
                dictUpdate=nil;
            }
            [self getSubCat];
            
        }
    }
   
}

#pragma mark Table Sections

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==table1)
    return  44;
    else
        return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == table2)
    {
        return 0;
    }
    else if(tableView == table1)
    {
        return 0;
    }
     return 0;
}


-(IBAction)getSection:(id)sender{
    UIButton *button=(UIButton *)sender;
	tagbtn=button.tag;
    sectionOUt=tagbtn-1;
    NSLog(@"%d",sectionOUt);
    str_mtid=[arr_maintask objectAtIndex:sectionOUt];
    [[NSUserDefaults standardUserDefaults] setValue:str_mtid forKey:@"str_mtid_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"id is %@",str_mtid);
    //index=indexPath.row;
}
- (NSArray*)indexPathsInSection:(NSInteger)section 
{
	NSMutableArray *paths = [NSMutableArray array];
	NSInteger row1;	
	for ( row1 = 0; row1 < [table2 numberOfRowsInSection:section]; row1++ ) {
		[paths addObject:[NSIndexPath indexPathForRow:row1 inSection:section]];
	}
	return [NSArray arrayWithArray:paths];
}
#pragma mark IndentOutdentBtn
-(IBAction)buttonClicked:(id)sender
{
    [self playSoundOnButtonClick];
    UIButton *button=(UIButton *)sender;
    
    tagbtn=button.tag;
    str_mtid=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^0",tagbtn]];
    [[NSUserDefaults standardUserDefaults] setValue:str_mtid forKey:@"str_mtid"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    i=5;
   int b = [[arr_tagNew objectAtIndex:(tagbtn)] intValue];
	if(b == 0)
		[arr_tagNew replaceObjectAtIndex:(tagbtn) withObject:[NSString stringWithFormat:@"%d",1]];
	else {
		[arr_tagNew replaceObjectAtIndex:(tagbtn) withObject:[NSString stringWithFormat:@"%d",0]];
        NSLog(@"%@",dictForRows);
//        [dictForRows removeObjectForKey:[NSString stringWithFormat:@"%d^0",tagbtn]];
//        int hh=1;
//         NSLog(@"%@",dictForRows);
//        [dictForRows setObject:[NSString stringWithFormat:@"%d",hh] forKey:[NSString stringWithFormat:[NSString stringWithFormat:@"%d^0",tagbtn]]];
//         NSLog(@"%@",dictForRows);
        
	}
   NSLog(@"%@",dictForRows);
    rowsCnt=0;
    [table2 reloadData];
    
  
   
}


#pragma mark tableMethods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
   

	if (tableView==table1)
	{
		return 1;
	}
	else if(tableView == table2)
	{
        if(reodered==100){
            return [dictMainTask count]+1;
        }
        else{
        NSLog(@"Sections %d",[dictMainTask count]);
        return [dictMainTask count];
        }
            
	}
    else if(tableView==tblCalendar){
        return 1;
    }
    else{
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     int a,b;
	if(tableView==table1)
	{
       

        int count;
        count=[arrsubCatTitle count];
        if(table1.editing) count++;
        return count;
	}
	else if(tableView == table2)
	{
        if(section==[dictMainTask count]){
            return 1;
        }
       
        else
        {
            
       
            if(i==100)
            {
                if(![arrTemptag count]==0)
                {
                
                    b = [[arrTemptag objectAtIndex:section] intValue];
                }
                if([arrTemptag count]==0)
                {
                return 0;
                }
            }
            else
            {
                NSLog(@"section %d",section);
                NSLog(@"arr tag new%@",arr_tagNew);
                if(![arr_tagNew count]==0)
                {
           
                    b = [[arr_tagNew objectAtIndex:section] intValue];
                }
                if([arr_tagNew count]==0)
                {
                return 0;
                }
            }
            if(b==0)
            {
                a=1;
                rowsCnt++;
            
            }
            else
            {
                NSString *rowsno=[dictForRows valueForKey:[NSString stringWithFormat:@"%d^0",section]];
                a=[rowsno intValue];
                rowsCnt+=a;
           
            }
      
        return a;
    }
    }
    else if(tableView==tblCalendar){
        if(calIndex==1){
            
            return [arrCalText count]+1;
            
        }
        else
        return [arrCalText count];
    }
    else if(tableView==tblSearch){
        return [arrSearch count];
    }
       
        return 0;
        
	
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==table1)
    {
        //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgcell1.png"]];
    }
    if (tableView==table2)
    {
        //cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]; 
    }
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//	NSString *cellid=@"cell";
//	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell1 == nil) {
        cell1 = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell1.shouldIndentWhileEditing = NO;
	if(tableView == table1)
	{
        NSString *cellid=@"cell";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellid];
        [[NSBundle mainBundle] loadNibNamed:@"CategoryCustomCell" owner:self options:nil];
        cell1=self.category_cell;
        self.category_cell=nil;
        

	// Set up the cell...
        
        if(!table1.editing){
            txt_category.frame=CGRectMake(0, 0, 0, 0);
            
            cell1.textLabel.textColor = [UIColor whiteColor];
            cell1.textLabel.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
            cell1.textLabel.text=[arrsubCatTitle objectAtIndex:indexPath.row];
            

            
        }
        else{
        
        
        if(table1.editing && indexPath.row != 0)
            
		            
            if(indexPath.row == ([arrsubCatTitle count]) && table1.editing){
                
                return cell1;
            }
            txt_category.text=[arrsubCatTitle objectAtIndex:indexPath.row];
            txt_category.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
            
        //	cell.textLabel.text = [dataList objectAtIndex:indexPath.row];
        }
        return cell1;
    

	}
	
	
	else if(tableView == table2)
	{
       // NSLog(@"index of sec %d && count of dict is %d",indexPath.section,[dictMainTask count]);
        if(indexPath.section==sectionOUt && indexPath.row==index){
            cell1.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Active lineRight.png"]] autorelease];
        }
        else{
            
        }
        

		
        [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell1=self.tbl2Cell;
        self.tbl2Cell=nil;
        if([dictMainTask count]==indexPath.section){
            rowsCnt=0;
            CGRect labelRect = CGRectMake(127,10,255.0,31);
            txtmainfld=[[UITextField alloc] initWithFrame:labelRect];
            [cell1.contentView addSubview:txtmainfld];
            txtmainfld.text=@"";
            [txtmainfld becomeFirstResponder];
            txtmainfld.backgroundColor=[UIColor clearColor];
            [txtmainfld addTarget:self action:@selector(endOfMain:) forControlEvents:UIControlEventEditingDidEnd];
            txtmainfld.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
            txtmainfld.textColor=[UIColor colorWithRed:61.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1];
            txtmainfld.delegate=self;
            txt.text=@"";
           
            
        }
        if(![dic_txt count]==0){
            
            if(indexPath.row>=1){
                txt.text=[NSString stringWithFormat:@"       %@",[dic_txt valueForKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.row]]];
            }
            else{
            
                txt.text=[dic_txt valueForKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.row]];
            }
            
            if([txt.text isEqualToString:[NSString stringWithFormat:@"%@",str_searchID]]){
                txt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
                txt.textColor=[UIColor redColor];
            }
            else{
            txt.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
            txt.textColor=[UIColor colorWithRed:61.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1];
            }
                
                
         
          
        if([[dictArrow valueForKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.row]] intValue]==1){
            
            if([[arr_tagNew objectAtIndex:indexPath.section] isEqualToString:@"0"]){
                [btnShrink setImage:[UIImage imageNamed:@"disclosure.png"] forState:UIControlStateNormal];
                btnShrink.tag=indexPath.section;
            }
            
            else{
                [btnShrink setImage:[UIImage imageNamed:@"shrink.png"] forState:UIControlStateNormal];
                btnShrink.tag=indexPath.section;
            }
            }
        else{
            btnShrink.enabled=NO;
        }
        }
       
//        NSLog(@"here is %@",[dic_image valueForKey:[NSString stringWithFormat:@"%d^%d",indexPath.row,indexPath.section]]);
        UIImage *image=[UIImage imageNamed:@"btnkeep.png"];
        NSData* pictureData = UIImagePNGRepresentation(image);
        if([dic_image valueForKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.row]]){
            
            if([[dic_image valueForKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.row]] isEqualToData:pictureData]){
                
                
            }
            else
            {

                NSData *data=[dic_image valueForKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.row]];
        
                UIImage* image = [UIImage imageWithData:data];
        
                [statusBtn setImage:image forState:UIControlStateNormal];
            }
        }
        if([dic_priorityimage valueForKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.row]])
        {
            
            if([[dic_priorityimage valueForKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.row]] isEqualToData:pictureData]){
                
                
            }
            else{
            NSData *data_priority=[dic_priorityimage valueForKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.row]];
            UIImage* image_priority = [UIImage imageWithData:data_priority];
        
            [priorityBtn setImage:image_priority forState:UIControlStateNormal];
            }
        }
      
	    return cell1;

    }
    else if(tableView==tblCalendar){
        [[NSBundle mainBundle] loadNibNamed:@"CalendarCell" owner:self options:nil];
        cell1=self.cellCalendar;
        //self.cellCalendar=nil;
        if([arrCalText count]==indexPath.row && calIndex==1){
            calIndex=0;
            CGRect labelRect = CGRectMake(58,10,255.0,31);
            txtCal=[[UITextField alloc] initWithFrame:labelRect];
            [cell1.contentView addSubview:txtCal];
            txtCal.text=@"";
            [txtCal becomeFirstResponder];
            txtCal.backgroundColor=[UIColor clearColor];
            [txtCal addTarget:self action:@selector(endOfCal:) forControlEvents:UIControlEventEditingDidEnd];
            txtCal.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
            txtCal.textColor=[UIColor colorWithRed:61.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1];
            txtCal.delegate=self;
            lblTime.text=@"";
            
        }
        else{
           
            if([arrCalText count]!=0){
            lblTime.text=[[arrCalText objectAtIndex:indexPath.row]valueForKey:@"title"];
            if([[[arrCalText objectAtIndex:indexPath.row] valueForKey:@"priority"] isEqualToString:@"0"]){
                UIImage *image=[UIImage imageNamed:@"Acitical.png"];
               
                [btnPriorityCal setImage:image forState:UIControlStateNormal];
            }
            else if([[[arrCalText objectAtIndex:indexPath.row] valueForKey:@"priority"] isEqualToString:@"1"]){
                 UIImage *image=[UIImage imageNamed:@"BHigh.png"];
               
                [btnPriorityCal setImage:image forState:UIControlStateNormal];
            }
            else if([[[arrCalText objectAtIndex:indexPath.row] valueForKey:@"priority"] isEqualToString:@"2"]){
                UIImage *image=[UIImage imageNamed:@"C.png"];
               
                [btnPriorityCal setImage:image forState:UIControlStateNormal];
            }
            }
               
      
        
        }  
        return cell1;
    }
    else if(tableView==tblSearch){
        cell1.textLabel.textColor = [UIColor whiteColor];
        cell1.textLabel.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
        
        cell1.textLabel.text=[NSString stringWithFormat:@"%@-%@",[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"title"],[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"titleCat"]];
    }
    return cell1;

}

#pragma mark DidSelectTable
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(tableView == table1)
	{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
      
       // cell.contentView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.4 alpha:1.0];
        
        rowsCnt=0;

        str_scid=[arrScid objectAtIndex:indexPath.row];
        [arr_maintask removeAllObjects];
        [arrayOfSection removeAllObjects];
        [dic_txt removeAllObjects];
        [dictForRows removeAllObjects];
        [arr_tagNew removeAllObjects];
        [dic_image removeAllObjects];
        [dic_priorityimage removeAllObjects];        
        [arrSuBTaskID removeAllObjects];
        [dictSubTaskID removeAllObjects];
        [arrSuBTaskID removeAllObjects];
        [dictArrow removeAllObjects];
        [dictMainTask removeAllObjects];
        lblCatTitle.text=[arrsubCatTitle objectAtIndex:indexPath.row];
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Active side line.png"]] autorelease];
        cell.textLabel.highlightedTextColor = [UIColor colorWithRed:61.0/255.0 green:109/255.0 blue:149/255.0 alpha:1];

        isEdit=indexPath.row;
        [[NSUserDefaults standardUserDefaults] setValue:str_scid forKey:@"parentSubCAT_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"str scid=>%@",str_scid);
        if(indexPath.row==0){
            allFlag=0;
            reodered=0;
            isOpen=FALSE;
            [self getAllMainTask];
            
        }
        else{
            allFlag=1;
            reodered=0;
            alertFlag=10;
            isOpen=FALSE;
            [self getMainTask];
        }
       
                
	}
	if(tableView == table2 && [dictMainTask count]!=indexPath.section)
	{
        
        NSLog(@"%@",arrsubCatTitle);
        index=indexPath.row;
        sectionOUt=indexPath.section;
        UITableViewCell *cell = [table2 cellForRowAtIndexPath:indexPath];
        

        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Active lineRight.png"]] autorelease];
        
        str_scid = [[NSUserDefaults standardUserDefaults]valueForKey:@"parentSubCAT_id"];
        NSString *strTitle=[dic_txt valueForKey:[NSString stringWithFormat:@"%d^%d",sectionOUt,index]];
        strTitle=[strTitle stringByReplacingOccurrencesOfString:@"       " withString:@""];
        [[NSUserDefaults standardUserDefaults] setValue:strTitle forKey:@"strTitle"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        str_mtid=[NSString stringWithFormat:@"%@",[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",sectionOUt,index]]];
        
        str_stid=[NSString stringWithFormat:@"%@",[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",sectionOUt,index]]];
        
        TapView *tap= [[TapView alloc] initWithNibName:@"TapView" bundle:nil];
        tap.str_scid=str_scid;
        if(indexPath.row==0){
            tap.str_mtid=str_mtid;
            tap.str_stid=nil;
        }
        else{
            tap.str_mtid=nil;
            tap.str_stid=str_stid;
        }
        
        
        if(appdel.sound==1){
        NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/smoothbutton1.wav"];
        
        SystemSoundID soundID;
        
        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        
        //Use audio sevices to create the sound
        
        AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
        
        //Use audio services to play the sound
        
        AudioServicesPlaySystemSound(soundID);  
        }
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tap];
        [[NSNotificationCenter defaultCenter] 
         addObserver:self
         selector:@selector(dismissPopOverViewHome3:)
         name:@"dismissPopOverViewHome"
         object:popover_tap.contentViewController];
       
        self.popover_tap = [[UIPopoverController alloc] initWithContentViewController:navController];
        self.popover_tap.delegate = self;
        
		
        
        CGRect frame = [table2 cellForRowAtIndexPath:indexPath].frame;
        CGRect rect = frame;
        
        [self.popover_tap presentPopoverFromRect:CGRectMake(rect.origin.x+375, rect.origin.y+67, 320, 300)												inView:self.view 
							  permittedArrowDirections:(
														UIPopoverArrowDirectionLeft| UIPopoverArrowDirectionRight)
											  animated:YES];
        
              
       
       
    }

    else if(tableView==tblCalendar){
        
        
       
        index=indexPath.row;
        sectionOUt=indexPath.section;
        UITableViewCell *cell = [tblCalendar cellForRowAtIndexPath:indexPath];
        
        
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Active lineRight.png"]] autorelease];
        
        str_scid = [[NSUserDefaults standardUserDefaults]valueForKey:@"parentSubCAT_id"];
        NSString *strTitle=[[arrCalText objectAtIndex:indexPath.row] valueForKey:@"title"];
        
        [[NSUserDefaults standardUserDefaults] setValue:strTitle forKey:@"strTitle"];
        [[NSUserDefaults standardUserDefaults] synchronize];
       
        
        TapView *tap= [[TapView alloc] initWithNibName:@"TapView" bundle:nil];
        
        tap.strCid=[[arrCalText objectAtIndex:indexPath.row] valueForKey:@"cid"];
        tap.str_mtid=nil;
        tap.str_stid=nil;
        if(appdel.sound==1){
            NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/smoothbutton1.wav"];
            
            SystemSoundID soundID;
            
            NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
            
            //Use audio sevices to create the sound
            
            AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
            
            //Use audio services to play the sound
            
            AudioServicesPlaySystemSound(soundID);  
        }
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tap];
        [[NSNotificationCenter defaultCenter] 
         addObserver:self
         selector:@selector(dismissPopOverViewHome3:)
         name:@"dismissPopOverViewHome"
         object:popover_tap.contentViewController];
        
        self.popover_tap = [[UIPopoverController alloc] initWithContentViewController:navController];
        self.popover_tap.delegate = self;
        
		
        
        CGRect frame = [tblCalendar cellForRowAtIndexPath:indexPath].frame;
        CGRect rect = frame;
        NSLog(@"rect %f %f",rect.origin.x,rect.origin.y);
        [self.popover_tap presentPopoverFromRect:CGRectMake(rect.origin.x, rect.origin.y-105, 250, 250)												inView:tblCalendar
                        permittedArrowDirections:(
                                                  UIPopoverArrowDirectionLeft| UIPopoverArrowDirectionRight)
                                        animated:YES];
        
        

    
}
    else if(tableView==tblSearch){
        str_scid=[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"scid"];
        lblCatTitle.text=[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"titleCat"];
        str_searchID=[[arrSearch objectAtIndex:indexPath.row] valueForKey:@"title"];
        reodered=0;
        isOpen=FALSE;
        UITableViewCell *cell = [tblSearch cellForRowAtIndexPath:indexPath];
        cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Active side line.png"]] autorelease];
        cell.textLabel.highlightedTextColor = [UIColor colorWithRed:61.0/255.0 green:109/255.0 blue:149/255.0 alpha:1];
        [self getMainTask];
        
    }
}
-(IBAction)deleteCal:(UIButton *)sender{
    UIButton *btn=(UIButton *)sender;
    NSLog(@"%d",btn.tag);
    for(int p=0;p<[arrCalText count];p++){
        if([[arrTime objectAtIndex:btn.tag] isEqualToString:[[arrCalText objectAtIndex:p]valueForKey:@"time"]]){
        NSString *strid=[[arrCalText objectAtIndex:p]valueForKey:@"cid"];
            [dal deleteFromTable:@"tblCal" WhereField:@"cid=" Condition:[NSString stringWithFormat:@"%@",strid]];
        }
        
    }
    [self getCalendar];
}
    

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int add=0;
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeRight || self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        add=134;
    }
    else{
        add=0;
    }

        if([table2 isEditing])
            
        {
            lineVIew1.frame=CGRectMake(35, 0, 1, table2.frame.size.height+scrollView.contentOffset.y);
            lineView2.frame=CGRectMake(80, 0, 1, table2.frame.size.height+scrollView.contentOffset.y);
            lineView3.frame=CGRectMake(120, 0, 1, table2.frame.size.height+scrollView.contentOffset.y);
            lineView4.frame=CGRectMake(450, 0, 1, table2.frame.size.height+scrollView.contentOffset.y);
            lblStatus.frame=CGRectMake(283+add, 171, 46, 21);
            lblPriority.frame=CGRectMake(326+add, 171, 46, 21);
        }
        else if(![tblCalendar isEditing])
        
        {
                       
            lineCal1.frame = CGRectMake(0, 0, 1, tblCalendar.frame.size.height+scrollView.contentOffset.y);
            lineCal2.frame = CGRectMake(45, 0, 1, tblCalendar.frame.size.height+scrollView.contentOffset.y);
           
            lineCal3.frame = CGRectMake(465, 0, 1, tblCalendar.frame.size.height+scrollView.contentOffset.y);
            lastLine.frame = CGRectMake(489, 0, 1, tblCalendar.frame.size.height+scrollView.contentOffset.y);

               
        }

        
        else if(![table2 isEditing])
        {
            lineVIew1.frame = CGRectMake(0, 0, 1, table2.frame.size.height+scrollView.contentOffset.y);
            lineView2.frame = CGRectMake(45, 0, 1, table2.frame.size.height+scrollView.contentOffset.y);
            lineView3.frame = CGRectMake(90, 0, 1, table2.frame.size.height+scrollView.contentOffset.y);
            lineView4.frame = CGRectMake(465, 0, 1, table2.frame.size.height+scrollView.contentOffset.y);
            lineView5.frame = CGRectMake(489, 0, 1, table2.frame.size.height+scrollView.contentOffset.y);
            //lineCal1.frame = CGRectMake(0, 0, 1, tblCalendar.frame.size.height+scrollView.contentOffset.y);
            //lineCal2.frame = CGRectMake(489, 0, 1, tblCalendar.frame.size.height+scrollView.contentOffset.y);
        }
        else{
            
        }
   
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
   // if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    //    if (self.editing && indexPath.row == ([array_demo count])) {
    //		return UITableViewCellEditingStyleInsert;
    //	} else {
    //		return UITableViewCellEditingStyleDelete;
    //	}
    
    if(aTableView==table1){
        if (table1.editing && indexPath.row == ([arrsubCatTitle count])) {
            return UITableViewCellEditingStyleInsert;
        }
        else if(table1.editing){
            return UITableViewCellEditingStyleDelete;
        }
        else {
            return UITableViewCellEditingStyleNone;
        }
    }
   
    else if(aTableView==table2){
        [self.table1 setEditing:NO animated:NO];
        if(table2.editing)
            return UITableViewCellEditingStyleDelete;
        else
            return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == table1)
	{
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            

            // Delete the row from the data source.
            
                str_scid=[arrScid objectAtIndex:indexPath.row];
                [self deleteSubCat];
                
           
        }   
        else if (editingStyle == UITableViewCellEditingStyleInsert)
        {
            if(strSubCatTitle)
            {
                
            }
            else 
            {    
            if([strSubCatTitle isEqualToString:@""] || [strSubCatTitle isEqualToString:@"Enter"]){
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry!!!"
                                                              message:@"Please enter a title" 
                                                             delegate:self 
                                                    cancelButtonTitle:@"Ok" 
                                                    otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            else{
                
                [self insertSubCat];
            }
            

            }
        }}
    else if(tableView == table2)
    {
        if (editingStyle == UITableViewCellEditingStyleDelete) 
        {
            NSLog(@"%@",dictSubTaskID);
           	[self.table1 setEditing:NO animated:NO];
            str_stid=[[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.row]] retain];
            str_mtid=[[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^0",indexPath.section]]retain ];
            NSLog(@"str mtid %@",str_stid);
            
            [dic_txt removeObjectForKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.row]];
            int a=[[dictForRows valueForKey:[NSString stringWithFormat:@"%d^0",indexPath.section]] intValue];
            a--;
            NSLog(@"%d",a);
            [dictSubTaskID removeObjectForKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.row]];
            [dictForRows setObject:[NSString stringWithFormat:@"%d",a] forKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.section]];
            if(a==1){
                
                NSMutableDictionary *dicter=[[NSMutableDictionary alloc] init];
                [dicter setObject:@"1" forKey:@"child"];
                [dal updateRecord:dicter forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",str_mtid]];
                [dictArrow removeObjectForKey:[NSString stringWithFormat:@"%d^0",indexPath.section]];
                [dictArrow setObject:@"0" forKey:[NSString stringWithFormat:@"%d^0",indexPath.section]];
                
                
                [arr_tagNew replaceObjectAtIndex:indexPath.section withObject:@"0"];
                
                if(dicter!=nil){
                    [dicter removeAllObjects];
                    [dicter release];
                    dicter=nil;
                }
            }
            if(indexPath.row>=1){
            
            [self deleteSubtask];
            }
            else{
                sectionOUt=indexPath.section;
                [self deleteMainTask];
            }
        }
        else
        {
            NSLog(@"nothing");
        }
        
    }
    

}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(tableView==table1){
        if(indexPath.row==0 ||  [arrScid count]==indexPath.row){
            return NO;
        }
        else{
            return YES;
        }
    }
    else{
        return YES;
    }
    
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if(tableView ==table1)
    {
       
                
        NSLog(@"%d  %d",sourceIndexPath.row,destinationIndexPath.row);
       // if(!sourceIndexPath.row==[arrsubCatTitle count]){
        NSString *strIDSrc = [[arrScid objectAtIndex:sourceIndexPath.row] retain];
        NSString *strIDDes=[[arrScid objectAtIndex:destinationIndexPath.row] retain];
              
        int postSrc,postDes;
        NSArray *arrScr=[[NSArray alloc] initWithObjects:@"postionCat", nil];
        NSMutableArray *arrscr;
        arrscr=[dal SelectQuery:@"tblSubCat" withColumn:arrScr withCondition:@"scid=" withColumnValue:[NSString stringWithFormat:@"%@",strIDSrc]];
        postSrc=[[[arrscr objectAtIndex:0] valueForKey:@"postionCat"] intValue];
        arrscr=nil;
        arrscr=[dal SelectQuery:@"tblSubCat" withColumn:arrScr withCondition:@"scid=" withColumnValue:[NSString stringWithFormat:@"%@",strIDDes]];
        postDes=[[[arrscr objectAtIndex:0] valueForKey:@"postionCat"] intValue];
        NSLog(@"%d %d",postSrc,postDes);
        
        NSMutableDictionary *dictTemp=[[NSMutableDictionary alloc] init];
        [dictTemp setObject:[NSString stringWithFormat:@"%d",postDes] forKey:@"postionCat"];
        [dal updateRecord:dictTemp forID:@"scid=" inTable:@"tblSubCat" withValue:[NSString stringWithFormat:@"%@",strIDSrc]];
        [dictTemp removeAllObjects];
        [dictTemp setObject:[NSString stringWithFormat:@"%d",postSrc ] forKey:@"postionCat"];
        [dal updateRecord:dictTemp forID:@"scid=" inTable:@"tblSubCat" withValue:[NSString stringWithFormat:@"%@",strIDDes]];
        if(dictTemp!=nil){
            [dictTemp removeAllObjects];
            [dictTemp release];
            dictTemp=nil;
        }
        [strIDDes release];
        [strIDSrc release];
        
        [self getSubCat];
        //}
        
    }
    if(table2==tableView){
        swipeYES=1;
        NSLog(@"Sorce %d %d",sourceIndexPath.section,sourceIndexPath.row);
        NSLog(@"destina %d  %d",destinationIndexPath.section,destinationIndexPath.row);
        NSString *strIDSrc=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^0",sourceIndexPath.section,sourceIndexPath.row]] ;
        NSString *strIDDes=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^0",destinationIndexPath.section,destinationIndexPath.row]];
        NSLog(@"%@   %@",strIDSrc,strIDDes);
        int rowsDes=[[dictForRows valueForKey:[NSString stringWithFormat:@"%d^0",destinationIndexPath.section]] intValue];
        
        if(sourceIndexPath.row==0 && destinationIndexPath.row==0){
            
            int postSrc,postDes;
            NSArray *arrScr=[[NSArray alloc] initWithObjects:@"position", nil];
            NSMutableArray *arrscr;
            arrscr=[dal SelectQuery:@"tblMainTask" withColumn:arrScr withCondition:@"mtid=" withColumnValue:[NSString stringWithFormat:@"%@",strIDSrc]];
            postSrc=[[[arrscr objectAtIndex:0] valueForKey:@"position"] intValue];
            arrscr=nil;
            arrscr=[dal SelectQuery:@"tblMainTask" withColumn:arrScr withCondition:@"mtid=" withColumnValue:[NSString stringWithFormat:@"%@",strIDDes]];
            postDes=[[[arrscr objectAtIndex:0] valueForKey:@"position"] intValue];
            
            NSLog(@"%d  %d",postSrc,postDes);
            NSMutableDictionary *dictOfpos=[[NSMutableDictionary alloc] init];
            [dictOfpos setObject:[NSString stringWithFormat:@"%d",postDes] forKey:@"position"];
            [dal updateRecord:dictOfpos forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strIDSrc]];
            [dictOfpos removeAllObjects];
            [dictOfpos setObject:[NSString stringWithFormat:@"%d",postSrc] forKey:@"position"];
            [dal updateRecord:dictOfpos forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strIDDes]];
            
            NSString *item = [[arr_tagNew objectAtIndex:sourceIndexPath.section] retain];
            NSString *item1=[[arr_tagNew objectAtIndex:destinationIndexPath.section] retain];
            [arr_tagNew replaceObjectAtIndex:sourceIndexPath.section withObject:[NSString stringWithFormat:@"%@",item1]];
            [arr_tagNew replaceObjectAtIndex:destinationIndexPath.section withObject:[NSString stringWithFormat:@"%@",item]];
            [item1 release];
            [item release];
            
            if(dictOfpos!=nil){
                [dictOfpos release];
                dictOfpos=nil;
            }
            
        }
        else if(sourceIndexPath.row==0 && destinationIndexPath.row==rowsDes){
            
            int postSrc,postDes;
            NSArray *arrScr=[[NSArray alloc] initWithObjects:@"position", nil];
            NSMutableArray *arrscr;
            arrscr=[dal SelectQuery:@"tblMainTask" withColumn:arrScr withCondition:@"mtid=" withColumnValue:[NSString stringWithFormat:@"%@",strIDSrc]];
            postSrc=[[[arrscr objectAtIndex:0] valueForKey:@"position"] intValue];
            arrscr=nil;
            arrscr=[dal SelectQuery:@"tblMainTask" withColumn:arrScr withCondition:@"mtid=" withColumnValue:[NSString stringWithFormat:@"%@",strIDDes]];
            postDes=[[[arrscr objectAtIndex:0] valueForKey:@"position"] intValue];
            
            NSLog(@"%d  %d",postSrc,postDes);
            NSMutableDictionary *dictOfpos=[[NSMutableDictionary alloc] init];
            [dictOfpos setObject:[NSString stringWithFormat:@"%d",postDes] forKey:@"position"];
            [dal updateRecord:dictOfpos forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strIDSrc]];
            [dictOfpos removeAllObjects];
            [dictOfpos setObject:[NSString stringWithFormat:@"%d",postSrc] forKey:@"position"];
            [dal updateRecord:dictOfpos forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strIDDes]];
            
            NSString *item = [[arr_tagNew objectAtIndex:sourceIndexPath.section] retain];
            NSString *item1=[[arr_tagNew objectAtIndex:destinationIndexPath.section] retain];
            NSLog(@"%@",arr_tagNew);
            [arr_tagNew replaceObjectAtIndex:sourceIndexPath.section withObject:[NSString stringWithFormat:@"%@",item1]];
            [arr_tagNew replaceObjectAtIndex:destinationIndexPath.section withObject:[NSString stringWithFormat:@"%@",item]];
            [item1 release];
            [item release];
            NSLog(@"%@",arr_tagNew);
            if(dictOfpos!=nil){
                [dictOfpos release];
                dictOfpos=nil;
            }
        }
        else if(sourceIndexPath.row>=1 && destinationIndexPath.row>=1 && sourceIndexPath.section!=destinationIndexPath.section){
            if([[arr_tagNew objectAtIndex:sourceIndexPath.section] isEqualToString:[arr_tagNew objectAtIndex:destinationIndexPath.section]]) {
                NSArray *arrPos=[[NSArray alloc] initWithObjects:@"position",@"mtid", nil];
                NSString *strep=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",destinationIndexPath.section,destinationIndexPath.row]];
                NSString *strep22=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",sourceIndexPath.section,sourceIndexPath.row]];
                NSLog(@"%@  %@",strep,strep22 );
                NSMutableArray *arrTeop=[[NSMutableArray alloc] init];
                [arrTeop addObject:[dal SelectQuery:@"tblSubTask" withColumn:arrPos withCondition:@"stid=" withColumnValue:[NSString stringWithFormat:@"%@",strep22]]];
                NSLog(@"%@",arrTeop);
                NSString *postSrc=[[[arrTeop objectAtIndex:0] valueForKey:@"position"] objectAtIndex:0] ;
                NSLog(@"%@",postSrc);
                [arrTeop addObject:[dal SelectQuery:@"tblSubTask" withColumn:arrPos withCondition:@"stid=" withColumnValue:[NSString stringWithFormat:@"%@",strep]]];
                NSString * postDes=[[[arrTeop objectAtIndex:1] valueForKey:@"position"]objectAtIndex:0] ;
                NSLog(@"%@",postDes);
                NSMutableDictionary *dictTemp=[[NSMutableDictionary alloc] init];
                [dictTemp setObject:[NSString stringWithFormat:@"%@",postDes] forKey:@"position"];
                [dictTemp setObject:[NSString stringWithFormat:@"%@",strIDDes] forKey:@"mtid"];
                [dal updateRecord:dictTemp forID:@"stid=" inTable:@"tblSubTask" withValue:[NSString stringWithFormat:@"%@",strep22]];
                [dictTemp removeAllObjects];
                [dictTemp setObject:[NSString stringWithFormat:@"%@",postSrc] forKey:@"position"];
                [dal updateRecord:dictTemp forID:@"stid=" inTable:@"tblSubTask" withValue:[NSString stringWithFormat:@"%@",strep]];
                if(dictTemp!=nil){
                    [dictTemp removeAllObjects];
                    [dictTemp release];
                    dictTemp=nil;
                }
                if(arrTeop!=nil){
                    [arrTeop removeAllObjects];
                    [arrTeop release];
                    arrTeop=nil;
                }
                
            }
        }
        else if(sourceIndexPath.section==destinationIndexPath.section && sourceIndexPath.row>0 && destinationIndexPath.row>0 && [[arr_tagNew objectAtIndex:sourceIndexPath.section ] isEqualToString:@"1"]){
            
            NSArray *arrPos=[[NSArray alloc] initWithObjects:@"position",@"mtid", nil];
            NSString *strIDDEs=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",destinationIndexPath.section,destinationIndexPath.row]];
            NSString *StrIDSrc=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",sourceIndexPath.section,sourceIndexPath.row]];
            NSLog(@"%@  %@",StrIDSrc,strIDDEs );
            NSMutableArray *arrTeop=[[NSMutableArray alloc] init];
            [arrTeop addObject:[dal SelectQuery:@"tblSubTask" withColumn:arrPos withCondition:@"stid=" withColumnValue:[NSString stringWithFormat:@"%@",StrIDSrc]]];
            NSLog(@"%@",arrTeop);
            NSString *postSrc=[[[arrTeop objectAtIndex:0] valueForKey:@"position"] objectAtIndex:0] ;
            NSLog(@"%@",postSrc);
            [arrTeop addObject:[dal SelectQuery:@"tblSubTask" withColumn:arrPos withCondition:@"stid=" withColumnValue:[NSString stringWithFormat:@"%@",strIDDEs]]];
            NSString * postDes=[[[arrTeop objectAtIndex:1] valueForKey:@"position"]objectAtIndex:0] ;
            NSLog(@"%@",postDes);
            NSMutableDictionary *dictTemp=[[NSMutableDictionary alloc] init];
            
            [dictTemp setObject:[NSString stringWithFormat:@"%@",postDes] forKey:@"position"];
            [dal updateRecord:dictTemp forID:@"stid=" inTable:@"tblSubTask" withValue:[NSString stringWithFormat:@"%@",StrIDSrc]];
            [dictTemp removeAllObjects];
            [dictTemp setObject:[NSString stringWithFormat:@"%@",postSrc] forKey:@"position"];
            [dal updateRecord:dictTemp forID:@"stid=" inTable:@"tblSubTask" withValue:[NSString stringWithFormat:@"%@",strIDDEs]];
            if(dictTemp!=nil){
                [dictTemp removeAllObjects];
                [dictTemp release];
                dictTemp=nil;
            }
            if(arrTeop!=nil){
                [arrTeop removeAllObjects];
                [arrTeop release];
                arrTeop=nil;
            }

        }
        isOpen=TRUE;
        
        if(isEdit==0){
            [self getAllMainTask];
        }
        else{
            [self getMainTask];
        }
    }
    
    
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
//{
//    return UITableViewCellEditingStyleNone;
//}
#pragma mark Orientation
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        float add=134;
       
        appdel.isLandscape=TRUE;
        
        [self changeColor]; 
        editBtn.frame=CGRectMake(146, 79, 53, 29);
        imgSearch.frame=CGRectMake(143, 44, 216, 35);
        txtSearch.frame=CGRectMake(143+18, 44, 216, 35);
        imgCalList.frame=CGRectMake(125+add, 79, 97, 29);
        btnCal.frame=CGRectMake(172+add, 78, 50, 33);
        btnList.frame=CGRectMake(121+add, 78, 50, 32);
        scroll.frame=CGRectMake(9+add, 110, 224, 585);
        view_cal.frame=CGRectMake(9+add, 110, 224, 585);
        table1.frame=CGRectMake(9+add, 110, 224, 585);
        tblSearch.frame=CGRectMake(9+add, 110, 224, 585);
        imgPaperBG.frame=CGRectMake(230+add, 40, 527, 1000);
        btnOutdent.frame=CGRectMake(533+add, 129, 42, 37);
        btnIndent.frame=CGRectMake(588+add, 129, 42, 37);
        editBtn2.frame=CGRectMake(643+add, 129, 42, 37);
        addBtn.frame=CGRectMake(698+add, 129, 42, 37);
        table2.frame=CGRectMake(249+add, 193, 490, 493);
        lblStatus.frame=CGRectMake(249+add, 173, 46, 21);
        if([appdel.isTaskOrEvent isEqualToString:@"0"]){
            lblPriority.frame=CGRectMake(295+add, 173, 46, 21);
        }
        else{
            lblPriority.frame=CGRectMake(250+add, 200, 43, 21);
        }
        lblCatTitle.frame=CGRectMake(249+add, 130, 279, 35);
        [self setMainTabs];
        [self setButtons];
        [self setActiveButton];
        btnProgress.frame=CGRectMake(5+add, 686, 194, 49);
        btnSync.frame=CGRectMake(197+add, 686, 189, 49);
        btnSettings.frame=CGRectMake(384+add, 686, 189, 49);
        btnInfo.frame=CGRectMake(566+add, 686, 190, 49);
        tblCalendar.frame=CGRectMake(249+add, 220,490, 493);
        lblDay.frame=CGRectMake(312+add, 131, 101, 26);
        lblDate.frame=CGRectMake(247+add, 115, 46, 75);
        lblMonth.frame=CGRectMake(312+add, 154, 128, 30);
        viewCalendarTbl.frame=CGRectMake(249+add, 180, 490, 760);
        if([popover_sync isPopoverVisible])
            [popover_sync presentPopoverFromRect:CGRectMake(240+134,688,100, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
        
        if([popover_progress isPopoverVisible]){
            [popover_progress dismissPopoverAnimated:YES];
            [btnProgress setSelected:NO];
            [self clickOnProgress:nil];
            
            
        }
        MADayView *dayView = (MADayView *) viewCalendarTbl;
        dayView.delegate=self;
        dayView.dataSource=self;
        
    }
    else{
        [self changeColor];
        appdel.isLandscape=FALSE;
        imgFrame.frame=CGRectMake(0, 0, 768, 1004);
        viewCalendarTbl.frame=CGRectMake(249, 180, 490, 760);
        editBtn.frame=CGRectMake(12, 79, 53, 29);
        imgSearch.frame=CGRectMake(9, 44, 216, 35);
        txtSearch.frame=CGRectMake(21, 44, 216, 35);
        imgCalList.frame=CGRectMake(125, 79, 97, 29);
        btnCal.frame=CGRectMake(172, 78, 50, 33);
        btnList.frame=CGRectMake(121, 78, 50, 32);
        scroll.frame=CGRectMake(9, 110, 224, 842);
        view_cal.frame=CGRectMake(9, 110, 224, 842);
        table1.frame=CGRectMake(9, 110, 224, 842);
        tblSearch.frame=CGRectMake(9, 110, 224, 842);
        imgPaperBG.frame=CGRectMake(230, 40, 527, 1000);
        [self setMainTabs];
        //[self setButtons];
        [self setActiveButton];
        btnOutdent.frame=CGRectMake(533, 129, 42, 37);
        btnIndent.frame=CGRectMake(588, 129, 42, 37);
        editBtn2.frame=CGRectMake(643, 129, 42, 37);
        addBtn.frame=CGRectMake(698, 129, 42, 37);
        table2.frame=CGRectMake(249, 193, 490, 760);
        lblStatus.frame=CGRectMake(249, 173, 46, 21);
        
        lblCatTitle.frame=CGRectMake(249, 130, 279, 35);
        
        btnProgress.frame=CGRectMake(7, 944, 194, 49);
        btnSync.frame=CGRectMake(197, 944, 189, 49);
        btnSettings.frame=CGRectMake(384, 944, 189, 49);
        btnInfo.frame=CGRectMake(564, 944, 190, 49);
        if([appdel.isTaskOrEvent isEqualToString:@"0"]){
            lblPriority.frame=CGRectMake(295, 173, 46, 21);
        }
        else{
            lblPriority.frame=CGRectMake(250, 200, 43, 21);
        }
        tblCalendar.frame=CGRectMake(249, 220,490, 760);
        lblDay.frame=CGRectMake(312, 131, 101, 26);
        lblDate.frame=CGRectMake(247, 115, 46, 75);
        lblMonth.frame=CGRectMake(312, 154, 128, 30);
        if([popover_sync isPopoverVisible]){
            [popover_sync presentPopoverFromRect:CGRectMake(240,942,100, 100) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
        
        
        }
        if([popover_progress isPopoverVisible]){
       
        [popover_progress dismissPopoverAnimated:YES];
            [btnProgress setSelected:NO];
            [self clickOnProgress:nil];

        }
        MADayView *dayView = (MADayView *) viewCalendarTbl;
        dayView.delegate=self;
        dayView.dataSource=self;
    }

    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
        return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
   
    
    return YES;
}


#pragma mark ChangeSegment
-(IBAction)cliclList:(id)sender
{
    [self playSoundOnButtonClick];
    isCalendar=FALSE;
    
    imgCalList.image=[UIImage imageNamed:@"listActive.png"];
   
    table1.hidden= FALSE;
    tblCalendar.hidden=YES;
    [table1 reloadData];
    scroll.hidden= TRUE;
    view_cal.hidden = TRUE;
    editBtn.enabled=TRUE;
    
    lblDay.hidden=TRUE;
    lblDate.hidden=TRUE;
    lblMonth.hidden=TRUE;
    lblStatus.hidden=FALSE;
    lblPriority.hidden=FALSE;
    lblCatTitle.hidden=FALSE;
    btnIndent.hidden=FALSE;
    btnOutdent.hidden=FALSE;
    longPress.enabled=YES;
    btnWork.enabled=TRUE;
    btnUrgent.enabled=TRUE;
    btnShopping.enabled=TRUE;
    btnShared.enabled=TRUE;
    btnPersonal.enabled=TRUE;
    btnHealth.enabled=TRUE;
    btnFamily.enabled=TRUE;
    btnFinance.enabled=TRUE;
    table2.alpha=1.0;
   // btnProgress.frame=CGRectMake(9, 944, 154, 48);
    panGesture.enabled=YES;
//    btnMail.frame=CGRectMake(160, 944, 152, 48);
//    btnSync.frame=CGRectMake(309, 944, 152, 48);
//    btnSettings.frame=CGRectMake(456, 944, 154, 48);
//    btnInfo.frame=CGRectMake(597, 944, 170, 48);
    viewCalendarTbl.hidden=TRUE;
    tblCalendar.hidden=TRUE;
    table2.hidden=FALSE;
    int add=0;
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeRight || self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        add=134;
    }
    else{
        add=0;
    }

    lblPriority.frame=CGRectMake(295+add, 173, 43, 21);
    appdel.isTaskOrEvent=@"0";
    dailyView.hidden=TRUE;
        
}
-(IBAction)clickCalendar:(id)sender{
    
    
   
    
//	/* The default is not to autoscroll, so let's override the default here */
	dailyView.hidden=FALSE;
    viewCalendarTbl.hidden=TRUE;
    tblCalendar.hidden=FALSE;
    table2.hidden=TRUE;
    [tblCalendar reloadData];
    [self playSoundOnButtonClick];
    currentDate=[NSDate date];
    [currentDate retain];
    
    appdel.isTaskOrEvent=@"1";
   
   table1.hidden = TRUE;
   viewCalendarTbl.hidden=TRUE;
   [btnProgress bringSubviewToFront:scroll];
   isCalendar=TRUE;
   isCalAdd=FALSE;
	scroll.hidden = FALSE;
	view_cal.hidden = FALSE;
   tblCalendar.hidden=NO;
	scroll.delegate=self;
   //scroll.frame=table1.frame;
   //view_cal.frame=table1.frame;
   editBtn.enabled=FALSE;
   lblDay.hidden=FALSE;
   lblDate.hidden=FALSE;
   table2.alpha=0.0;
   lblMonth.hidden=FALSE;
   lblStatus.hidden=TRUE;
   lblPriority.hidden=FALSE;
    int add=0;
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeRight || self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        add=134;
    }
    else{
        add=0;
    }

    lblPriority.frame=CGRectMake(250+add, 200, 43, 21);
   lblCatTitle.hidden=TRUE;
   btnIndent.hidden=TRUE;
    btnOutdent.hidden=TRUE;
    longPress.enabled=NO;
    panGesture.enabled=NO;
    btnWork.enabled=FALSE;
    btnUrgent.enabled=FALSE;
    btnShopping.enabled=FALSE;
    btnShared.enabled=FALSE;
    btnPersonal.enabled=FALSE;
    btnHealth.enabled=FALSE;
    btnFamily.enabled=FALSE;
    btnFinance.enabled=FALSE;

//    btnProgress.frame=CGRectMake(5, 944, 158, 48);
//    btnMail.frame=CGRectMake(157, 944, 155, 48);
//    btnSync.frame=CGRectMake(307, 944, 155, 48);
//    btnSettings.frame=CGRectMake(454, 944, 160, 48);
//    btnInfo.frame=CGRectMake(603, 944, 160, 48);
    NSDate *yourDate=[NSDate date];
        lblTime.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
        lblDay.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:26];
        lblMonth.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:26];
        lblDate.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:76];
    
        imgCalList.image=[UIImage imageNamed:@"calActive.png"];
       
        calIndex=0;
       
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:yourDate];
   // [comp setDay:1];
    NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:comp];
    NSLog(@"%@",firstDayOfMonthDate);
    
    
    NSDate *curDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange daysRange = 
    [currentCalendar 
     rangeOfUnit:NSDayCalendarUnit 
     inUnit:NSMonthCalendarUnit 
     forDate:curDate];
    
    NSInteger day1=[comp day];
    // daysRange.length will contain the number of the last day
    // of the month containing curDate
    
    NSLog(@"%i", daysRange.length);

		
		float s=7000;
		float h=0;
		float heightSC=0;
		for(int m=0;m<=11;m++){
			TKCalendarMonthView *calendar1=[[TKCalendarMonthView alloc] init];
			calendar1.delegate = self;
			calendar1.dataSource = self;
            
			
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:yourDate];
			NSInteger theDay = [todayComponents day];
			NSInteger theMonth = [todayComponents month];
			NSInteger theYear = [todayComponents year];
			
			// now build a NSDate object for yourDate using these components
			NSDateComponents *components = [[NSDateComponents alloc] init];
			[components setDay:theDay]; 
			[components setMonth:theMonth]; 
			[components setYear:theYear];
			NSDate *thisDate = [gregorian dateFromComponents:components];
			[components release];
			h=calendar1.frame.size.height;
			// now build a NSDate object for the next day
			NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
			[offsetComponents setMonth:-1];
			NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
			//NSLog(@"%@",nextDate);
			[calendar1 selectDate:nextDate];
			s=s-calendar1.frame.size.height;
			UIView *view_c=[[UIView alloc]initWithFrame:CGRectMake(0, s, 224, calendar1.frame.size.height)];
			//NSLog(@"view start is %@",view_c);
			//[self.view addSubview:scroll];
			//[view2 addSubview:calendar1];
			//[scroll addSubview:view2];
			
			//NSLog(@"height is %f",calendar1.frame.size.height);
			
			//NSLog(@"s is %f",s);
			
			
			yourDate=nextDate;
			//CGPoint currentOff = scroll.contentOffset;
			//currentOff.y+=3250*m;
			//[scroll setContentOffset:currentOff animated: YES];
			//scroll.contentSize=CGSizeMake(150, 300+(300*m));
			
			heightSC=heightSC+calendar1.frame.size.height;
			[view_c release];
			[calendar1 release];
			
			
			
		}
		NSLog(@"hellop %f",heightSC);
		yourDate=[NSDate date];
		s=heightSC;
		for(int m=11;m>=0;m--){
			TKCalendarMonthView *calendar1=[[TKCalendarMonthView alloc] init];
			calendar1.delegate = self;
			calendar1.dataSource = self;
			
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:yourDate];
			NSInteger theDay = [todayComponents day];
			NSInteger theMonth = [todayComponents month];
			NSInteger theYear = [todayComponents year];
			
			// now build a NSDate object for yourDate using these components
			NSDateComponents *components = [[NSDateComponents alloc] init];
			[components setDay:theDay]; 
			[components setMonth:theMonth]; 
			[components setYear:theYear];
			NSDate *thisDate = [gregorian dateFromComponents:components];
			[components release];
			h=calendar1.frame.size.height;
			// now build a NSDate object for the next day
			NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
			[offsetComponents setMonth:-1];
			NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
			//NSLog(@"%@",nextDate);
			[calendar1 selectDate:nextDate];
			s=s-calendar1.frame.size.height;
			UIView *view_c=[[UIView alloc]initWithFrame:CGRectMake(0, s, 224, calendar1.frame.size.height
                                                                   )];
			//NSLog(@"view start is %@",view_c);
			[self.view addSubview:scroll];
			[view_c addSubview:calendar1];
			[scroll addSubview:view_c];
			
			//NSLog(@"height is %f",calendar1.frame.size.height);
			
			//NSLog(@"s is %f",s);
			
			
			yourDate=nextDate;
			//CGPoint currentOff = scroll.contentOffset;
			//currentOff.y+=3250*m;
			//[scroll setContentOffset:currentOff animated: YES];
			//scroll.contentSize=CGSizeMake(150, 300+(300*m));
			
			[view_c release];
			[calendar1 release];
			
		}
       

		//NSLog(@"s out is %f",s);
		yourDate=[NSDate date];
		s=heightSC;
		for(int m=11;m<=35;m++){
			TKCalendarMonthView *calendar1=[[TKCalendarMonthView alloc] init];
			calendar1.delegate = self;
			calendar1.dataSource = self;
			
			NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:yourDate];
			NSInteger theDay = [todayComponents day];
			NSInteger theMonth = [todayComponents month];
			NSInteger theYear = [todayComponents year];
            int fla=1;
			if(theDay==1){
                fla=0;
            }
			// now build a NSDate object for yourDate using these components
			NSDateComponents *components = [[NSDateComponents alloc] init];
			[components setDay:theDay]; 
			[components setMonth:theMonth]; 
			[components setYear:theYear];
			NSDate *thisDate = [gregorian dateFromComponents:components];
			[components release];
			
			// now build a NSDate object for the next day
			NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
            if(fla==0){
                [offsetComponents setDay:32];
            }
            else{
			[offsetComponents setMonth:1];
            }
			NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
			//NSLog(@"%@",nextDate);
			if(m==11){
				nextDate=yourDate;
                [scroll setContentOffset:CGPointMake(0, s) animated:YES];
                
				//s=s+calendar1.frame.size.height;
			}
			[calendar1 selectDate:nextDate];
			
			UIView *view_c=[[UIView alloc]initWithFrame:CGRectMake(0, s, 224, calendar1.frame.size.height
                                                                   )]; 
			
            
			s=s+calendar1.frame.size.height;
			
			
			//NSLog(@"calendar is %@",calendar1);
			//NSLog(@"view in 2 is %@",view_c);
			[self.view addSubview:view_c];
			[scroll addSubview:view_c];
			[view_c addSubview:calendar1];
			
			yourDate=nextDate;
			
			//scroll.contentSize=CGSizeMake(150, 300+(300*m));
			[view_c release];
			[calendar1 release];
			
		}
    NSLog(@"%f",s);
    scroll.contentSize=CGSizeMake(150, s);
    //scroll.contentOffset=CGPointMake(0, 0);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    NSInteger year = [components year];
    NSInteger day = [components day];
    NSDateFormatter *weekDay = [[[NSDateFormatter alloc] init] autorelease];
    [weekDay setDateFormat:@"EEEE"];
    NSDateFormatter *calMonth = [[[NSDateFormatter alloc] init] autorelease];
    [calMonth setDateFormat:@"MMMM"];
    if(day<=9){
        lblDay.frame=CGRectMake(285+add, 128, 101, 26);
        lblMonth.frame=CGRectMake(285+add, 154, 200, 30);
    }
    else{
        lblDay.frame=CGRectMake(312+add, 128, 101, 26);
        lblMonth.frame=CGRectMake(312+add, 154, 200, 30);
    }
   
    lblDay.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:26];
    lblDate.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:76];
    lblMonth.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:26];
    lblDay.text=[NSString stringWithFormat:@"%@",[weekDay stringFromDate:[NSDate date]]];
    lblDate.text=[NSString stringWithFormat:@"%i",day];
    lblMonth.text=[NSString stringWithFormat:@"%@ %i",[calMonth stringFromDate:[NSDate date]],year];
     [self getCalendar];
  
}
#pragma mark -
#pragma mark TKCalendarMonthViewDelegate methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //TKCalendarMonthView *calendar=[[TKCalendarMonthView alloc] init];
     appdel.set=touches;
   // calendar.delegate=self;
    //calendar.dataSource=self;
    //[TKCalendarMonthView DragAndDrop1];
   
    
//    NSNotification *notif = [NSNotification notificationWithName:@"pushIt" object:self];
//    [[NSNotificationCenter defaultCenter] postNotification:notif];
   
}
- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d {
	NSLog(@"d is %@",d);
    NSDate *date = d;
    currentDate=d;
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MMM dd, yyy"];
    date = [formatter dateFromString:@"Apr 7, 2011"];
    NSLog(@"%@", [formatter stringFromDate:date]);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:d];
    NSInteger year = [components year];
   // NSInteger month=[components month];       // if necessary
    NSInteger day = [components day];
   // NSInteger weekday = [components weekday]; // if necessary
    
    NSDateFormatter *weekDay = [[[NSDateFormatter alloc] init] autorelease];
    [weekDay setDateFormat:@"EEEE"];
    
    NSDateFormatter *calMonth = [[[NSDateFormatter alloc] init] autorelease];
    [calMonth setDateFormat:@"MMMM"];
    
    
    
    lblDay.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:26];
    
    
    lblDate.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:76];
   
    
    lblMonth.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:26];
    lblDay.text=[NSString stringWithFormat:@"%@",[weekDay stringFromDate:d]];
    lblDate.text=[NSString stringWithFormat:@"%i",day];
    lblMonth.text=[NSString stringWithFormat:@"%@ %i",[calMonth stringFromDate:d],year];
    int add=0;
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        add=134;
        viewCalendarTbl.frame=CGRectMake(249+add, 180, 490, 760);
    }
    else{
        add=0;
         viewCalendarTbl.frame=CGRectMake(249+add, 180, 490, 760);
    }
    if(day<=9){
        lblDate.frame=CGRectMake(247+add, 115, 46, 75);
        lblDay.frame=CGRectMake(285+add, 128, 101, 26);
        lblMonth.frame=CGRectMake(285+add, 154, 200, 30);
       
        
        [lblDate sizeToFit];
    }
    else{
        lblDate.frame=CGRectMake(247+add, 115, 46, 75);
        lblDay.frame=CGRectMake(312+add, 128, 101, 26);
        lblMonth.frame=CGRectMake(312+add, 154, 200, 30);
        
        [lblDate sizeToFit];
        
    }
    if([appdel.isTaskOrEvent isEqualToString:@"1"]){
        [self getCalendar];
    }
    else{
    MADayView *dayView = (MADayView *) viewCalendarTbl;
    
	/* The default is not to autoscroll, so let's override the default here */
	dayView.autoScrollToFirstEvent = YES;
    dayView.delegate=self;
    dayView.dataSource=self;
   
        
    
    }
    [self playSoundOnButtonClick];

    
}
#pragma mark Day view
static NSDate *date = nil;

- (NSArray *)dayView:(MADayView *)dayView eventsForDate:(NSDate *)startDate {
	date = startDate;
    i=0;
    
    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    NSArray *arrThings=[[NSArray alloc] initWithObjects:@"title",@"date",@"datedate",@"priority",@"starttime",@"endtime",@"cid", nil];
    
    arrRetCal=[dal SelectQuery:@"tblCal" withColumn:arrThings withCondition:@"date=" withColumnValue:[NSString stringWithFormat:@"\"%@%@\"",lblDate.text,lblMonth.text]];
    NSLog(@"%@",arrRetCal);
    
    arrayTitle=[[NSMutableArray alloc] init];
    for(int m=0;m<[arrRetCal count];m++){
        [arrayTitle addObject:[[arrRetCal objectAtIndex:m]valueForKey:@"title"]];
        NSArray *arr1 = [NSArray arrayWithObjects: self.event,nil];
        [arr addObjectsFromArray:arr1];
    }
    
    //arrayTitle=[[NSMutableArray alloc] initWithObjects:@"1st thing",@"2nd thing ",@"3rd thing",@"4th  thing",@"5th thing",@"6th thing",@"7th Thing",@"8 thing",@"9 thing", nil];
    
    
	
	static size_t generateAllDayEvents;
	
	generateAllDayEvents++;
	
	if (generateAllDayEvents % 4 == 0) {
//		((MAEvent *) [arr objectAtIndex:0]).title = @"All-day events test";
//		((MAEvent *) [arr objectAtIndex:0]).allDay = YES;
//		
//		((MAEvent *) [arr objectAtIndex:1]).title = @"All-day events Added";
//		((MAEvent *) [arr objectAtIndex:1]).allDay = YES;
	}
	return arr;
}

- (MAEvent *)event {
	
	//static BOOL flag;
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	[dict setObject:[NSString stringWithFormat:@"number %i", i++] forKey:@"test"];
	
	
	 MAEvent *event = [[MAEvent alloc] init];   
    
	if([[[arrRetCal objectAtIndex:i-1] valueForKey:@"starttime"] isEqualToString:@""]){
        event=nil;
    
    }
    else{
        if([[[arrRetCal objectAtIndex:i-1 ] valueForKey:@"priority"] isEqualToString:@"0"]){
            event.backgroundColor=[UIColor redColor];
        }
        else if([[[arrRetCal objectAtIndex:i-1 ] valueForKey:@"priority"] isEqualToString:@"1"]){
            event.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:221.0/255.0 blue:98.0/255.0 alpha:1];
        }
        else if([[[arrRetCal objectAtIndex:i-1 ] valueForKey:@"priority"] isEqualToString:@"2"]){
            event.backgroundColor=[UIColor colorWithRed:0 green:159.0/255.0 blue:0 alpha:1];
        }
        //event.backgroundColor = ((flag = !flag) ? [UIColor purpleColor] : [UIColor brownColor]);
        event.textColor = [UIColor blackColor];
        event.allDay = NO;
        event.userInfo = dict;

        
    NSLog(@"Title array is %@  %d",arrayTitle,i-1);
    event.title=[arrayTitle objectAtIndex:i-1];
	
    NSString *strFin=[[arrRetCal objectAtIndex:i-1] valueForKey:@"starttime"];
    NSLog(@"%@",strFin);
    if(strFin.length>6)
        strFin = [strFin substringToIndex:[strFin length] - 5];
        
        NSLog(@"%@",strFin);
        //NSString *test = [formatter stringFromDate:@""];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateee = [dateFormatter dateFromString:strFin];
    
    
    NSLog(@"Month %@",[dateFormatter dateFromString:strFin]);
    
    
    NSDate *stDate = [NSDate dateWithTimeInterval:0 sinceDate:dateee];
    NSLog(@"%@",stDate);
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    NSDate *endOfWorldWar3 = [gregorian dateByAddingComponents:offsetComponents toDate:stDate options:0];
    NSLog(@"%@", endOfWorldWar3);

  
    
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:stDate];
    NSInteger    hour = [components hour];
    NSLog(@"%d",hour);
	[components setHour:hour];
	[components setMinute:0];
	[components setSecond:0];
	
	event.start = [CURRENT_CALENDAR dateFromComponents:components];
	
	[components setHour:hour+1];
	[components setMinute:0];
	
	event.end = [CURRENT_CALENDAR dateFromComponents:components];
      
	}
	return event;
}

/* Implementation for the MADayViewDelegate protocol */

- (void)dayView:(MADayView *)dayView eventTapped:(MAEvent *)event {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:event.start];
	NSString *eventInfo = [NSString stringWithFormat:@"Hour %i. Userinfo: %@", [components hour], [event.userInfo objectForKey:@"test"]];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:event.title
                                                    message:eventInfo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)d {
	NSLog(@"calendarMonthView monthDidChange");	
}

#pragma mark -
#pragma mark TKCalendarMonthViewDataSource methods

- (NSArray*)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate {	
	//NSLog(@"calendarMonthView marksFromDate toDate");	
	//NSLog(@"Make sure to update 'data' variable to pull from CoreData, website, User Defaults, or some other source.");
	// When testing initially you will have to update the dates in this array so they are visible at the
	// time frame you are testing the code.
	NSArray *data = [NSArray arrayWithObjects:
					 @"1911-01-01 00:00:00 +0000", nil]; 
	
	
	// Initialise empty marks array, this will be populated with TRUE/FALSE in order for each day a marker should be placed on.
	NSMutableArray *marks = [NSMutableArray array];
	
	// Initialise calendar to current type and set the timezone to never have daylight saving
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	// Construct DateComponents based on startDate so the iterating date can be created.
	// Its massively important to do this assigning via the NSCalendar and NSDateComponents because of daylight saving has been removed 
	// with the timezone that was set above. If you just used "startDate" directly (ie, NSDate *date = startDate;) as the first 
	// iterating date then times would go up and down based on daylight savings.
	NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | 
											  NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit) 
									fromDate:startDate];
	NSDate *d = [cal dateFromComponents:comp];
	
	// Init offset components to increment days in the loop by one each time
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setDay:1];	
	
	
	// for each date between start date and end date check if they exist in the data array
	while (YES) {
		// Is the date beyond the last date? If so, exit the loop.
		// NSOrderedDescending = the left value is greater than the right
		if ([d compare:lastDate] == NSOrderedDescending) {
			break;
		}
		
		// If the date is in the data array, add it to the marks array, else don't
		if ([data containsObject:[d description]]) {
			[marks addObject:[NSNumber numberWithBool:NO]];
		} else {
			[marks addObject:[NSNumber numberWithBool:NO]];
		}
		
		// Increment day using offset components (ie, 1 day in this instance)
		d = [cal dateByAddingComponents:offsetComponents toDate:d options:0];
	}
	
	[offsetComponents release];
	
	return [NSArray arrayWithArray:marks];
}


#pragma mark TextFeild Delegate;
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    //tblCalendar.contentOffset=CGPointMake(0, 100);
//    NSLog(@"%d",rowsCnt);
//    if([dic_txt count]>=10){
//        self.table2.frame= CGRectMake(self.table2.frame.origin.x, self.table2.frame.origin.y, self.table2.frame.size.width, self.table2.frame.size.height - 190);
//    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:4];
//    [self.table2 scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//
//    }
    //table2.contentInset =  UIEdgeInsetsMake(0, 0, 250, 0);

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if([dic_txt count]>=10){
//         self.table2.frame= CGRectMake(self.table2.frame.origin.x, self.table2.frame.origin.y, self.table2.frame.size.width, 760);
//        
//    }
    
     //tblCalendar.contentOffset=CGPointMake(0, 0);
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
       
        return YES;
    
    
}
#pragma mark Swipe
-(void)cellSwipeRight:(UIPinchGestureRecognizer *)gesture1
{
    //outdent
    
       CGPoint location = [gesture1 locationInView:table2];
    NSIndexPath *swipedIndexPath = [table2 indexPathForRowAtPoint:location];
    NSLog(@"%d %d",swipedIndexPath.row,swipedIndexPath.section);
    sectionOUt=swipedIndexPath.section;
    //NSLog(@"%@",dictSubTaskID);
    
    if(!swipedIndexPath.row==0 ){
        swipeYES=1;
        
        if(appdel.sound==1){
        NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/schwing04.wav"];
        
        SystemSoundID soundID;
        
        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        
        //Use audio sevices to create the sound
        
        AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
        
        //Use audio services to play the sound
        
        AudioServicesPlaySystemSound(soundID); 
        }
        NSMutableDictionary *dictscid;
        dictscid=[dal executeDataSet:[NSString stringWithFormat:@"select scid from tblMainTask where mtid=%@",[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^0",sectionOUt]]]];
        NSLog(@"%@",dictscid);
        NSString *strscid=[[dictscid valueForKey:@"Table1"] valueForKey:@"scid"];
        NSString *strin=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^%d",swipedIndexPath.section,swipedIndexPath.row]];
        
        NSString *strTitle=[dic_txt valueForKey:[NSString stringWithFormat:@"%d^%d",swipedIndexPath.section,swipedIndexPath.row]];
        NSMutableArray *arr=[[NSMutableArray alloc] initWithObjects:@"status",@"priority", nil];
        NSMutableArray *arrRet;
        arrRet=[dal SelectQuery:@"tblSubTask" withColumn:arr withCondition:@"stid=" withColumnValue:[NSString stringWithFormat:@"%@",strin]];  
        //NSLog(@"%@",arrRet);
        NSString *strStat=[[arrRet objectAtIndex:0] valueForKey:@"status"];
        NSString *strpri=[[arrRet objectAtIndex:0] valueForKey:@"priority"];
        [dal deleteFromTable:@"tblSubTask" WhereField:@"stid=" Condition:[NSString stringWithFormat:@"%@",strin] ];
        NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
        NSMutableDictionary *dictad=[[NSMutableDictionary alloc] init];
        NSMutableDictionary *dictre;
        dictre=   [dal executeDataSet:[NSString stringWithFormat:@"select max(position) from tblMainTask"]];
        
        //NSLog(@"%@",[dictre valueForKey:@"Table1"]);
        //NSLog(@"%@",[[dictre valueForKey:@"Table1"] valueForKey:@"max(position)"]);
        int cnt=[[[dictre valueForKey:@"Table1"]valueForKey:@"max(position)"] intValue];
        [dictad setObject:[NSString stringWithFormat:@"%d",cnt+1] forKey:@"position"];
        
        [dictad setObject:[NSString stringWithFormat:@"%@",strTitle] forKey:@"title"];
        [dictad setObject:[NSString stringWithFormat:@"%@",strStat] forKey:@"status"];
        [dictad setObject:[NSString stringWithFormat:@"%@",strpri ] forKey:@"priority"];
        [dictad setObject:[NSString stringWithFormat:@"%@",strscid] forKey:@"scid"];
        [dictad setObject:[NSString stringWithFormat:@"%@",str_id] forKey:@"userid"];
        [dal insertRecord:dictad inTable:@"tblMainTask"];
        if([[dictForRows valueForKey:[NSString stringWithFormat:@"%d^0",swipedIndexPath.section]]isEqualToString:@"2"])
        {
            [arr_tagNew replaceObjectAtIndex:swipedIndexPath.section withObject:@"0"];
            
        }
        [arr_tagNew addObject:@"0"];
       // NSLog(@"%@",dictForRows);
       // NSLog(@"%@",arr_tagNew);
        if(arr!=nil){
            [arr release];
            arr=nil;
        }
        if(dictad!=nil){
            [dictad removeAllObjects];
            [dictad release];
            dictad=nil;
        }
        isOpen=TRUE;
        if(isEdit==0){
            [self getAllMainTask];
        }
        else{
            [self getMainTask];
        }
        
        
    }
    
    reodered=0;
    
    //Your own code...
}
-(void)swipeRight:(UIPinchGestureRecognizer *)gesture1{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.4];
//    [UIView setAnimationDelay:0.0];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDidStopSelector:@selector(animCompleteHandler:finished:context:)];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
//    [UIView commitAnimations];

    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.4];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//    [UIView setAnimationWillStartSelector:@selector(transitionWillStart:finished:context:)];
//    [UIView setAnimationDidStopSelector:@selector(transitionDidStop:finished:context:)];
//    // other animation properties
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp 
//                           forView:tblCalendar cache:YES];
//    // set view properties
//    [UIView commitAnimations];
    
    if(appdel.sound==1){
        NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/schwing04.wav"];
        
        SystemSoundID soundID;
        
        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        
        //Use audio sevices to create the sound
        
        AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
        
        //Use audio services to play the sound
        
        AudioServicesPlaySystemSound(soundID); 
    }
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:0.5];
    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    animation.type = @"pageUnCurl";
    animation.subtype = @"fromRight";
    animation.fillMode = kCAFillModeForwards;
    // animation.startProgress = 0.35;
    [animation setRemovedOnCompletion:YES];
    [viewCalendarTbl.layer addAnimation:animation forKey:@"pageUnCurlAnimation"]; 
    
    NSLog(@"%@",currentDate);
    NSDate *earlierDate = [currentDate addTimeInterval:-60*24*60];
    NSLog(@"%@",earlierDate);
    currentDate=earlierDate;
    [currentDate retain];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MMM dd, yyy"];
    
    NSLog(@"%@", [formatter stringFromDate:earlierDate]);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:earlierDate];
    NSInteger year = [components year];
    // NSInteger month=[components month];       // if necessary
    NSInteger day = [components day];
    // NSInteger weekday = [components weekday]; // if necessary
    
    NSDateFormatter *weekDay = [[[NSDateFormatter alloc] init] autorelease];
    [weekDay setDateFormat:@"EEEE"];
    
    NSDateFormatter *calMonth = [[[NSDateFormatter alloc] init] autorelease];
    [calMonth setDateFormat:@"MMMM"];
    
    
    
    lblDay.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:26];
    
    
    lblDate.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:76];
    
    
    lblMonth.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:26];
    lblDay.text=[NSString stringWithFormat:@"%@",[weekDay stringFromDate:earlierDate]];
    lblDate.text=[NSString stringWithFormat:@"%i",day];
    lblMonth.text=[NSString stringWithFormat:@"%@ %i",[calMonth stringFromDate:earlierDate],year];
    int add=0;
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        add=134;
    }
    else{
        add=0;
    }
    if(day<=9){
        lblDate.frame=CGRectMake(247+add, 115, 46, 75);
        lblDay.frame=CGRectMake(285+add, 128, 101, 26);
        lblMonth.frame=CGRectMake(285+add, 154, 200, 30);
        
        [lblDate sizeToFit];
    }
    else{
        lblDate.frame=CGRectMake(247+add, 115, 46, 75);
        lblDay.frame=CGRectMake(312+add, 128, 101, 26);
        lblMonth.frame=CGRectMake(312+add, 154, 200, 30);
        [lblDate sizeToFit];
        
    }
    

   
    [self getCalendar];
    

}
-(void)swipeLeft:(UIPinchGestureRecognizer *)gesture1{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.4];
//    [UIView setAnimationDelay:0.0];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDidStopSelector:@selector(animCompleteHandler:finished:context:)];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
//    [UIView commitAnimations];
    if(appdel.sound==1){
        NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/schwing04.wav"];
        
        SystemSoundID soundID;
        
        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        
        //Use audio sevices to create the sound
        
        AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
        
        //Use audio services to play the sound
        
        AudioServicesPlaySystemSound(soundID);  
    }

    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:0.5];
    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    animation.type = @"pageCurl";
    animation.subtype = @"fromRight";
    animation.fillMode = kCAFillModeForwards;
    [animation setRemovedOnCompletion:YES];
    [viewCalendarTbl.layer addAnimation:animation forKey:@"pageCurlAnimation"];  
    
    
    NSDate *earlierDate = [currentDate addTimeInterval:60*24*60];
    NSLog(@"%@",earlierDate);
    currentDate=earlierDate;
    [currentDate retain];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MMM dd, yyy"];
   
    NSLog(@"%@", [formatter stringFromDate:earlierDate]);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:earlierDate];
    NSInteger year = [components year];
    // NSInteger month=[components month];       // if necessary
    NSInteger day = [components day];
    // NSInteger weekday = [components weekday]; // if necessary
    
    NSDateFormatter *weekDay = [[[NSDateFormatter alloc] init] autorelease];
    [weekDay setDateFormat:@"EEEE"];
    
    NSDateFormatter *calMonth = [[[NSDateFormatter alloc] init] autorelease];
    [calMonth setDateFormat:@"MMMM"];
    
    
    
    lblDay.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:26];
    
    
    lblDate.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:76];
    
    
    lblMonth.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:26];
    lblDay.text=[NSString stringWithFormat:@"%@",[weekDay stringFromDate:earlierDate]];
    lblDate.text=[NSString stringWithFormat:@"%i",day];
    lblMonth.text=[NSString stringWithFormat:@"%@ %i",[calMonth stringFromDate:earlierDate],year];
    int add=0;
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        add=134;
    }
    else{
        add=0;
    }
    if(day<=9){
        lblDate.frame=CGRectMake(247+add, 115, 46, 75);
        lblDay.frame=CGRectMake(285+add, 128, 101, 26);
        lblMonth.frame=CGRectMake(285+add, 154, 200, 30);
        
        [lblDate sizeToFit];
    }
    else{
        lblDate.frame=CGRectMake(247+add, 115, 46, 75);
        lblDay.frame=CGRectMake(312+add, 128, 101, 26);
        lblMonth.frame=CGRectMake(312+add, 154, 200, 30);
        [lblDate sizeToFit];
        
    }
   
    
    
   
    [self getCalendar];

}
-(void)cellSwipeLeft:(UIPinchGestureRecognizer *)gesture1
{
    //indent
    
    CGPoint location = [gesture1 locationInView:table2];
    NSIndexPath *swipedIndexPath = [table2 indexPathForRowAtPoint:location];
    int strArrow=[[dictArrow valueForKey:[NSString stringWithFormat:@"%d^0",swipedIndexPath.section]] intValue];
    NSLog(@"%@",dictArrow);
    
   
    NSLog(@"%d %d",swipedIndexPath.row,swipedIndexPath.section);
    sectionOUt=swipedIndexPath.section;
    if(swipedIndexPath.row==0 && swipedIndexPath.section>=1 && strArrow!=1)
    {
        if(appdel.sound==1){
        NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/schwing04.wav"];
        
        SystemSoundID soundID;
        
        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        
        //Use audio sevices to create the sound
        
        AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
        
        //Use audio services to play the sound
        
        AudioServicesPlaySystemSound(soundID);  
        }
        swipeYES=1;
        [arr_tagNew replaceObjectAtIndex:swipedIndexPath.section-1 withObject:@"1"];
        [arr_tagNew removeObjectAtIndex:swipedIndexPath.section];
        NSString *strin=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^0",swipedIndexPath.section]];
        NSString *strUp=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^0",swipedIndexPath.section-1]];
        NSString *strTitle=[dic_txt valueForKey:[NSString stringWithFormat:@"%d^0",swipedIndexPath.section]];
        NSMutableArray *arr=[[NSMutableArray alloc] initWithObjects:@"status",@"priority", nil];
        NSMutableArray *arrRet;
        arrRet=[dal SelectQuery:@"tblMainTask" withColumn:arr withCondition:@"mtid=" withColumnValue:[NSString stringWithFormat:@"%@",strin]];  
        NSLog(@"%@",arr);
        NSString *strStat=[[arrRet objectAtIndex:0] valueForKey:@"status"];
        NSString *strpri=[[arrRet objectAtIndex:0] valueForKey:@"priority"];
        [dal deleteFromTable:@"tblMainTask" WhereField:@"mtid=" Condition:[NSString stringWithFormat:@"%@",strin] ];
         NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
        NSMutableDictionary *dictad=[[NSMutableDictionary alloc] init];
        NSMutableDictionary *dictre;
        dictre=   [dal executeDataSet:[NSString stringWithFormat:@"select max(position) from tblSubTask"]];
        
        NSLog(@"%@",[dictre valueForKey:@"Table1"]);
        NSLog(@"%@",[[dictre valueForKey:@"Table1"] valueForKey:@"max(position)"]);
        int cnt=[[[dictre valueForKey:@"Table1"]valueForKey:@"max(position)"] intValue];
        [dictad setObject:[NSString stringWithFormat:@"%d",cnt+1] forKey:@"position"];
        [dictad setObject:[NSString stringWithFormat:@"%@",strTitle] forKey:@"title"];
        [dictad setObject:[NSString stringWithFormat:@"%@",strStat] forKey:@"status"];
        [dictad setObject:[NSString stringWithFormat:@"%@",strpri ] forKey:@"priority"];
        [dictad setObject:[NSString stringWithFormat:@"%@",strUp] forKey:@"mtid"];
        [dictad setObject:[NSString stringWithFormat:@"%@",str_id] forKey:@"userid"];
        [dal insertRecord:dictad inTable:@"tblSubTask"];
        NSMutableDictionary *dicter=[[NSMutableDictionary alloc] init];
        [dicter setObject:@"1" forKey:@"child"];
        [dal updateRecord:dicter forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strUp]];
        isOpen=TRUE;
        if(isEdit==0){
            [self getAllMainTask];
        }
        else{
            [self getMainTask];
        }
        
        if(arr!=nil){
            [arr release];
            arr=nil;
        }

        if(dictad!=nil){
            [dictad removeAllObjects];
            [dictad release];
            dictad=nil;
        }
        if(dicter!=nil){
            [dicter removeAllObjects];
            [dicter release];
            dicter=nil;
        }
        
        
    }
    
    reodered=0;
    
    //Your own code...
}



#pragma mark Gesture
- (void)handlePanning:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(swipeYES==1){
        [draggedCell removeFromSuperview];
        [draggedCell release];
        draggedCell = nil;
        
        [draggedData release];
        draggedData = nil;
        swipeYES=0;
    }
    //UILongPressGestureRecognizer *LongGest=[[UILongPressGestureRecognizer alloc] init];
    
    else{
       
    switch ([gestureRecognizer state]) {
        case UIGestureRecognizerStateBegan:
            [self startDragging:gestureRecognizer];
            break;
        case UIGestureRecognizerStateChanged:
            [self doDrag:gestureRecognizer];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self stopDragging:gestureRecognizer];
            break;
        default:
            break;
    }
        }
}



- (void)initDraggedCellWithCell:(UITableViewCell*)cell AtPoint:(CGPoint)point indexPath:(NSIndexPath *)indexpath
{
    // get rid of old cell, if it wasn't disposed already
    if(draggedCell != nil)
    {
        [draggedCell removeFromSuperview];
        [draggedCell release];
        draggedCell = nil;
    }
   
    if(gesture==1){
        CGRect frame = CGRectMake(point.x, point.y,200, 35);
        
        draggedCell = [[UITableViewCell alloc] init];
        draggedCell.selectionStyle = UITableViewCellSelectionStyleGray;
        draggedCell.textLabel.text = [arrsubCatTitle objectAtIndex:indexpath.row];
        dragedID=[arrScid objectAtIndex:indexpath.row];
        strMainTaskTitle=[arrsubCatTitle objectAtIndex:indexpath.row];
        draggedCell.textLabel.textColor = cell.textLabel.textColor;
        draggedCell.textLabel.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
        draggedCell.highlighted = YES;
        draggedCell.frame = frame;
        draggedCell.alpha = 0.8;
        
        [self.view addSubview:draggedCell];
    }
    else if(gesture==5){
        CGRect frame = CGRectMake(point.x, point.y,200, 35);
        
        draggedCell = [[UITableViewCell alloc] init];
        draggedCell.selectionStyle = UITableViewCellSelectionStyleGray;
        draggedCell.textLabel.text = [arrTime objectAtIndex:indexpath.row];
        //dragedID=[arrScid objectAtIndex:indexpath.row];
        //strMainTaskTitle=[arrsubCatTitle objectAtIndex:indexpath.row];
       // draggedCell.textLabel.textColor = cell.textLabel.textColor;
        draggedCell.textLabel.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
        draggedCell.highlighted = YES;
        draggedCell.frame = frame;
        draggedCell.alpha = 0.8;
        
        [self.view addSubview:draggedCell];
    }
    else{
   
    CGRect frame = CGRectMake(point.x, point.y,200, 35);
    
    draggedCell = [[UITableViewCell alloc] init];
    draggedCell.selectionStyle = UITableViewCellSelectionStyleGray;
    draggedCell.textLabel.text = [dic_txt valueForKey:[NSString stringWithFormat:@"%d^0",indexpath.section]];
    dragedID=[dictSubTaskID valueForKey:[NSString stringWithFormat:@"%d^0",indexpath.section]];
    strMainTaskTitle=[dic_txt valueForKey:[NSString stringWithFormat:@"%d^0",indexpath.section]];
    draggedCell.textLabel.textColor = cell.textLabel.textColor;
    draggedCell.textLabel.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
    draggedCell.highlighted = YES;
    draggedCell.frame = frame;
    draggedCell.alpha = 0.8;
    
    [self.view addSubview:draggedCell];
    }
}
#pragma mark -
#pragma mark Helper methods for dragging

- (void)startDragging:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint pointInSrc = [gestureRecognizer locationInView:table2];
    CGPoint pointInDst = [gestureRecognizer locationInView:table1];
    //CGPoint pointinCal=[gestureRecognizer locationInView:tblCalendar];
     pointinTable=[gestureRecognizer locationInView:table1];
    NSLog(@"pint in start %f",pointinTable.x);
    NSLog(@"point in start%f",pointinTable.y);
//    if([tblCalendar pointInside:pointinCal withEvent:nil]){
//        gesture=5;
//        [self startDraggingFromSrcAtPoint:pointinCal];
//        dragFromSource=YES;
//    }
//    else 
    if([table2 pointInside:pointInSrc withEvent:nil])
    {
        gesture=0;
        [self startDraggingFromSrcAtPoint:pointInSrc];
        dragFromSource = YES;
    }
    else if([table1 pointInside:pointinTable withEvent:nil]){
        gesture=1;
        [self startDraggingFromSrcAtPoint:pointinTable];
        dragFromSource = YES;
    }
    else if([table1 pointInside:pointInDst withEvent:nil])
    {
        gesture=0;
        [self startDraggingFromDstAtPoint:pointInDst];
        dragFromSource = NO;
    }
    
}

- (void)startDraggingFromSrcAtPoint:(CGPoint)point 
{
    NSIndexPath* indexPath;
    UITableViewCell* cell;
    if(gesture==1){
        indexPath = [table1 indexPathForRowAtPoint:point];
        cell = [table1 cellForRowAtIndexPath:indexPath];
        dragedID=[arrScid objectAtIndex:indexPath.row];
        NSArray *arrUID=[[NSArray alloc] initWithObjects:@"userid", nil];
        NSMutableArray *arrret;
        
        arrret=[dal SelectQuery:@"tblSubCat" withColumn:arrUID withCondition:@"scid=" withColumnValue:[NSString stringWithFormat:@"%@",dragedID]];
        NSLog(@"%@",[[arrret objectAtIndex:0] valueForKey:@"userid"]);
        int temp=[[[arrret objectAtIndex:0] valueForKey:@"userid"] intValue];
        if(cell != nil && indexPath.row!=0 )
        {
            if(temp!=0 ){
            CGPoint origin = cell.frame.origin;
            origin.x += table1.frame.origin.x;
            origin.y += table1.frame.origin.y;
            
            [self initDraggedCellWithCell:cell AtPoint:origin indexPath:indexPath];
            cell.highlighted = NO;
            
            if(draggedData != nil)
            {
                [draggedData release];
                draggedData = nil;
            }
            draggedData = [[arrsubCatTitle objectAtIndex:indexPath.row] retain];
        }
    }
    }
    else if(gesture==5){
        indexPath = [tblCalendar indexPathForRowAtPoint:point];
        cell = [tblCalendar cellForRowAtIndexPath:indexPath];
        if(cell != nil  )
        {
            
                CGPoint origin = cell.frame.origin;
                origin.x += tblCalendar.frame.origin.x;
                origin.y += tblCalendar.frame.origin.y;
                
                [self initDraggedCellWithCell:cell AtPoint:origin indexPath:indexPath];
                cell.highlighted = NO;
                
                if(draggedData != nil)
                {
                    [draggedData release];
                    draggedData = nil;
                }
                draggedData = [[arrTime objectAtIndex:indexPath.row] retain];
            }
    }
    else{
        
        indexPath = [table2 indexPathForRowAtPoint:point];
        cell = [table2 cellForRowAtIndexPath:indexPath];
        if(cell != nil && indexPath.row==0)
        {
            CGPoint origin = cell.frame.origin;
            origin.x += table2.frame.origin.x;
            origin.y += table2.frame.origin.y;
            [self initDraggedCellWithCell:cell AtPoint:origin indexPath:indexPath];
            //[self initDraggedCellWithCell:cell AtPoint:origin];
            cell.highlighted = NO;
            
            if(draggedData != nil)
            {
                [draggedData release];
                draggedData = nil;
            }
            draggedData = [[srcData objectAtIndex:indexPath.row] retain];
        }
    }
    
}

- (void)startDraggingFromDstAtPoint:(CGPoint)point
{
    NSIndexPath* indexPath = [table1 indexPathForRowAtPoint:point];
    UITableViewCell* cell = [table1 cellForRowAtIndexPath:indexPath];
    if(cell != nil)
    {
        CGPoint origin = cell.frame.origin;
        origin.x += dropArea.frame.origin.x;
        origin.y += dropArea.frame.origin.y;
        
        [self initDraggedCellWithCell:cell AtPoint:origin];
        cell.highlighted = NO;
        
        if(draggedData != nil)
        {
            [draggedData release];
            draggedData = nil;
        }
        draggedData = [[dstData objectAtIndex:indexPath.row] retain];
        
        // remove old cell
        [dstData removeObjectAtIndex:indexPath.row];
        [table1 deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        pathFromDstTable = [indexPath retain];
        
        [UIView animateWithDuration:0.2 animations:^
         {
             CGRect frame = table1.frame;
             frame.size.height = kCellHeight * [dstData count];
             table1.frame = frame;
         }];
        
    }
}

- (void)doDrag:(UIPanGestureRecognizer *)gestureRecognizer
{
    if(draggedCell != nil && draggedData != nil)
    {
        //CGPoint translation = [gestureRecognizer translationInView:[draggedCell superview]];
        //[draggedCell setCenter:CGPointMake([draggedCell center].x + translation.x,
                                          // [draggedCell center].y + translation.y)];
         [draggedCell setCenter:[gestureRecognizer locationInView:self.view.superview]];
        //[gestureRecognizer setTranslation:CGPointZero inView:[draggedCell superview]];
        
    }
}

- (void)stopDragging:(UIPanGestureRecognizer *)gestureRecognizer
{
   
    
    CGPoint p = [gestureRecognizer locationInView:self.view];
    NSLog(@"%f",p.x);
    NSLog(@"%f",p.y);
    if(gesture==1 && p.y<20){
            if( dragedID ){
            NSMutableDictionary *dictSt=[[NSMutableDictionary alloc] init];
            if(p.x<btnWork.frame.origin.x+67 && p.x>=btnWork.frame.origin.x){
                [dictSt setObject:@"1" forKey:@"mcid"];
                
                [dal updateRecord:dictSt forID:@"scid=" inTable:@"tblSubCat" withValue:[NSString stringWithFormat:@"%@",dragedID]];
            }
            else if(p.x<btnPersonal.frame.origin.x+67 && p.x>=btnPersonal.frame.origin.x){
                [dictSt setObject:@"4" forKey:@"mcid"];
                
                [dal updateRecord:dictSt forID:@"scid=" inTable:@"tblSubCat" withValue:[NSString stringWithFormat:@"%@",dragedID]];
            }
            else if(p.x<btnFamily.frame.origin.x+67 && p.x>=btnFamily.frame.origin.x){
                [dictSt setObject:@"2" forKey:@"mcid"];
                
                [dal updateRecord:dictSt forID:@"scid=" inTable:@"tblSubCat" withValue:[NSString stringWithFormat:@"%@",dragedID]];
            }
            else if(p.x<btnHealth.frame.origin.x+67 && p.x>=btnHealth.frame.origin.x){
                [dictSt setObject:@"3" forKey:@"mcid"];
                
                [dal updateRecord:dictSt forID:@"scid=" inTable:@"tblSubCat" withValue:[NSString stringWithFormat:@"%@",dragedID]];
            }
            else if(p.x<btnFinance.frame.origin.x+67 && p.x>=btnFinance.frame.origin.x){
                [dictSt setObject:@"5" forKey:@"mcid"];
                
                [dal updateRecord:dictSt forID:@"scid=" inTable:@"tblSubCat" withValue:[NSString stringWithFormat:@"%@",dragedID]];
            }
            else if(p.x<btnShared.frame.origin.x+67 && p.x>=btnShared.frame.origin.x){
                [dictSt setObject:@"6" forKey:@"mcid"];
                
                [dal updateRecord:dictSt forID:@"scid=" inTable:@"tblSubCat" withValue:[NSString stringWithFormat:@"%@",dragedID]];
            }
            else if(p.x<btnUrgent.frame.origin.x+67 && p.x>=btnUrgent.frame.origin.x){
                [dictSt setObject:@"7" forKey:@"mcid"];
                
                [dal updateRecord:dictSt forID:@"scid=" inTable:@"tblSubCat" withValue:[NSString stringWithFormat:@"%@",dragedID]];
            }
            else if(p.x<btnShopping.frame.origin.x+67 && p.x>=btnShopping.frame.origin.x){
                [dictSt setObject:@"8" forKey:@"mcid"];
                
                [dal updateRecord:dictSt forID:@"scid=" inTable:@"tblSubCat" withValue:[NSString stringWithFormat:@"%@",dragedID]];
            }
        [self getSubCat];
        if(dictSt!=nil){
            [dictSt release];
            dictSt=nil;
        }
        
        
    }}
    else{
    if(p.x>0 && p.x<127 && p.y>18 && pointinTable.x>224 ){
   
    NSIndexPath *indexPath = [table1 indexPathForRowAtPoint:p];
    NSLog(@"%@",indexPath);
    NSLog(@"%d section",indexPath.section);
    NSLog(@"%d row",indexPath.row);
   
    NSMutableDictionary *dictadd=[[NSMutableDictionary alloc] init];
     //NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
//    [dictadd setObject:[NSString stringWithFormat:@"%@",strMainTaskTitle] forKey:@"titleCat"];
//    [dictadd setObject:[NSString stringWithFormat:@"%d",[arrsubCatTitle count]] forKey:@"postionCat"];
//    [dictadd setObject:[NSString stringWithFormat:@"%@",str_id] forKey:@"userid"];
//        
//    [dictadd setObject:[NSString stringWithFormat:@"%@",appdel.str_mcid] forKey:@"mcid"];
//       
//        [dal insertRecord:dictadd inTable:@"tblSubCat"];
//        if(dictadd!=nil){
//            [dictadd removeAllObjects];
//            [dictadd release];
//            dictadd=nil;
//        }
        NSLog(@"%@",arrScid);
       [dictadd setObject:[NSString stringWithFormat:@"%@",[arrScid objectAtIndex:indexPath.row]] forKey:@"scid"];

        [dal updateRecord:dictadd forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",dragedID]];
        [self getSubCat];
        isOpen=TRUE;
        if(isEdit==0){
            [self getAllMainTask];
        }
        else{
            [self getMainTask];
        }
        
    if (indexPath == nil)
        NSLog(@"long press on table view but not on a row");
    else
        NSLog(@"long press on table view at row %d", indexPath.row);

    }
    else if(gesture==0 && p.y<20){
        
        NSMutableDictionary *dictSt=[[NSMutableDictionary alloc] init];
        if(p.x<btnWork.frame.origin.x+67 && p.x>=btnWork.frame.origin.x ){
            [dictSt setObject:@"1" forKey:@"scid"];
            
            [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",dragedID]];
        }
        else if(p.x<btnPersonal.frame.origin.x+67 && p.x>=btnPersonal.frame.origin.x){
            [dictSt setObject:@"6" forKey:@"scid"];
            
            [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",dragedID]];
        }
        else if(p.x<btnFamily.frame.origin.x+67 && p.x>=btnFamily.frame.origin.x){
            [dictSt setObject:@"12" forKey:@"scid"];
            
            [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",dragedID]];
        }
        else if(p.x<btnHealth.frame.origin.x+67 && p.x>=btnHealth.frame.origin.x){
            [dictSt setObject:@"15" forKey:@"scid"];
            
            [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",dragedID]];
        }
        else if(p.x<btnFinance.frame.origin.x+67 && p.x>=btnFinance.frame.origin.x){
            [dictSt setObject:@"20" forKey:@"scid"];
            
            [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",dragedID]];
        }
        else if(p.x<btnShared.frame.origin.x+67 && p.x>=btnShared.frame.origin.x){
            [dictSt setObject:@"26" forKey:@"scid"];
            
            [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",dragedID]];
        }
        else if(p.x<btnUrgent.frame.origin.x+67 && p.x>=btnUrgent.frame.origin.x){
            [dictSt setObject:@"27" forKey:@"scid"];
            
            [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",dragedID]];
        }
        else if(p.x<btnShopping.frame.origin.x+67 && p.x>=btnShopping.frame.origin.x){
            [dictSt setObject:@"28" forKey:@"scid"];
            
            [dal updateRecord:dictSt forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",dragedID]];
        }
        if(isEdit==0){
            [self getAllMainTask];
        }
        else{
            [self getMainTask];
        }
        if(dictSt!=nil){
            [dictSt release];
            dictSt=nil;
        }
    }
        [self getCount];
    
//    if(gesture==1){
//        dropArea=[[UIView alloc] initWithFrame:table1.frame];
//    }
//    else{
//        dropArea=[[UIView alloc] initWithFrame:table1.frame];
//    }
//   
    
   // if(draggedCell != nil && draggedData != nil)
//    {
//        if([gestureRecognizer state] == UIGestureRecognizerStateEnded
//           && [dropArea pointInside:[gestureRecognizer locationInView:dropArea] withEvent:nil])
//        {      
//            
//            NSIndexPath* indexPath = [table1 indexPathForRowAtPoint:[gestureRecognizer locationInView:table1]];
//            if(indexPath != nil)
//            {
//                NSLog(@"%d",indexPath.row);
//                UITableViewCell *cell = [table1 cellForRowAtIndexPath:indexPath];
//                cell.selectionStyle = UITableViewCellSelectionStyleGray;
//                [table1 selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//                
//                //[dstData insertObject:draggedData atIndex:indexPath.row];
//                //[table1 insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
//            }
//            else
//            {
//                //[dstData addObject:draggedData];
//                //[table1 reloadData];
//            }
//        }
//        else if(!dragFromSource && pathFromDstTable != nil)
//        {
//            // insert cell back where it came from
//            [dstData insertObject:draggedData atIndex:pathFromDstTable.row];
//            [table1 insertRowsAtIndexPaths:[NSArray arrayWithObject:pathFromDstTable] withRowAnimation:UITableViewRowAnimationMiddle];
//            
//            [pathFromDstTable release];
//            pathFromDstTable = nil;
//        }
//        
//        
//    }
}
    [UIView animateWithDuration:0.3 animations:^
     {
         //CGRect frame = table1.frame;
         //frame.size.height = kCellHeight * [dstData count];
         //table1.frame = frame;
     }];
    
    [draggedCell removeFromSuperview];
    [draggedCell release];
    draggedCell = nil;
    
    [draggedData release];
    draggedData = nil;
    }
-(void)playSoundOnButtonClick{
    if(appdel.sound==1){
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/smooth_button_click02.wav"];
   
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    //Use audio sevices to create the sound
    
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    
    //Use audio services to play the sound
    
    AudioServicesPlaySystemSound(soundID); 
    }
}
-(void)playSoundOnStatusPrio{
    if(appdel.sound==1){
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/smooth_button_click04.wav"];
    
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    //Use audio sevices to create the sound
    
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    
    //Use audio services to play the sound
    
    AudioServicesPlaySystemSound(soundID);  
    }
}
-(void)memoryRelease{
    if(appdel.sound==1){
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/smooth_button_click01.wav"];
    
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    //Use audio sevices to create the sound
    
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    
    //Use audio services to play the sound
    
    AudioServicesPlaySystemSound(soundID);
    }
    tblSearch.hidden=TRUE;
    table1.hidden=FALSE;
    [arr_maintask removeAllObjects];
    [arrayOfSection removeAllObjects];
    [dic_txt removeAllObjects];
    [dictForRows removeAllObjects];
    [arr_tagNew removeAllObjects];
    [dic_image removeAllObjects];
    [dic_priorityimage removeAllObjects];        
    [arrSuBTaskID removeAllObjects];
    [dictSubTaskID removeAllObjects];
    [arrSuBTaskID removeAllObjects];
    [dictArrow removeAllObjects];
    [dictMainTask removeAllObjects];

}
- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] autorelease];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
	bgImageName = @"popoverBg.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 13; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13 
	bgCapSize = 31; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin = bgMargin;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin = contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = contentMargin; 
	props.bottomContentMargin = contentMargin;
	
	props.arrowMargin = 4.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;	
}
-(void)setButtons{
    int x=233;
    int y=44;
    int width=68;
    int height=67;
    if(self.interfaceOrientation==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        x=x+134;
    }
    else{
        x=233;
    }
    NSLog(@"%@",arrtab);
    for(int p=0;p<[arrtab count];p++){
    
    if([[arrtab objectAtIndex:p] isEqualToString:@"Work"] && ![lblCatTitle.text isEqualToString:@"All Works"] ){
        btnWork.frame=CGRectMake(x, y, width, height);
        //lblWork.frame=CGRectMake(height, 52, 20, 21);
        //lblWork.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
       [btnWork setBackgroundImage:[UIImage imageNamed:@"workM.png"] forState:UIControlStateNormal];
        
       
        
        
        
    }
    else if([[arrtab objectAtIndex:p] isEqualToString:@"Personal"] && ![lblCatTitle.text isEqualToString:@"All Personal"]){
        btnPersonal.frame=CGRectMake(x, y, width, height);
        //lblPersonal.frame=CGRectMake(height, 52, 20, 21);
        //lblPersonal.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
        [btnPersonal setBackgroundImage:[UIImage imageNamed:@"personalM.png"] forState:UIControlStateNormal];
       
        
        
    }
    else if([[arrtab objectAtIndex:p] isEqualToString:@"Family"] && ![lblCatTitle.text isEqualToString:@"All Family"]){
        btnFamily.frame=CGRectMake(x, y, width, height);
       
        //lblFamily.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
        [btnFamily setBackgroundImage:[UIImage imageNamed:@"familyM.png"] forState:UIControlStateNormal];
         
        
        
        
    }
    else if([[arrtab objectAtIndex:p] isEqualToString:@"Health"] && ![lblCatTitle.text isEqualToString:@"All Health"]){
        btnHealth.frame=CGRectMake(x, y, width, height);
       // lblHealth.frame=CGRectMake(height, 52, 20, 21);
       // lblHealth.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
        [btnHealth setBackgroundImage:[UIImage imageNamed:@"healthM.png"] forState:UIControlStateNormal];
       
        
    }
    else if([[arrtab objectAtIndex:p] isEqualToString:@"Finance"] && ![lblCatTitle.text isEqualToString:@"All Finance"]){
        btnFinance.frame=CGRectMake(x, y, width, height);
       
        //lblFinance.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
        [btnFinance setBackgroundImage:[UIImage imageNamed:@"financeM.png"] forState:UIControlStateNormal];
      
        
    }
    else if([[arrtab objectAtIndex:p] isEqualToString:@"Shared"] && ![lblCatTitle.text isEqualToString:@"All Shared"]){
        btnShared.frame=CGRectMake(x, y, width, height);
       // lblShared.frame=CGRectMake(height,52, 20, 21);
        //lblShared.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
        [btnShared setBackgroundImage:[UIImage imageNamed:@"sharedM.png"] forState:UIControlStateNormal];
              
        
    }
    else if([[arrtab objectAtIndex:p] isEqualToString:@"Urgent"] && ![lblCatTitle.text isEqualToString:@"All Urgent"]){
        btnUrgent.frame=CGRectMake(x, y, width, height);
       
        //lblUrgent.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
        [btnUrgent setBackgroundImage:[UIImage imageNamed:@"urgentM.png"] forState:UIControlStateNormal];
       
        
        
    }
    else if([[arrtab objectAtIndex:p] isEqualToString:@"Shopping"] && ![lblCatTitle.text isEqualToString:@"All Shopping"]){
        btnShopping.frame=CGRectMake(x, y, width, height);
        
        //lblShopping.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:18];
        [btnShopping setBackgroundImage:[UIImage imageNamed:@"shoppingM.png"] forState:UIControlStateNormal];
        
    }
    else{
        
    }
    x=x+66;  
    // height=height+68;
    
}

}
-(void)setActiveButton{
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Work"] && [appdel.str_mcid isEqualToString:@"1"]){
            //[btnWork setFrame:CGRectMake(btnWork.frame.origin.x+15, 65, 35, 45)];
            [btnWork setFrame:CGRectMake(btnWork.frame.origin.x+15, 60, 35, 45)];
            [btnWork setBackgroundImage:[UIImage imageNamed:@"Work-Active-.png"] forState:UIControlStateNormal];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Family"] && [appdel.str_mcid isEqualToString:@"2"]){
            NSLog(@"%d",233+aa*68+15);
            [btnFamily setFrame:CGRectMake(btnFamily.frame.origin.x+15, 60, 35, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Personal"]&& [appdel.str_mcid isEqualToString:@"4"]){
            [btnPersonal setFrame:CGRectMake(btnPersonal.frame.origin.x+15, 60, 35, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Health"] && [appdel.str_mcid isEqualToString:@"3"]){
            [btnHealth setFrame:CGRectMake(btnHealth.frame.origin.x+15, 60, 35, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }
    
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Finance"]&& [appdel.str_mcid isEqualToString:@"5"]){
            [btnFinance setFrame:CGRectMake(btnFinance.frame.origin.x+15, 60, 35, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Shared"] && [appdel.str_mcid isEqualToString:@"6"]){
            [btnShared setFrame:CGRectMake(btnShared.frame.origin.x+15, 60, 35, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }
    
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Urgent"] && [appdel.str_mcid isEqualToString:@"7"]){
            [btnUrgent setFrame:CGRectMake(btnUrgent.frame.origin.x+15, 60, 35, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }
    for(int aa=1;aa<=[arrtab count];aa++){
        if([[arrtab objectAtIndex:aa-1] isEqualToString:@"Shopping"] && [appdel.str_mcid isEqualToString:@"8"]){
            [btnShopping setFrame:CGRectMake(btnShopping.frame.origin.x+15, 60, 35, 45)];
            NSLog(@"value of aa is %d",aa);
            if(aa==1){
                //set only left img
                [self setLeftImgOnly:aa];
            }
            else if(aa==8){
                //set only left img
                [self setRightImgOnly:aa-2];
            }
            else{
                //set both
                [self setLeftImgOnly:aa];
                [self setRightImgOnly:aa-2];
            }
        }
    }

}
#pragma mark memory dealloc

// Override to allow orientations other than the default portrait orientation.

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    
   category_cell=nil;
    view_cal=nil;
	table1=nil;
	table2=nil;
   editBtn=nil;
	
   btnWork=nil;
   btnPersonal=nil;
   btnFamily=nil;
   btnHealth=nil;
   btnFinance=nil;
   btnShared=nil;
   btnUrgent=nil;
   btnShopping=nil;
   tbl2Cell=nil;
   
	statusBtn=nil;
	priorityBtn=nil;
	addBtn=nil;
   editBtn2=nil;
	
	scroll=nil;
	txt=nil;
    txt_category=nil;
   btnShrink=nil;
   lblWork=nil;
   lblPersonal=nil;
   lblFamily=nil;
   lblHealth=nil;
   lblFinance=nil;
   lblShared=nil;
   lblUrgent=nil;
   lblShopping=nil;
   lblPriority=nil;
   lblStatus=nil;
   
    btnProgress=nil;
  btnMail=nil;
  btnSettings=nil;
  btnInfo=nil;
  btnSync=nil;
   lblCatTitle=nil;
   
  cellCalendar=nil;
    lblTime=nil;
   txtTask=nil;
   lblDate=nil;
   lblDay=nil;
   lblMonth=nil;
   tblCalendar=nil;
   btnIndent=nil;
   btnOutdent=nil;
   
   imgCalList=nil;
   btnCal=nil;
   btnList=nil;
   btnLoca=nil;
   
  tblSearch=nil;
   txtSearch=nil;
    viewCalendarTbl=nil;
    imgFrame=nil;
    
}
- (void)dealloc {
	
	if (feedPostId != nil) {
		[feedPostId release];
	}
	[fbGraph release];
    [category_cell release];
    [view_cal release];
	[table1 release];
	[table2 release];
    [editBtn release];
	
    [btnWork release];
    [btnPersonal release];
    [btnFamily release];
    [btnHealth release];
    [btnFinance release];
    [btnShared release];
    [btnUrgent release];
    [btnShopping release];
    [tbl2Cell release];
   	[statusBtn release];
	[priorityBtn release];
	[addBtn release];
    [editBtn2 release];
    [scroll release];
	[txt release];
    [txt_category release];
    [btnShrink release];
    [lblWork release];
    [lblPersonal release];
    [lblFamily release];
    [lblHealth release];
    [lblFinance release];
    [lblShared release];
    [lblUrgent release];
    [lblShopping release];
    [lblPriority release];
    [lblStatus release];
    [btnProgress release];
    [btnMail release];
    [btnSettings release];
    [btnInfo release];
    [btnSync release];
    [lblCatTitle release];
    
    [cellCalendar release];
    [lblTime release];
    [txtTask release];
    [lblDate release];
    [lblDay release];
    [lblMonth release];
    [tblCalendar release];
    [btnIndent release];
    [btnOutdent release];
    
    [imgCalList  release];
    [btnCal  release];
    [btnList  release];
    [btnLoca  release];
    
    [tblSearch  release];
    [txtSearch  release];
   [viewCalendarTbl  release];
    [txtmainfld release];
    [imgFrame release];
    [super dealloc];
}


@end

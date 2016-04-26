//
//  Settings.m
//  PlannerApp
//
//  Created by Openxcell on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"
#import "SyncSubView.h"
#import "PlannerAppAppDelegate.h"
#import "LocationsAlerts.h"
#import "LoginPage.h"
#import "AddNewLocation.h"
#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"
#import "GMGridViewLayoutStrategies.h"
#import "OptionsViewController.h"
#import "OptionsViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GDataFeedCalendar.h"
#import "GDataWhen.h"
#import "GDataWhere.h"
@interface Settings () <GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewTransformationDelegate>
{
    __gm_weak GMGridView *_gmGridView1;
    __gm_weak GMGridView *_gmGridView2;
    
    __gm_weak UIButton *_buttonOptionsGrid1;
    __gm_weak UIButton *_buttonOptionsGrid2;
    
    UIPopoverController *_popOverController;
    UIViewController *_optionsController1;
    UIViewController *_optionsController2;
}

- (void)computeViewFrames;
- (void)showOptionsFromButton:(UIButton *)button;
- (void)optionsDoneAction;

@end

@implementation Settings
@synthesize googleCalendarService;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
       
        index=0;
        section=0;
        datacntsec=0;
        arrFinalData=[[NSMutableArray alloc] init];
        googleCalendarService = [[GDataServiceGoogleCalendar alloc] init];
        [googleCalendarService setUserAgent:@"Planner"];
        data = [[NSMutableArray alloc] init];
        if(appdel.sound==1)
            [btnSound setSelected:NO];
        else
            [btnSound setSelected:YES];
        arrName=[[NSMutableArray alloc] init];
        arrTab=[[NSMutableArray alloc] init];
        arrName= [[NSUserDefaults standardUserDefaults] objectForKey:@"tab"];
        NSLog(@"%@",arrName);
        arrTabName=[[NSMutableArray alloc] init];
        for(int i=0;i<[arrName count];i++){
            if([[arrName objectAtIndex:i] isEqualToString:@"Work"]){
                [arrTab addObject:@"Work.png"];
                [arrTabName addObject:[arrName objectAtIndex:i]];
                
            }
            else if([[arrName objectAtIndex:i] isEqualToString:@"Personal"]){
                [arrTab addObject:@"Personal.png"];
                [arrTabName addObject:[arrName objectAtIndex:i]];
                
            }
            else if([[arrName objectAtIndex:i] isEqualToString:@"Family"]){
                [arrTab addObject:@"Family.png"];
                [arrTabName addObject:[arrName objectAtIndex:i]];
                
            }
            else if([[arrName objectAtIndex:i] isEqualToString:@"Health"]){
                [arrTab addObject:@"Healt.png"];
                [arrTabName addObject:[arrName objectAtIndex:i]];
                
            }
            else if([[arrName objectAtIndex:i] isEqualToString:@"Finance"]){
                [arrTab addObject:@"Finance.png"];
                [arrTabName addObject:[arrName objectAtIndex:i]];
                
            }
            else if([[arrName objectAtIndex:i] isEqualToString:@"Shared"]){
                [arrTab addObject:@"Shared.png"];
                [arrTabName addObject:[arrName objectAtIndex:i]];
                
            }
            else if([[arrName objectAtIndex:i] isEqualToString:@"Urgent"]){
                [arrTab addObject:@"Urgent.png"];
                [arrTabName addObject:[arrName objectAtIndex:i]];
                
            }
            else if([[arrName objectAtIndex:i] isEqualToString:@"Shopping"]){
                [arrTab addObject:@"Shopping.png"];
                [arrTabName addObject:[arrName objectAtIndex:i]];
                
            }
            
        }

               
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
    //    
    //    _gmGridView1.sortingDelegate   = self;
    //    _gmGridView1.transformDelegate = self;
    //    _gmGridView1.dataSource = self;
    self.title=@"Settings";
    
    self.contentSizeForViewInPopover=CGSizeMake(678, 780);
    
    _gmGridView2.sortingDelegate   = self;
    _gmGridView2.transformDelegate = self;
    _gmGridView2.dataSource = self;
    
       
    // _gmGridView1.mainSuperView = self.navigationController.view;
    _gmGridView2.mainSuperView = self.navigationController.view;
    
     
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication]delegate ];
    
    [googleCalendarService setUserCredentialsWithUsername:appdel.username
                                                 password:appdel.password]; 
    self.navigationController.navigationBarHidden=TRUE;
    tblLocation.hidden=TRUE;
    arrLoc=[[NSMutableArray alloc] initWithObjects:@"Location 1",@"Location 2",@"Location 3",@"Location 4",@"Location 5", nil];
    lblSelLoc.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
    lblColr.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
  
    lblLocationAlert.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
    lblSorting.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
    lblSettings.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:24];
    lbltab.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
    lblPush.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
    lblSync.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];

  
   
    
    UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    [doubleTap release];
    isNoti=YES;
    
    NSString *strColor=[[NSUserDefaults standardUserDefaults]valueForKey:@"color"];
    if([strColor isEqualToString:@"yellow"]){
        [btnYellow setSelected:YES];
        [btnBlue setSelected:NO];
        [btnBlack setSelected:NO];
        [btnPink setSelected:NO];
    }
    else if([strColor isEqualToString:@"pink"]){
        [btnYellow setSelected:NO];
        [btnBlue setSelected:NO];
        [btnBlack setSelected:NO];
        [btnPink setSelected:YES];
    }
    else if([strColor isEqualToString:@"blue"]){
        [btnYellow setSelected:NO];
        [btnBlue setSelected:YES];
        [btnBlack setSelected:NO];
        [btnPink setSelected:NO];
    }
    else{
        [btnYellow setSelected:NO];
        [btnBlue setSelected:NO];
        [btnBlack setSelected:YES];
        [btnPink setSelected:NO];
    }
    NSString *strSort=[[NSUserDefaults standardUserDefaults]valueForKey:@"sort"];
    if([strSort isEqualToString:@"status"]){
        [btnStat setSelected:YES];
        [btnPrio setSelected:NO];
    }
    else if([strSort isEqualToString:@"priority"]){
        [btnStat setSelected:NO];
        [btnPrio setSelected:YES];
    }
    else{
        [btnStat setSelected:NO];
        [btnPrio setSelected:NO];

    }
    [btnNotification setSelected:YES];

   }

- (IBAction)tapDetected:(UIGestureRecognizer *)sender{
    
    NSLog(@"tap");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dissmissSetting" object:self];
    // PlannerAppViewController *plannerOb=[[PlannerAppViewController alloc] init];
    
    //[plannerOb dissmissProgress:sender];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
   
    
    arrLoc=nil;
    
    arrName=nil;
   
    arrTab=nil;
    arrTabName=nil;
    lblSelLoc=nil;
    lblSync=nil;
    lblColr=nil;
    lbltab=nil;
    
    lblSorting=nil;
    lblSettings=nil;
    lblPush=nil;
    lblLocationAlert=nil;
    
    
    btnGoogle=nil;
    btnYahoo=nil;
    btnTodo=nil;
    
    btnPrio=nil;
    btnStat=nil;
    
    
    btnPink=nil;
    btnYellow=nil;
    btnBlue=nil;
    btnBlack=nil;
    btnSound=nil;
    
    btnNotification=nil;
    tabView=nil;

    arrFinalData=nil;
    
       // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [arrLoc count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    UIImageView * background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TBLBg.png"]];
    [tableView setBackgroundView:background];
    [background release];
    
    cell.textLabel.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.text=[arrLoc objectAtIndex:indexPath.row];
       return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    tblLocation.hidden=TRUE; 
    lblSelLoc.text=[arrLoc objectAtIndex:indexPath.row];
     
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
-(IBAction)clickSound:(id)sender{
    [self playSoundOnButtonClick];
    if([btnSound isSelected]){
        appdel.sound=1;
        [btnSound setSelected:NO];
    }
    else{
        appdel.sound=0;
        [btnSound setSelected:YES];
    }
}
-(IBAction)logOut:(id)sender{
    [self playSoundOnButtonClick];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Logout"
                                                  message:@"Are You Sure You Want To Logout?" 
                                                 delegate:self 
                                        cancelButtonTitle:nil 
                                        otherButtonTitles:@"YES",@"NO",nil];
    [alert show];
    [alert release];
}
-(IBAction)addNewLocation:(id)sender{
    [self playSoundOnButtonClick];
    AddNewLocation *addNewLoc=[[AddNewLocation alloc] init];
    [self.navigationController pushViewController:addNewLoc animated:YES];
    [addNewLoc release];
}
-(IBAction)ClickDrop:(id)sender{
    [self playSoundOnButtonClick];
    tblLocation.hidden=FALSE;
   
    [tblLocation reloadData];
}
-(IBAction)clickGoogle:(id)sender{
    [self playSoundOnButtonClick];
    [btnGoogle setSelected:YES];
    [btnYahoo setSelected:NO];
    [btnTodo setSelected:NO];
   
    [self refresh];
   
    
}
-(IBAction)clickYahoo:(id)sender{
    [self playSoundOnButtonClick];
    [btnGoogle setSelected:NO];
    [btnYahoo setSelected:YES];
    [btnTodo setSelected:NO];
   
   
}
-(IBAction)clickTodo:(id)sender
{
    [self playSoundOnButtonClick];
    [btnGoogle setSelected:NO];
    [btnYahoo setSelected:NO];
    [btnTodo setSelected:YES];
    
}
  -(IBAction)clickPrio:(id)sender{
    [self playSoundOnButtonClick];
    [[NSUserDefaults standardUserDefaults] setValue:@"priority" forKey:@"sort"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [btnStat setSelected:NO];
    [btnPrio setSelected:YES];
   
}
-(IBAction)clickStat:(id)sender{
    [self playSoundOnButtonClick];
    [btnStat setSelected:YES];
    [btnPrio setSelected:NO];
    [[NSUserDefaults standardUserDefaults] setValue:@"status" forKey:@"sort"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   }
-(IBAction)clickBlack:(id)sender{
    [self playSoundOnButtonClick];
    [[NSUserDefaults standardUserDefaults] setValue:@"black" forKey:@"color"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [btnBlack setSelected:YES];
    [btnPink setSelected:NO];
    [btnYellow setSelected:NO];
    [btnBlue setSelected:NO];
   
    
}
-(IBAction)clickYellow:(id)sender{
    [self playSoundOnButtonClick];
    [[NSUserDefaults standardUserDefaults] setValue:@"yellow" forKey:@"color"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [btnBlack setSelected:NO];
    [btnPink setSelected:NO];
    [btnYellow setSelected:YES];
    [btnBlue setSelected:NO];
    
}
-(IBAction)clickBlue:(id)sender{
    [self playSoundOnButtonClick];
    [[NSUserDefaults standardUserDefaults] setValue:@"blue" forKey:@"color"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [btnBlack setSelected:NO];
    [btnPink setSelected:NO];
    [btnYellow setSelected:NO];
    [btnBlue setSelected:YES];
    [self playSoundOnButtonClick];
    
}
-(IBAction)clickPink:(id)sender{
    [self playSoundOnButtonClick];
    [[NSUserDefaults standardUserDefaults] setValue:@"pink" forKey:@"color"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [btnBlack setSelected:NO];
    [btnPink setSelected:YES];
    [btnYellow setSelected:NO];
    [btnBlue setSelected:NO];
    
}
-(IBAction)clickNotification:(id)sender{
    [self playSoundOnButtonClick];
    if(isNoti){
        isNoti=NO;
        [btnNotification setSelected:YES];
    }
    else{
        isNoti=YES;
        [btnNotification setSelected:NO];
    }
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0)
	{
        appdel.str=@"100";
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            [cookies deleteCookie:cookie];
        }
        NSString *str=@"";
        [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"fbtoken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"loginName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"loginPassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"ischeck"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dissmissSetting" object:self];
        		
	}
    else{
        
    }
}
#pragma mark Reoder



//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ViewController implementation
//////////////////////////////////////////////////////////////




- (id)init
{
    if ((self = [super init])) 
    {
        //self.title = @"Demo 2";
    }
    return self;
}

//////////////////////////////////////////////////////////////
#pragma mark View lifecycle
//////////////////////////////////////////////////////////////

- (void)loadView
{
    [super loadView];
    //self.view.backgroundColor = [UIColor whiteColor];
    
      
    GMGridView *gmGridView2 = [[GMGridView alloc] initWithFrame:CGRectMake(0, 0, 608, 60)];
    gmGridView2.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    gmGridView2.style = GMGridViewStylePush;
    gmGridView2.itemSpacing = 0;
    gmGridView2.minEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    gmGridView2.centerGrid = YES;
    gmGridView2.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
    [tabView addSubview:gmGridView2];
    _gmGridView2 = gmGridView2;
    
       
    [self computeViewFrames];
}

- (void)viewDidLayoutSubviews
{
    [self computeViewFrames];
}





//////////////////////////////////////////////////////////////
#pragma mark Controller events
//////////////////////////////////////////////////////////////


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

//////////////////////////////////////////////////////////////
#pragma mark Privates
//////////////////////////////////////////////////////////////

- (void)computeViewFrames
{
    
    _gmGridView2.frame=CGRectMake(8,30,600,60);
    
    
}

- (void)showOptionsFromButton:(UIButton *)button
{
    UIViewController *optionsControllerToShow = button == _buttonOptionsGrid1 ? _optionsController1 : _optionsController2;
    
   
    
        if(![_popOverController isPopoverVisible])
        {
            _popOverController = [[UIPopoverController alloc] initWithContentViewController:optionsControllerToShow];
            [_popOverController presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            [self optionsDoneAction];
        }
    
}

- (void)optionsDoneAction
{
        
    
        [_popOverController dismissPopoverAnimated:YES];
        _popOverController = nil;

}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [arrTabName count];
}

- (CGSize)sizeForItemsInGMGridView:(GMGridView *)gridView
{
   
    
        return CGSizeMake(74, 41);
    
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self sizeForItemsInGMGridView:gridView];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) 
    {
        cell = [[GMGridViewCell alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        NSLog(@"%@",[arrTab objectAtIndex:index]);
        view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrTab objectAtIndex:index]]]];
       // view.backgroundColor = (gridView == _gmGridView1) ? [UIColor purpleColor] : [UIColor greenColor];
       // view.layer.masksToBounds = NO;
       // view.layer.cornerRadius = 8;
        //view.layer.shadowColor = [UIColor grayColor].CGColor;
        //view.layer.shadowOffset = CGSizeMake(5, 5);
        //view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
        //view.layer.shadowRadius = 8;
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
       
    return cell;
}


//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         //cell.contentView.backgroundColor = [UIColor orangeColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     } 
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{  
                         //cell.contentView.backgroundColor = (gridView == _gmGridView1) ? [UIColor purpleColor] : [UIColor greenColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    NSString *item = [[arrTab objectAtIndex:oldIndex] retain];
    [arrTab removeObject:item];
    [arrTab insertObject:item atIndex:newIndex];
    NSLog(@"%@",arrTab);
    [item release];
    
    
    NSString *item1 = [[arrTabName objectAtIndex:oldIndex] retain];
    [arrTabName removeObject:item1];
    [arrTabName insertObject:item1 atIndex:newIndex];
    NSLog(@"%@",arrTabName);
    [item1 release];
    [[NSUserDefaults standardUserDefaults] setObject:arrTabName forKey:@"tab"];
    [[NSUserDefaults standardUserDefaults] synchronize];


    // We dont care about this in this demo (see demo 1 for examples)
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    // We dont care about this in this demo (see demo 1 for examples)
}


//////////////////////////////////////////////////////////////
#pragma mark DraggableGridViewTransformingDelegate
//////////////////////////////////////////////////////////////

- (CGSize)GMGridView:(GMGridView *)gridView sizeInFullSizeForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
   
        return CGSizeMake(75, 37);
    
}

- (UIView *)GMGridView:(GMGridView *)gridView fullSizeViewForCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    UIView *fullView = [[UIView alloc] init];
    fullView.backgroundColor = [UIColor yellowColor];
    fullView.layer.masksToBounds = NO;
    fullView.layer.cornerRadius = 8;
    
    CGSize size = [self GMGridView:gridView sizeInFullSizeForCell:cell atIndex:index];
    fullView.bounds = CGRectMake(0, 0, size.width, size.height);
    
    UILabel *label = [[UILabel alloc] initWithFrame:fullView.bounds];
    label.text = [NSString stringWithFormat:@"Fullscreen View for cell at index %d", index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
   
        label.font = [UIFont boldSystemFontOfSize:20];
    
    
    [fullView addSubview:label];
    
    
    return fullView;
}

- (void)GMGridView:(GMGridView *)gridView didStartTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor blueColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     } 
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEndTransformingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.5 
                          delay:0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                         cell.contentView.backgroundColor = (gridView == _gmGridView1) ? [UIColor purpleColor] : [UIColor greenColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     } 
                     completion:nil];
}

- (void)GMGridView:(GMGridView *)gridView didEnterFullSizeForCell:(GMGridViewCell *)cell
{
    
}

-(void)viewWillDisappear:(BOOL)animated{
     
   
    //NSLog(@"arr final is %@",[arrFinalData objectAtIndex:0]);
   
    //NSLog(@"%@",[[arrFinalData objectAtIndex:0] valueForKey:@"title"]);
}





#pragma mark Utility methods for searching index paths.

- (NSDictionary *)dictionaryForIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section<[data count] )
        return [data objectAtIndex:indexPath.section];
    return nil;
}

- (NSMutableArray *)eventsForIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictionary = [self dictionaryForIndexPath:indexPath];
    if( dictionary )
        return [dictionary valueForKey:KEY_EVENTS];
    return nil;
}

- (GDataEntryCalendarEvent *)eventForIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *events = [self eventsForIndexPath:indexPath];
    if( events && indexPath.row<[events count] )
        return [events objectAtIndex:indexPath.row];
    return nil;
}

#pragma mark Google Data APIs

- (void)refresh{
    // Note: The next call returns a ticket, that could be used to cancel the current request if the user chose to abort early.
    // However since I didn't expose such a capability to the user, I don't even assign it to a variable.
    [data removeAllObjects];
    [googleCalendarService fetchCalendarFeedForUsername:appdel.username
                                               delegate:self
                                      didFinishSelector:@selector( calendarsTicket:finishedWithFeed: )
                                        didFailSelector:@selector( ticket:failedWithError: )];
}

- (void)calendarsTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedCalendar *)feed{
    int count = [[feed entries] count];
    for( int i=0; i<count; i++ ){
        GDataEntryCalendar *calendar = [[feed entries] objectAtIndex:i];
        
        // Create a dictionary containing the calendar and the ticket to fetch its events.
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        
        [dictionary setObject:calendar forKey:KEY_CALENDAR];
        [dictionary setObject:[[NSMutableArray alloc] init] forKey:KEY_EVENTS];
        if( [calendar ACLLink] )  // We can determine whether the calendar is under user's control by the existence of its ACL link.
            [dictionary setObject:KEY_EDITABLE forKey:KEY_EDITABLE];
        
        NSURL *feedURL = [[calendar alternateLink] URL];
        if( feedURL ){
            GDataQueryCalendar* query = [GDataQueryCalendar calendarQueryWithFeedURL:feedURL];
            
            // Currently, the app just shows calendar entries from 15 days ago to 31 days from now.
            // Ideally, we would instead use similar controls found in Google Calendar web interface, or even iCal's UI.
            NSDate *minDate = [NSDate date];  // From right now...
            GDataDateTime *updatedMinTime = [GDataDateTime dateTimeWithDate:minDate timeZone:[NSTimeZone systemTimeZone]];
            [query setMinimumStartTime:updatedMinTime];
            
            NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*90];  // ...to 90 days from now.
            GDataDateTime *updatedMaxTime = [GDataDateTime dateTimeWithDate:maxDate timeZone:[NSTimeZone systemTimeZone]];
            [query setMaximumStartTime:updatedMaxTime];
            
            [query setOrderBy:@"starttime"];  // http://code.google.com/apis/calendar/docs/2.0/reference.html#Parameters
            [query setIsAscendingOrder:YES];
            [query setShouldExpandRecurrentEvents:YES];
            
            GDataServiceTicket *ticket = [googleCalendarService fetchCalendarQuery:query
                                                                          delegate:self
                                                                 didFinishSelector:@selector( eventsTicket:finishedWithEntries: )
                                                                   didFailSelector:@selector( ticket:failedWithError: )];
            // I add the service ticket to the dictionary to make it easy to find which calendar each reply belongs to.
            [dictionary setObject:ticket forKey:KEY_TICKET];
            [data addObject:dictionary];
            [dictionary release];
        }
    }
    
   
    
  [self getInfoCalendar];
}

- (void)eventsTicket:(GDataServiceTicket *)ticket finishedWithEntries:(GDataFeedCalendarEvent *)feed{
    NSMutableDictionary *dictionary;
    for( int section=0; section<[data count]; section++ ){
        NSMutableDictionary *nextDictionary = [data objectAtIndex:section];
        GDataServiceTicket *nextTicket = [nextDictionary objectForKey:KEY_TICKET];
        if( nextTicket==ticket ){		// We've found the calendar these events are meant for...
            dictionary = nextDictionary;
            break;
        }
    }
    
    if( !dictionary )
        return;		// This should never happen.  It means we couldn't find the ticket it relates to.
    
    int count = [[feed entries] count];
    
    NSMutableArray *events = [dictionary objectForKey:KEY_EVENTS];
    for( int i=0; i<count; i++ ){
        GDataEntryCalendarEvent *event = [[feed entries] objectAtIndex:i];
        [events addObject:event];
    }
    
   
    
    NSURL *nextURL = [[feed nextLink] URL];
    if( nextURL ){
        NSLog( @"There are more events...  Fetching again." );
        GDataServiceTicket *ticket = [googleCalendarService fetchCalendarEventFeedWithURL:nextURL
                                                                                 delegate:self
                                                                        didFinishSelector:@selector( eventsTicket:finishedWithEntries: )   // Right back here...
                                                                          didFailSelector:@selector( ticket:failedWithError: )];
        // Update the ticket in the dictionary for the next batch.
        [dictionary setObject:ticket forKey:KEY_TICKET];
    }
    [self getInfoCalendar];
}

- (void)deleteCalendarEvent:(GDataEntryCalendarEvent *)calendarEvent{
    [googleCalendarService deleteCalendarEventEntry:calendarEvent
                                           delegate:self
                                  didFinishSelector:nil
                                    didFailSelector:@selector( ticket:failedWithError: )];
}

- (void)insertCalendarEvent:(GDataEntryCalendarEvent *)newEvent toCalendar:(GDataEntryCalendar *)calendar{
    [googleCalendarService fetchCalendarEventByInsertingEntry:newEvent
                                                   forFeedURL:[[calendar alternateLink] URL]
                                                     delegate:self
                                            didFinishSelector:@selector( insertTicket:finishedWithEntry: )
                                              didFailSelector:@selector( ticket:failedWithError: )];
}

- (void)insertTicket:(GDataServiceTicket *)ticket finishedWithEntry:(GDataEntryCalendarEvent *)entry{
    [self refresh];
}

- (void)updateCalendarEvent:(GDataEntryCalendarEvent *)newEvent toCalendar:(GDataEntryCalendar *)calendar{
    [googleCalendarService fetchCalendarEventEntryByUpdatingEntry:newEvent
                                                      forEntryURL:[[calendar alternateLink] URL]
                                                         delegate:self
                                                didFinishSelector:nil
                                                  didFailSelector:@selector( ticket:failedWithError: )];
}
-(void)getInfoCalendar{
//    for(int i=0;i<[data count];i++){
//        NSMutableDictionary *dictionary = [data objectAtIndex:i];
//        NSMutableArray *events = [dictionary objectForKey:KEY_EVENTS];
//        NSLog(@"Events %@",events);
//        NSLog(@"dict  %@",dictionary);
//        int count1 = [events count];
//    }
    NSIndexPath *indexPath;
    NSLog(@"data count %d",[data count]);
    if([data count]>=1){
    indexPath=[NSIndexPath indexPathForRow:index inSection:datacntsec];
    }
    
    
    NSArray *events = [self eventsForIndexPath:indexPath];
    if([events count]>0){
        index=0;
        datacntsec++;
        section=0;
    }
       NSLog(@"index is %d  event count %d",index,[events count]);
   
    // The DetailCell has two modes of display - either the typical record or a prompt for creating a new item
  
    for(int i=0;i<[events count];i++){
        
        GDataEntryCalendarEvent *event = [events objectAtIndex:i];
        GDataWhen *when = [[event objectsForExtensionClass:[GDataWhen class]] objectAtIndex:0];
        if( when ){
            GDataDateTime *dateTime = [when startTime];
            NSString *str = [NSString stringWithFormat:@"%@", [dateTime date]] ;
            NSLog(@"str is %@",str);
             NSLog(@"%@",[str substringToIndex:10]) ;
             NSLog(@"%@",[[event title] stringValue]);
            NSString *strTitle=[[event title] stringValue];
            NSLog(@"%@",strTitle);
            NSMutableDictionary *dictAddCal=[[NSMutableDictionary alloc] init];
            [dictAddCal setObject:[NSString stringWithFormat:@"%@",str] forKey:@"time"];
            [dictAddCal setObject:[NSString stringWithFormat:@"%@",strTitle] forKey:@"title"];
            NSLog(@"%@",dictAddCal);
            [arrFinalData addObject:[NSString stringWithFormat:@"%@",dictAddCal]];
            //[arrFinalData addObject:[NSString stringWithFormat:@"%@",str]];
            //[arrFinalData addObject:[NSString stringWithFormat:@"%@",strTitle]];
            NSLog(@"arr final data is %@",arrFinalData);
            
            if(dictAddCal!=nil){
                [dictAddCal removeAllObjects];
                [dictAddCal release];
                dictAddCal=nil;
            }
            index++;
             //[str substringWithRange:NSMakeRange( 11, 8)];
        }
       
        
        
        //cell.name.text = [[event title] stringValue];
        // Note: An event might have multiple locations.  We're only displaying the first one.
       
    }
    
}
- (void)ticket:(GDataServiceTicket *)ticket failedWithError:(NSError *)error{
    NSString *title, *msg;
    if( [error code]==kGDataBadAuthentication ){
        title = @"Authentication Failed";
        msg = @"Invalid username/password\n\nPlease go to the iPhone's settings to change your Google account credentials.";
    }else{
        // some other error authenticating or retrieving the GData object or a 304 status
        // indicating the data has not been modified since it was previously fetched
        title = @"Unknown Error";
        msg = [error localizedDescription];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
   // [self getInfoCalendar];
    
   
}

-(void)dealloc{
    [super dealloc];
    [arrTab release];
    
    [arrLoc release];
    [arrName release];
    [arrTabName release];
    [lblSelLoc release];
    [lblSync release];;
    [lblColr release];;
    [lbltab release];;
    
    [lblSorting release];
    [lblSettings release];
    [lblPush release];
    [lblLocationAlert release];
    
    
    [btnGoogle release];
    [btnYahoo release];
    [btnTodo release];
    
    [btnPrio release];
    [btnStat release];
    
    
    [btnPink release];
    [btnYellow release];
    [btnBlue release];
    [btnBlack release];
    
    [btnSound release];
    
    [btnNotification release];
    [tabView release];
    [arrFinalData release];
   
}
@end

//
//  PlannerAppAppDelegate.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//



#import "PlannerAppAppDelegate.h"
#import "PlannerAppViewController.h"
#import "AlertsPopView.h"
#import "AlertHandler.h"
#import "JSONParser.h"
#import "SplashScreen.h"
@implementation PlannerAppAppDelegate

@synthesize window,dict,array,strLoginID,url,str,reminderText,navigationKeepMeSigned,tagFlag;
@synthesize str_mcid,dateSel,set,sound,username,password,isTaskOrEvent,isLandscape;
@synthesize viewController,isColor,navigationController,arrLocation,navigationControllerIPhone;
//
NSString *kRemindMeNotificationDataKey = @"kRemindMeNotificationDataKey";
#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
  
    sound=1;
    Class cls = NSClassFromString(@"UILocalNotification");
	if (cls) {
		UILocalNotification *notification = [launchOptions objectForKey:
                                             UIApplicationLaunchOptionsLocalNotificationKey];
		
        NSLog(@"Notification called %@",notification.userInfo);
		if (notification) {
            NSLog(@"user info in appdel %@",notification.userInfo);
            reminderText = [notification.userInfo 
                            objectForKey:@"remTitle"];
            NSString *reminderText1 = [notification.userInfo
                                       objectForKey:@"remTitle"];

            AlertsPopView *alertpop=[[AlertsPopView alloc] init];
            [alertpop showReminder:reminderText1];
            [alertpop release];

			
		}
	}
	
	application.applicationIconBadgeNumber = 0;
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeNewsstandContentAvailability];
    
    // Override point for customization after app launch.
    [self.window addSubview:viewController.view];
	
    url=@"http://openxcellaus.info/emainder";
    
    NSLog(@"%@    %@    %@ ",[[NSUserDefaults standardUserDefaults]valueForKey:@"loginName"],[[NSUserDefaults standardUserDefaults]valueForKey:@"loginPassword"],[[NSUserDefaults standardUserDefaults]valueForKey:@"ischeck"]);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
        spObj=[[SplashScreen alloc] initWithNibName:@"SplashScreen" bundle:nil];
        [self.window addSubview:spObj.view];
        
       
    }
    else
    {
        
        [self.window addSubview:navigationControllerIPhone.view];
    }
    [self.window makeKeyAndVisible];
    array=[[NSMutableArray alloc]init];
    dict=[[NSMutableDictionary alloc] init];
	arrLocation=[[NSMutableArray alloc]init];
    [self checkAndCreateDatabase];
    dal=[[DAL alloc] initDatabase:@"Planner.sqlite"];
    [self loadSettings];
    [self storeSettings];
	return YES;
}
-(void)removeSplash{
    [spObj.view removeFromSuperview];
    if( ![[[NSUserDefaults standardUserDefaults]valueForKey:@"loginName"] isEqualToString:@""] &&  ![[[NSUserDefaults standardUserDefaults]valueForKey:@"loginPassword"]isEqualToString:@""]
       && [[[NSUserDefaults standardUserDefaults]valueForKey:@"ischeck"] isEqualToString:@"YES"])
    {
        
        
        [self.window addSubview:navigationKeepMeSigned.view];
        
    }
    else{
        [self.window addSubview:navigationController.view];
    }
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"deviceToken: %@", deviceToken); 
    NSString *token = [[[[deviceToken description]
                         stringByReplacingOccurrencesOfString: @"<" withString: @""] 
                        stringByReplacingOccurrencesOfString: @">" withString: @""] 
                       stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[NSUserDefaults standardUserDefaults]setValue:token forKey:@"PlannerDeviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error == %@",[error description]);
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"user info%@",userInfo);
    //[self hideHUD];
    //dicPushInformation = [[NSDictionary alloc] initWithDictionary:userInfo];
    //NSString *actionType = [[[userInfo valueForKey:@"aps"] valueForKey:@"message"]valueForKey:@"vFullName"];
    
   // NSString *message = [NSString stringWithFormat:@"%@ commented on your post.",actionType];
    dictAdd=(NSMutableDictionary *)userInfo ;
    [dictAdd retain];
    NSLog(@"%@",dictAdd);
    NSString *str1=[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"title"];
    NSString *email=[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"email"];
    strAtid=[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"atid"];
    NSLog(@"atid %@",strAtid);
    
    if([[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"messageText"] isEqualToString:@"got task"]){
        strAtid=[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"atid"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Task sent by %@",email] message:[NSString stringWithFormat:@"%@",str1] delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
    [self playSoundOnButtonClick];
    [alert show];
    [alert release];
    }
    else if([[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"messageText"] isEqualToString:@"got sub task"]){
        strAtid=[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"astid"];
        subTask=1;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Task sent by %@",email] message:[NSString stringWithFormat:@"%@",str1] delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
        [self playSoundOnButtonClick];
        [alert show];
        [alert release];
    }
    else if([[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"messageText"] isEqualToString:@"got task invitee"]){
        strAtid=[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"astid"];
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Invitation sent by %@",email] message:[NSString stringWithFormat:@"%@",str1] delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
        alert.tag=5;
        [self playSoundOnButtonClick];
        [alert show];
        [alert release];
    }
    else if([[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"messageText"] isEqualToString:@"got sub task invitee"]){
        strAtid=[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"astid"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Invitation sent by %@",email] message:[NSString stringWithFormat:@"%@",str1] delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
        alert.tag=5;
        [self playSoundOnButtonClick];
        [alert show];
        [alert release];
    }
    else if([[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"messageText"] isEqualToString:@"accepted"]){
        subTask=0;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Accepted %@ ",email,[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"title"]] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        alert.tag=5;
        [self playSoundOnButtonClick];
        [alert show];
        [alert release];
    }
    else if([[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"messageText"] isEqualToString:@"reject"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Rejected %@ ",email,[[[userInfo valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"title"]] message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        alert.tag=5;
        [self playSoundOnButtonClick];
        [alert show];
        [alert release];
    }
    
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *strres;
    if(buttonIndex==1){
        NSLog(@"Accepted");
        strres=@"accept";
        NSMutableDictionary *dictNEw=[[NSMutableDictionary alloc] init];
        NSLog(@"%@",dictAdd);
        NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];

        NSLog(@"%@",[[[dictAdd valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"title"]);
        
       
        NSMutableDictionary *dictre;
        dictre=   [dal executeDataSet:[NSString stringWithFormat:@"select max(position) from tblMainTask"]];
        tagFlag=1;
        NSLog(@"%@",[dictre valueForKey:@"Table1"]);
        NSLog(@"%@",[[dictre valueForKey:@"Table1"] valueForKey:@"max(position)"]);
        int cnt=[[[dictre valueForKey:@"Table1"]valueForKey:@"max(position)"] intValue];
        [dictNEw setObject:[NSString stringWithFormat:@"%d",cnt+1] forKey:@"position"];
        
      
        [dictNEw setObject:[NSString stringWithFormat:@"%d",1] forKey:@"scid"];
        [dictNEw setObject:[NSString stringWithFormat:@"%@",str_id] forKey:@"userid"];
        NSString *strep=[[[dictAdd valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"title"];
        NSLog(@"%@",strep);
                    
        [dictNEw setObject:[[[dictAdd valueForKey:@"aps"] valueForKey:@"message"] valueForKey:@"title"] forKey:@"title"];
        [dal insertRecord:dictNEw inTable:@"tblMainTask"];
        
        if(dictNEw!=nil){
            [dictNEw removeAllObjects];
            [dictNEw release];
            dictNEw=nil;
        }
    }
    else{
        strres=@"reject";
    }
    if(actionSheet.tag!=5)
    [self JSONAccept:strres];
}
-(void)JSONAccept:(NSString *)response
{
    
    http://openxcellaus.info/emainder/user_action.php?action=responce_task&atid=64&response=accept
    [AlertHandler showAlertForProcess];
    NSString *str1;
    NSLog(@"%@",strAtid);
    if(subTask==0)
    str1=[NSString stringWithFormat:@"%@/user_action.php?action=responce_task&atid=%@&response=%@",url,strAtid,response];
    
    else
    str1=[NSString stringWithFormat:@"%@/user_action.php?action=responce_sub_task&astid=%@&response=%@",url,strAtid,response];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str1]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchfaceBook:) andHandler:self];
    NSLog(@"%@",parser);
    
	
}
-(void)searchfaceBook:(NSDictionary*)dictionary
{
    [AlertHandler hideAlert];
    NSLog(@"%@",dictionary);
    
    
    
}	
-(void)playSoundOnButtonClick{
    if(sound==1){
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/newsalert.wav"];
    
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    //Use audio sevices to create the sound
    
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    
    //Use audio services to play the sound
    
    AudioServicesPlaySystemSound(soundID); 
    }
}
-(void) checkAndCreateDatabase
{
	BOOL success;
	
	NSString *databaseName = @"Planner.sqlite";
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	//NSLog(@"database path:%@",databasePath);
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	success = [fileManager fileExistsAtPath:databasePath];
	
	if(success) return;
	
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	
	[fileManager release];
}
- (void)application:(UIApplication *)application 
didReceiveLocalNotification:(UILocalNotification *)notification {
	
	UIApplicationState state = [application applicationState];
	 if (state == UIApplicationStateInactive) {
    
     
	 }
        
     else{
         application.applicationIconBadgeNumber = 1;
         NSLog(@"%@",notification.userInfo);
         NSString *reminderText1 = [notification.userInfo
                                    objectForKey:@"remTitle"];
         
         AlertsPopView *alertpop=[[AlertsPopView alloc] init];
         [alertpop showReminder:reminderText1];
         [alertpop release];

     }
	
	
	}
- (void)applicationWillTerminate:(UIApplication *)application{
    [self storeSettings];
}

- (void)loadSettings{
    CFPreferencesAppSynchronize( kCFPreferencesCurrentApplication );
    
    username = (NSString*)CFPreferencesCopyAppValue( PREF_USERNAME, kCFPreferencesCurrentApplication );
    if( !username )
        username = @"dhara@openxcell.info";
        if( ![username rangeOfString:@"@"].length )		// If the domain isn't specified, then default to gmail.com.  It may be a different domain, however.
            username = [username stringByAppendingString:@"@gmail.com"];
    
   // password = (NSString*)CFPreferencesCopyAppValue( PREF_PASSWORD, kCFPreferencesCurrentApplication );
    //if( !password )
        password = @"dhara22c";
    
}

- (void)storeSettings{
    CFPreferencesSetAppValue( PREF_USERNAME, username, kCFPreferencesCurrentApplication );
    CFPreferencesSetAppValue( PREF_PASSWORD, password, kCFPreferencesCurrentApplication );
    CFPreferencesAppSynchronize( kCFPreferencesCurrentApplication );
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}




#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [navigationController release];
    [window release];
    [super dealloc];
}


@end

//
//  Repeat_days.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Repeat_days.h"
#import "RepeatsPopView.h"


@implementation Repeat_days
@synthesize SelectedDays;
@synthesize delegate,strMID,strSID;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.contentSizeForViewInPopover=CGSizeMake(320, 460);
	//day_array=[[NSMutableArray alloc] initWithObjects:@"None",@"5 minutes before",@"15 minutes before",@"30 minutes before",@"1 hour before",@"2 hours before",@"1 day before",@"2 days before",nil];
    day_array=[[NSMutableArray alloc] initWithObjects:@"None",@"Every Day",@"Every Mon & Wed",@"Every Tues & Thur",@"Every Mon,Wed & Fri",@"Every Week",@"Every 2 Weeks",@"Every Month",@"Every Year", nil];
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneFolder)];
    
    
    [self.navigationItem setRightBarButtonItem:doneButton];
    [doneButton release];
    
    UIBarButtonItem *canButton=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    
    [self.navigationItem setLeftBarButtonItem:canButton];
    [canButton release];
    dal=[[DAL alloc] initDatabase:@"Planner.sqlite"];}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableArray *arrget;
    if(strMID){
        arrget=[dal SelectWithStar:@"tblMainTask" withCondition:@"mtid=" withColumnValue:[NSString stringWithFormat:@"%@",strMID]];
        for(int i=0;i<[day_array count];i++){
            if([[[arrget objectAtIndex:0] valueForKey:@"repeat"] isEqualToString:[day_array objectAtIndex:i]])
                selectedIndex=i;
        }
        
    }
    else{
        arrget=[dal SelectWithStar:@"tblSubTask" withCondition:@"stid=" withColumnValue:[NSString stringWithFormat:@"%@",strSID]];
        for(int i=0;i<[day_array count];i++){
            if([[[arrget objectAtIndex:0] valueForKey:@"repeat"] isEqualToString:[day_array objectAtIndex:i]])
                selectedIndex=i;
        }
    }

    
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
   
        [self.navigationController popViewControllerAnimated:YES];

}
-(void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)doneFolder{
    
    NSMutableDictionary *dictInsert=[[NSMutableDictionary alloc] init];
    [dictInsert setObject:[NSString stringWithFormat:@"%@",[day_array objectAtIndex:selectedIndex]] forKey:@"repeat"];
    if(strMID)
    [dal updateRecord:dictInsert forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strMID]];
    else
         [dal updateRecord:dictInsert forID:@"stid=" inTable:@"tblSubTask" withValue:[NSString stringWithFormat:@"%@",strSID]];
    if(dictInsert!=nil){
        [dictInsert removeAllObjects];
        [dictInsert release];
        dictInsert=nil;
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    NSMutableArray *arrdd=[[NSMutableArray alloc] init];
    dictValues=[[NSMutableDictionary alloc] init];
    NSString *uidtodelete,*ID;
    if(strMID){
        arrdd=[dal SelectWithStar:@"tblMainTask" withCondition:@"mtid=" withColumnValue:[NSString stringWithFormat:@"%@",strMID]];
        ID=[[arrdd objectAtIndex:0] valueForKey:@"mtid"];
    }
    else{
        arrdd=[dal SelectWithStar:@"tblSubTask" withCondition:@"stid=" withColumnValue:[NSString stringWithFormat:@"%@",strSID]];
        ID=[[arrdd objectAtIndex:0] valueForKey:@"stid"];
    }
    NSLog(@"count is %d",[arrdd count]);
    if([[[arrdd objectAtIndex:0] valueForKey:@"alertTime"] isEqualToString:@""]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Please set an alert first" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else{
    uidtodelete=[[arrdd objectAtIndex:0] valueForKey:@"alertTime"];
    strTitle=[[[arrdd objectAtIndex:0] valueForKey:@"title"] retain];
    for (int i=0; i<[eventArray count]; i++)
    {
        
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSLog(@"%@",userInfoCurrent);
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"FIRE_TIME_KEY"]];
        NSString *star=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"NOTIFICATION_MESSAGE_KEY"]];
        NSLog(@"%@",ID);
        NSLog(@"%@",star);
        NSLog(@"%@",uidtodelete);
        NSLog(@"%@",uid);
        if ([uid isEqualToString:uidtodelete] && [ID intValue]==[star intValue] )
        {
            //Cancelling local notification
            [dictValues setDictionary:userInfoCurrent];
            [app cancelLocalNotification:oneEvent];
             NSLog(@"%@",userInfoCurrent);
           
        }
    }
    NSLog(@"%@",dictValues);
   
        NSString *strFin=[dictValues valueForKey:@"FIRE_TIME_KEY"];
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
        
				
		NSDateFormatter *dtForm = [[NSDateFormatter alloc] init];
		[dtForm setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
		[dtForm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		
    NSDictionary *userDict,*dict2,*dict3Friday;
		//date = [dtForm dateFromString:endTime];
		NSLog(@"%@",endOfWorldWar3);
    
		if(selectedIndex==1 || selectedIndex==0) {
            if(strSID){
            userDict=[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
        
            }
            else{
                NSLog(@"%@  %@",strMID,endOfWorldWar3);
                userDict=[[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil] retain];
            }
            //notif.repeatInterval=NSMinuteCalendarUnit*24;
        }
        else if(selectedIndex==2 || selectedIndex==4){
            
            NSLog(@"dict is %@",dictValues);
            
            NSDateFormatter *weekDay = [[[NSDateFormatter alloc] init] autorelease];
            [weekDay setDateFormat:@"EE"];
            NSString *day=[weekDay stringFromDate:endOfWorldWar3];
            NSLog(@"%@",day);
            if([day isEqualToString:@"Mon"]){
               
                NSLog(@"for mon %@",endOfWorldWar3);
                
                
                
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                [offsetComponents setDay:2];
                NSDate *threeDaysFromToday = [gregorian dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                NSLog(@"for wed %@",threeDaysFromToday);
                
                NSDate *threeDaysFromToday3;
                if(selectedIndex==4){
                    //fri
                    NSCalendar *gregorian3 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *offsetComponents3 = [[NSDateComponents alloc] init];
                    [offsetComponents3 setDay:4];
                    threeDaysFromToday3 = [gregorian3 dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                    NSLog(@"for wed %@",threeDaysFromToday3);
                }
                
                
               
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    if(selectedIndex==4){
                         dict3Friday=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday3,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    }
                    
                }
                else{
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                      dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    if(selectedIndex==4){
                        dict3Friday=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday3,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    }
                }
                
                               
            }
            else if([day isEqualToString:@"Tue"]){
                //mon
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                [offsetComponents setDay:6];
                NSDate *threeDaysFromToday = [gregorian dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday);
               
                //wed
                NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
                [offsetComponents1 setDay:1];
                NSDate *threeDaysFromToday1 = [gregorian1 dateByAddingComponents:offsetComponents1 toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday1);
                
                NSDate *threeDaysFromToday3;
                if(selectedIndex==4){
                    //fri
                    NSCalendar *gregorian3 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *offsetComponents3 = [[NSDateComponents alloc] init];
                    [offsetComponents3 setDay:3];
                    threeDaysFromToday3 = [gregorian3 dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                    NSLog(@"for wed %@",threeDaysFromToday3);
                }

                
                
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    if(selectedIndex==4){
                        dict3Friday=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday3,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    }
                    
                }
                else{
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strMID,@"ID",strTitle,@"remTitle",nil];
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strMID,@"ID",strTitle,@"remTitle",nil];
                    if(selectedIndex==4){
                        dict3Friday=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday3,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    }
                }
                
            }
            else if([day isEqualToString:@"Wed"]){
                
               
                
                //mon
                NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
                [offsetComponents1 setDay:5];
                NSDate *threeDaysFromToday1 = [gregorian1 dateByAddingComponents:offsetComponents1 toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday1);
                
                
                NSDate *threeDaysFromToday3;
                if(selectedIndex==4){
                    //fri
                    NSCalendar *gregorian3 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *offsetComponents3 = [[NSDateComponents alloc] init];
                    [offsetComponents3 setDay:2];
                    threeDaysFromToday3 = [gregorian3 dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                    NSLog(@"for wed %@",threeDaysFromToday3);
                }
               
                
                
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    if(selectedIndex==4){
                        dict3Friday=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday3,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    }
                    
                }
                else{
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strMID,@"ID",strTitle,@"remTitle",nil];
                    if(selectedIndex==4){
                        dict3Friday=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday3,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    }
                }

                               
            }
            else if([day isEqualToString:@"Thu"]){
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                [offsetComponents setDay:4];
                NSDate *threeDaysFromToday = [gregorian dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday);
              
                
                
                NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
                [offsetComponents1 setDay:6];
                NSDate *threeDaysFromToday1 = [gregorian1 dateByAddingComponents:offsetComponents1 toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday1);
                
                NSDate *threeDaysFromToday3;
                if(selectedIndex==4){
                    //fri
                    NSCalendar *gregorian3 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *offsetComponents3 = [[NSDateComponents alloc] init];
                    [offsetComponents3 setDay:1];
                    threeDaysFromToday3 = [gregorian3 dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                    NSLog(@"for wed %@",threeDaysFromToday3);
                }
                
                
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    if(selectedIndex==4){
                        dict3Friday=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday3,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    }
                    
                }
                else{
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strMID,@"ID",strTitle,@"remTitle",nil];
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    if(selectedIndex==4){
                        dict3Friday=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday3,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    }
                }
                
            }
            else if([day isEqualToString:@"Fri"]){
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                [offsetComponents setDay:3];
                NSDate *threeDaysFromToday = [gregorian dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday);
                
                
                NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
                [offsetComponents1 setDay:5];
                NSDate *threeDaysFromToday1 = [gregorian1 dateByAddingComponents:offsetComponents1 toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday1);
                
                
              
                
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    if(selectedIndex==4){
                        dict3Friday=[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    }
                    
                }
                else{
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strMID,@"ID",strTitle,@"remTitle",nil];
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    if(selectedIndex==4){
                        dict3Friday=[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    }
                }
                
            }
            else if([day isEqualToString:@"Sat"]){
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                [offsetComponents setDay:2];
                NSDate *threeDaysFromToday = [gregorian dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday);
                
                
                
                NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
                [offsetComponents1 setDay:4];
                NSDate *threeDaysFromToday1 = [gregorian1 dateByAddingComponents:offsetComponents1 toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday1);
                
                NSDate *threeDaysFromToday3;
                if(selectedIndex==4){
                    //fri
                    NSCalendar *gregorian3 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *offsetComponents3 = [[NSDateComponents alloc] init];
                    [offsetComponents3 setDay:6];
                    threeDaysFromToday3 = [gregorian3 dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                    NSLog(@"for wed %@",threeDaysFromToday3);
                }
                
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strSID,@"ID",strTitle,@"remTitle",nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strSID,@"ID",strTitle,@"remTitle",nil];
                    
                    if(selectedIndex==4){
                        dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday3,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    }
                    
                }
                else{
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strMID,@"ID",strTitle,@"remTitle",nil];
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    if(selectedIndex==4){
                        dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday3,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    }
                }

               
            }
            else if([day isEqualToString:@"Sun"]){
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                [offsetComponents setDay:1];
                NSDate *threeDaysFromToday = [gregorian dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday);
                
                
                
                NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
                [offsetComponents1 setDay:3];
                NSDate *threeDaysFromToday1 = [gregorian1 dateByAddingComponents:offsetComponents1 toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday1);
                
                
                NSDate *threeDaysFromToday3;
                if(selectedIndex==4){
                    //fri
                    NSCalendar *gregorian3 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *offsetComponents3 = [[NSDateComponents alloc] init];
                    [offsetComponents3 setDay:5];
                    threeDaysFromToday3 = [gregorian3 dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                    NSLog(@"for wed %@",threeDaysFromToday3);
                }
                
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strSID,@"ID",strTitle,@"remTitle",nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    if(selectedIndex==4){
                        dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday3,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    }
                    
                }
                else{
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    if(selectedIndex==4){
                        dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday3,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    }
                }

               
            }
            
           
        }
    
        else if(selectedIndex==3){
            
            NSLog(@"dict is %@",dictValues);
            
            NSDateFormatter *weekDay = [[[NSDateFormatter alloc] init] autorelease];
            [weekDay setDateFormat:@"EE"];
            NSString *day=[weekDay stringFromDate:endOfWorldWar3];
            NSLog(@"%@",day);
            if([day isEqualToString:@"Mon"]){
                
                NSLog(@"for mon %@",endOfWorldWar3);
                //tues
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                [offsetComponents setDay:1];
                NSDate *threeDaysFromToday = [gregorian dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                NSLog(@"for wed %@",threeDaysFromToday);
                
                //thu
                NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
                [offsetComponents1 setDay:3];
                NSDate *threeDaysFromToday1 = [gregorian1 dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                NSLog(@"for wed %@",threeDaysFromToday1);
                
                
                
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strSID,@"ID",strTitle,@"remTitle",nil];
                    
                }
                else{
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                }
                
                
            }
            else if([day isEqualToString:@"Tue"]){
                
                
                //thurs
                NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
                [offsetComponents1 setDay:2];
                NSDate *threeDaysFromToday1 = [gregorian1 dateByAddingComponents:offsetComponents1 toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday1);
                
                
                
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                }
                else{
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strMID,@"ID",strTitle,@"remTitle",nil];
                }
                
            }
            else if([day isEqualToString:@"Wed"]){
                
                
                //tues
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                [offsetComponents setDay:6];
                NSDate *threeDaysFromToday = [gregorian dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday);

                
                //thurs
                NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
                [offsetComponents1 setDay:1];
                NSDate *threeDaysFromToday1 = [gregorian1 dateByAddingComponents:offsetComponents1 toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday1);
                
                
                
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strSID,@"ID",strTitle,@"remTitle",nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                }
                else{
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strMID,@"ID",strTitle,@"remTitle",nil];
                }
                
                
            }
            else if([day isEqualToString:@"Thu"]){
               
                
                
                //
                NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
                [offsetComponents1 setDay:5];
                NSDate *threeDaysFromToday1 = [gregorian1 dateByAddingComponents:offsetComponents1 toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday1);
                
                
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strSID,@"ID",strTitle,@"remTitle",nil];
                    
                }
                else{
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                }
                
            }
            else if([day isEqualToString:@"Fri"]){
                //tues
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                [offsetComponents setDay:4];
                NSDate *threeDaysFromToday = [gregorian dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday);
                
                //thur
                NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
                [offsetComponents1 setDay:6];
                NSDate *threeDaysFromToday1 = [gregorian1 dateByAddingComponents:offsetComponents1 toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday1);
                
                
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                }
                else{
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                }
                
            }
            else if([day isEqualToString:@"Sat"]){
                //tues
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                [offsetComponents setDay:3];
                NSDate *threeDaysFromToday = [gregorian dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday);
                
                
                //thurs
                NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
                [offsetComponents1 setDay:5];
                NSDate *threeDaysFromToday1 = [gregorian1 dateByAddingComponents:offsetComponents1 toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday1);
                
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                }
                else{
                    NSLog(@"%@  %@  %@",threeDaysFromToday,strMID,strTitle);
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                }
                
                
            }
            else if([day isEqualToString:@"Sun"]){
                //tues
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                [offsetComponents setDay:2];
                NSDate *threeDaysFromToday = [gregorian dateByAddingComponents:offsetComponents toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday);
                
                
                //thur
                NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents *offsetComponents1 = [[NSDateComponents alloc] init];
                [offsetComponents1 setDay:4];
                NSDate *threeDaysFromToday1 = [gregorian1 dateByAddingComponents:offsetComponents1 toDate:endOfWorldWar3 options:0];
                NSLog(@"%@",threeDaysFromToday1);
                if(strSID){
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                    
                }
                else{
                    userDict=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                    dict2=[NSDictionary dictionaryWithObjectsAndKeys:threeDaysFromToday1,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
                }
                
                
            }
            
            
        }
        else if(selectedIndex==5 || selectedIndex==6 || selectedIndex==7 || selectedIndex==8){
            if(strSID){
                userDict=[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strSID,@"ID",strTitle,@"remTitle", nil];
                
                
                
            }
            else{
                userDict=[NSDictionary dictionaryWithObjectsAndKeys:endOfWorldWar3,@"Fire Date",strMID,@"ID",strTitle,@"remTitle", nil];
               
            }
        }
        
    if(selectedIndex==1 || selectedIndex==0 || selectedIndex==5 || selectedIndex==6 || selectedIndex==7 || selectedIndex==8){
    [self scheduleNotificationWithItem:userDict];
    }
    else if(selectedIndex==4){
        [self scheduleNotificationWithItem:userDict];
        [self scheduleNotificationWithItem:dict2];
        [self scheduleNotificationWithItem:dict3Friday];
        
    }
    else{
        [self scheduleNotificationWithItem:userDict];
        [self scheduleNotificationWithItem:dict2];
    }
    
    
     [self.navigationController popViewControllerAnimated:YES];   
	}	
      
}
    
    
    

    

- (void)scheduleNotificationWithItem:(NSDictionary*)item  {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
  
    
    if (localNotification == nil)   return;
    
    localNotification.fireDate =  [item valueForKey:@"Fire Date" ];
    //notif.fireDate = [sDate dateByAddingTimeInterval:3600*i];
    
    localNotification.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSLog(@"title %@",strTitle);
    localNotification.alertBody = strTitle;
    
    localNotification.alertAction = @"View Details";
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    localNotification.userInfo = item;
    if(selectedIndex==0){
        
    }
    else if(selectedIndex==1){
        localNotification.repeatInterval=NSDayCalendarUnit;
    }
    else if(selectedIndex==2 || selectedIndex==3 || selectedIndex==4 || selectedIndex==5){
        localNotification.repeatInterval =NSWeekCalendarUnit;
    }
    else if(selectedIndex==6){
        localNotification.repeatInterval=NSWeekCalendarUnit*2;
    }
    else if(selectedIndex==7){
        localNotification.repeatInterval=NSMonthCalendarUnit;
    }
    else if(selectedIndex==8){
        localNotification.repeatInterval=NSYearCalendarUnit;
        
    }
    
    
    NSLog(@"%@",localNotification.userInfo);
    NSLog(@"%@",localNotification);
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    [localNotification release];
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [day_array count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text=[day_array objectAtIndex:indexPath.row];
    
    if (indexPath.row==selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    
    selectedIndex=indexPath.row;
    
    [tableView reloadData];
    
   
    
      
   
	
}






#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

-(void)viewDidDisappear:(BOOL)animated{
    
//    int count=0;
//    SelectedDays=@"";
//    for(int i=0;i<[selectedObjects count];i++){
//        if([[selectedObjects objectAtIndex:i] isEqualToString:@"0"]){
//            SelectedDays=[SelectedDays stringByAppendingString:[NSString stringWithFormat:@"%@ ",[day_array objectAtIndex:i] ]];
//            count++;
//            
//        }
//    }
//    if(count==7){
//        SelectedDays=@"All Days";
//    }
//    NSLog(@"%@",SelectedDays);
//    [self.delegate addItemViewController:self didFinishEnteringItem:SelectedDays];
   
    
   
}





- (void)dealloc {
    [super dealloc];
   [SelectedDays release];
}


@end


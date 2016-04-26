//
//  FolderView.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FolderView.h"

@implementation FolderView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
        
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
  
        scroll.hidden= TRUE;
        view_cal.hidden = TRUE;
        UISearchBar *sBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        [sBar sizeToFit];
        
        //searchBar.delegate = self;
        sBar.placeholder = @"Search..";
        tbl.tableHeaderView = sBar;
        [sBar release];
        
        scroll.contentSize=CGSizeMake(0, 500);
        
        taskbutton.selected=TRUE;
        
        personal_data=FALSE;
        family_data=FALSE;
        health_data=FALSE;
        finance_data=FALSE;
        work_data=TRUE;
        
        work_array=[[NSMutableArray alloc] initWithObjects:@"Admin",@"Finance",@"Personnel",@"Sales",nil];
        personal_array=[[NSMutableArray alloc] initWithObjects:@"Relaxation",@"Vacation",@"Hobbies",@"Educational",@"Spiritual",nil];
        family_array=[[NSMutableArray alloc]initWithObjects:@"Partner",@"Activities",nil];
        health_array=[[NSMutableArray alloc]initWithObjects:@"Exercise",@"Nutrition",@"Medical",nil ];
        finance_array=[[NSMutableArray alloc]initWithObjects:@"Banking",@"Bill Pay",@"Credit Cards",@"Taxes",@"Retirement",@"Saving",nil];
        
        [tbl reloadData];
        workbtn =[[UIButton alloc] init];
        workbtn.frame=CGRectMake(10,130, 60, 15);
        [workbtn setTitle:@"Work" forState:UIControlStateNormal];
        [workbtn addTarget:self action:@selector(clickOnWork:) forControlEvents:UIControlEventTouchUpInside];
        
        
        personalbtn = [[UIButton alloc]init];
        personalbtn.frame=CGRectMake(15,170, 80, 15);
        [personalbtn setTitle:@"Personal" forState:UIControlStateNormal];
        [personalbtn addTarget:self action:@selector(clickOnPersonal:) forControlEvents:UIControlEventTouchUpInside];
        
        familybtn = [[UIButton alloc]init];
        familybtn.frame=CGRectMake(10,210, 80, 15);
        [familybtn setTitle:@"Family" forState:UIControlStateNormal];
        [familybtn addTarget:self action:@selector(clickOnFamily:) forControlEvents:UIControlEventTouchUpInside];
        
        
        healthbtn = [[UIButton alloc]init];
        healthbtn.frame=CGRectMake(10,250, 80, 15);
        [healthbtn setTitle:@"Health" forState:UIControlStateNormal];
        [healthbtn addTarget:self action:@selector(clickOnHealth:) forControlEvents:UIControlEventTouchUpInside];
        
        financebtn = [[UIButton alloc]init];
        financebtn.frame=CGRectMake(15, 290, 80, 15);
        [financebtn setTitle:@"Finance" forState:UIControlStateNormal];
        [financebtn addTarget:self action:@selector(clickOnFinance:) forControlEvents:UIControlEventTouchUpInside];
        
}


#pragma mark iboutlets
-(IBAction)onClickDismiss:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
    

-(IBAction)taskbuttonClicked:(id)sender
{
	if(taskbutton.selected == TRUE)
	{
        taskbutton.selected = FALSE;
        //taskbutton.hidden=TRUE;
        //donebtn.hidden=FALSE;
        workbtn.hidden=FALSE;
        personalbtn.hidden=FALSE;
        familybtn.hidden=FALSE;
        healthbtn.hidden=FALSE;
        financebtn.hidden=FALSE;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:view3 cache:YES];
		view1.frame=CGRectMake(230,0,90, 460);
        //workbtn=[[UIButton alloc]initWithFrame:CGRectMake(725,290, 20, 40)];
        
        [view1 addSubview:workbtn];
        [view1 addSubview:personalbtn];
        [view1 addSubview:familybtn];
        [view1 addSubview:healthbtn];
        [view1 addSubview:financebtn];
        //[view3 addSubview:donebtn];
        //[view4 removeFromSuperview];
        [UIView commitAnimations];
	}
	else if(taskbutton.selected == FALSE)
	{
		taskbutton.selected = TRUE;
		taskbutton.hidden=FALSE;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		
		//donebtn.hidden=TRUE;
		workbtn.hidden=TRUE;
		personalbtn.hidden=TRUE;
		familybtn.hidden=TRUE;
		healthbtn.hidden=TRUE;
		financebtn.hidden=TRUE;
		view1.frame=CGRectMake(290, 0, 30, 460);
		[UIView commitAnimations];
		
	}
	
}
-(IBAction)clickOnWork:(id)sender
{
	personal_data=FALSE;
	family_data=FALSE;
	health_data=FALSE;
	finance_data=FALSE;
	work_data=TRUE;
	[tbl reloadData];
}

-(IBAction)clickOnPersonal:(id)sender
{
	//personal_data=FALSE;
	work_data=FALSE;
    
	family_data=FALSE;
	health_data=FALSE;
	finance_data=FALSE;
	personal_data=TRUE;
	[tbl reloadData];
}


-(IBAction)clickOnFamily:(id)sender
{
	work_data=FALSE;
    
	personal_data=FALSE;
	//family_data=FALSE;
	health_data=FALSE;
	finance_data=FALSE;
	family_data=TRUE;
	[tbl reloadData];
}


-(IBAction)clickOnHealth:(id)sender
{
	work_data=FALSE;
    
	personal_data=FALSE;
	family_data=FALSE;
	//health_data=FALSE;
	finance_data=FALSE;
	health_data=TRUE;
	[tbl reloadData];
}

-(IBAction)clickOnFinance:(id)sender
{
	work_data=FALSE;
    
	personal_data=FALSE;
	family_data=FALSE;
	health_data=FALSE;
	//finance_data=FALSE;
	finance_data=TRUE;
	[tbl reloadData];
}

-(IBAction)clickOnEditBtn:(id)sender
{
	if(self.editing)
	{ 
		[super setEditing:NO animated:NO]; 
		[tbl setEditing:NO animated:NO];
		[tbl reloadData];
		[editBtn setTitle:@"Edit" forState:UIControlStateNormal];
		//self.navigationItem.leftBarButtonItem.enabled=TRUE;
		
	}
	else
	{
		[super setEditing:YES animated:YES]; 
		[tbl setEditing:YES animated:YES];
		[tbl reloadData];
		[editBtn setTitle:@"Done" forState:UIControlStateNormal];
		
		//[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
		//self.navigationItem.leftBarButtonItem.enabled=TRUE;
		
	}
}

-(IBAction)changeSegment
{
	if(segment.selectedSegmentIndex == 0)
	{
        taskbutton.enabled=TRUE;
		tbl.hidden= FALSE;
		[tbl reloadData];
		scroll.hidden= TRUE;
		view_cal.hidden = TRUE;
        editBtn.hidden=FALSE;
	}
	else if(segment.selectedSegmentIndex == 1)
	{
        taskbutton.enabled=FALSE;
		tbl.hidden = TRUE;
		scroll.hidden = FALSE;
		view_cal.hidden = FALSE;
		scroll.delegate=self;
        editBtn.hidden=TRUE;
		[self.view addSubview:view_cal];
		[view_cal addSubview:scroll];
        NSDate *yourDate=[NSDate date];
		
		float s=7000;
		float h=0;
		float heightSC=0;
		for(int i=0;i<=11;i++){
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
			//h=calendar1.frame.size.height;
			// now build a NSDate object for the next day
			NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
			[offsetComponents setMonth:-1];
			NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
			//NSLog(@"%@",nextDate);
			[calendar1 selectDate:nextDate];
			s=s-calendar1.frame.size.height;
			UIView *view_c=[[UIView alloc]initWithFrame:CGRectMake(0, s, 272, calendar1.frame.size.height)];
			//NSLog(@"view start is %@",view_c);
			//[self.view addSubview:scroll];
			//[view2 addSubview:calendar1];
			//[scroll addSubview:view2];
			
			//NSLog(@"height is %f",calendar1.frame.size.height);
			
			//NSLog(@"s is %f",s);
			
			
			yourDate=nextDate;
			
			//scroll.contentSize=CGSizeMake(150, 300+(300*i));
			CGPoint currentOff = scroll.contentOffset;
			currentOff.y+=3250*i;
			[scroll setContentOffset:currentOff animated: YES];
			
			[view_c release];
			[calendar1 release];
			
			heightSC=heightSC+calendar1.frame.size.height;
			
		}
		//NSLog(@"hellop %f",heightSC);
		yourDate=[NSDate date];
		s=3244;
		for(int i=11;i>=0;i--){
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
			//h=calendar1.frame.size.height;
			// now build a NSDate object for the next day
			NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
			[offsetComponents setMonth:-1];
			NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
			//NSLog(@"%@",nextDate);
			[calendar1 selectDate:nextDate];
			s=s-calendar1.frame.size.height;
			UIView *view_c=[[UIView alloc]initWithFrame:CGRectMake(0, s, 272, calendar1.frame.size.height
                                                                   )];
			//NSLog(@"view start is %@",view_c);
			[self.view addSubview:scroll];
			[view_c addSubview:calendar1];
			[scroll addSubview:view_c];
			
			//NSLog(@"height is %f",calendar1.frame.size.height);
			
			//NSLog(@"s is %f",s);
			
			
			yourDate=nextDate;
			CGPoint currentOff = scroll.contentOffset;
			currentOff.y+=3250*i;
			[scroll setContentOffset:currentOff animated: YES];
			//scroll.contentSize=CGSizeMake(150, 300+(300*i));
			
			[view_c release];
			[calendar1 release];
			
		}
		
		//NSLog(@"s out is %f",s);
		yourDate=[NSDate date];
		s=3244;
		for(int i=11;i<=23;i++){
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
			
			// now build a NSDate object for the next day
			NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
			[offsetComponents setMonth:1];
			NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
			//NSLog(@"%@",nextDate);
			if(i==11){
				nextDate=yourDate;
				//s=s+calendar1.frame.size.height;
			}
			[calendar1 selectDate:nextDate];
			
			UIView *view_c=[[UIView alloc]initWithFrame:CGRectMake(0, s, 272, calendar1.frame.size.height
                                                                   )]; 
			
            
			s=s+calendar1.frame.size.height;
			
			
			//NSLog(@"calendar is %@",calendar1);
			//NSLog(@"view in 2 is %@",view_c);
			[self.view addSubview:view_c];
			[scroll addSubview:view_c];
			[view_c addSubview:calendar1];
			
			yourDate=nextDate;
			
			//scroll.contentSize=CGSizeMake(150, 300+(300*i));
			[view_c release];
			[calendar1 release];
			
		}
		scroll.contentSize=CGSizeMake(150, 7000);
	}

   	
}
#pragma mark -
#pragma mark TKCalendarMonthViewDelegate methods

- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d {
	NSLog(@"d is %@",d);
    
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
					 @"2011-01-01 00:00:00 +0000", @"2011-01-09 00:00:00 +0000", @"2011-01-22 00:00:00 +0000",
					 @"2011-01-10 00:00:00 +0000", @"2011-01-11 00:00:00 +0000", @"2011-01-12 00:00:00 +0000",
					 @"2011-01-15 00:00:00 +0000", @"2011-01-28 00:00:00 +0000", @"2011-01-04 00:00:00 +0000",					 
					 @"2011-01-16 00:00:00 +0000", @"2011-01-18 00:00:00 +0000", @"2011-01-19 00:00:00 +0000",					 
					 @"2011-01-23 00:00:00 +0000", @"2011-01-24 00:00:00 +0000", @"2011-01-25 00:00:00 +0000",					 					 
					 @"2011-02-01 00:00:00 +0000", @"2011-03-01 00:00:00 +0000", @"2011-04-01 00:00:00 +0000",
					 @"2011-05-01 00:00:00 +0000", @"2011-06-01 00:00:00 +0000", @"2011-07-01 00:00:00 +0000",
					 @"2011-08-01 00:00:00 +0000", @"2011-09-01 00:00:00 +0000", @"2011-10-01 00:00:00 +0000",
					 @"2011-11-01 00:00:00 +0000", @"2011-12-01 00:00:00 +0000", nil]; 
	
	
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



#pragma mark table delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if(personal_data == TRUE)
    {
        return [personal_array count];
    }
    else if(family_data ==TRUE)
    {
        return [family_array count];
    }
    else if(health_data == TRUE)
    {
        return [health_array count];
    }
    else if(finance_data ==TRUE)
    {
        return [finance_array count];
    }
    else if(work_data == TRUE)
    {
        return [work_array count];
    }
    
    else
    {
		return [work_array count];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if(personal_data == TRUE)
    {
        cell.textLabel.text=[personal_array objectAtIndex:indexPath.row];
    }
    else if (family_data == TRUE)
    {
        cell.textLabel.text=[family_array objectAtIndex:indexPath.row];
    }
    else if(health_data ==TRUE)
    {
        cell.textLabel.text=[health_array objectAtIndex:indexPath.row];
    }
    else if(finance_data ==TRUE)
    {
        cell.textLabel.text=[finance_array objectAtIndex:indexPath.row];
    }
    else if(work_data ==TRUE)
    {
        cell.textLabel.text=[work_array objectAtIndex:indexPath.row];
    }
    
    else
    {
		cell.textLabel.text=[work_array objectAtIndex:indexPath.row];
    }		
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
          if (editingStyle == UITableViewCellEditingStyleDelete)
          {
            // Delete the row from the data source.
            if(work_data ==TRUE)
            {
                [work_array removeObjectAtIndex:indexPath.row];
                [tbl reloadData];
            }
            else if(personal_data == TRUE)
            {
                [personal_array removeObjectAtIndex:indexPath.row];
                [tbl reloadData];
            }
            
            else if(family_data == TRUE)
            {
                [family_array removeObjectAtIndex:indexPath.row];
                [tbl reloadData];
            }
            else if(health_data == TRUE)
            {
                [health_array removeObjectAtIndex:indexPath.row];
                [tbl reloadData];
            }
            else if(finance_data == TRUE)
            {
                [finance_array removeObjectAtIndex:indexPath.row];
                [tbl reloadData];
            }
            
        }   
        else if (editingStyle == UITableViewCellEditingStyleInsert)
        {
            
        }

}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
{
			if(work_data == TRUE)
		{
			NSString *item = [[work_array objectAtIndex:sourceIndexPath.row] retain];
			[work_array removeObject:item];
			[work_array insertObject:item atIndex:destinationIndexPath.row];
			[item release];
		}
		if(personal_data == TRUE)
		{
			NSString *item = [[personal_array objectAtIndex:sourceIndexPath.row] retain];
			[personal_array removeObject:item];
			[personal_array insertObject:item atIndex:destinationIndexPath.row];
			[item release];
		}
		if(family_data ==TRUE)
		{
			NSString *item = [[family_array objectAtIndex:sourceIndexPath.row] retain];
			[family_array removeObject:item];
			[family_array insertObject:item atIndex:destinationIndexPath.row];
			[item release];
		}
		if(health_data ==TRUE)
		{
			NSString *item = [[health_array objectAtIndex:sourceIndexPath.row] retain];
			[health_array removeObject:item];
			[health_array insertObject:item atIndex:destinationIndexPath.row];
			[item release];
		}
		if(finance_data == TRUE)
		{
			NSString *item = [[finance_array objectAtIndex:sourceIndexPath.row] retain];
			[finance_array removeObject:item];
			[finance_array insertObject:item atIndex:destinationIndexPath.row];
			[item release];
		}

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

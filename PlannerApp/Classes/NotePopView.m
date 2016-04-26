//
//  NotePopView.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "NotePopView.h"
#import "DAL.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PlannerAppAppDelegate.h"
@implementation NotePopView

@synthesize strMtid,strStid,strCid;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Add Note";
	appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication]delegate];
    dal=[[DAL alloc] initDatabase:@"Planner.sqlite"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.contentSizeForViewInPopover=CGSizeMake(320, 300);
    NSArray *arrNote=[[[NSArray alloc] initWithObjects:@"note", nil] autorelease];
    NSMutableArray *arrret=[[[NSMutableArray alloc] init] autorelease];
    if(strMtid){
        NSLog(@"%@",strMtid);
      arrret=  [dal SelectQuery:@"tblMainTask" withColumn:arrNote withCondition:@"mtid=" withColumnValue:[NSString stringWithFormat:@"%@",strMtid]];
        NSLog(@"%@",arrret);
        txtView.text=[[arrret objectAtIndex:0] valueForKey:@"note"];
        
    }
    else if(strCid){
        arrret=  [dal SelectQuery:@"tblCal" withColumn:arrNote withCondition:@"cid=" withColumnValue:[NSString stringWithFormat:@"%@",strCid]];
        NSLog(@"%@",arrret);
        txtView.text=[[arrret objectAtIndex:0] valueForKey:@"note"];
    }
    else{
        arrret=  [dal SelectQuery:@"tblSubTask" withColumn:arrNote withCondition:@"stid=" withColumnValue:[NSString stringWithFormat:@"%@",strStid]];
        NSLog(@"%@",arrret);
        txtView.text=[[arrret objectAtIndex:0] valueForKey:@"note"];
    }
    
    
       
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(appdel.sound==1){
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/smooth_button_click01.wav"];
    
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    //Use audio sevices to create the sound
    
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    
    //Use audio services to play the sound
    
    AudioServicesPlaySystemSound(soundID);
    }
    return YES;
}

-(IBAction)clickOnDone:(id)sender
{
    NSMutableDictionary *dictNote=[[NSMutableDictionary alloc] init];
    if(strMtid){
    [dictNote setObject:[NSString stringWithFormat:@"%@",txtView.text] forKey:@"note"];
        
        [dal updateRecord:dictNote forID:@"mtid=" inTable:@"tblMainTask" withValue:[NSString stringWithFormat:@"%@",strMtid]];
        
    }
    else if(strCid){
        [dictNote setObject:[NSString stringWithFormat:@"%@",txtView.text] forKey:@"note"];
        
        [dal updateRecord:dictNote forID:@"cid=" inTable:@"tblCal" withValue:[NSString stringWithFormat:@"%@",strCid]];
    }
    else{
        [dictNote setObject:[NSString stringWithFormat:@"%@",txtView.text] forKey:@"note"];
        [dal updateRecord:dictNote forID:@"stid=" inTable:@"tblSubTask" withValue:[NSString stringWithFormat:@"%@",strStid]];
        
    }
    if(dictNote!=nil){
        [dictNote removeAllObjects];
        [dictNote release];
        dictNote=nil;
    }
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

//
//  SplashScreen.m
//  PlannerApp
//
//  Created by Openxcell on 8/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SplashScreen.h"

@implementation SplashScreen

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
    appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *strColor=[[NSUserDefaults standardUserDefaults]valueForKey:@"color"];
    if([strColor isEqualToString:@"yellow"]){
        splashScreen.image=[UIImage imageNamed:@"splash-screen_Beige.png"];
    }
    else if([strColor isEqualToString:@"pink"]){
        splashScreen.image=[UIImage imageNamed:@"splash-screen_PINK.png"];
    }
    else if([strColor isEqualToString:@"blue"]){
        splashScreen.image=[UIImage imageNamed:@"splash-screen_Blue.png"];
    }
    else{
        splashScreen.image=[UIImage imageNamed:@"splash-screen.png"];
    }
    
    [self performSelector:@selector(callMethod) withObject:self afterDelay:2.0];
    // Do any additional setup after loading the view from its nib.
}
-(void)callMethod{
    [appdel removeSplash];
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
	return YES;
}

@end

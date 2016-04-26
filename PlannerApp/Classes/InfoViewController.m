//
//  InfoViewController.m
//  PlannerApp
//
//  Created by Openxcell on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import "TestClassFragmented.h"
#import "BarTestClass.h"
@implementation InfoViewController

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
    //TestClassFragmented *rootController=[[TestClassFragmented alloc]init];
   
    BarTestClass *rootController=[[BarTestClass alloc]init]; 
    [self.view addSubview:rootController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
     self.navigationController.navigationBar.hidden=FALSE;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end

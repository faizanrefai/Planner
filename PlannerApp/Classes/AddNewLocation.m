//  AddNewLocation.m
//  PlannerApp
//
//  Created by Openxcell on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddNewLocation.h"
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
@implementation AddNewLocation

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
    appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication] delegate];
    array=[[NSMutableArray alloc] initWithObjects:@"Type",@"Name",@"Address",@"Category",@"Distance", nil];
    [tblLocation setBackgroundView:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    //self.navigationController.navigationBarHidden=FALSE;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    
    if(indexPath.row==0){
        cell.textLabel.text=[array objectAtIndex:indexPath.row];
        if (!txtType) {
            txtType=[[UITextField alloc]initWithFrame:CGRectMake(150, 10, 300, 44)];
            txtType.delegate=self;
            txtType.placeholder=@"Enter";
            txtType.tag=indexPath.row;
            txtType.text=strStr;
            [cell.contentView addSubview:txtType];
        }else
        {
            
        }
        
    }
    else if([[array objectAtIndex:indexPath.row] isEqualToString:@"Category"]){
        
        cell.textLabel.text=[array objectAtIndex:indexPath.row];
        txtCategory=[[UITextField alloc]initWithFrame:CGRectMake(150, 10, 300, 44)];
        txtCategory.delegate=self;
        txtCategory.placeholder=@"Enter";
        txtCategory.tag=indexPath.row;
        
        [cell.contentView addSubview:txtCategory];
        
    }
    else   
    {
        txt=[[UITextField alloc]initWithFrame:CGRectMake(150, 10, 300, 44)];
        txt.delegate=self;
        txt.placeholder=@"Enter";
        txt.tag=indexPath.row;
        
        [cell.contentView addSubview:txt];
        cell.textLabel.text=[array objectAtIndex:indexPath.row];
        [txt release];
    }
    NSLog(@"%d %d",indexPath.row,[array count]-1);
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn addTarget:self 
            action:@selector(addLocation:)
  forControlEvents:UIControlEventTouchDown];
    [btn setTitle:@"Add" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 50, 120, 40);
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(244, 0, 280, 100)];
    [footerView addSubview:btn];
    
    
    tableView.tableFooterView = footerView; 
    [footerView release];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    
    return cell;
}
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    
    if(textField==txtType){
        
        
        [txt resignFirstResponder];
        appdel.isColor=TRUE;
        objLocatiobType=[[LocationType alloc]initWithNibName:@"LocationType" bundle:nil];
        [objLocatiobType setParent:self];
        popView = [[UIPopoverController alloc] initWithContentViewController:objLocatiobType];
        popView.delegate = self;
        
        //NSLog(@"%d",i);
        
        
        [popView presentPopoverFromRect:textField.frame inView:tblLocation permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
        
    }
    if(textField==txtCategory){
        
        
        NSLog(@"category tag %d",txtCategory.tag);
        [txtCategory resignFirstResponder];
        appdel.isColor=FALSE;
        objLocatiobType=[[LocationType alloc]initWithNibName:@"LocationType" bundle:nil];
        [objLocatiobType setParent:self];
        popView = [[UIPopoverController alloc] initWithContentViewController:objLocatiobType];
        popView.delegate = self;
        
        if ([txtCategory tag]==4) {
            
            [popView presentPopoverFromRect:CGRectMake(300, 210, 20, 25) inView:tblLocation permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }else if([txtCategory tag]==5)
        {
            
            [popView presentPopoverFromRect:CGRectMake(300, 258, 20, 25) inView:tblLocation permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else if([txtCategory tag]==3)
        {
            
            [popView presentPopoverFromRect:CGRectMake(300, 170, 20, 25) inView:tblLocation permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
        
    }
}
-(void)CallMehtod:(NSString *)str{
    
    [popView dismissPopoverAnimated:YES];
    NSLog(@"str %@",str);
    
    strStr=[str retain];
    if(appdel.isColor){
        
        
        if([str isEqualToString:@"Home & Office"]){
            
            [array removeAllObjects];
            array=[[NSMutableArray alloc] initWithObjects:@"Type",@"Address",@"City",@"State",@"Category",@"Distance", nil];
            
            [tblLocation reloadData];
            
            [txtType setText:str];
        }
        else if([str isEqualToString:@"School & Medical"]){
            [array removeAllObjects];
            array=[[NSMutableArray alloc] initWithObjects:@"Type",@"Name",@"Address",@"City",@"State",@"Category",@"Distance", nil];
            
            [tblLocation reloadData];
            
            [txtType setText:str];
        }
        else{
            [array removeAllObjects];
            array=[[NSMutableArray alloc] initWithObjects:@"Type",@"Vendor",@"Address",@"City",@"State",@"Category",@"Distance", nil];
            
            [tblLocation reloadData];
            
            [txtType setText:str];
        }
    }
    else{
        
        [txtCategory setText:str];
    }    
    
}
-(IBAction)addLocation:(id)sender{
    //[appdel.dict setObject:txtType.text forKey:@"LocationType"];
    // [appdel.dict setObject:txtName.text forKey:@"LocationName"];
    // [appdel.dict setObject:txtAddress.text forKey:@"LocationAddress"];
    // [appdel.dict setObject:txtCategory.text forKey:@"LocationCategory"];
    //[appdel.dict setObject:txtDistance.text forKey:@"LocationDist"];
    NSLog(@"%@",appdel.dict);
    
    appdel.str=[NSString stringWithFormat:@"%@",txt.text];
    [appdel.array addObject:appdel.dict];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)backButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
- (void)dealloc {
    [super dealloc];
    [btn release];
    [txtCategory release];
    [txtfield release];
    [txtType release];
}

@end
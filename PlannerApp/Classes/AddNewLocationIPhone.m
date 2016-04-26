//
//  AddNewLocationIPhone.m
//  PlannerApp
//
//  Created by Openxcell on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddNewLocationIPhone.h"

@implementation AddNewLocationIPhone
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;

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
    array=[[NSArray alloc] initWithObjects:@"Type",@"Name",@"Address",@"Category",@"Distance",@"", nil];
    arrType=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    pickerCat.hidden=TRUE;
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text=[array objectAtIndex:indexPath.row];
	
    if(indexPath.row==0){
        txtType=[[UITextField alloc]initWithFrame:CGRectMake(150, 10, 200, 44)];
        txtType.delegate=self;
        txtType.placeholder=@"Enter here";
        txtType.tag=indexPath.row;
        [cell.contentView addSubview:txtType];
		
    }
    else if(indexPath.row==3){
        txtCategory=[[UITextField alloc]initWithFrame:CGRectMake(150, 10, 200, 44)];
        txtCategory.delegate=self;
        txtCategory.placeholder=@"Enter here";
        txtCategory.tag=indexPath.row;
        [cell.contentView addSubview:txtCategory];
    }
    else if(indexPath.row==4){
        txtDistance=[[UITextField alloc]initWithFrame:CGRectMake(150, 10, 200, 44)];
        txtDistance.delegate=self;
        txtDistance.placeholder=@"Enter here";
        txtDistance.tag=indexPath.row;
        [cell.contentView addSubview:txtDistance];
    }

	
    else if(indexPath.row == 1)  
	{
		txtName=[[UITextField alloc]initWithFrame:CGRectMake(150, 10, 200, 44)];
		txtName.delegate=self;
		txtName.placeholder=@"Enter here";
		txtName.tag=indexPath.row;
		[cell.contentView addSubview:txtName];
    }
	else if(indexPath.row == 2)
	{
		txtAddress=[[UITextField alloc]initWithFrame:CGRectMake(150, 10, 200, 44)];
		txtAddress.delegate=self;
		txtAddress.placeholder=@"Enter here";
		txtAddress.tag=indexPath.row;
		[cell.contentView addSubview:txtAddress];
		
	}
	else if(indexPath.row == 5)
	{
		btnAdd = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[btnAdd addTarget:self 
				action:@selector(addLocation:)
	  forControlEvents:UIControlEventTouchUpInside];
		[btnAdd setTitle:@"Add" forState:UIControlStateNormal];
		btnAdd.frame = CGRectMake(120, 4.5, 50.0, 35.0);
        [cell.contentView addSubview:btnAdd];
		
		
	}
	
	
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    // Configure the cell...
    
    return cell;
}
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    CGRect textFieldRect =[self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =[self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 1.0 * textFieldRect.size.height;
    CGFloat numerator =midline - viewRect.origin.y- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)* viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    animatedDistance = floor(162.0 * heightFraction);
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
   
    if(textField==txtType){
        
        [txtType resignFirstResponder];
		appdel.isColor=TRUE;

        
        
    }
    if(textField==txtCategory){
        [txtCategory resignFirstResponder];
        appdel.isColor=FALSE;
       
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [txtCategory resignFirstResponder];
    [txtType resignFirstResponder];
    [txtName resignFirstResponder];
    [txtDistance resignFirstResponder];
    [txtAddress resignFirstResponder];

    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [txtCategory resignFirstResponder];
    [txtType resignFirstResponder];
    [txtName resignFirstResponder];
    [txtDistance resignFirstResponder];
    [txtAddress resignFirstResponder];
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
-(void)CallMehtod:(NSString *)str{
    
    NSLog(@"str %@",str);
    if(appdel.isColor)
		[txtType setText:str];
    else
        [txtCategory setText:str];
    
}
-(IBAction)addLocation:(id)sender{
    //[appdel.dict setObject:txtType.text forKey:@"LocationType"];
	// [appdel.dict setObject:txtName.text forKey:@"LocationName"];
	// [appdel.dict setObject:txtAddress.text forKey:@"LocationAddress"];
	// [appdel.dict setObject:txtCategory.text forKey:@"LocationCategory"];
    //[appdel.dict setObject:txtDistance.text forKey:@"LocationDist"];
    NSLog(@"%@",appdel.dict);
	
    appdel.str=[NSString stringWithFormat:@"%@",txtName.text];
    [appdel.array addObject:appdel.dict];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma picker
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:txtType])
    {
        
        if (!actionSheetType)
        {
            arrType=[[NSMutableArray alloc] initWithObjects:@"Home",
                             @"Office",
                             @"Store",
                             @"School", 
                             @"Bank",
                             @"Medical",
                             @"Restaurant",
                             @"Auto",
                             @"Other", nil];
            actionSheetType = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            [actionSheetType setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
            
            CGRect pickerFrame;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                pickerFrame = CGRectMake(0, 40, 768, 300);
            else
                pickerFrame = CGRectMake(0, 40, 320, 200);
            
            pickerType = [[UIPickerView alloc] initWithFrame:pickerFrame];
            pickerType.showsSelectionIndicator = YES;
            pickerType.userInteractionEnabled = TRUE;
            pickerType.dataSource = self;
            pickerType.delegate = self;
            [actionSheetType addSubview:pickerType];
            
            UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
            closeButton.momentary = YES;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                closeButton.frame = CGRectMake(700, 7.0f, 50.0f, 30.0f);
            else
                closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
            
            
            closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
            closeButton.tintColor = [UIColor blackColor];
            [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
            [actionSheetType addSubview:closeButton];
            [closeButton release];
            
            
            CGRect frame;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                frame = CGRectMake(self.view.frame.origin.x, 630, 768.0f,350.0f);
            else
                frame = CGRectMake(self.view.frame.origin.x, 200.0f, 480.0f,300.0f);
            
            [actionSheetType setFrame:frame];
            [self.view addSubview:actionSheetType];
            
            return NO;           
        }
    }
    if ([textField isEqual:txtCategory])
    {
        
        if (!actionSheetCat)
        {
            [txtCategory resignFirstResponder];
            arrType=[[NSMutableArray alloc] initWithObjects:@"Specific",
                             @"Any Location",
                             @"Any",
                             nil];

            actionSheetCat = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
            [actionSheetCat setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
            
            CGRect pickerFrame;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                pickerFrame = CGRectMake(0, 40, 768, 300);
            else
                pickerFrame = CGRectMake(0, 40, 320, 200);
            
            pickerCat = [[UIPickerView alloc] initWithFrame:pickerFrame];
            pickerCat.userInteractionEnabled = TRUE;
            pickerCat.dataSource = self;
            pickerCat.delegate = self;
            [pickerCat setShowsSelectionIndicator:YES];
            [actionSheetCat addSubview:pickerCat];
            
            UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
            closeButton.momentary = YES;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                closeButton.frame = CGRectMake(700, 7.0f, 50.0f, 30.0f);
            else
                closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
            
            
            closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
            closeButton.tintColor = [UIColor blackColor];
            [closeButton addTarget:self action:@selector(dismissActionSheet) forControlEvents:UIControlEventValueChanged];
            [actionSheetCat addSubview:closeButton];
            [closeButton release];
            
            
            CGRect frame;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                frame = CGRectMake(self.view.frame.origin.x, 630, 768.0f,350.0f);
            else
                frame = CGRectMake(self.view.frame.origin.x, 200, 480.0f,300.0f);
            
            [actionSheetCat setFrame:frame];
            [self.view addSubview:actionSheetCat];
            
            return NO;           
        }
    }

    else {
        pickerCat.hidden=TRUE;
        pickerType.hidden=TRUE;
        return YES;
    }
    return 0;
}

-(void)dismissActionSheet
{
    if (actionSheetType)
    {
        if ([txtType.text isEqualToString:@""])
        {
            txtType.text=[NSString stringWithFormat:@"%@",[arrType objectAtIndex:0]];
        }       
    }
    if (actionSheetCat)
    {
        if ([txtCategory.text isEqualToString:@""])
        {
            txtCategory.text=[NSString stringWithFormat:@"%@",[arrType objectAtIndex:0]];
        }       
    }

    actionSheetType.hidden = TRUE;
    
    [actionSheetType release];
    actionSheetType=nil;
    actionSheetCat.hidden = TRUE;
    
    [actionSheetCat release];
    actionSheetCat=nil;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == pickerType || pickerView==pickerCat) {
        return 1;
    }
    
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView == pickerType)
    {
        NSString *a =  [arrType objectAtIndex:row];
        txtType.text= [NSString stringWithFormat:@"%@",a];
    }
    if (pickerView == pickerCat)
    {
        NSString *a =  [arrType objectAtIndex:row];
        txtCategory.text= [NSString stringWithFormat:@"%@",a];
    }
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

{
    if(pickerView == pickerType)
    {
        if (component==0)
        {
            return [arrType count];
        }
    }
    if(pickerView == pickerCat)
    {
        if (component==0)
        {
            return [arrType count];
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

{
    if(pickerView == pickerType || pickerView==pickerCat)
    {
        if (component==0)
        {
            return [arrType objectAtIndex:row];
        }
    }
    return 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end

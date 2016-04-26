//
//  RepeatsPopView.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RepeatsPopView.h"
#import "Repeat_days.h"


@implementation RepeatsPopView
@synthesize repeat_text,start_text,after_text,on_text;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    picker_text.hidden=TRUE;
    pickerRepeat.hidden=TRUE;
    
	self.title = @"Repeats";
    day_array=[[NSMutableArray alloc] initWithObjects:@"Daily",@"Every WeekDay(Mon-Fri)",@"Every Mon.,Wed.,Fri.",@"Every Tues. and Thurs..",@"Weekly",@"Monthly",@"Yearly",nil];
	btn_mon.selected = TRUE;
	btn_tue.selected = TRUE;
	btn_wed.selected = TRUE;
	btn_thu.selected = TRUE;
	btn_fri.selected = TRUE;
	btn_sat.selected = TRUE;
	btn_sun.selected = TRUE;
	self.contentSizeForViewInPopover=CGSizeMake(320, 460);
	picker.hidden =TRUE;
	tool.hidden = TRUE;
	NSDate *now = [NSDate date];
	
    [picker setDate:now animated:YES];
	
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    repeat_text.text=[day_array objectAtIndex:4];
    viewYear.hidden=TRUE;

}
- (void)addItemViewController:(Repeat_days *)controller didFinishEnteringItem:(NSString *)item
{
   
    [item retain];
    [repeatsON setText:item];
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{	
    if(textField == repeat_text)
	{
        pickerRepeat.hidden=FALSE;
        tool.hidden=FALSE;
        picker.hidden=TRUE;
        k=1;
        return NO;
    }
    else if(textField == start_text)
    {
                k=2;
                picker_text.hidden=TRUE;
        		tool.hidden = FALSE;
        		picker.hidden=FALSE;
        		[textField resignFirstResponder];
        return NO;
    }
    else if(textField == repeatsON){
        [repeatsON resignFirstResponder];
        Repeat_days *objRepeat=[[Repeat_days alloc] initWithNibName:@"Repeat_days" bundle:nil];
        objRepeat.delegate=self;
        [self.navigationController pushViewController:objRepeat animated:YES];
        [objRepeat release];
        return NO;
       
        
    }
    else {
        return YES;
    }

	
	
}
    
    
- (void)textFieldDidEndEditing:(UITextField *)textField 
{
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//	tool.hidden = YES;
//	picker.hidden=YES;
//	[textField resignFirstResponder];
//	//[to resignFirstResponder];
//	return YES;	
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	//[to resignFirstResponder];
	return NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	tool.hidden =YES;
	picker.hidden=YES;
	[start_text resignFirstResponder];
}

-(IBAction)showdate:(id)sender
{
	[start_text resignFirstResponder];
    NSDate *selected = [picker date];
    self.start_text.text = [NSString stringWithFormat:@"%@",selected];
}



#pragma mark IBOutlet

-(IBAction)clickOnDone:(id)sender
{
	[start_text resignFirstResponder];
    [repeat_text resignFirstResponder];
    if(k==1)
    {
        tool.hidden=TRUE;
        pickerRepeat.hidden=TRUE;
    }
    else if(k == 2)
    {
        tool.hidden = TRUE;
        picker.hidden = TRUE;
    }
	
}

-(IBAction)neverClicked:(id)sender
{
	[btn_never setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateNormal];
	[btn_after setImage:[UIImage imageNamed:@"UnChecked.png"] forState:UIControlStateNormal];
	[btn_on setImage:[UIImage imageNamed:@"UnChecked.png"] forState:UIControlStateNormal];

}

-(IBAction)onClicked:(id)sender
{
	
		[btn_never setImage:[UIImage imageNamed:@"UnChecked.png"] forState:UIControlStateNormal];
		[btn_on setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateNormal];
		[btn_after setImage:[UIImage imageNamed:@"UnChecked.png"] forState:UIControlStateNormal];

}

-(IBAction)afterClicked:(id)sender
{
	[btn_never setImage:[UIImage imageNamed:@"UnChecked.png"] forState:UIControlStateNormal];
	[btn_on setImage:[UIImage imageNamed:@"UnChecked.png"] forState:UIControlStateNormal];
	[btn_after setImage:[UIImage imageNamed:@"Checked.png"] forState:UIControlStateNormal];
}


-(IBAction)monClicked:(id)sender
{
	if(btn_mon.selected == TRUE)
	{
		btn_mon.selected = FALSE;
		[btn_mon setImage:[UIImage imageNamed:@"checksymbol.png"] forState:UIControlStateNormal];
	}
	else if(btn_mon.selected == FALSE)
	{
		btn_mon.selected = TRUE;
		[btn_mon setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
	}
}
-(IBAction)tueClicked:(id)sender
{
	if(btn_tue.selected == TRUE)
	{
		btn_tue.selected = FALSE;
		[btn_tue setImage:[UIImage imageNamed:@"checksymbol.png"] forState:UIControlStateNormal];
	}
	else if(btn_tue.selected == FALSE)
	{
		btn_tue.selected = TRUE;
		[btn_tue setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
	}
}

-(IBAction)wedClicked:(id)sender
{
	if(btn_wed.selected == TRUE)
	{
		btn_wed.selected = FALSE;
		[btn_wed setImage:[UIImage imageNamed:@"checksymbol.png"] forState:UIControlStateNormal];
	}
	else if(btn_wed.selected == FALSE)
	{
		btn_wed.selected = TRUE;
		[btn_wed setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
	}
}

-(IBAction)thuClicked:(id)sender
{
	if(btn_thu.selected == TRUE)
	{
		btn_thu.selected = FALSE;
		[btn_thu setImage:[UIImage imageNamed:@"checksymbol.png"] forState:UIControlStateNormal];
	}
	else if(btn_thu.selected == FALSE)
	{
		btn_thu.selected = TRUE;
		[btn_thu setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
	}
}


-(IBAction)friClicked:(id)sender
{
	if(btn_fri.selected == TRUE)
	{
		btn_fri.selected = FALSE;
		[btn_fri setImage:[UIImage imageNamed:@"checksymbol.png"] forState:UIControlStateNormal];
	}
	else if(btn_fri.selected == FALSE)
	{
		btn_fri.selected = TRUE;
		[btn_fri setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
	}
}

-(IBAction)satClicked:(id)sender
{
	if(btn_sat.selected == TRUE)
	{
		btn_sat.selected = FALSE;
		[btn_sat setImage:[UIImage imageNamed:@"checksymbol.png"] forState:UIControlStateNormal];
	}
	else if(btn_sat.selected == FALSE)
	{
		btn_sat.selected = TRUE;
		[btn_sat setImage:[UIImage imageNamed:@"uncheck.png"]forState:UIControlStateNormal];
	}
}

-(IBAction)sunClicked:(id)sender
{
	if(btn_sun.selected == TRUE)
	{
		btn_sun.selected = FALSE;
		[btn_sun setImage:[UIImage imageNamed:@"checksymbol.png"] forState:UIControlStateNormal];
	}
	else if(btn_sun.selected == FALSE)
	{
		btn_sun.selected = TRUE;
		[btn_sun setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
	}
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView == pickerRepeat)
    {
        NSString *a =  [day_array objectAtIndex:row];
        repeat_text.text= [NSString stringWithFormat:@"%@",a];
    }
    if(row==0 || row==6){
        repeatsOn.hidden=TRUE;
        repeatsEvery.hidden=FALSE;
        viewYear.hidden=TRUE;
        repeatsEvery.frame=CGRectMake(0, 60, 320, 50);
        staticView.frame=CGRectMake(0, 120, 320, 300);
        
    }
    else if(row==1 || row==2 || row==3){
        repeatsOn.hidden=TRUE;
        repeatsEvery.hidden=TRUE;
        viewYear.hidden=TRUE;
        staticView.frame=CGRectMake(0, 60, 320, 300);
    }
    else if(row==4){
        repeatsOn.hidden=FALSE;
        repeatsEvery.hidden=FALSE;
        viewYear.hidden=TRUE;
        repeatsOn.frame=CGRectMake(0, 50, 320, 50);
        repeatsEvery.frame=CGRectMake(0, 110, 320, 50);
        staticView.frame=CGRectMake(0, 170, 320, 300);
    }
    else{
        repeatsOn.hidden=TRUE;
        repeatsEvery.hidden=FALSE;
        viewYear.hidden=FALSE;
        viewYear.frame=CGRectMake(0, 60, 320, 75);
        repeatsEvery.frame=CGRectMake(0, 145, 320, 50);
        staticView.frame=CGRectMake(0, 105, 320, 300);
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

{
    if(pickerView == pickerRepeat)
    {
        if (component==0)
        {
            return [day_array count];
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

{
    if(pickerView == pickerRepeat)
    {
        if (component==0)
        {
            return [day_array objectAtIndex:row];
        }
    }
    return 0;
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

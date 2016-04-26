//
//  DelegatePopView.m
//  PlannerApp
//
//  Created by openxcell tech.. on 2/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DelegatePopView.h"
#import "JSONParser.h"
#import "AlertHandler.h"

@implementation DelegatePopView
@synthesize strMID,strSID;
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
	self.title=@"Delegate";
	self.contentSizeForViewInPopover=CGSizeMake(320, 460);
	appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication]delegate];
    dal=[[DAL alloc] initDatabase:@"Planner.sqlite"];
}

-(IBAction)Click:(id)sender
{
	ABPeoplePickerNavigationController *picker =
	
	[[ABPeoplePickerNavigationController alloc] init];
	
	picker.peoplePickerDelegate = self;
	
	//[self.navigationController pushViewController:picker animated:YES];
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
		
}
//- (BOOL)peoplePickerNavigationController:
//
//(ABPeoplePickerNavigationController *)peoplePicker
//
//      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
//	
//	
//	
//    NSString* namestr = (NSString *)ABRecordCopyValue(person,
//												   
//												   kABPersonFirstNameProperty);
//	
//    name.text = namestr;
//	
//    //[name release];
//	
//	[namestr release];
//	
//   	
//    [self dismissModalViewControllerAnimated:YES];
//	
//	
//	
//    return NO;
//	
//}
- (void)peoplePickerNavigationControllerDidCancel:

(ABPeoplePickerNavigationController *)peoplePicker {
	
    [self dismissModalViewControllerAnimated:YES];
	
}



- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    ABMultiValueRef emails = ABRecordCopyValue(person, property);
    CFStringRef email = ABMultiValueCopyValueAtIndex(emails, identifier);
    NSLog( (NSString *) email);
    strEmail = (NSString *) email;
    [self dismissModalViewControllerAnimated:YES];
    
    
    [self findEmail];
    
    
    return NO;
}
-(void)findEmail{
    NSString *str;
    //http://openxcellaus.info/emainder/user_action.php?action=userlist
    str=[NSString stringWithFormat:@"%@/user_action.php?action=userlist",appdel.url];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchEmail:) andHandler:self];
    NSLog(@"%@",parser);
}
-(void)searchEmail:(NSDictionary*)dictionary{
    [AlertHandler hideAlert];
    NSLog(@"%@",dictionary);
    int flagemai=0;
    NSString *strUID;
    NSMutableArray *arrEmail=(NSMutableArray *)[dictionary valueForKey:@"users"];
    NSLog(@"%@",[arrEmail objectAtIndex:0]);
    for(int y=0;y<[arrEmail count];y++){
        if([[[arrEmail objectAtIndex:y] valueForKey:@"email"] isEqualToString:strEmail]){
            NSLog(@"found");
            flagemai=1;
            strUID=[[arrEmail objectAtIndex:y] valueForKey:@"uid"];
            
        }
    }
    if(flagemai==1){
        [self JSONDelegate:strEmail strid:strUID];
    }
    else{
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"The email address is not registered" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [alert show];
//        [alert release];
        NSMutableArray *arrRet;
        if(strMID){
            arrRet=[dal SelectWithStar:@"tblMainTask"];
        }
        else{
            arrRet=[dal SelectWithStar:@"tblSubTask"];
        }
        NSLog(@"arr ret is %@",[arrRet objectAtIndex:0]);
        
//        NSString *to=[NSString stringWithFormat:@"%@",strEmail];
//        NSString *subject=@"Task Delegated From Planner"; 
//        NSString *body=[NSString stringWithFormat:@"Task has been delegated to you %@ at %@",[[arrRet objectAtIndex:0] valueForKey:@"title"],[[arrRet objectAtIndex:0] valueForKey:@"alertTime"]];
//        NSString *str=[NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@", [to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], [body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
       
        NSString *body=[NSString stringWithFormat:@"Task has been delegated to you %@ at %@",[[arrRet objectAtIndex:0] valueForKey:@"title"],[[arrRet objectAtIndex:0] valueForKey:@"alertTime"]];
        mail=[[MFMailComposeViewController alloc]init];
        mail.mailComposeDelegate=self;
        
        [mail setToRecipients:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",strEmail], nil]];
        
        [mail setSubject:@"Task Delegated From Planner"];
        [mail setMessageBody:[NSString stringWithFormat:@"%@",body] isHTML:YES];
        [self presentModalViewController:mail animated:YES];
        //self.view=firstResponder;
        [mail resignFirstResponder];
        [mail respondsToSelector:@selector(set:)];
        [mail release];
       
        
        

        
    }
    
}
-(void)JSONDelegate:(NSString *)email strid:(NSString *)strid
{
    //http://openxcellaus.info/emainder/user_action.php?action=assign_sub_task&uid=1&auid=5&stid=26
    
    [AlertHandler showAlertForProcess];
    NSString *str;
    NSString *str_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"user_id"];
    if(strMID)
    str=[NSString stringWithFormat:@"%@/user_action.php?action=assign_task&uid=%@&auid=%@&mtid=%@",appdel.url,str_id,strid,strMID];
    else
        str=[NSString stringWithFormat:@"%@/user_action.php?action=assign_sub_task&uid=%@&auid=%@&stid=%@",appdel.url,str_id,strid,strSID];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchDelegate:) andHandler:self];
    NSLog(@"%@",parser);
    
	
}
-(void)searchDelegate:(NSDictionary*)dictionary
{
    [AlertHandler hideAlert];
    NSLog(@"%@",dictionary);
    if([[dictionary valueForKey:@"msg"]isEqualToString:@"task already assigned"]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"The task has been already assigned" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if([[dictionary valueForKey:@"msg"]isEqualToString:@"task assigned successfull"] && [[dictionary valueForKey:@"status"] isEqualToString:@"Notification sent succesfully"]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Task Delegated Successfully" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    else if([[dictionary valueForKey:@"msg"]isEqualToString:@"sub task assigned successfull"] && [[dictionary valueForKey:@"status"] isEqualToString:@"Notification sent succesfully"]){
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Task Delegated Successfully" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissPopOverViewHome" object:self]; 
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result" message:@"Mail Sent Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
   
    
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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

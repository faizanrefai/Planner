//
//  RegisterPage.m
//  PlannerApp
//
//  Created by openxcell tech.. on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegisterPage.h"
#import "AlertHandler.h"
#import <AudioToolbox/AudioToolbox.h>
@implementation RegisterPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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
-(void)playSoundOnButtonClick{
    if(appdel.sound==1){
    NSString *path = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], @"/smooth_button_click02.wav"];
    
    SystemSoundID soundID;
    
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    //Use audio sevices to create the sound
    
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    
    //Use audio services to play the sound
    
    AudioServicesPlaySystemSound(soundID);  
    }
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
    arrAge=[[NSArray alloc] initWithObjects:@"21 and Under",@"22 to 34",@"35 to 44",@"45 to 54",@"55 to 64",@"65 and Over",@"Decline", nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.navigationItem.hidesBackButton=YES;
    isCheck=YES;
    arrGender=[[NSMutableArray alloc] initWithObjects:@"0",@"0", nil];
    tblAge.hidden=YES;
    terms=0;
    //tblAge.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"regTblBG.png"]];
    lblAge.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
    NSString *strColor=[[NSUserDefaults standardUserDefaults]valueForKey:@"color"];
    if([strColor isEqualToString:@"yellow"]){
        imgBack.image=[UIImage imageNamed:@"background-login_beige.png"];
        
    }
    else if([strColor isEqualToString:@"pink"]){
        imgBack.image=[UIImage imageNamed:@"background-login_pink.png"];
    }
    else if([strColor isEqualToString:@"blue"]){
        imgBack.image=[UIImage imageNamed:@"background-login_blue.png"];
    }
    else{
        imgBack.image=[UIImage imageNamed:@"Background-login-screen.png"];
    }
}
-(void)JSON
{
    [AlertHandler showAlertForProcess];
   // NSString *udid = [UIDevice currentDevice].uniqueIdentifier;
    NSString *strGender;
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"PlannerDeviceToken"]);
    if([[arrGender objectAtIndex:1] isEqualToString:@"1"]){
        strGender=@"Female";
    }
    else {
        strGender=@"Male";
    }
    NSString *encoded=(NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)lblAge.text, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
    NSString *str=[NSString stringWithFormat:@"%@/user_action.php?action=registration&password=%@&email=%@&age=%@&gender=%@",appdel.url,txt_pwd.text,txt_emailid.text,encoded,strGender  ];

    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    JSONParser *parser = [[JSONParser alloc] initWithRequestForThread:request sel:@selector(searchResult:) andHandler:self];
    NSLog(@"%@",parser);
	
}

-(void)searchResult:(NSDictionary*)dictionary
{
    [AlertHandler hideAlert];
    NSLog(@"%@",dictionary);
    if([[dictionary valueForKey:@"msg"] isEqualToString:@"User Registered successfully"] ){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Registered!!!"
                                                      message:@"Registered Successfully" 
                                                     delegate:self 
                                            cancelButtonTitle:nil 
                                            otherButtonTitles:@"OK",nil];
        [alert show];
        alert.tag=4;
        [alert release];

    }
    else if([[dictionary valueForKey:@"msg"] isEqualToString:@"User upadted successfully"]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry!!!"
                                                      message:@"Email is already registered" 
                                                     delegate:self 
                                            cancelButtonTitle:nil 
                                            otherButtonTitles:@"OK",nil];
        
        [alert show];
        [alert release];

    }
       
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry!!!"
                                                      message:@"Cannot resiter please try again" 
                                                     delegate:self 
                                            cancelButtonTitle:nil 
                                            otherButtonTitles:@"OK",nil];
        
        [alert show];
        [alert release];
    }
   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(actionSheet.tag==4){
    LoginPage *log=[[LoginPage alloc]initWithNibName:@"LoginPage" bundle:nil];
    [self.navigationController pushViewController:log animated:YES];
        [log release];
    }
    else{
        
    }

}
- (BOOL)validateEmailWithString:(NSString*)email11
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:email11];
	
}
-(IBAction)ClickonCheckMark:(id)sender{
        
    if(isCheck){
        terms=1;
        [btnCheckMark setSelected:YES];
        isCheck=NO;
        
    }
    else{
        terms=0;
        [btnCheckMark setSelected:NO];
        isCheck=YES;
    }
}
-(IBAction)ClickOnRegister:(id)sender
{
    [self playSoundOnButtonClick];
    emailstatus=[self validateEmailWithString:txt_emailid.text];
   
     if(!emailstatus){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                      message:@"Please Enter Valid Email Address" 
                                                     delegate:self 
                                            cancelButtonTitle:nil 
                                            otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
    }
    else if([txt_pwd.text isEqualToString:@""]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                      message:@"Please Enter Password" 
                                                     delegate:self 
                                            cancelButtonTitle:nil 
                                            otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
    }
    else if([[arrGender objectAtIndex:0] isEqualToString:@"0"] && [[arrGender objectAtIndex:1] isEqualToString:@"0"]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                      message:@"Please Select The Gender" 
                                                     delegate:self 
                                            cancelButtonTitle:nil 
                                            otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
    }
    else if(!lblAge){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Sorry!"
                                                      message:@"Please Select Your Age Group" 
                                                     delegate:self 
                                            cancelButtonTitle:nil 
                                            otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
    }
    else if(terms==0){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Please Accept Terms and Condition To Regiser"
                                                      message:@"" 
                                                     delegate:self 
                                            cancelButtonTitle:nil 
                                            otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
    }
    else{
    [self JSON];
    }
    

}
-(IBAction)clickMale:(id)sender{
   
    [arrGender replaceObjectAtIndex:0 withObject:@"1"];
    [arrGender replaceObjectAtIndex:1 withObject:@"0"];
    [txt_pwd resignFirstResponder];
    [txt_emailid resignFirstResponder];
    
    [btnMale setSelected:YES];
    [btnFemale setSelected:NO];
        
        
   }
-(IBAction)clickFemale:(id)sender{
   
    [txt_pwd resignFirstResponder];
    [txt_emailid resignFirstResponder];
    [arrGender replaceObjectAtIndex:1 withObject:@"1"];
    [arrGender replaceObjectAtIndex:0 withObject:@"0"];
    

    [btnFemale setSelected:YES];
    [btnMale setSelected:NO];
       
      
   
}

-(IBAction)ClickOnCancel:(id)sender
{
    [self playSoundOnButtonClick];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)clickDrop:(id)sender{
    tblAge.hidden=NO;
    [tblAge reloadData];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrAge count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
   // cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
    cell.textLabel.font=[UIFont fontWithName:@"HelenBgCondensed-Bold" size:20];
    cell.textLabel.text=[arrAge objectAtIndex:indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    tblAge.hidden=TRUE;
    lblAge.text=[arrAge objectAtIndex:indexPath.row];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc{
    [super dealloc];
    [txt_emailid release];
    [txt_pwd release];
    [btnMale release];
    [btnFemale release];
    [btnCheckMark release];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end

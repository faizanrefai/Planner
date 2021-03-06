//
//  PlannerAppViewControllerIPhone.m
//  PlannerApp
//
//  Created by Openxcell on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlannerAppViewControllerIPhone.h"
#import "SettingsIPhone.h"
#import "SyncViewIPhone.h"
#import "ProgressViewControllerIPhone.h"
#import "FolderView.h"
#import "TapView.h"
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
@implementation PlannerAppViewControllerIPhone
@synthesize tvcell;


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

     appdel=(PlannerAppAppDelegate *)[[UIApplication sharedApplication]delegate ];
    
//    NSString *client_id = @"130902823636657";
//	
//	//alloc and initalize our FbGraph instance
//	fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
//	
//	//begin the authentication process.....
//    [fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
//						 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}
-(void)viewWillAppear:(BOOL)animated{
    dic_txt=[[NSMutableDictionary alloc]init];
	
    sectionOUt=-1;
    row=0;
    i=-1;
    
    arrayOfSection=[[NSMutableArray alloc]init];
    dictForRows=[[NSMutableDictionary alloc] init];
    dictSection=[[NSMutableDictionary alloc]init];
	self.title=@"Tasks";
	
	arr_tag=[[NSMutableArray alloc]init];
   	//[self.tableView reloadData];

}
#pragma textFeild

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}


- (IBAction)devTyping:(UITextField*)sender   {
    //NSLog(@"The user is typing in text field %d",sender.tag );
    //NSLog(@"%@",txt.text);
    UITextField *newTxt=(UITextField *)sender;
    [txt resignFirstResponder];
	NSString *str=[NSString stringWithFormat:@"%@",newTxt.text];
	//NSLog(@"text is:%@",str);
	
   // NSLog(@"Dictionary is: %@",dic_txt);
    NSIndexPath *indexPath1;
    UITableViewCell *cell = (UITableViewCell *)[[newTxt superview] superview];
    
    indexPath1=[table indexPathForCell:cell];
    
    sectioncell=indexPath1.section;
    rowcell=indexPath1.row;
   // NSLog(@"section is %d & index row is %d",sectioncell,rowcell);
    NSString *contents=@"";
    contents=[contents stringByAppendingString:[NSString stringWithFormat:@"%d",sectioncell]];
    contents=[contents stringByAppendingString:[NSString stringWithFormat:@"^%d",rowcell]];
    
    
    [dic_txt setObject:str forKey:contents]; 
    
    //NSLog(@"dict of contents is %@",dic_txt);
    
    [table reloadData];
}
-(IBAction)textHeaderEnd:(UITextField *)sender{
    UITextField *newTxt=(UITextField *)sender;
    [newTxt resignFirstResponder];
    strTextHeader=[NSString stringWithFormat:@"%@",newTxt.text];
    int a=newTxt.tag-1;
   // NSLog(@"text feild tag is %d",a);
    [dictSection setObject:strTextHeader forKey:[NSString stringWithFormat:@"%d",a]];
   // NSLog(@"%@",dictSection);
   
}


#pragma facebook
- (void)fbGraphCallback:(id)sender {
	
	if ( (fbGraph.accessToken == nil) || ([fbGraph.accessToken length] == 0) ) {
		
		NSLog(@"You pressed the 'cancel' or 'Dont Allow' button, you are NOT logged into Facebook...I require you to be logged in & approve access before you can do anything useful....");
		
		//restart the authentication process.....
		[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) 
							 andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access,user_checkins,friends_checkins"];
		
	} else {
		//pop a message letting them know most of the info will be dumped in the log
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note" message:@"For the simplest code, I've written all output to the 'Debugger Console'." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		//[alert show];
		[alert release];
		
		NSLog(@"------------>CONGRATULATIONS<------------, You're logged into Facebook...  Your oAuth token is:  %@", fbGraph.accessToken);
        [self getMeButtonPressed];
        
		
	}
	
}
-(void)getMeButtonPressed {
	FbGraphResponse *fb_graph_response = [fbGraph doGraphGet:@"me" withGetVars:nil];
	//NSLog(@"getMeButtonPressed:  %@", fb_graph_response.htmlResponse);
    NSArray *arr=[fb_graph_response.htmlResponse componentsSeparatedByString:@":"];
    
    
	NSArray *finalarr=[[arr objectAtIndex:1] componentsSeparatedByString:@","];
    
    appdel.strLoginID=[finalarr objectAtIndex:0];
    //NSLog(@"%@",appdel.strLoginID);
    if(finalarr!=nil){
        finalarr=nil;
        [finalarr release];
    }
    if(arr!=nil){
        arr=nil;
        [arr release];
    }
}

#pragma IBAction
-(IBAction)clickOnSettings:(id)sender{
    SettingsIPhone *objSettings=[[SettingsIPhone alloc]initWithNibName:@"SettingsIPhone" bundle:nil];
    [self.navigationController pushViewController:objSettings animated:YES];
    [objSettings release];
}

-(IBAction)clickOnSync:(id)sender
{
	SyncViewIPhone *sync=[[SyncViewIPhone alloc]initWithNibName:@"SyncViewIPhone" bundle:nil];
	[self.navigationController presentModalViewController:sync animated:YES];
    [sync release];
}

-(IBAction)clickOnProgress:(id)sender
{
    ProgressViewControllerIPhone *progress=[[ProgressViewControllerIPhone alloc] initWithNibName:@"ProgressViewControllerIPhone" bundle:nil];
    [self.navigationController pushViewController:progress animated:YES];
	
    [progress release];
}
//-(IBAction)clickOnInfo:(id)sender
//{
//    InfoViewController *objInfo=[[InfoViewController alloc]initWithNibName:@"InfoViewController" bundle:nil];
//    [self.navigationController pushViewController:objInfo animated:YES];
//    [objInfo release];
//}
-(IBAction)clickOnMail:(id)sender
{
	mail=[[MFMailComposeViewController alloc]init];
	mail.mailComposeDelegate=self;
	[mail setToRecipients:[NSArray arrayWithObjects:@"email@email.com",nil]];
	NSString *str=[NSString stringWithFormat:@"hello"];
	[mail setSubject:str];
	[mail setMessageBody:@"Message of email" isHTML:YES];
	[self presentModalViewController:mail animated:YES];
	//self.view=firstResponder;
	[mail resignFirstResponder];
	[mail respondsToSelector:@selector(set:)];
	[mail release];
	
}
-(IBAction)Folder:(id)sender{
    FolderView *folderObj=[[FolderView alloc] initWithNibName:@"FolderView" bundle:nil];
    [self presentModalViewController:folderObj animated:YES];
    [folderObj release];
}

#pragma Mail

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma IBAction
-(IBAction)btninDent:(id)sender{
    
	//NSLog(@"%d",index);
    //NSLog(@"%d",sectionOUt);
    
    NSString *rowsno=[dictForRows valueForKey:[NSString stringWithFormat:@"%d",sectionOUt]];
    
    
    
    int a=[rowsno intValue];
    a++;
    
    [dictForRows setObject:[NSString stringWithFormat:@"%d",a] forKey:[NSString stringWithFormat:@"%d",sectionOUt]];
    
    
    
   // NSLog(@"dict is %@",dic_txt);
    [table reloadData];
    
    
}
-(IBAction)btnOutDent:(id)sender{
   // NSLog(@"%d",index);
    //NSLog(@"%d",sectionOUt);
    
    NSString *rowsno=[dictForRows valueForKey:[NSString stringWithFormat:@"%d",sectionOUt]];
    
    
    int a=[rowsno intValue];
    a++;
    
    [dictForRows setObject:[NSString stringWithFormat:@"%d",a] forKey:[NSString stringWithFormat:@"%d",sectionOUt]];
    
    NSMutableArray *tempArr=[[NSMutableArray alloc] init];
    //NSLog(@"dict is %@",dic_txt);
    for(int m=0;m<a-1;m++){
        NSString *str=[dic_txt valueForKey:[NSString stringWithFormat:@"%d^%d",sectionOUt,m]];
        if(str==nil){
            [tempArr addObject:@""];
        }
        else
            [tempArr addObject:str];
        
        
    }
    
    for(int m=0;m<a-1;m++){
        [dic_txt setObject:[tempArr objectAtIndex:m] forKey:[NSString stringWithFormat:@"%d^%d",sectionOUt,m+1]];
    }
    if(tempArr!=nil){
        [tempArr removeAllObjects];
        [tempArr release];
        tempArr=nil;
    }
    [dic_txt setObject:@"" forKey:[NSString stringWithFormat:@"%d^0",sectionOUt]];
    [table reloadData];
}
-(IBAction)btnAdd:(id)sender{
	
	[arr_tag addObject:[NSString stringWithFormat:@"%d",0]];
    i++;
    [arrayOfSection addObject:[NSString stringWithFormat:@"%d",i]];
    //[dict setObject:@"main" forKey:[NSString stringWithFormat:@"%d",i]];
    [dictForRows setObject:[NSString stringWithFormat:@"%d",row] forKey:[NSString stringWithFormat:@"%d",i]];
    
    [table reloadData];
}
-(IBAction)btnDelete:(id)sender{
   // NSLog(@"%d",index);
   // NSLog(@"%d",sectionOUt);
    
    NSString *rowsno=[dictForRows valueForKey:[NSString stringWithFormat:@"%d",sectionOUt]];
    
   // NSLog(@"%@",rowsno);
    
    int a=[rowsno intValue]-1;
    
    [dictForRows setObject:[NSString stringWithFormat:@"%d",a] forKey:[NSString stringWithFormat:@"%d",sectionOUt]];
    
    [dic_txt removeObjectForKey:[NSString stringWithFormat:@"%d^%d",sectionOUt,index]];
    NSMutableArray *tempArr=[[NSMutableArray alloc] init];
    for(int m=0;m<a+1;m++){
        NSString *str=[dic_txt valueForKey:[NSString stringWithFormat:@"%d^%d",sectionOUt,m]];
        if(str==nil){
            //[tempArr addObject:@""];
        }
        else
            [tempArr addObject:str];
        
        
    }
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    //NSLog(@"%@",tempArr);
    for(int m=0;m<[tempArr count];m++){
        [dict setObject:[tempArr objectAtIndex:m] forKey:[NSString stringWithFormat:@"%d^%d",sectionOUt,m]];
    }
    if(tempArr!=nil){
        [tempArr removeAllObjects];
        [tempArr release];
        tempArr=nil;
    }
    if(dict!=nil){
        [dict removeAllObjects];
        [dict release];
        dict=nil;
    }
    //NSLog(@"dict for rows %@",dict);
    
    [table reloadData];
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 323, 44)];
//    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame=CGRectMake(0, 7, 30, 30);
//    button.tag=section+1;
//	UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame=headerView.frame;
//    [backButton addTarget:self action:@selector(getSection:) forControlEvents:UIControlEventTouchUpInside];
//    backButton.tag=section+1;
//    [backButton setSelected:YES];
//    [backButton setFrame:CGRectMake(50, 0, 310, 44)];
//    [backButton setImage:[UIImage imageNamed:@"sectionBg.png"] forState:UIControlStateNormal];
//    
//    textHeader=[[UITextField alloc] initWithFrame:CGRectMake(50, 5, 100, 44)];
//    textHeader.delegate=self;
//    [textHeader addTarget:self action:@selector(textHeaderEnd:) forControlEvents:UIControlEventEditingDidEnd];
//    textHeader.placeholder=@"Write here";
//    textHeader.tag=section+1;
//    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    //NSLog(@"dict of rows %@",dictForRows);
//    if([[dictForRows valueForKey:[NSString stringWithFormat:@"%d",section]] intValue]>=1 ){
//        [button setImage:[UIImage imageNamed:@"shrink.png"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"disclosure.png"] forState:UIControlStateSelected];
//       
//    }
//    
//    
//    if(![dictSection count]==0 || [textHeader.text isEqualToString:@""] || [textHeader.text isEqualToString:@"(null)"]){
//        
//        NSString *temp=[NSString stringWithFormat:@"%@",[dictSection valueForKey:[NSString stringWithFormat:@"%d",section]]];
//        if ([temp isEqualToString:@"(null)"]){
//            [textHeader setText:@""];
//        }
//        else{
//            [textHeader setText:temp];
//        }
//    }
//   // NSLog(@"%@",arr_tag);
//    if([[arr_tag objectAtIndex:section] intValue]==0) button.selected=NO;
//    else button.selected=YES;
//    //    if([[dictForRows valueForKey:[NSString stringWithFormat:@"%d",section]] intValue]==0) 
//    //        button.selected=YES;
//    //    else 
//    //        button.selected=NO;
//    [headerView addSubview:button];
//    [headerView addSubview:backButton];
//    [headerView addSubview:textHeader];
//	return  headerView;
//}
-(IBAction)getSection:(id)sender{
    UIButton *button=(UIButton *)sender;
	tagbtn=button.tag;
    sectionOUt=tagbtn-1;
      // NSLog(@"%d",sectionOUt);
    //index=indexPath.row;
}
- (NSArray*)indexPathsInSection:(NSInteger)section 
{
	NSMutableArray *paths = [NSMutableArray array];
	NSInteger row1;	
	for ( row1 = 0; row1 < [table numberOfRowsInSection:section]; row1++ ) {
		[paths addObject:[NSIndexPath indexPathForRow:row1 inSection:section]];
	}
	return [NSArray arrayWithArray:paths];
}
-(IBAction)buttonClicked:(id)sender
{
	
    
    
    
    UIButton *button=(UIButton *)sender;
    
	tagbtn=button.tag;
	int b = [[arr_tag objectAtIndex:(tagbtn-1)] intValue];
	if(b == 0)
		[arr_tag replaceObjectAtIndex:(tagbtn-1) withObject:[NSString stringWithFormat:@"%d",1]];
	else {
		[arr_tag replaceObjectAtIndex:(tagbtn-1) withObject:[NSString stringWithFormat:@"%d",0]];
        
	}
    
   	[table reloadData];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return [arrayOfSection count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{     
	int a,b;
    b = [[arr_tag objectAtIndex:section] intValue];
    if(b==1)
        a=0;
    else{
        
        NSString *rowsno=[dictForRows valueForKey:[NSString stringWithFormat:@"%d",section]];
        
        
        a=[rowsno intValue];
        
    }
    return a;
    
}         


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSLog(@"%@",dic_txt);
	static NSString *CustomCellIdentifier = @"CustomCellIdentifier ";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
	if (cell == nil) 
	{ 
		[[NSBundle mainBundle] loadNibNamed:@"CustomCelliPhone" owner:self options:nil];
		cell=self.tvcell;
		self.tvcell=nil;
        
	}
    txt.text=[dic_txt valueForKey:[NSString stringWithFormat:@"%d^%d",indexPath.section,indexPath.row]];
    
    txt.tag=[[NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row ] intValue];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sectionOUt=indexPath.section;
    index=indexPath.row;
    
    TapView *tap=[[TapView alloc]initWithNibName:@"TapView" bundle:nil];
    [self.navigationController pushViewController:tap animated:YES];
    [tap release];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)dealloc {
	[table release];
	if (feedPostId != nil) {
		[feedPostId release];
	}
	[fbGraph release];
    [super dealloc];
}


@end

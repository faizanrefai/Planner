//
//  PlannerAppViewController.h
//  PlannerApp
//
//  Created by openxcell tech.. on 2/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Foundation/Foundation.h>
#import "StatusView.h"
#import "PriorityView.h"
#import "TapView.h"
#import "InfoViewController.h"
#import "ProgressViewController.h"
#import "PlannerAppAppDelegate.h"
#import "SyncView.h"
#import "TKCalendarMonthView.h"
#import "FbGraph.h"
#import "JSONParser.h"
#import "DAL.h"
#import "WEPopoverController.h"
#import "TKCalendarMonthView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MADayView.h"
@class WEPopoverController;
@class TabOrderController;
@interface PlannerAppViewController : UIViewController <TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource,UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate,MFMailComposeViewControllerDelegate,UIScrollViewDelegate,UIWebViewDelegate,UITextFieldDelegate,UITabBarDelegate,WEPopoverControllerDelegate,UIGestureRecognizerDelegate,TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource,MADayViewDataSource,MADayViewDelegate>
{
    
    
   // TKCalendarMonthView *_monthView;

    IBOutlet UITableViewCell *category_cell;
	int k,l;
	MFMailComposeViewController *mail;
	PlannerAppAppDelegate *appdel;

    IBOutlet UIImageView *imgFrame;
    IBOutlet UIImageView *imgSearch;
    IBOutlet UIImageView *imgPaperBG;
    
	IBOutlet UIView *view_cal;
	IBOutlet UITableView *table1;
	IBOutlet UITableView *table2;
    IBOutlet UIButton *editBtn;
	
    IBOutlet UIButton *btnWork;
    IBOutlet UIButton *btnPersonal;
    IBOutlet UIButton *btnFamily;
    IBOutlet UIButton *btnHealth;
    IBOutlet UIButton *btnFinance;
    IBOutlet UIButton *btnShared;
    IBOutlet UIButton *btnUrgent;
    IBOutlet UIButton *btnShopping;    

    
	
	NSMutableArray *arrsubCatTitle;

    NSMutableArray *arrSuBTaskID;
   
	
	DAL *dal;
	
	
	IBOutlet UITableViewCell *tbl2Cell;
    
	IBOutlet UIButton *statusBtn;
	IBOutlet UIButton *priorityBtn;
	IBOutlet UIButton *addBtn;
    IBOutlet UIButton *editBtn2;
	
	IBOutlet UIScrollView *scroll;
	
	UIPopoverController *popover;
	UIPopoverController *popover2;
	UIPopoverController *popover_tap;
	UIPopoverController *popover_sync;
    UIPopoverController *popover_Event;
   
    WEPopoverController *popover_progress;
    WEPopoverController *popOver_settings;
    WEPopoverController *popOver_Location;
    Class popoverClass;
	BOOL isStatus;
	BOOL isPriority;
	
	UITextField *txtmainfld;
	
	
    NSMutableArray *arr_maintask;
    
    FbGraph *fbGraph;
    
	
	NSString *feedPostId;
    
    int sectionOUt;
    int row;
    int index;
    int i;
    
    NSMutableDictionary *dictForRows;
    
    
    NSMutableArray *arrayOfSection;
    
	IBOutlet UILabel *txt;
    UITextField *txtMain;
	NSMutableDictionary *dic_txt;
	
	
	
	NSMutableArray *arr_tagNew;
    NSMutableArray *arrTemptag;
    int tagbtn;
    NSMutableDictionary *dictSection;
    int sectioncell;
    int rowcell;
    UITextField *textHeader;
    NSMutableDictionary *dic_image;
    NSMutableDictionary *dic_priorityimage;
    UIButton *btnpriority;
    UIButton *btnDel;
    IBOutlet UITextField *txt_category;

    NSMutableArray *arrScid;
    NSMutableArray *arr_subtasktitle;
    
    NSString *str_scid;
    NSString *str_mtid;
    NSString *str_stid;
    NSString *str_mcid;
    NSString *str_searchID;
    
    NSString *strSubCatTitle;
    NSString *strMainTaskTitle;
    NSString *strMaintaskPosi;
    NSString *strOfSubtask;
    
    
    
  
	int flag;
    int isIndent;
    int isEdit;
    int alertFlag;
    
   
    NSMutableArray *arrOfArrow;
    
    NSMutableDictionary *dictSubTaskID;
    NSMutableDictionary *dictMainTask;
    NSMutableDictionary *dictArrow;
        
    IBOutlet UIButton *btnShrink;
    int flagStart;
    
    
    
    IBOutlet UIImageView *lblWork;
    IBOutlet UIImageView *lblPersonal;
    IBOutlet UIImageView *lblFamily;
    IBOutlet UIImageView *lblHealth;
    IBOutlet UIImageView *lblFinance;
    IBOutlet UIImageView *lblShared;
    IBOutlet UIImageView *lblUrgent;
    IBOutlet UIImageView *lblShopping;
    UILabel *lblWork1;
    UILabel *lblPer;
    UILabel *lblfami;
    UILabel *lblhealt;
    UILabel *lblFin;
    UILabel *lblShar;
    UILabel *lblUrge;
    UILabel *lblShop;
    
    IBOutlet UILabel *lblPriority;
    
    
    
    IBOutlet UILabel *lblStatus;
    
    IBOutlet UIButton *btnProgress;
    IBOutlet UIButton *btnMail;
    IBOutlet UIButton *btnSettings;
    IBOutlet UIButton *btnInfo;
    IBOutlet UIButton *btnSync;
    
    UIView*             dropArea;
     BOOL            dragFromSource;
     UITableViewCell*    draggedCell;
    NSMutableArray*     srcData;
    NSMutableArray*     dstData;
    NSIndexPath*    pathFromDstTable;
    
    int allFlag;
    int reodered;
    id draggedData;
    int gesture;
    
    
    
     UIImageView *imgLine0;
     UIImageView *imgLine1;
     UIImageView *imgLine2;
     UIImageView *imgLine3;
    IBOutlet UILabel *lblCatTitle;
    
    IBOutlet UITableViewCell *cellCalendar;
    IBOutlet UILabel *lblTime;
    IBOutlet UIButton *btnPriorityCal;
    IBOutlet UITextField *txtTask;
    
    
    IBOutlet UILabel *lblDate;
    IBOutlet UILabel *lblDay;
    IBOutlet UILabel *lblMonth;
    IBOutlet UITableView *tblCalendar;
    NSMutableArray *arrCalText;
   
    
    NSArray *arrTime;
    
    NSMutableArray *arrtab;
    int rowsCnt;
    
    
    UIView *lineVIew1;
    UIView *lineView2;
    UIView *lineView3;
    UIView *lineView4;
    UIView *lineView5;
   
    UIView *lineCal1;
    UIView *lineCal2;
    UIView *lineCal3;
    UIView *lastLine;
    
    IBOutlet UIButton *btnIndent;
    IBOutlet UIButton *btnOutdent;
    
    IBOutlet UIImageView *imgCalList;
    IBOutlet UIButton *btnCal;
    IBOutlet UIButton *btnList;
    
    BOOL isCalendar;
    BOOL isCalAdd;
    int calIndex;
    UIButton *delButton;
    
    BOOL isOpen;
    
    
    IBOutlet UIButton *btnLoca;
    
    IBOutlet UITableView *tblSearch;
    IBOutlet UITextField *txtSearch;
    NSMutableArray *arrSearch;
    
    NSString *dragedID;
    int swipeYES;
    UISwipeGestureRecognizer *showExtrasSwipe;
    UISwipeGestureRecognizer *showExtrasLeft;
    UIPanGestureRecognizer* panGesture;
    UIPanGestureRecognizer *panCal;
    
    CGPoint pointinTable;
    NSString *strEmail;
    UILongPressGestureRecognizer *longPress;
    
    IBOutlet UIView *viewCalendarTbl;
    NSDate *currentDate;
    CGFloat animatedDistance;
    
    NSMutableArray *arrayTitle;
    UITextField *txtCal;
    IBOutlet UIButton *dailyView;
    NSMutableArray *arrRetCal;
    NSString *str_cid;
  
    
    
  
    
}
@property(nonatomic,retain)UIButton *btnSettings;
@property (nonatomic, retain) UIPopoverController *popover_tap;
@property (nonatomic, retain) WEPopoverController *popover_progress;
@property (nonatomic, retain) WEPopoverController *popOver_settings;
@property (nonatomic, retain) WEPopoverController *popOver_Location;
@property (nonatomic,retain) IBOutlet UITableViewCell *category_cell;
@property (nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic, retain) NSString *feedPostId;

@property(nonatomic,retain)UITextField *txtMain;
@property (nonatomic,retain)IBOutlet UITableView *table1;
@property (nonatomic,retain)IBOutlet UITableView *table2;
@property (nonatomic,retain) IBOutlet UIButton *btnShrink;

//@property (nonatomic,retain)UIButton *donebtn;  



+(void)DragAndDrop1;
@property (nonatomic,retain)IBOutlet UITableViewCell *tbl2Cell;
@property (nonatomic,retain) UITableViewCell *cellCalendar;
@property(nonatomic,retain)UILabel *lblTime;
@property(nonatomic,retain)UITextField *txtTask;
@property (nonatomic,retain)IBOutlet UIButton *addBtn;
- (NSString *) base64Encoding;
-(IBAction)clcikOnDailyView:(id)sender;
-(void)changeColor;
-(void)tap;
-(void)CallMethod:(UIImage *)image indexis:(int)indexis email:(NSString *)email;
-(void)CallMethodPriority:(UIImage *)image;
-(void)getMeButtonPressed;
-(IBAction)actionPressed:(id)sender;
-(IBAction)clickOnEditBtn:(id)sender;

-(IBAction)taskbuttonClicked:(id)sender;
-(IBAction)clickOnWork:(id)sender;
-(IBAction)clickOnPersonal:(id)sender;
-(IBAction)clickOnFamily:(id)sender;
-(IBAction)clickOnHealth:(id)sender;
-(IBAction)clickOnFinance:(id)sender;
-(IBAction)clickOnShare:(id)sender;
-(IBAction)clickonUrgent:(id)sender;
-(IBAction)clickOnShop:(id)sender;

//-(IBAction)clickOnDone:(id)sender;
-(IBAction)clickOnaddBtn:(id)sender;
-(IBAction)clickOnstatusBtn:(id)sender event:(id)event;
-(IBAction)clickOnpriorityBtn:(id)sender event:(id)event;
-(IBAction)clickOnSettings:(id)sender;
-(IBAction)tapDetected:(UIGestureRecognizer *)sender;

-(IBAction)clickOnLocation:(id)sender event:(id)event;
-(IBAction)clickPriorityCal:(id)sender event:(id)event;
-(void)removeProgress;
-(IBAction)hidePopView:(id)sender;
-(IBAction)topBarEdit:(id)sender;
-(IBAction)changeSegment;
-(IBAction)btninDent:(id)sender;
-(IBAction)btnAdd:(id)sender;
-(IBAction)btnOutDent:(id)sender;

-(IBAction)clickOnSettings:(id)sender;
-(IBAction)clickOnSync:(id)sender;
-(IBAction)clickOnProgress:(id)sender;
-(IBAction)clickOnInfo:(id)sender;
-(IBAction)clickOnMail:(id)sender;


-(IBAction)clickCalendar:(id)sender;
-(IBAction)cliclList:(id)sender;

-(void)dissmissProgress:(id)sender;

-(void)JSONFacebook;
-(void)JSON;
-(void)JSONMainCategory;
-(void)JSONDelegate:(NSString *)email strid:(NSString *)strid;
-(void)JSON_maintaskRetrive;
-(void)findEmail;
-(void)JSON_subtaskRetrive;

-(void)setButtons;
-(void)setRightImgOnly:(int)number;
-(void)setLeftImgOnly:(int)number;
-(void)setMainTabs;
-(void)setActiveButton;
-(IBAction)category_txtType:(UITextField *)sender;
- (void)initDraggedCellWithCell:(UITableViewCell*)cell AtPoint:(CGPoint)point indexPath:(NSIndexPath *)indexpath;
- (void)startDraggingFromDstAtPoint:(CGPoint)point;
- (void)doDrag:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)stopDragging:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)startDragging:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)startDraggingFromSrcAtPoint:(CGPoint)point;
- (void)initDraggedCellWithCell:(UITableViewCell*)cell AtPoint:(CGPoint)point;
- (void)setupDestinationTableWithFrame:(CGRect)frame;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;
-(void)memoryRelease;
-(void)nextMethod;
-(void)CallMe;

-(void)playSoundOnButtonClick;
-(void)playSoundOnStatusPrio;

//getDB

-(void)getSubCat;
-(int)getsubTask:(NSString *)mtid;
-(void) getAllMainTask;
-(void)getCount;
-(void)getMainTask;
-(void)getCalendar;
-(void)insertMainTask;
-(void)insertSubCat;
-(void)updateStatusMain;
-(void)updatePriorityMain;
-(void)updateStatusSub;
-(void)updatePrioritySub;
-(void)deleteSubCat;
-(void)deleteMainTask;

@end


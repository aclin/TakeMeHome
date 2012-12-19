//
//  TPFoundFormViewController.m
//  MeetMyPet
//
//  Created by Allan on 12/12/8.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPFoundFormViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NSString+MD5.h"
#import "NSData+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@interface TPFoundFormViewController ()
{
   int petID;
    int typeID;
    
    NSURLConnection *connect;
}

@property (strong, nonatomic) NSDictionary<FBGraphUser> *user;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property(strong, nonatomic) UIToolbar *toolbar;

@end

@implementation TPFoundFormViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
     
}

- (void)dealloc {
    self.foundMap.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.toolbar = [[NSBundle mainBundle] loadNibNamed:@"TPFoundToolbar" owner:self options:nil][0];
    self.foundDate.inputAccessoryView = self.toolbar;
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.foundDate.inputView = self.datePicker;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	self.foundDate.text = [NSString stringWithFormat:@"%@",
                           [df stringFromDate:[NSDate date]]];
    
    
    
	self.datePicker.datePickerMode = UIDatePickerModeDate;
	self.datePicker.hidden = NO;
	self.datePicker.date = [NSDate date];

    
	[self.datePicker addTarget:self
                        action:@selector(pickDate:)
              forControlEvents:UIControlEventValueChanged];

    
    [[self foundDate] setDelegate:self];
    [[self foundMap] setDelegate:self];
    [[self foundMap] setShowsUserLocation:YES];
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelForm:(id)sender {
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"You have not submitted this form!"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Submit Form", @"Discard and Go Back", nil];
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Submit the form to the server
        
    } else if (buttonIndex == 1) {
        // Discard the form and return to the previous page
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        return;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.toolbar = [[NSBundle mainBundle] loadNibNamed:@"TPFoundToolbar" owner:self options:nil][0];
    self.foundDate.inputAccessoryView = self.toolbar;
    self.datePicker = [[UIDatePicker alloc] init];
    self.foundDate.inputView = self.datePicker;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	self.foundDate.text = [NSString stringWithFormat:@"%@",
                           [df stringFromDate:[NSDate date]]];
    
    
    
	self.datePicker.datePickerMode = UIDatePickerModeDate;
	self.datePicker.hidden = NO;
	self.datePicker.date = [NSDate date];
    
    
	[self.datePicker addTarget:self
                        action:@selector(pickDate:)
              forControlEvents:UIControlEventValueChanged];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];

}

- (void)pickDate:(UIDatePicker *)sender {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
   	df.dateStyle = NSDateFormatterMediumStyle;
	self.foundDate.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:self.datePicker.date]];

}

- (IBAction)toolbarDone:(id)sender{
    self.datePicker.hidden = YES;
    self.toolbar.hidden = YES;
    [self.foundDate resignFirstResponder];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"accuracy: %f", userLocation.location.horizontalAccuracy);
    if (userLocation.location.horizontalAccuracy < 100.0f) {
        MKCoordinateRegion myRegion = mapView.region;
        myRegion.center = mapView.userLocation.coordinate;
        myRegion.span = MKCoordinateSpanMake(0.003, 0.003);
        [mapView setRegion:myRegion animated:YES];
    }
}

- (IBAction)submitForm:(id)sender{
    
    //[self uploadPhotoDB];
    
    typeID = 2;
    petID = 1;
    
    NSString * owner = self.user.id;
    
    NSLog(@"owner:%@",owner);
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    NSString *str =[NSString stringWithFormat:@"%@%@", owner, dateString];
    
    str = [str MD5];
    
    
    NSString *post = [NSString stringWithFormat:@"hashURL=%@ &condition=%d &typeID=%d &petID=%d &date=%@ &photoID=%d &email=%@ &longitude=%f &latitude=%f",str, 1,typeID , petID, self.foundDate.text,petID,self.Email.text, self.foundMap.userLocation.coordinate.longitude, self.foundMap.userLocation.coordinate.latitude];
    NSLog(@"%@", post);
    
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"http://secret-temple-2872.herokuapp.com/api/FormUpload/"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	
	[request setHTTPBody:postData];
    
    self.tempData = [NSMutableData alloc];
	connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    [self.datePicker removeFromSuperview];
    [self.foundDate resignFirstResponder];
    [self.Email resignFirstResponder];

}

-(void)uploadPhotoDB{
    
    NSString * owner = self.user.id;
    
    NSLog(@"owner:%@",owner);
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    NSString *str =[NSString stringWithFormat:@"%@%@", owner, dateString];
    
    str = [str MD5];
    
    NSString *post = [NSString stringWithFormat:@"hashURL=%@",str];
    NSLog(@"%@", post);
    
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"http://secret-temple-2872.herokuapp.com/api/PhotoUpload/"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	
	[request setHTTPBody:postData];
    
    connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{   //發生錯誤
	NSLog(@"發生錯誤");
}
- (void)connection: (NSURLConnection *)connection didReceiveResponse: (NSURLResponse *)aResponse {  //連線建立成功
    //取得狀態
    NSInteger status = (NSInteger)[(NSHTTPURLResponse *)aResponse statusCode];
    NSLog(@"%d", status);
}
-(void) connection:(NSURLConnection *)connection didReceiveData: (NSData *) incomingData
{   //收到封包，將收到的資料塞進緩衝中並修改進度條
	[self.tempData appendData:incomingData];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{   //檔案下載完成
    NSString *loadData = [[NSMutableString alloc] initWithData:self.tempData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", loadData);
}





@end

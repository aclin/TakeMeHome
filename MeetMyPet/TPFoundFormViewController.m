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

@interface TPFoundFormViewController (){
    
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadPhoto:)];
    [_petProfilePic addGestureRecognizer:tap];
    [_petProfilePic setUserInteractionEnabled:YES];
    
    UIImage *patternImage = [UIImage imageNamed:@"background.png"];
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
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
    targetSheet.tag = 1;
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
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

- (IBAction)loadPhoto:(id)sender
{
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"Choose where to load image:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take a Picture", @"Choose from Gallery", nil];
    targetSheet.tag = 2;
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == 1){
        if (buttonIndex == 0) {
            // Submit the form to the server
            
        } else if (buttonIndex == 1) {
            // Discard the form and return to the previous page
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            return;
        }
    }else{
        if (buttonIndex == 0) {
            [self performSelector:@selector(takePicture:) withObject:self];
        } else if(buttonIndex == 1) {
            [self makeUIImagePickerControllerForCamera:self];
        } else {
            return;
        }
    }
}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    [imagePicker setAllowsEditing:YES];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (IBAction) makeUIImagePickerControllerForCamera:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //[picker setMediaTypes:[NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil]];
    
   [self presentViewController:picker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Get the image from the result
    //image.size = CGsize
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [_petProfilePic setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    
    NSString *post = [NSString stringWithFormat:@"hashURL=%@ &condition=%d &typeID=%d &petID=%d &date=%@ &longitude=%f &latitude=%f",str, 1,typeID , petID, self.foundDate.text, self.foundMap.userLocation.coordinate.longitude, self.foundMap.userLocation.coordinate.latitude];
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
    //[self.Email resignFirstResponder];
    
}




@end

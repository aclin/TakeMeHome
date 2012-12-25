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
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"

@interface TPFoundFormViewController (){
    
    NSString * typeID;

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
    
//    UIImage *patternImage = [UIImage imageNamed:@"background.png"];
//    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    UIImageView *boxBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:boxBackView];

    
    
    NSArray *plistPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistDocumentsDirectory = [plistPaths objectAtIndex:0];
    //    NSLog(@"plistDocumentsDirectory: %@", plistDocumentsDirectory);
    NSString *plistPath = [plistDocumentsDirectory stringByAppendingPathComponent:@"local_profile.plist"];
    NSFileManager *plistFileMgr = [NSFileManager defaultManager];
    //    NSLog(@"plistPath: %@", plistPath);
    
    // Read data from the plist if the plist file exists
    if ([plistFileMgr fileExistsAtPath:plistPath]) {
        NSMutableDictionary *savedPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        _petID = [savedPlist valueForKey:@"petID"];
        _username = [savedPlist valueForKey:@"ownerName"];
        
        NSLog(@"PetID: %@",_petID);
        
        NSLog(@"OwnerName: %@",_username);
        //[self openPhoto:@"profile_photo.jpg"];
    } else {
        NSLog(@"local_profile.plist does not exist");
    }
    
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

- (void) savePhoto:(UIImage*) image{
    
    NSData *jpgData = UIImageJPEGRepresentation(image, 0.5);
    NSString *filePath = [self documentsPathForFileName:@"profile_photo.jpg"];
    [jpgData writeToFile:filePath atomically:YES]; //Write the file
    NSLog(@"%@", filePath);
}
- (void)openPhoto:(NSString*)filename{
    
    NSString *filePath = [self documentsPathForFileName:filename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){ //photo exist
        NSData *jpgData = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:jpgData];
        [_petProfilePic setImage:image];
    }
    
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    //NSLog(@"%@", documentsPath);
    return [documentsPath stringByAppendingPathComponent:name];
}

- (NSDictionary *)buildParams {
    typeID = @"2";
    NSString * latitude = [NSString stringWithFormat:@"%f", _foundMap.userLocation.coordinate.latitude];
    NSString * longitude = [NSString stringWithFormat:@"%f", _foundMap.userLocation.coordinate.longitude];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _petID, @"petID",
                            fname, @"hashURL",
                            _foundDate.text, @"date",
                            latitude, @"latitude",
                            longitude, @"longitude",
                            _username , @"username",
                            typeID, @"typeID",
                            nil];
    return params;
}
- (void)uploadPhoto:(UIImage*) image {
    // Create request
    NSURL *url = [NSURL URLWithString:@"https://csie.ntu.edu.tw/~r00944044/mpptmh/"];
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    fname = [NSString stringWithFormat:@"%@%@", _username, dateString];
    fname = [[fname MD5] stringByAppendingString:@".jpg"];
    
    NSData *imageToUpload = UIImageJPEGRepresentation(image, 8);
    AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:url];
    
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST"
                                                                     path:@"photoupload.php"
                                                               parameters:nil
                                                constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                                    [formData appendPartWithFileData: imageToUpload
                                                                                name:@"file"
                                                                            fileName:fname
                                                                            mimeType:@"image/jpeg"];
                                                }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [operation responseString];
        NSLog(@"response: [%@]",response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([operation.response statusCode] == 403){
            NSLog(@"Upload Failed");
            return;
        }
        NSLog(@"error: %@", [operation error]);
        
    }];
    
    [operation start];
}




- (IBAction)submitForm:(id)sender{
    
    //[self savePhoto:_petProfilePic.image];
    [self uploadPhoto:_petProfilePic.image];
    
    NSURL *url = [NSURL URLWithString:@"https://secret-temple-2872.herokuapp.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"api/FormUpload/index.php"
                                                      parameters:[self buildParams]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"JSON: %@", JSON);
        NSLog(@"Response: %d", response.statusCode);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Error: %@ \nResponse: %d", error, response.statusCode);
    }];
    
    [operation start];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
//  NSString *post = [NSString stringWithFormat:@"hashURL=%@ &condition=%d &typeID=%d &petID=%d &date=%@ &longitude=%f &latitude=%f",str, 1,typeID , petID, self.foundDate.text, self.foundMap.userLocation.coordinate.longitude, self.foundMap.userLocation.coordinate.latitude];
//    NSLog(@"%@", post);
//    
//	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//    
//	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//	[request setURL:[NSURL URLWithString:@"http://secret-temple-2872.herokuapp.com/api/FormUpload/"]];
//	[request setHTTPMethod:@"POST"];
//	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    
//	[request setHTTPBody:postData];
//    
//    self.tempData = [NSMutableData alloc];
//	connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    
//    [self.datePicker removeFromSuperview];
//    [self.foundDate resignFirstResponder];
//    //[self.Email resignFirstResponder];
    
}




@end

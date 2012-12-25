//
//  TPLostFormViewController.m
//  MeetMyPet
//
//  Created by Allan on 12/12/8.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPLostFormViewController.h"
#import "NSString+MD5.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"

@interface TPLostFormViewController ()
{
    NSString *typeID;
}


@property (strong, nonatomic) UIDatePicker *datePicker;
@property(strong, nonatomic) UIToolbar *toolbar;

@end

@implementation TPLostFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.lostMap.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.toolbar = [[NSBundle mainBundle] loadNibNamed:@"TPLostToolbar" owner:self options:nil][0];
    self.lostDate.inputAccessoryView = self.toolbar;
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.lostDate.inputView = self.datePicker;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	self.lostDate.text = [NSString stringWithFormat:@"%@",
                           [df stringFromDate:[NSDate date]]];
    
    
    
	self.datePicker.datePickerMode = UIDatePickerModeDate;
	self.datePicker.hidden = NO;
	self.datePicker.date = [NSDate date];
    
    
	[self.datePicker addTarget:self
                        action:@selector(pickDate:)
              forControlEvents:UIControlEventValueChanged];
    
    
    [[self lostDate] setDelegate:self];
    [[self lostMap] setDelegate:self];
    [[self lostMap] setShowsUserLocation:YES];
    
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
        _username.text = [savedPlist valueForKey:@"ownerName"];
    } else {
        NSLog(@"local_profile.plist does not exist");
    }


    
    [self loadProfile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelForm:(id)sender {
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"You have not submitted this form!"
                                                             delegate:self cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Submit Form", @"Discard and Go Back", nil];
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.toolbar = [[NSBundle mainBundle] loadNibNamed:@"TPLostToolbar" owner:self options:nil][0];
    self.lostDate.inputAccessoryView = self.toolbar;
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.lostDate.inputView = self.datePicker;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	self.lostDate.text = [NSString stringWithFormat:@"%@",
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
	self.lostDate.text = [NSString stringWithFormat:@"%@",
                           [df stringFromDate:self.datePicker.date]];
    
}

- (void)loadProfile {
    // Store on disk
    //NSError *error;
    NSArray *plistPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistDocumentsDirectory = [plistPaths objectAtIndex:0];
    //    NSLog(@"plistDocumentsDirectory: %@", plistDocumentsDirectory);
    NSString *plistPath = [plistDocumentsDirectory stringByAppendingPathComponent:@"local_profile.plist"];
    NSFileManager *plistFileMgr = [NSFileManager defaultManager];
    //    NSLog(@"plistPath: %@", plistPath);
    
    // Read data from the plist if the plist file exists
    if ([plistFileMgr fileExistsAtPath:plistPath]) {
        NSMutableDictionary *savedPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        self.petName.text = [savedPlist valueForKey:@"petName"];
        if ([[savedPlist valueForKey:@"petGender"] isEqualToString:@"Male"]) {
            self.petGender.selectedSegmentIndex = 0;
        } else {
            self.petGender.selectedSegmentIndex = 1;
        }
        self.petBreed.text = [savedPlist valueForKey:@"petBreed"];
        if ([[savedPlist valueForKey:@"petChip"] boolValue]) {
            self.petChip.selectedSegmentIndex = 0;
        } else {
            self.petChip.selectedSegmentIndex = 1;
        }
        _username.text = [savedPlist valueForKey:@"ownerName"];
        self.ownerEmail.text = [savedPlist valueForKey:@"ownerEmail"];
        
        
        _petID = [savedPlist valueForKey:@"petID"];
        
        fname = [savedPlist valueForKey:@"hashURL"];
        
        
        [self openPhoto:@"profile_photo.jpg"];
    }
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
- (void)uploadPhoto:(UIImage*) image {
    // Create request
    NSURL *url = [NSURL URLWithString:@"https://csie.ntu.edu.tw/~r00944044/mpptmh/"];
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    fname = [NSString stringWithFormat:@"%@%@", _username.text, dateString];
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

- (NSDictionary *)buildParams {
    typeID = @"1";
    NSString * latitude = [NSString stringWithFormat:@"%f", _lostMap.userLocation.coordinate.latitude];
    NSString * longitude = [NSString stringWithFormat:@"%f", _lostMap.userLocation.coordinate.longitude];
    NSString *gender, *chip;
    
    if (_petGender.selectedSegmentIndex == 0) {
        gender = @"Male";
    } else {
        gender = @"Female";
    }
    if (_petChip.selectedSegmentIndex == 0) {
        chip = @"YES";
    } else {
        chip = @"NO";
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            typeID, @"typeID",
                            _petID, @"petID",
                            fname, @"hashURL",
                            _lostDate.text , @"date",
                            _ownerEmail.text, @"email",
                            longitude, @"longitude",
                            latitude, @"latitude",
                            _petName.text, @"petName",
                            _petBreed.text, @"petBreed",
                            gender, @"petGender",
                            chip, @"petChip",
                            _username.text, @"username",
                            nil];
    return params;
}




- (IBAction)submitForm:(id)sender {
    
    [self.datePicker removeFromSuperview];
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
    
    
}

- (IBAction)toolbarDone:(id)sender {
    self.datePicker.hidden = YES;
    self.toolbar.hidden = YES;
    [self.lostDate resignFirstResponder];
    
    
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

- (IBAction)loadPhoto:(id)sender{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
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



@end

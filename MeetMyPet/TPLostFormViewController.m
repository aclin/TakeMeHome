//
//  TPLostFormViewController.m
//  MeetMyPet
//
//  Created by Allan on 12/12/8.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPLostFormViewController.h"

@interface TPLostFormViewController ()

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
    
    UIImage *patternImage = [UIImage imageNamed:@"background.png"];
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
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
        self.ownerName.text = [savedPlist valueForKey:@"ownerName"];
        self.ownerEmail.text = [savedPlist valueForKey:@"ownerEmail"];
        
        [self openPhoto:@"profile_photo.jpg"];
    }
}


- (IBAction)submitForm:(id)sender {
    
    [self.datePicker removeFromSuperview];
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


@end

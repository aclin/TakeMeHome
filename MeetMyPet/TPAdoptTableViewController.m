//
//  TPAdoptTableViewController.m
//  MeetMyPet
//
//  Created by Evelyn on 12/17/12.
//  Copyright (c) 2012 aclin. All rights reserved.
//

#import "TPAdoptTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NSString+MD5.h"
#import "NSData+MD5.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface TPAdoptTableViewController ()
{
    NSString * typeID;
    ACAccount *facebookAccount;

}

@property (strong, nonatomic) UIDatePicker *datePicker;
@property(strong, nonatomic) UIToolbar *toolbar;

- (void)accessFacebookAccountWithPermission:(NSArray *)permissions Handler:(void (^)(void))handler;

@end

@implementation TPAdoptTableViewController

- (void)accessFacebookAccountWithPermission:(NSArray *)permissions Handler:(void (^)(void))handler; {
    if (!facebookAccount) {
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        
        NSDictionary *facebookRequestOptions = @{
    ACFacebookAppIdKey: @"494252897273531",
    ACFacebookPermissionsKey: permissions,
    ACFacebookAudienceKey: ACFacebookAudienceEveryone,
        };
        [accountStore requestAccessToAccountsWithType:facebookAccountType
                                              options:facebookRequestOptions
                                           completion:^(BOOL granted, NSError *error) {
                                               if (granted) {
                                                   NSArray *accounts = [accountStore
                                                                        accountsWithAccountType:facebookAccountType];
                                                   facebookAccount = [accounts lastObject];
                                                   handler();
                                               } else {
                                                   NSLog(@"Auth Error: %@", [error localizedDescription]);
                                               }
                                           }];
    } else {
        handler();
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([_fromCamera isEqualToString:@"1"])
        _petProfilePic.image = _image;
    
    self.toolbar = [[NSBundle mainBundle] loadNibNamed:@"TPFoundToolbar" owner:self options:nil][0];
    self.date.inputAccessoryView = self.toolbar;
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.date.inputView = self.datePicker;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	self.date.text = [NSString stringWithFormat:@"%@",
                           [df stringFromDate:[NSDate date]]];
    
    
    
	self.datePicker.datePickerMode = UIDatePickerModeDate;
	self.datePicker.hidden = NO;
	self.datePicker.date = [NSDate date];
    
    
	[self.datePicker addTarget:self
                        action:@selector(pickDate:)
              forControlEvents:UIControlEventValueChanged];


    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadPhoto:)];
    [_petProfilePic addGestureRecognizer:tap];
    [_petProfilePic setUserInteractionEnabled:YES];

    
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
        _ownerName.text = [savedPlist valueForKey:@"ownerName"];
        
        NSLog(@"PetID: %@",_petID);
        
        NSLog(@"OwnerName: %@",_ownerName.text);
        //[self openPhoto:@"profile_photo.jpg"];
    } else {
        NSLog(@"local_profile.plist does not exist");
    }


}


- (void) viewDidAppear:(BOOL)animated{
    if ([_usingProfile isEqualToString:@"Yes"]){
        [self loadProfile];
    }
}

- (void) viewDidDisappear:(BOOL)animated{
    _usingProfile = @"No";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.toolbar = [[NSBundle mainBundle] loadNibNamed:@"TPAdoptToolbar" owner:self options:nil][0];
    self.date.inputAccessoryView = self.toolbar;
    self.datePicker = [[UIDatePicker alloc] init];
    self.date.inputView = self.datePicker;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	df.dateStyle = NSDateFormatterMediumStyle;
	self.date.text = [NSString stringWithFormat:@"%@",
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
	self.date.text = [NSString stringWithFormat:@"%@",
                           [df stringFromDate:self.datePicker.date]];
    
}

- (IBAction)toolbarDone:(id)sender{
    self.datePicker.hidden = YES;
    self.toolbar.hidden = YES;
    [self.date resignFirstResponder];
    
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
        self.petAge.text = [savedPlist valueForKey:@"petAge"];
        self.petChar.text = [savedPlist valueForKey:@"petChar"];
        self.petVac.text = [savedPlist valueForKey:@"petVac"];
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
        if ([[savedPlist valueForKey:@"petNeuSpay"] boolValue]) {
            self.petNeuSpay.selectedSegmentIndex = 0;
        } else {
            self.petNeuSpay.selectedSegmentIndex = 1;
        }
        self.ownerName.text = [savedPlist valueForKey:@"ownerName"];
        self.ownerEmail.text = [savedPlist valueForKey:@"ownerEmail"];
        self.city.text = [savedPlist valueForKey:@"city"];
        self.country.text = [savedPlist valueForKey:@"country"];
        
        _petID = [savedPlist valueForKey:@"petID"];
        _ownerName.text = [savedPlist valueForKey:@"ownerName"];
        
        fname = [savedPlist valueForKey:@"hashURL"];
        
        [self openPhoto:@"profile_photo.jpg"];
    }
}

- (IBAction)cancelForm:(id)sender {
    
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"You have not submitted this form!"
                                                             delegate:self cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Submit Form", @"Discard and Go Back", nil];
    targetSheet.tag = 1;
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
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

- (NSDictionary *)buildParams {
    typeID = @"3";
    NSString *gender, *chip, *spay;
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
    if (_petNeuSpay.selectedSegmentIndex == 0) {
        spay = @"YES";
    } else {
        spay = @"NO";
    }


    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            typeID, @"typeID",
                            _petID, @"petID",
                            fname, @"hashURL",
                            _ownerEmail.text , @"email",
                            _petName.text , @"petName",
                            _petBreed.text, @"petBreed",
                            gender, @"petGender",
                            chip,@"petChip",
                            _petAge.text, @"petAge",
                            _petChar.text, @"petChar",
                            _petVac.text, @"petVac",
                            spay, @"petNeuSpay",
                            _city.text, @"city",
                            _country.text , @"country",
                            _ownerName.text , @"username",
                            _date.text , @"date",
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
    
    fname = [NSString stringWithFormat:@"%@%@", _ownerName.text, dateString];
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
    
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"How would you like to save?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save and Post to Facebook", @"Save Only", nil];
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
    targetSheet.tag = 3;
    
}

-(void)uploadTask{
    
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
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // We use SLComposer here. This will post on behalf of iOS or OS X.
    if(actionSheet.tag == 3)
    {
        NSString *serviceType = SLServiceTypeFacebook;
        
        if (buttonIndex==0) {
            
            [self uploadPhoto:_petProfilePic.image];
            [self uploadTask];
            
            SLComposeViewController *composer = [SLComposeViewController composeViewControllerForServiceType:serviceType];
            NSString *text = [NSString stringWithFormat:@"%@ needs a new home.\nAdopt me, please? ^^\n\n-sent from TakeMeHome" , self.petName.text ];
            [composer setInitialText:text];
            [composer addImage:self.petProfilePic.image];
            [composer addURL:[NSURL URLWithString:@"https://www.facebook.com/Taktmehome"]];
            
            composer.completionHandler = ^(SLComposeViewControllerResult result) {
                NSString *title = nil;
                if (result==SLComposeViewControllerResultCancelled) title = @"Post canceled";
                else if (result==SLComposeViewControllerResultDone) title = @"Post sent";
                else title = @"Unknown";
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            };
            [self presentViewController:composer animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else if(buttonIndex==1)
        {
            
            [self uploadPhoto:_petProfilePic.image];
            [self uploadTask];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }else if (actionSheet.tag == 2) {
        if (buttonIndex == 0) {
            [self performSelector:@selector(takePicture:) withObject:self];
        } else if(buttonIndex == 1) {
            [self makeUIImagePickerControllerForCamera:self];
        } else {
            return;
        }
    }else if (actionSheet.tag == 1){
        if (buttonIndex==0){
            [self uploadPhoto:_petProfilePic.image];
            [self uploadTask];
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (buttonIndex==1){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end

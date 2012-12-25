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

@interface TPAdoptTableViewController ()
{
    NSString * typeID;
}

@end

@implementation TPAdoptTableViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadPhoto:)];
    [_petProfilePic addGestureRecognizer:tap];
    [_petProfilePic setUserInteractionEnabled:YES];
    
    //_usingProfile = FALSE;
    
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == 1){
        if (buttonIndex == 0) {
            // Submit the form to the server
            
        } else if (buttonIndex == 1) {
            // Discard the form and return to the previous page
            //[self dismissViewControllerAnimated:YES completion:nil];
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
    
}


@end

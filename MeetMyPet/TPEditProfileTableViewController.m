//
//  editProfileTableViewController.m
//  THProfile
//
//  Created by Evelyn on 12/14/12.
//  Copyright (c) 2012 Evelyn. All rights reserved.
//

#import "TPEditProfileTableViewController.h"
#import "NSString+MD5.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"

@interface TPEditProfileTableViewController ()

@end

@implementation TPEditProfileTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    UIImage *patternImage = [UIImage imageNamed:@"background.png"];
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    [self loadProfile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Load saved profile data to all the text fields
// If this is the first time the user loads this page
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
        self.petAge.text = [savedPlist valueForKey:@"petAge"];
        self.petAnimal.text = [savedPlist valueForKey:@"petAnimal"];
        self.petChar.text = [savedPlist valueForKey:@"petChar"];
        self.petHobbies.text = [savedPlist valueForKey:@"petHobbies"];
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
        self.petVac.text = [savedPlist valueForKey:@"petVac"];
    
        self.ownerEmail.text = [savedPlist valueForKey:@"ownerEmail"];
        self.city.text = [savedPlist valueForKey:@"city"];
        self.country.text = [savedPlist valueForKey:@"country"];
        
        _petID = [savedPlist valueForKey:@"petID"];
        NSLog(@"%@", _petID);
        _ownerName.text = [savedPlist valueForKey:@"ownerName"];
        _userName = [savedPlist valueForKey:@"ownerName"];
        
        [self openPhoto:@"profile_photo.jpg"];
    } else {
        NSLog(@"local_profile.plist does not exist");
    }
}

- (IBAction)saveProfile:(id)sender {
    // Store on disk
    NSError *error;
    NSArray *plistPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistDocumentsDirectory = [plistPaths objectAtIndex:0];
//    NSLog(@"plistDocumentsDirectory: %@", plistDocumentsDirectory);
    NSString *plistPath = [plistDocumentsDirectory stringByAppendingPathComponent:@"local_profile.plist"];
    NSFileManager *plistFileMgr = [NSFileManager defaultManager];
//    NSLog(@"plistPath: %@", plistPath);
    
    // Create a plist if it doesn't already exist
    if (![plistFileMgr fileExistsAtPath:plistPath]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"local_profile" ofType:@"plist"];
        [plistFileMgr copyItemAtPath:bundle toPath:plistPath error:&error];
    }
    
    // Write to the plist
    NSMutableDictionary *localProfilePlist = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    [localProfilePlist setObject:[NSString stringWithFormat:@"%@", self.petName.text] forKey:@"petName"];
    [localProfilePlist setObject:[NSString stringWithFormat:@"%@", [self.petGender titleForSegmentAtIndex:self.petGender.selectedSegmentIndex]] forKey:@"petGender"];
    [localProfilePlist setObject:[NSString stringWithFormat:@"%@", self.petBreed.text] forKey:@"petBreed"];
    [localProfilePlist setObject:[NSString stringWithFormat:@"%@", self.petAge.text] forKey:@"petAge"];
    [localProfilePlist setObject:[NSString stringWithFormat:@"%@", self.petAnimal.text] forKey:@"petAnimal"];
    [localProfilePlist setObject:[NSString stringWithFormat:@"%@", self.petChar.text] forKey:@"petChar"];
    [localProfilePlist setObject:[NSString stringWithFormat:@"%@", self.petHobbies.text] forKey:@"petHobbies"];
    if (self.petChip.selectedSegmentIndex == 0) {
        [localProfilePlist setObject:[NSNumber numberWithBool:YES] forKey:@"petChip"];
    } else {
        [localProfilePlist setObject:[NSNumber numberWithBool:NO] forKey:@"petChip"];
    }
    if (self.petNeuSpay.selectedSegmentIndex == 0) {
        [localProfilePlist setObject:[NSNumber numberWithBool:YES] forKey:@"petNeuSpay"];
    } else {
        [localProfilePlist setObject:[NSNumber numberWithBool:NO] forKey:@"petNeuSpay"];
    }
    [localProfilePlist setObject:[NSString stringWithFormat:@"%@", self.petVac.text] forKey:@"petVac"];
    
    [localProfilePlist setObject:[NSString stringWithFormat:@"%@", self.ownerEmail.text] forKey:@"ownerEmail"];
    [localProfilePlist setObject:[NSString stringWithFormat:@"%@", self.city.text] forKey:@"city"];
    [localProfilePlist setObject:[NSString stringWithFormat:@"%@", self.country.text] forKey:@"country"];
    if (photoChanged) {
        [self savePhoto:_petProfilePic.image];
        [self uploadPhoto:_petProfilePic.image];
        NSLog(@"%@", @"Photo changed");
    } else {
        fname = @"";
    }
    
    [localProfilePlist writeToFile:plistPath atomically:YES];
    
    [self uploadProfile];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) savePhoto:(UIImage*) image{
    
    NSData *jpgData = UIImageJPEGRepresentation(image, 0.5);
    NSString *filePath = [self documentsPathForFileName:@"profile_photo.jpg"];
    [jpgData writeToFile:filePath atomically:YES]; //Write the file
    NSLog(@"%@", filePath);
}

- (void)uploadPhoto:(UIImage*) image {
    // Create request
    NSURL *url = [NSURL URLWithString:@"https://csie.ntu.edu.tw/~r00944044/mpptmh/"];
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    fname = [NSString stringWithFormat:@"%@%@", _ownerName, dateString];
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

- (IBAction)cancelForm:(id)sender {
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"Canceling will discard all changes!"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Discard and Go Back", nil];
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
            // Discard the changes to the profile and return to the previous page
            //        [self dismissViewControllerAnimated:YES completion:nil];
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
    photoChanged = TRUE;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSDictionary *)buildParams {
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
                            _petName.text, @"petName",
                            _petAge.text, @"petAge",
                            _petBreed.text, @"petBreed",
                            gender, @"petGender",
                            _petChar.text, @"petChar",
                            _petHobbies.text, @"petHobbies",
                            chip, @"petChip",
                            spay, @"petNeuSpay",
                            _petVac.text, @"petVac",
                            _city.text, @"city",
                            _country.text, @"country",
                            _ownerEmail.text, @"email",
                            _petID, @"petID",
                            fname, @"hashURL",
                            nil];
    return params;
}

- (void)uploadProfile {
    NSURL *url = [NSURL URLWithString:@"https://secret-temple-2872.herokuapp.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/api/ProfileUpload/"
                                                      parameters:[self buildParams]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [operation responseString];
        NSLog(@"response: [%@]\n",response);
        NSLog(@"Response Object: %@", [NSString stringWithFormat:@"%@", responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if([operation.response statusCode] == 403){
            NSLog(@"Upload Failed");
            return;
        }
        NSLog(@"error: %@", [operation error]);
        
    }];
    
    [operation start];
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"JSON: %@", JSON);
//        NSLog(@"Response: %d", response.statusCode);
//        
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        NSLog(@"Error: %@ \nResponse: %d", error, response.statusCode);
//    }];
//    
//    [operation start];
}

@end

//
//  editProfileTableViewController.h
//  THProfile
//
//  Created by Evelyn on 12/14/12.
//  Copyright (c) 2012 Evelyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

bool *photoChanged;
NSString *fname;

@interface TPEditProfileTableViewController : UITableViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSDictionary<FBGraphUser> *user;
@property (strong, nonatomic) IBOutlet UIImageView *petProfilePic;
@property (strong, nonatomic) IBOutlet UITextField *petName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *petGender;
@property (strong, nonatomic) IBOutlet UITextField *petBreed;
@property (strong, nonatomic) IBOutlet UITextField *petAge;
@property (strong, nonatomic) IBOutlet UITextField *petAnimal;
@property (strong, nonatomic) IBOutlet UITextView *petChar;
@property (strong, nonatomic) IBOutlet UITextView *petHobbies;
@property (strong, nonatomic) IBOutlet UISegmentedControl *petChip;
@property (strong, nonatomic) IBOutlet UISegmentedControl *petNeuSpay;
@property (strong, nonatomic) IBOutlet UITextView *petVac;
@property (strong, nonatomic) IBOutlet UILabel *ownerName;
@property (strong, nonatomic) IBOutlet UITextField *ownerEmail;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *country;

@property (strong, nonatomic) NSString *petID;
@property (strong, nonatomic) NSString *userName;

- (IBAction)saveProfile:(id)sender;
- (IBAction)cancelForm:(id)sender;
- (IBAction)loadPhoto:(id)sender;
- (IBAction)takePicture:(id)sender;
- (void) savePhoto:(UIImage*)image;
- (void)openPhoto:(NSString*) filename;
- (void)uploadPhoto:(UIImage*)image;
- (NSString *)documentsPathForFileName:(NSString *)name;
@property (strong, nonatomic) IBOutlet UIImageView *camera;
- (NSDictionary *)buildParams;
- (void)uploadProfile;

@end

//
//  TPAdoptTableViewController.h
//  MeetMyPet
//
//  Created by Evelyn on 12/17/12.
//  Copyright (c) 2012 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPAdoptTableViewController : UITableViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *petProfilePic;
@property (strong, nonatomic) IBOutlet UITextField *petName;
@property (strong, nonatomic) IBOutlet UITextField *petBreed;
@property (strong, nonatomic) IBOutlet UISegmentedControl *petGender;
@property (strong, nonatomic) IBOutlet UITextField *petAge;
@property (strong, nonatomic) IBOutlet UITextView *petChar;
@property (strong, nonatomic) IBOutlet UITextView *petVac;
@property (strong, nonatomic) IBOutlet UISegmentedControl *petChip;
@property (strong, nonatomic) IBOutlet UISegmentedControl *petNeuSpay;
@property (strong, nonatomic) IBOutlet UILabel *ownerName;
@property (strong, nonatomic) IBOutlet UITextField *ownerEmail;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *country;
@property (strong, nonatomic) NSString *usingProfile;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil set:(BOOL *)useProfile;

- (id)initWithProfile:(BOOL)useProfile;
- (IBAction)loadPhoto:(id)sender;
- (IBAction)cancelForm:(id)sender;
- (IBAction)takePicture:(id)sender;
- (void)openPhoto:(NSString*)filename;
- (NSString *)documentsPathForFileName:(NSString *)name;

@end

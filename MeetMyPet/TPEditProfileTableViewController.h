//
//  editProfileTableViewController.h
//  THProfile
//
//  Created by Evelyn on 12/14/12.
//  Copyright (c) 2012 Evelyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPEditProfileTableViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *petProfilePic;
@property (strong, nonatomic) IBOutlet UITextField *petName;
@property (strong, nonatomic) IBOutlet UITextField *petGender;
@property (strong, nonatomic) IBOutlet UITextField *petBreed;
@property (strong, nonatomic) IBOutlet UITextField *petAge;
@property (strong, nonatomic) IBOutlet UITextField *petAnimal;
@property (strong, nonatomic) IBOutlet UITextView *petChar;
@property (strong, nonatomic) IBOutlet UITextView *petHobbies;
@property (strong, nonatomic) IBOutlet UISegmentedControl *petChip;
@property (strong, nonatomic) IBOutlet UISegmentedControl *petNeuSpay;
@property (strong, nonatomic) IBOutlet UITextView *petVac;

@property (strong, nonatomic) IBOutlet UITextField *ownerEmail;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *country;

- (IBAction)saveProfile:(id)sender;
- (IBAction)cancelForm:(id)sender;

@end

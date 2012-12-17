//
//  editProfileTableViewController.m
//  THProfile
//
//  Created by Evelyn on 12/14/12.
//  Copyright (c) 2012 Evelyn. All rights reserved.
//

#import "TPEditProfileTableViewController.h"

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
    NSError *error;
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
    
    [localProfilePlist writeToFile:plistPath atomically:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelForm:(id)sender {
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"Canceling will discard all changes!"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Discard and Go Back", nil];
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Discard the changes to the profile and return to the previous page
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        return;
    }
}

@end

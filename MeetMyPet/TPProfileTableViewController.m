//
//  profileTableViewController.m
//  THProfile
//
//  Created by Evelyn on 12/14/12.
//  Copyright (c) 2012 Evelyn. All rights reserved.
//

#import "TPProfileTableViewController.h"

@interface TPProfileTableViewController ()

@end

@implementation TPProfileTableViewController

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
    
    UIImage *patternImage = [UIImage imageNamed:@"background.png"];
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadProfile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
            self.petChip.text = @"Yes";
        } else {
            self.petChip.text = @"No";
        }
        if ([[savedPlist valueForKey:@"petNeuSpay"] boolValue]) {
            self.petNeuSpay.text = @"Yes";
        } else {
            self.petNeuSpay.text = @"No";
        }
        self.petVac.text = [savedPlist valueForKey:@"petVac"];
        
        self.ownerEmail.text = [savedPlist valueForKey:@"ownerEmail"];
        self.city.text = [savedPlist valueForKey:@"city"];
        self.country.text = [savedPlist valueForKey:@"country"];
    }
}

@end

//
//  ViewController.m
//  THProfile
//
//  Created by Evelyn on 12/14/12.
//  Copyright (c) 2012 Evelyn. All rights reserved.
//

#import "TPHomeViewController.h"
#import "TPAppDelegate.h"
#import "TPProfileTableViewController.h"

@interface TPHomeViewController ()

@property (strong, nonatomic) NSDictionary<FBGraphUser> *user;
- (void)sessionStateChanged:(NSNotification*)notification;

@end

@implementation TPHomeViewController

- (void)sessionStateChanged:(NSNotification*)notification {
    if (!FBSession.activeSession.isOpen) {
        [self performSegueWithIdentifier:@"SegueToLogin" sender:self];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage *patternImage = [UIImage imageNamed:@"background"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Check the session for a cached token to show the proper authenticated
        // UI. However, since this is not user intitiated, do not show the login UX.
        TPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate openSessionWithAllowLoginUI:NO];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Present login modal if necessary after the view has been
    // displayed, not in viewWillAppear: so as to allow display
    // stack to "unwind"
    if(FBSession.activeSession.isOpen ||
               FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded ||
               FBSession.activeSession.state == FBSessionStateCreatedOpening) {
        [self populateUserDetails];
//        [self saveProfile];
    } else {
        [self performSegueWithIdentifier:@"SegueToLogin" sender:self];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonClicked:(id)sender {
    TPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate closeSession];
}

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *userName,
           NSError *error) {
             if (!error) {
                 self.user = userName;
                 self.lblName.text = userName.name;
                 [self saveProfile];
                 [self openPhoto:@"profile_photo.jpg"];
             }
         }];
    }
}

- (void)saveProfile {
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
        
        // Write to the plist
        NSMutableDictionary *localProfilePlist = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        
        [localProfilePlist setObject:[NSString stringWithFormat:@"%@", self.user.name] forKey:@"ownerName"];
        [localProfilePlist setObject:[NSString stringWithFormat:@"%@", self.user.id] forKey:@"petID"];
        NSLog(@"Username2: %@", self.user.name);
        NSLog(@"UserID2: %@", self.user.id);
        
        [localProfilePlist writeToFile:plistPath atomically:YES];
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
    
@end

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

@synthesize user = _user;

- (void)sessionStateChanged:(NSNotification*)notification {
    if (!FBSession.activeSession.isOpen) {
        [self performSegueWithIdentifier:@"SegueToLogin" sender:self];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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

@end

//
//  TPHomeViewController.m
//  MeetMyPet
//
//  Created by Allan on 12/12/5.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPHomeViewController.h"
#import "TPAppDelegate.h"

@interface TPHomeViewController ()

@end

@implementation TPHomeViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    TPAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate closeSession];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  TPLostFoundCollectionViewController.m
//  MeetMyPet
//
//  Created by Allan on 12/12/9.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPLostFoundCollectionViewController.h"

@interface TPLostFoundCollectionViewController ()

@end

@implementation TPLostFoundCollectionViewController

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

- (IBAction)createReport:(id)sender {
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"What Would You Like to Report?"
                                                             delegate:self cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Report Lost", @"Report Found", nil];
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Report lost
        [self performSegueWithIdentifier:@"showLostForm" sender:self];
//        TPLostFormViewController *lostFormViewController = [[TPLostFormViewController alloc] init];
//        [self.navigationController pushViewController:lostFormViewController animated:YES];
    } else if (buttonIndex == 1) {
        // Report found
        [self performSegueWithIdentifier:@"showFoundForm" sender:self];
//        TPFoundFormViewController *foundFormViewController = [[TPFoundFormViewController alloc] init];
//        [self.navigationController pushViewController:foundFormViewController animated:YES];
    } else {
        return;
    }
}

@end

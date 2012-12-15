//
//  TPCameraViewController.m
//  MeetMyPet
//
//  Created by Allan on 12/12/4.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPCameraViewController.h"

@interface TPCameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@end

@implementation TPCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadActionSheet:)];
    [_myImage addGestureRecognizer:tap];
    [_myImage setUserInteractionEnabled:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    _defaultImage = [UIImage imageNamed:@"default_photo.png"];
    if (pictureTaken==false)
        [self performSelector:@selector(takePicture:) withObject:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (pictureTaken)
        pictureTaken = false;
    [_myImage setImage:_defaultImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *newImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [_myImage setImage:newImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    pictureTaken = true;
    
    // Save image
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    //else // All is well
    //        alert = [[UIAlertView alloc] initWithTitle:@"Success"
    //                                           message:@"Image saved to Photo Album."
    //                                          delegate:self cancelButtonTitle:@"Ok"
    //                                 otherButtonTitles:nil];
    //    [alert show];
    [self performSelector:@selector(loadActionSheet:) withObject:self];
}


- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    pictureTaken = false;
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
}


- (IBAction)loadActionSheet:(id)sender
{
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"What do you like to do with this picture?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Nothing"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Set Profile Picture", @"Report Lost", @"Report Found", @"Post for Adopt", nil];
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // Report lost
        //[self performSegueWithIdentifier:@"showLostForm" sender:self];
        // TPLostFormViewController *lostFormViewController = [[TPLostFormViewController alloc] init];
        // [self.navigationController pushViewController:lostFormViewController animated:YES];
    } else if (buttonIndex == 1) {
        // Report found
        //[self performSegueWithIdentifier:@"showFoundForm" sender:self];
        // TPFoundFormViewController *foundFormViewController = [[TPFoundFormViewController alloc] init];
        // [self.navigationController pushViewController:foundFormViewController animated:YES];
    } else if (buttonIndex == 2) {
        //
    } else if (buttonIndex == 3) {
        //
    } else {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
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
    
    //    Use ModalView for iOS 5.1 or earlier
    //    [self presentModalViewController:imagePicker animated:NO];
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}


@end

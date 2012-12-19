//
//  TPCameraViewController.m
//  MeetMyPet
//
//  Created by Allan on 12/12/4.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPCameraViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NSString+MD5.h"
#import "NSData+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@interface TPCameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    NSURLConnection *connect;
}
@property (strong, nonatomic) NSDictionary<FBGraphUser> *user;
@end

@implementation TPCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadActionSheet:)];
    [_myImage addGestureRecognizer:tap];
    [_myImage setUserInteractionEnabled:YES];
    
    UIImage *patternImage = [UIImage imageNamed:@"background"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
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
        [self uploadPhotoDB];
        //[self performSegueWithIdentifier:@"showFoundForm" sender:self];
        // TPFoundFormViewController *foundFormViewController = [[TPFoundFormViewController alloc] init];
        // [self.navigationController pushViewController:foundFormViewController animated:YES];
    } else if (buttonIndex == 2) {
        [self uploadPhotoDB];
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

-(void)uploadPhotoDB{
    
    NSString * owner = self.user.id;
    
    NSLog(@"owner:%@",owner);
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    NSString *str =[NSString stringWithFormat:@"%@%@", owner, dateString];
    
    str = [str MD5];
    
    NSString *post = [NSString stringWithFormat:@"hashURL=%@",str];
    NSLog(@"%@", post);
    
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:@"http://secret-temple-2872.herokuapp.com/api/PhotoUpload/"]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	
	[request setHTTPBody:postData];
    
    connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{   //發生錯誤
	NSLog(@"發生錯誤");
}
- (void)connection: (NSURLConnection *)connection didReceiveResponse: (NSURLResponse *)aResponse {  //連線建立成功
    //取得狀態
    NSInteger status = (NSInteger)[(NSHTTPURLResponse *)aResponse statusCode];
    NSLog(@"%d", status);
}
-(void) connection:(NSURLConnection *)connection didReceiveData: (NSData *) incomingData
{   //收到封包，將收到的資料塞進緩衝中並修改進度條
	[self.tempData appendData:incomingData];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{   //檔案下載完成
    NSString *loadData = [[NSMutableString alloc] initWithData:self.tempData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", loadData);
}


@end

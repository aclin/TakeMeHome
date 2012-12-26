//
//  TPFoundFormViewController.h
//  MeetMyPet
//
//  Created by Allan on 12/12/8.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NSString *fname;
@interface TPFoundFormViewController : UITableViewController <UIActionSheetDelegate, MKMapViewDelegate, UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *petProfilePic;
@property (strong, nonatomic) IBOutlet UITextField *foundDate;
@property (strong, nonatomic) IBOutlet MKMapView *foundMap;

@property (strong, nonatomic) NSString *petID;
@property (strong, nonatomic) NSString *username;

@property(strong,nonatomic)NSMutableData *tempData;

@property(strong, nonatomic) NSString *test;

- (IBAction)loadPhoto:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)submitForm:(id)sender;
- (IBAction)cancelForm:(id)sender;
- (void)pickDate;

- (void) savePhoto:(UIImage*)image;
- (void)openPhoto:(NSString*) filename;
- (NSString *)documentsPathForFileName:(NSString *)name;
- (NSDictionary *)buildParams;

- (IBAction)toolbarDone:(id)sender;

@end

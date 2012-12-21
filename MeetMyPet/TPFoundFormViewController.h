//
//  TPFoundFormViewController.h
//  MeetMyPet
//
//  Created by Allan on 12/12/8.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface TPFoundFormViewController : UITableViewController <UIActionSheetDelegate, MKMapViewDelegate, UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *petProfilePic;
@property (strong, nonatomic) IBOutlet UITextField *foundDate;
@property (strong, nonatomic) IBOutlet MKMapView *foundMap;

@property(strong,nonatomic)NSMutableData *tempData;

- (IBAction)loadPhoto:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)submitForm:(id)sender;
- (IBAction)cancelForm:(id)sender;
- (void)pickDate;

- (IBAction)toolbarDone:(id)sender;
//- (IBAction)toolbarClear:(id)sender;
@end

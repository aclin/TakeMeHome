//
//  TPLostFormViewController.h
//  MeetMyPet
//
//  Created by Allan on 12/12/8.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NSString *fname;

@interface TPLostFormViewController : UITableViewController <UIActionSheetDelegate, MKMapViewDelegate,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImage *image;
@property(strong, nonatomic) NSString *test;
@property (strong, nonatomic) IBOutlet UIImageView *petProfilePic;
@property (strong, nonatomic) IBOutlet UITextField *petName;
@property (strong, nonatomic) IBOutlet UISegmentedControl *petGender;
@property (strong, nonatomic) IBOutlet UITextField *petBreed;
@property (strong, nonatomic) IBOutlet UISegmentedControl *petChip;
@property (strong, nonatomic) IBOutlet MKMapView *lostMap;
@property (strong, nonatomic) IBOutlet UITextField *lostDate;

@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UITextField *ownerEmail;
@property (strong, nonatomic) NSString *petID;

- (IBAction)cancelForm:(id)sender;
- (IBAction)submitForm:(id)sender;
- (IBAction)loadPhoto:(id)sender;
- (IBAction)takePicture:(id)sender;

- (IBAction)toolbarDone:(id)sender;


- (NSString *)documentsPathForFileName:(NSString *)name;
- (NSDictionary *)buildParams;


@end

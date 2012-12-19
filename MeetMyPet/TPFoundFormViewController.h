//
//  TPFoundFormViewController.h
//  MeetMyPet
//
//  Created by Allan on 12/12/8.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface TPFoundFormViewController : UITableViewController <UIActionSheetDelegate, MKMapViewDelegate, UITextFieldDelegate,UINavigationControllerDelegate>

//@property (strong, nonatomic) NSNumber *petID;
//@property (strong, nonatomic) NSNumber *typeID;


@property (strong, nonatomic) IBOutlet UITextField *Email;

@property (strong, nonatomic) IBOutlet UITextField *foundDate;
@property (strong, nonatomic) IBOutlet MKMapView *foundMap;
@property (strong, nonatomic) IBOutlet UIImageView *photoID;


@property(strong, nonatomic) NSMutableData *tempData;    //下載時暫存用的記憶體




- (IBAction)submitForm:(id)sender;
- (IBAction)cancelForm:(id)sender;
- (void)pickDate;

- (IBAction)toolbarDone:(id)sender;
//- (IBAction)toolbarClear:(id)sender;
@end

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


@property (strong, nonatomic) IBOutlet UITextField *foundDate;
@property (strong, nonatomic) IBOutlet MKMapView *foundMap;




- (IBAction)submitForm:(id)sender;
- (IBAction)cancelForm:(id)sender;
- (void)pickDate;

- (IBAction)toolbarDone:(id)sender;
//- (IBAction)toolbarClear:(id)sender;
@end

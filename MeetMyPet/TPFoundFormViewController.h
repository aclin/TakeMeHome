//
//  TPFoundFormViewController.h
//  MeetMyPet
//
//  Created by Allan on 12/12/8.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TPFoundFormViewController : UIViewController <UIActionSheetDelegate, MKMapViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *foundDate;
@property (strong, nonatomic) IBOutlet MKMapView *foundMap;

- (IBAction)cancelForm:(id)sender;
- (void)pickDate;
@end

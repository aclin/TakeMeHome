//
//  TPLostFormViewController.h
//  MeetMyPet
//
//  Created by Allan on 12/12/8.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TPLostFormViewController : UIViewController <UIActionSheetDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UITextField *petName;
@property (strong, nonatomic) IBOutlet UITextField *petType;
@property (strong, nonatomic) IBOutlet UITextField *petBreed;
@property (strong, nonatomic) IBOutlet UISegmentedControl *genderSegCtrl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *chipImplanted;
@property (strong, nonatomic) IBOutlet MKMapView *lostMap;

- (IBAction)cancelForm:(id)sender;

@end

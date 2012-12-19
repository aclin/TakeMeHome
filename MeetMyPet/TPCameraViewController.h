//
//  TPCameraViewController.h
//  MeetMyPet
//
//  Created by Allan on 12/12/4.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>

BOOL pictureTaken;

@interface TPCameraViewController : UIViewController

@property(strong, nonatomic) NSMutableData *tempData;
@property (strong, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (nonatomic) UIImage *defaultImage;

- (IBAction)takePicture:(id)sender;
- (IBAction)loadActionSheet:(id)sender;

@end

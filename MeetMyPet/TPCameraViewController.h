//
//  TPCameraViewController.h
//  MeetMyPet
//
//  Created by Allan on 12/12/4.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPCameraViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *myImage;

- (IBAction)takePicture:(id)sender;

@end

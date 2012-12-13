//
//  TPLoginViewController.h
//  MeetMyPet
//
//  Created by Allan on 12/12/13.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface TPLoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)login:(id)sender;

@end

//
//  ViewController.h
//  THProfile
//
//  Created by Evelyn on 12/14/12.
//  Copyright (c) 2012 Evelyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPHomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *petProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *lblName;

- (void)openPhoto:(NSString*) filename;
- (NSString *)documentsPathForFileName:(NSString *)name;

@end

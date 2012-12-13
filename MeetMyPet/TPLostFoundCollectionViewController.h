//
//  TPLostFoundCollectionViewController.h
//  MeetMyPet
//
//  Created by Allan on 12/12/9.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPLostFormViewController.h"
#import "TPFoundFormViewController.h"

@interface TPLostFoundCollectionViewController : UICollectionViewController <UIActionSheetDelegate>

- (IBAction)createReport:(id)sender;

@end

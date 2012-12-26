//
//  TPFeedTableCell.h
//  MeetMyPet
//
//  Created by Allan on 12/12/5.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPFeedTableCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *feedImage;
@property (strong, nonatomic) IBOutlet UILabel *dateOfPosts;
@property (strong, nonatomic) IBOutlet UILabel *typeOfPosts;

@end

//
//  TPFoundPostTableViewController.h
//  MeetMyPet
//
//  Created by Johnny Bee on 12/12/20.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TPPlist.h"

@interface TPFoundPostTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIImageView *petProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *dateFound;
@property (strong, nonatomic) IBOutlet MKMapView *map;

@property(strong,nonatomic)NSMutableData *tempData;
@end

//
//  TPLostPostTableViewController.h
//  MeetMyPet
//
//  Created by Johnny Bee on 12/12/20.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TPLostPostTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIImageView *petProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *petName;
@property (strong, nonatomic) IBOutlet UILabel *petBreed;
@property (strong, nonatomic) IBOutlet UILabel *dateLost;
@property (strong, nonatomic) IBOutlet UILabel *petGender;
@property (strong, nonatomic) IBOutlet UILabel *petChip;
@property (strong, nonatomic) IBOutlet UILabel *ownerName;
@property (strong, nonatomic) IBOutlet UILabel *ownerEmail;
@property (strong, nonatomic) IBOutlet MKMapView *map;

@end

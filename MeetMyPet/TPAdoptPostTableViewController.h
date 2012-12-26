//
//  TPAdoptPostTableViewController.h
//  MeetMyPet
//
//  Created by Evelyn on 12/26/12.
//  Copyright (c) 2012 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPAdoptPostTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSDictionary *adoptPost;
@property (strong, nonatomic) IBOutlet UILabel *petName;
@property (strong, nonatomic) IBOutlet UIImageView *petImage;
@property (strong, nonatomic) IBOutlet UILabel *petGender;
@property (strong, nonatomic) IBOutlet UILabel *petBreed;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *petAge;
@property (strong, nonatomic) IBOutlet UILabel *petChar;
@property (strong, nonatomic) IBOutlet UILabel *petChip;
@property (strong, nonatomic) IBOutlet UILabel *petNeuSpay;
@property (strong, nonatomic) IBOutlet UILabel *petVac;
@property (strong, nonatomic) IBOutlet UILabel *ownerName;
@property (strong, nonatomic) IBOutlet UILabel *ownerEmail;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UILabel *country;

@end

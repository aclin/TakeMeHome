//
//  profileTableViewController.h
//  THProfile
//
//  Created by Evelyn on 12/14/12.
//  Copyright (c) 2012 Evelyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPProfileTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *petName;
@property (strong, nonatomic) IBOutlet UILabel *petGender;
@property (strong, nonatomic) IBOutlet UILabel *petBreed;
@property (strong, nonatomic) IBOutlet UILabel *petAge;
@property (strong, nonatomic) IBOutlet UILabel *petAnimal;
@property (strong, nonatomic) IBOutlet UILabel *petChar;
@property (strong, nonatomic) IBOutlet UILabel *petHobbies;
@property (strong, nonatomic) IBOutlet UILabel *petChip;
@property (strong, nonatomic) IBOutlet UILabel *petNeuSpay;
@property (strong, nonatomic) IBOutlet UILabel *petVac;

@property (strong, nonatomic) IBOutlet UILabel *ownerName;
@property (strong, nonatomic) IBOutlet UILabel *ownerEmail;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UILabel *country;

@end

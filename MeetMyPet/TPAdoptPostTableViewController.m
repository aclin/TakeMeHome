//
//  TPAdoptPostTableViewController.m
//  MeetMyPet
//
//  Created by Evelyn on 12/26/12.
//  Copyright (c) 2012 aclin. All rights reserved.
//

#import "TPAdoptPostTableViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TPAdoptPostTableViewController ()

@end

@implementation TPAdoptPostTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *boxBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:boxBackView];
    
    self.petName.text = [self.adoptPost objectForKey:@"PetName"];
    self.petGender.text=[self.adoptPost objectForKey:@"PetGender"];
    self.petBreed.text = [self.adoptPost objectForKey:@"PetBreed"];
    self.date.text = [self.adoptPost objectForKey:@"Date"];
    self.petAge.text = [self.adoptPost objectForKey:@"PetAge"];
    self.petChar.text = [self.adoptPost objectForKey:@"PetChar"];
    self.petChip.text =[self.adoptPost objectForKey:@"PetChip"];
    self.petNeuSpay.text = [self.adoptPost objectForKey:@"PetNeuSpay"];
    self.petVac.text = [self.adoptPost objectForKey:@"PetVac"];
    self.ownerName.text = [self.adoptPost objectForKey:@"UserName"];
    self.ownerEmail.text = [self.adoptPost objectForKey:@"Email"];
    self.city.text = [self.adoptPost objectForKey:@"City"];
    self.country.text = [self.adoptPost objectForKey:@"Country"];
    
    NSString *imageName = [self.adoptPost objectForKey:@"ImageName"];
    NSString *imageURL = [NSString stringWithFormat:@"http://www.csie.ntu.edu.tw/~r00944044/mpptmh/tmhphotos/%@" ,  imageName];
    [self.petImage setImageWithURL:[NSURL URLWithString:imageURL]];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

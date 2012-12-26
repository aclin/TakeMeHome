//
//  TPFoundPostTableViewController.m
//  MeetMyPet
//
//  Created by Johnny Bee on 12/12/20.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPFoundPostTableViewController.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+AFNetworking.h"

@interface TPFoundPostTableViewController (){

NSURLConnection *connect;
}

@end

@implementation TPFoundPostTableViewController

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

    NSLog(@"%@", _data);
    self.dateFound.text = [_data objectForKey:@"Date"];
    NSString *imageName = [_data objectForKey:@"ImageName"];
    NSString *imageURL = [NSString stringWithFormat:@"http://www.csie.ntu.edu.tw/~r00944044/mpptmh/tmhphotos/%@" ,  imageName];
    [self.petProfilePic setImageWithURL:[NSURL URLWithString:imageURL]];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated{
    [self loadMap];
    UIImageView *boxBackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:boxBackView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMap{
    

    CLLocationDegrees lat = [[_data objectForKey:@"Latitude"] doubleValue];
    CLLocationDegrees lng = [[_data objectForKey:@"Longitude"] doubleValue];
    
    
    NSString *name = @"Last Seen";
    TPAnnotation *loc = [[TPAnnotation alloc] initWithName:name coordinate:CLLocationCoordinate2DMake(lat, lng)];
    
    [_map addAnnotation:loc];
    
    CLLocationCoordinate2D taipeiCityCoord = CLLocationCoordinate2DMake(lat, lng);
    MKCoordinateRegion taipeiCityRegion = MKCoordinateRegionMakeWithDistance(taipeiCityCoord, 750, 750);
    [self.map setCenterCoordinate:taipeiCityCoord];
    [self.map setRegion:taipeiCityRegion animated:YES];
}

@end

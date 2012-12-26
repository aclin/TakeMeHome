//
//  TPLostPostTableViewController.m
//  MeetMyPet
//
//  Created by Johnny Bee on 12/12/20.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPLostPostTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TPLostPostTableViewController ()

@end

@implementation TPLostPostTableViewController

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
    
    self.petName.text = [self.lostData objectForKey:@"PetName"];
    self.petGender.text=[self.lostData objectForKey:@"PetGender"];
    self.petBreed.text = [self.lostData objectForKey:@"PetBreed"];
    self.dateLost.text = [self.lostData objectForKey:@"Date"];

    
    self.petChip.text =[self.lostData objectForKey:@"PetChip"];
    self.ownerName.text = [self.lostData objectForKey:@"UserName"];
    self.ownerEmail.text = [self.lostData objectForKey:@"Email"];
    
    NSString *imageName = [self.lostData objectForKey:@"ImageName"];
    NSString *imageURL = [NSString stringWithFormat:@"http://www.csie.ntu.edu.tw/~r00944044/mpptmh/tmhphotos/%@" ,  imageName];
    [self.petProfilePic setImageWithURL:[NSURL URLWithString:imageURL]];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    CLLocationDegrees lat = [[self.lostData objectForKey:@"Latitude"] doubleValue];
    CLLocationDegrees lng = [[self.lostData objectForKey:@"Longitude"] doubleValue];
    
    NSString *name = @"Lost Here";
    TPAnnotation *loc = [[TPAnnotation alloc] initWithName:name coordinate:CLLocationCoordinate2DMake(lat, lng)];
    
    [_map addAnnotation:loc];
    
    CLLocationCoordinate2D taipeiCityCoord = CLLocationCoordinate2DMake(lat, lng);
    MKCoordinateRegion taipeiCityRegion = MKCoordinateRegionMakeWithDistance(taipeiCityCoord, 750, 750);
    [self.map setCenterCoordinate:taipeiCityCoord];
    [self.map setRegion:taipeiCityRegion animated:YES];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *annotationView = nil;
    static NSString *WebGeoIdentifier = @"WebGeo";
    
    annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:WebGeoIdentifier];
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:WebGeoIdentifier];
        annotationView.canShowCallout = YES;
    }
    annotationView.annotation = annotation;
    
    annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.png"]];

    
    return annotationView;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  TPFeedTableViewController.h
//  MeetMyPet
//
//  Created by Allan on 12/12/5.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
extern NSString *const FeedDictKeyCity;
extern NSString *const FeedDictKeyCountry;
extern NSString *const FeedDictKeyEmail;
extern NSString *const FeedDictKeyDate;
extern NSString *const FeedDictKeyPostID;
extern NSString *const FeedDictKeyImageName;
extern NSString *const FeedDictKeyPetAge;
extern NSString *const FeedDictKeyPetBreed;
extern NSString *const FeedDictKeyPetChar;
extern NSString *const FeedDictKeyPetChip;
extern NSString *const FeedDictKeyPetGender;
extern NSString *const FeedDictKeyPetName;
extern NSString *const FeedDictKeyPetNeuSpay;
extern NSString *const FeedDictKeyPetVac;
extern NSString *const FeedDictKeyPetinfoID;
extern NSString *const FeedDictKeyPhotoID;
extern NSString *const FeedDictKeyTypeID;
extern NSString *const FeedDictKeyType;
extern NSString *const FeedDictKeyUserName;

//Map Dictionary Keys
NSString *const FeedDictKeyLongitude;
NSString *const FeedDictKeyLatitude;



@interface TPFeedTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSCache * cache;
}


@property (nonatomic, strong) NSArray* myPosts;

@property (strong, nonatomic) NSString *petID;

-(void)loadPosts;

@property (nonatomic ,readwrite , copy) NSString *city;
@property (nonatomic ,readwrite , copy) NSString *country;
@property (nonatomic ,readwrite , copy) NSString *date;
@property (nonatomic ,readwrite , copy) NSString *email;
@property (nonatomic ,readwrite , copy) NSString *postID;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic ,readwrite , copy) NSString *petAge;
@property (nonatomic ,readwrite , copy) NSString *petBreed;
@property (nonatomic ,readwrite , copy) NSString *petChar;
@property (nonatomic ,readwrite , copy) NSString *petChip;
@property (nonatomic ,readwrite , copy) NSString *petGender;
@property (nonatomic ,readwrite , copy) NSString *petName;
@property (nonatomic ,readwrite , copy) NSString *petNeuSpay;
@property (nonatomic ,readwrite , copy) NSString *petVac;
@property (nonatomic ,readwrite , copy) NSString *petInfoID;
@property (nonatomic ,readwrite , copy) NSString *photoID;
@property (nonatomic ,readwrite , copy) NSString *imageName;
@property (nonatomic ,readwrite , copy) NSString *typeID;
@property (nonatomic ,readwrite , copy) NSString *type;
@property (nonatomic ,readwrite , copy) NSString *userName;

- (IBAction)reload:(id)sender;


@end

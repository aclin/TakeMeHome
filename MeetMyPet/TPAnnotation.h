//
//  TPAnnotation.h
//  MeetMyPet
//
//  Created by Allan on 12/12/27.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TPAnnotation : NSObject<MKAnnotation>

@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *subtitle;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coord;

@end

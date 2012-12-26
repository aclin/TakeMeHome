//
//  TPLocation.h
//  MeetMyPet
//
//  Created by Evelyn on 12/27/12.
//  Copyright (c) 2012 aclin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TPLocation : NSObject<MKAnnotation>

@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *subtitle;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coord;


@end
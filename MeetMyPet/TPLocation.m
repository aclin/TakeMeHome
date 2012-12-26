//
//  TPLocation.m
//  MeetMyPet
//
//  Created by Evelyn on 12/27/12.
//  Copyright (c) 2012 aclin. All rights reserved.
//

#import "TPLocation.h"


@implementation TPLocation


- (id)initWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coord {
    if (self = [super init]) {
        _title = name;
        _coordinate = coord;
    }
    return self;
}


@end

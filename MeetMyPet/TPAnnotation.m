//
//  TPAnnotation.m
//  MeetMyPet
//
//  Created by Allan on 12/12/27.
//  Copyright (c) 2012年 aclin. All rights reserved.
//

#import "TPAnnotation.h"

@implementation TPAnnotation

- (id)initWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coord {
    if (self = [super init]) {
        _title = name;
        _coordinate = coord;
    }
    return self;
}


@end

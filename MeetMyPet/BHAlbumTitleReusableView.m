//
//  BHAlbumTitleReusableView.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHAlbumTitleReusableView.h"

@interface BHAlbumTitleReusableView ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation BHAlbumTitleReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                           UIViewAutoresizingFlexibleHeight;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        //self.titleLabel.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        self.titleLabel.textColor = [UIColor colorWithRed:0.36f green:0.25f blue:0.18f alpha:1.0f];
        self.titleLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        self.titleLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = nil;
}

@end

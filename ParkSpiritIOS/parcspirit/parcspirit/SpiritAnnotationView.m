//
//  SpiritAnnotationView.m
//  parcspirit
//
//  Created by Max on 16/12/2016.
//  Copyright © 2016 Max. All rights reserved.
//

#import "SpiritAnnotationView.h"

#import <QuartzCore/QuartzCore.h>

#define  Arror_height 15

@interface SpiritAnnotationView ()

-(void)drawInContext:(CGContextRef)context;
- (void)getDrawPath:(CGContextRef)context;
@end

@implementation SpiritAnnotationView
@synthesize contentView;

- (void)dealloc
{
    self.contentView = nil;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        self.centerOffset = CGPointMake(0, -120);
        self.frame = CGRectMake(0, 0, 250, 220);
        
        UIView *_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - Arror_height)] ;
        _contentView.backgroundColor   = [UIColor clearColor];
        [self addSubview:_contentView];
        self.contentView = _contentView;
        
    }
    return self;
}
@end

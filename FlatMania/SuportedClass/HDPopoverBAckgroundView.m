//
//  HDPopoverBAckgroundView.m
//  HotelDemoProject
//
//  Created by Vladislav on 20.04.13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "HDPopoverBAckgroundView.h"
#import <QuartzCore/QuartzCore.h>
#define CONTENT_INSET 10.0
#define CAP_INSET 25.0
#define ARROW_BASE [UIImage imageNamed:@"dropdown-arrow.png"].size.width
#define ARROW_HEIGHT [UIImage imageNamed:@"dropdown-arrow.png"].size.height

@implementation HDPopoverBAckgroundView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _borderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown-big.png"]];
        _borderImageView.frame = frame;
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown-arrow.png"]];

        self.layer.cornerRadius=8;
        
        [self addSubview:_borderImageView];
        [self addSubview:_arrowView];
        //dfdfdgdfgf
        
    }
    return self;
}
+(UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake(10, 10,10, 10);
}

- (CGFloat) arrowOffset {
    return _arrowOffset;
}

- (void) setArrowOffset:(CGFloat)arrowOffset {
    _arrowOffset = arrowOffset;
}

- (UIPopoverArrowDirection)arrowDirection {
    return _arrowDirection;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;
}
+(CGFloat)arrowHeight{
    return ARROW_HEIGHT;
}

+(CGFloat)arrowBase{
    return ARROW_BASE;
}

-  (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat _height = self.frame.size.height;
    CGFloat _width = self.frame.size.width;
    CGFloat _left = 0.0;
    CGFloat _top = 0.0;
    CGFloat _coordinate = 0.0;
    CGAffineTransform _rotation = CGAffineTransformIdentity;
    
    
    switch (self.arrowDirection) {
        case UIPopoverArrowDirectionUp:
            _top += ARROW_HEIGHT;
            _height -= ARROW_HEIGHT;
            _coordinate = ((_borderImageView.frame.size.width / 2)) - (ARROW_BASE/2);
            _arrowView.frame = CGRectMake(_coordinate, 0, ARROW_BASE, ARROW_HEIGHT);
            break;
            
            
        case UIPopoverArrowDirectionDown:
            _height -= ARROW_HEIGHT;
            _coordinate = ((self.frame.size.width / 2) + self.arrowOffset) - (ARROW_BASE/2);
            _arrowView.frame = CGRectMake(_coordinate, _height, ARROW_BASE, ARROW_HEIGHT+4);
            _rotation = CGAffineTransformMakeRotation( M_PI );
            break;
            
        case UIPopoverArrowDirectionLeft:
            _left += ARROW_BASE-25;
            _width -= ARROW_BASE-25;
            _coordinate = ((self.frame.size.height / 2) + self.arrowOffset) - (ARROW_HEIGHT/2);
            _arrowView.frame = CGRectMake(-8, _coordinate, ARROW_BASE, ARROW_HEIGHT);
            _rotation = CGAffineTransformMakeRotation( -M_PI_2 );
            break;
            
        case UIPopoverArrowDirectionRight:
            _width -= ARROW_BASE;
            _coordinate = ((self.frame.size.height / 2) + self.arrowOffset)- (ARROW_HEIGHT/2);
            _arrowView.frame = CGRectMake(_width, _coordinate, ARROW_BASE, ARROW_HEIGHT);
            _rotation = CGAffineTransformMakeRotation( M_PI_2 );
            
            break;
            
    }
    
    _borderImageView.frame =  CGRectMake(_left, _top-2, _width, _height);
    
    
    [_arrowView setTransform:_rotation];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

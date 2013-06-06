//
//  FMFloopView.m
//  FlatMania
//
//  Created by Vladislav on 15.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMFloopView.h"
#import "FMAnnouncementViewController.h"
#import "FMRentViewController.h"
#import "FMMyFlatViewController.h"
#import "FMFavoriteViewController.h"

@implementation FMFloopView

- (id)initWithFrame:(CGRect)frame andTypeWindow:(int)type
{
    self = [super initWithFrame:frame];
    if (self) {
        typeWindow = type;
        
        UIImage *image = [UIImage imageNamed:@"footer-all.png"];
      
        NSLog(@"frame = %f",frame.size.width);
        footerAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerAllButton addTarget:self action:@selector(footerSelector:) forControlEvents:UIControlEventTouchUpInside];
        if (typeWindow==0) {
            [footerAllButton setBackgroundImage:[UIImage imageNamed:@"footer-all-select.png"] forState:UIControlStateNormal];
        }
        else[footerAllButton setBackgroundImage:[UIImage imageNamed:@"footer-all.png"] forState:UIControlStateNormal];
        
        footerAllButton.frame = CGRectMake(0, 0, frame.size.width/4,image.size.height);
        [self addSubview:footerAllButton];
        
        favoriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [favoriteButton addTarget:self action:@selector(footerSelector:) forControlEvents:UIControlEventTouchUpInside];
        if (typeWindow==1) {
            [favoriteButton setBackgroundImage:[UIImage imageNamed:@"footer-favorites-select.png"] forState:UIControlStateNormal];
        }
        else [favoriteButton setBackgroundImage:[UIImage imageNamed:@"footer-favorites.png"] forState:UIControlStateNormal];
        
        favoriteButton.frame = CGRectMake(frame.size.width/4,0, frame.size.width/4, image.size.height);
        [self addSubview:favoriteButton];
        
        therthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [therthButton addTarget:self action:@selector(footerSelector:) forControlEvents:UIControlEventTouchUpInside];
        if (typeWindow==2) {
            [therthButton setBackgroundImage:[UIImage imageNamed:@"footer-add-select.png"]
                                    forState:UIControlStateNormal];
        }
        else [therthButton setBackgroundImage:[UIImage imageNamed:@"footer-add.png"]
                                     forState:UIControlStateNormal];
        
        therthButton.frame = CGRectMake(frame.size.width*2/4,0, frame.size.width/4, image.size.height);
        [self addSubview:therthButton];
        
        myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [myButton addTarget:self action:@selector(footerSelector:) forControlEvents:UIControlEventTouchUpInside];
        if (typeWindow==3) {
            [myButton setBackgroundImage:[UIImage imageNamed:@"footer-my-select.png"] forState:UIControlStateNormal];
        }
        else
            [myButton setBackgroundImage:[UIImage imageNamed:@"footer-my.png"] forState:UIControlStateNormal];
        
        myButton.frame = CGRectMake(frame.size.width*3/4, 0, frame.size.width/4, image.size.height);
        [self addSubview:myButton];
        
     
    }
    return self;
}

-(void)footerSelector:(UIButton*)button {
    NSMutableDictionary *pushControllerDict = [[NSMutableDictionary alloc] init];
    if (button==footerAllButton)
        [pushControllerDict setObject:[NSString stringWithFormat:@"0"] forKey:@"controller"];
    if (button==therthButton) 
        [pushControllerDict setObject:[NSString stringWithFormat:@"2"] forKey:@"controller"];
    if (button==myButton)
        [pushControllerDict setObject:[NSString stringWithFormat:@"3"] forKey:@"controller"];
    if (button==favoriteButton)
           [pushControllerDict setObject:[NSString stringWithFormat:@"1"] forKey:@"controller"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dfdf" object:self userInfo:pushControllerDict];
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

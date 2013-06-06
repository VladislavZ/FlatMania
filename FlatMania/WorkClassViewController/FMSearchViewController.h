//
//  FMSearchViewController.h
//  FlatMania
//
//  Created by Vladislav on 22.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMSlideViewController.h"
#import "FMDropDounMenu.h"
#import "SBJson.h"
#import "UIPopoverController+iPhone.h"

@protocol FMSearchDelegate <NSObject>

-(void)searchResultArray:(NSString*)searchString;

@end


@interface FMSearchViewController : FMSlideViewController<FMDropMenuDelegate,UIPopoverControllerDelegate>{
    UIPopoverController *popoverController;
    int selectType;
    UIImage *dropMenuIMage;
    id <FMSearchDelegate> delegate;
}

@property (nonatomic,retain) id <FMSearchDelegate> delegate;

@end

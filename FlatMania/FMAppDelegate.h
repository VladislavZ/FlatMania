//
//  FMAppDelegate.h
//  FlatMania
//
//  Created by Vladislav on 12.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class FMViewController;

@interface FMAppDelegate : UIResponder <UIApplicationDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic, retain) Facebook *facebook;
-(void)showProgressHUD:(NSString*)msg;
-(void)hideProgressHUD;

@end

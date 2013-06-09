//
//  FMAppDelegate.m
//  FlatMania
//
//  Created by Vladislav on 12.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMAppDelegate.h"
#import "FMMenuViewController.h"
#import "FMSlideViewController.h"
#import "FMAnnouncementViewController.h"
#import "FMFavoriteViewController.h"
#import "FMAuthorizationViewController.h"
//static NSString* kAppId = @"442275729183619";
//NSString *const FBSessionStateChangedNotification = @"FBSessionStateChangedNotification";

@implementation FMAppDelegate
//@synthesize facebook;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"firstRespond"]) {
        [userDefaults setObject:@"OK" forKey:@"firstRespond"];
        NSMutableArray *favoriteArray = [[NSMutableArray alloc] init];
        [userDefaults setObject:favoriteArray forKey:@"favoritesKey"];
//        NSMutableArray *activeArray = [[NSMutableArray alloc] init];
//        [userDefaults setObject:activeArray forKey:@"ActiveMyAncountmentKey"];
//        [userDefaults objectForKey:@"ActiveMyAncountmentKey"]
        
        //data userDefaults
        [userDefaults setObject:nil forKey:@"UpdateKey"];
        [userDefaults setObject:nil forKey:@"allFlatKey"];
        [userDefaults setObject:nil forKey:@"allFlatImageKey"];
        [userDefaults setObject:nil forKey:@"authorizationKey"];
        
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    FMSlideViewController *startViewController = [[FMAnnouncementViewController alloc] initWithNibName:@"FMAnnouncementViewController" bundle:nil andInfoArray:nil];
    FMMenuViewController *slideMenu = [[FMMenuViewController alloc] init];
    [slideMenu addViewController:startViewController withTitle:startViewController.title];
    
     self.window.rootViewController = slideMenu;
    [self.window makeKeyAndVisible];
    
//    if ([userDefaults objectForKey:@"FBAccessTokenKey"] && [userDefaults objectForKey:@"FBExpirationDateKey"]) {
//        facebook.accessToken = [userDefaults objectForKey:@"FBAccessTokenKey"];
//        facebook.expirationDate = [userDefaults objectForKey:@"FBExpirationDateKey"];
//    }
//	
//	if (!kAppId) {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Setup Error"
//                                  message:@"Missing app ID. You cannot run the app until you provide this in the code."
//                                  delegate:self
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil,
//                                  nil];
//        [alertView show];
//    } else {
//        // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
//        // be opened, doing a simple check without local app id factored in here
//        NSString *url = [NSString stringWithFormat:@"fb%@://authorize",kAppId];
//        BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
//        NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
//        if ([aBundleURLTypes isKindOfClass:[NSArray class]] &&
//            ([aBundleURLTypes count] > 0)) {
//            NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
//            if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
//                NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
//                if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
//                    ([aBundleURLSchemes count] > 0)) {
//                    NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
//					NSLog(@"shema=%@",scheme);
//					NSLog(@"url=%@",url);
//					NSLog(@"%d",[scheme isKindOfClass:[NSString class]]);
//					NSLog(@"%d",[url hasPrefix:scheme]);
//                    if ([scheme isKindOfClass:[NSString class]] &&
//                        [url hasPrefix:scheme]) {
//                        bSchemeInPlist = YES;
//                    }
//                }
//            }
//        }
//        // Check if the authorization callback will work
//        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
//        if (!bSchemeInPlist || !bCanOpenUrl) {
//            UIAlertView *alertView = [[UIAlertView alloc]
//                                      initWithTitle:@"Setup Error"
//                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist."
//                                      delegate:self
//                                      cancelButtonTitle:@"OK"
//                                      otherButtonTitles:nil,
//                                      nil];
//            [alertView show];
//        }
//    }
//
//    
    
    
    return YES;
}

#pragma mark ProgressHUD mehtods
-(void)showProgressHUD:(NSString*)msg{
//    if(HUD!=nil &amp;&amp; [HUD retainCount]&gt;0;){
        [HUD removeFromSuperview];
//        [HUD release];
        HUD=nil;
//    }
    
    HUD = [[MBProgressHUD alloc] initWithWindow:self.window];
    HUD.labelText = msg;
//    HUD.detailsLabelText = @"By Nimit"; // It shows  the label which you want to display in Hud
    
    [self.window addSubview:HUD];
    
    [HUD setDelegate:(FMAppDelegate*)[[UIApplication sharedApplication]delegate]];
    [HUD show:YES];
}

-(void)hideProgressHUD{
    [HUD hide:YES];
//    if(HUD!=nil &amp;&amp; [HUD retainCount]&gt;0){
        [HUD removeFromSuperview];
//        [HUD release];
        HUD=nil;
//    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
}





- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [FBSession.activeSession close];
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return [self.facebook handleOpenURL:url];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [self.facebook handleOpenURL:url];
//}

@end

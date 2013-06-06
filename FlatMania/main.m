//
//  main.m
//  FlatMania
//
//  Created by Vladislav on 12.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FMAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        setenv("CLASSIC", "0", 1);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([FMAppDelegate class]));
    }
}

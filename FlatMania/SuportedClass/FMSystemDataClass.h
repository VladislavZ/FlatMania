//
//  FMSystemDataClass.h
//  FlatMania
//
//  Created by Vladislav on 14.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FMSystemDataClass : NSObject{
    
    int dropType;
}
+(FMSystemDataClass*)getSystemData;
-(NSMutableArray*)getArrayDromMenuInfoWithTypy:(int)type;
- (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage;

@end

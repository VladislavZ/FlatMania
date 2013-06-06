//
//  FMFlatObject.h
//  FlatMania
//
//  Created by Vladislav on 15.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMFlatObject : NSObject

@property (nonatomic,readwrite) NSInteger metrodistanceID;
@property (nonatomic,readwrite) NSInteger metroID;
@property (nonatomic,readwrite) NSInteger typeFlatID;
@property (nonatomic,readwrite) NSInteger typeHouseID;
@property (nonatomic,retain) NSMutableArray *imageFlatArray;
@property (nonatomic,retain) UIImage *mainImage;
@property (nonatomic,readwrite) NSInteger numberFloor;
@property (nonatomic,readwrite) NSInteger flatFloor;
@property (nonatomic,readwrite) BOOL liberal;
@property (nonatomic,readwrite) BOOL privat;
@property (nonatomic,retain) NSString *adress;
@property (nonatomic,retain) NSString *price;



@end

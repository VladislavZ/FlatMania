//
//  FMFlatObject.m
//  FlatMania
//
//  Created by Vladislav on 15.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMFlatObject.h"

@implementation FMFlatObject
@synthesize imageFlatArray,mainImage,numberFloor,flatFloor,liberal,typeFlatID,metrodistanceID,typeHouseID,metroID,adress,privat;

- (id)init
{
    self = [super init];
    if (self) {
        self.mainImage = nil;
        self.liberal = NO;
        self.privat = NO;
        self.imageFlatArray = [[NSMutableArray alloc] init];
        self.typeHouseID = 1000;
        self.typeFlatID = 1000;
        self.metroID = 1000;
    }
    return self;
}
@end

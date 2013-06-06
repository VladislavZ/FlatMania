//
//  FMSystemDataClass.m
//  FlatMania
//
//  Created by Vladislav on 14.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMSystemDataClass.h"
#import "SBJson.h"

@implementation FMSystemDataClass

static FMSystemDataClass *sharedInstance;

+(FMSystemDataClass*)getSystemData{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
    }
    return sharedInstance;
}

-(NSMutableArray*)getArrayDromMenuInfoWithTypy:(int)type {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *infoArray;
    NSURL *url = [NSURL URLWithString:serverUrl];
    switch (type) {
        case typeFlat:{
            if (![userDefaults objectForKey:@"typeFlatKey"]) {
            NSString *bodyString = @"action=flattypeget";
            NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
            [request1 setHTTPMethod: @"POST"];
            [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
            ////
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
            NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            infoArray = [parser objectWithString:htmlString error:nil];
                 NSData *typeFlatData = [NSKeyedArchiver archivedDataWithRootObject:infoArray];
                [userDefaults setObject:typeFlatData forKey:@"typeFlatKey"];
            }
            else {
                NSData *typeFlatData = [userDefaults objectForKey:@"typeFlatKey"];
                NSArray *typeFlatArray = [NSKeyedUnarchiver unarchiveObjectWithData:typeFlatData];
                typeFlatData =nil;
                infoArray = [[NSMutableArray alloc] initWithArray:typeFlatArray];
            }
            }
            break;
            
        case metroDistance:{
            if (![userDefaults objectForKey:@"metroDistanceKey"]) {
            NSString *bodyString = @"action=metrodistanceget";
            NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
            [request1 setHTTPMethod: @"POST"];
            [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
            ////
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
            NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            infoArray = [parser objectWithString:htmlString error:nil];
                NSData *metroDistanceData = [NSKeyedArchiver archivedDataWithRootObject:infoArray];
                [userDefaults setObject:metroDistanceData forKey:@"metroDistanceKey"];
            }
            else {
                NSData *metroDistanceData = [userDefaults objectForKey:@"metroDistanceKey"];
                NSArray *metroDistanceArray = [NSKeyedUnarchiver unarchiveObjectWithData:metroDistanceData];
                metroDistanceData =nil;
                infoArray = [[NSMutableArray alloc] initWithArray:metroDistanceArray];
            }
        }
            break;
        case typeHouse:{
            if (![userDefaults objectForKey:@"houseType"]) {
            NSString *bodyString = @"action=housetypeget";
            NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
            [request1 setHTTPMethod: @"POST"];
            [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
            ////
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
            NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            infoArray = [parser objectWithString:htmlString error:nil];
                NSData *typeHouseData = [NSKeyedArchiver archivedDataWithRootObject:infoArray];
                [userDefaults setObject:typeHouseData forKey:@"houseType"];
            }
            else {
                NSData *houseTypeData = [userDefaults objectForKey:@"houseType"];
                NSArray *houseTypeArray = [NSKeyedUnarchiver unarchiveObjectWithData:houseTypeData];
                houseTypeData =nil;
                infoArray = [[NSMutableArray alloc] initWithArray:houseTypeArray];
            }
            
        }
            break;
        case typeNumberFloor:{
            infoArray = [[NSMutableArray alloc] init];
            for (NSInteger k=1; k<=25; k++) {
                [infoArray addObject:[NSString stringWithFormat:@"%d",k]];
            }
        }
            break;
        case typeFlatFloor:{
            infoArray = [[NSMutableArray alloc] init];
            for (NSInteger k=1; k<=25; k++) {
                [infoArray addObject:[NSString stringWithFormat:@"%d",k]];
            }
        }
            break;
        case typeMetro:{
            if (![userDefaults objectForKey:@"metroTypeKey"]) {
            NSString *bodyString = @"action=metroget";
            NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
            [request1 setHTTPMethod: @"POST"];
            [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
            ////
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
            NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            infoArray = [parser objectWithString:htmlString error:nil];
                NSData *typeMetroData = [NSKeyedArchiver archivedDataWithRootObject:infoArray];
                [userDefaults setObject:typeMetroData forKey:@"metroTypeKey"];
            }
            else {
                NSData *metroTypeData = [userDefaults objectForKey:@"metroTypeKey"];
                NSArray *metroTypeArray = [NSKeyedUnarchiver unarchiveObjectWithData:metroTypeData];
                 metroTypeData =nil;
                infoArray = [[NSMutableArray alloc] initWithArray:metroTypeArray];
            }
        }
            break;
        case priceType:{
            infoArray = [[NSMutableArray alloc] init ];
            for (NSInteger k=1; k<11; k++) {
                [infoArray addObject:[NSString stringWithFormat:@"%d",(k*10000)]];
            }
        }
            break;
        default:
            break;
    }
    
    
    return infoArray;
}


- (void)processImageDataWithURLString:(NSString *)urlString andBlock:(void (^)(NSData *imageData))processImage
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    dispatch_queue_t callerQueue = dispatch_get_current_queue();
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
    dispatch_async(downloadQueue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(callerQueue, ^{
            processImage(imageData);
        });
    });
    //    dispatch_release(downloadQueue);
}

@end

//
//  UIImage+cache.m
//  ios_hdi_player
//
//  Created by Alexander Stepanitsa on 7/31/12.
//  Copyright (c) 2012 FilmOn. All rights reserved.
//

#import "UIImage+cache.h"

@implementation UIImage (cache)

+ (void)loadImageFromURL:(NSURL *)url completion:(void (^)(UIImage *))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self loadAndCacheImageByURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}


+ (UIImage*) loadAndCacheImageByURL:(NSURL *)url
{
    NSString *fileName =  [[url absoluteString] stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"?" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"=" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"&" withString:@"_"];
    UIImage* tempImage;// = [self loadFromFile:fileName];
    if ( ! tempImage )
    {
        tempImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url ]] ;
        [self cacheImage:tempImage imageName:fileName];
    }
    return tempImage;
}


+ (UIImage*)loadFromFile:(NSString*)name
{
	NSString* filePath = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"FilmOn.com/"] stringByAppendingPathComponent:name];
	return [UIImage imageWithContentsOfFile:filePath];
}


+ (bool)cacheImage:(UIImage*)image imageName:(NSString*)name
{
	NSFileManager* manager = [[NSFileManager alloc] init];
	if( ! [manager createDirectoryAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"FilmOn.com"] withIntermediateDirectories:YES attributes:nil error:nil] )
	{
		NSLog(@"%s. Can`t create temp directory \"FilmOn.com\"",__PRETTY_FUNCTION__);
//		[manager release];
		return NO;
	}
	
	NSData* imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
	if( ! [manager createFileAtPath:[[NSTemporaryDirectory() stringByAppendingPathComponent:@"FilmOn.com/"] stringByAppendingPathComponent:name] contents:imageData attributes:nil] ){
		NSLog(@"%s. do not create image file",__PRETTY_FUNCTION__);
//        [manager release];
        return NO;
    }
//	[manager release];
	return YES;
}

@end

//
//  FMAsynhImageView.m
//  FlatMania
//
//  Created by Vladislav on 02.06.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMAsynhImageView.h"

@implementation FMAsynhImageView
@synthesize fill;

- (id)initWithFrame:(CGRect)aRect{
	self = [super initWithFrame:aRect];
	
	//activityIndicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(27.0, 27.0, 20.0, 20.0)];
	
	activityIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	
	activityIndicator.frame=CGRectMake(((aRect.size.width)-20)/2, ((aRect.size.width)-20)/2, 20.0, 20.0);
	
	//self.backgroundColor=[UIColor blackColor];
	activityIndicator.hidesWhenStopped=YES;
	
	[activityIndicator startAnimating];
	
	[self addSubview:activityIndicator];
	
	return self;
	
}


- (void)dealloc {
	[connection cancel]; //in case the URL is still downloading
	[connection release];
	[data release];
    [super dealloc];
}


- (void)loadImageFromURL:(NSURL*)url {
	if (connection!=nil) { [connection release]; } //in case we are downloading a 2nd image
	if (data!=nil) { [data release]; }
	
	NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //notice how delegate set to self object
	//TODO error handling, what if connection is nil?
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    
    NSCachedURLResponse *newCachedResponse = cachedResponse;
    NSLog(@"%@",[[newCachedResponse  response] URL]);
//    if ([[[[cachedResponse response] URL] scheme] isEqual:@"https"]) {
//        newCachedResponse = nil;
//    } else {
//        NSDictionary *newUserInfo;
//        newUserInfo = [NSDictionary dictionaryWithObject:[NSCalendarDate date]
//                                                  forKey:@"Cached Date"];
//        newCachedResponse = [[[NSCachedURLResponse alloc]
//                              initWithResponse:[cachedResponse response]
//                              data:[cachedResponse data]
//                              userInfo:newUserInfo
//                              storagePolicy:[cachedResponse storagePolicy]]
//                             autorelease];
//    }
//    return newCachedResponse;
    return nil;
}


//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:2048]; }
	[data appendData:incrementalData];
}

//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	//so self data now has the complete image
	
	[activityIndicator stopAnimating];
	[connection release];
	connection=nil;
	if ([[self subviews] count]>0) {
		//then this must be another image, the old one is still in subviews
		[[[self subviews] objectAtIndex:0] removeFromSuperview]; //so remove it (releases it also)
	}
	
	//make an image view for the image
	//UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageWithData:data]] autorelease];
	
	UIImageView* imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)]autorelease];
    UIImage *loadImage = [UIImage imageWithData:data];
    
	imageView.image=loadImage;
	imageView.frame=CGRectMake(0, self.bounds.size.height/2-(loadImage.size.height*self.bounds.size.width)/(2*loadImage.size.width), self.bounds.size.width, (loadImage.size.height*self.bounds.size.width)/loadImage.size.width);
	
	//NSLog(@"ImageIvew frame is: %f High , %f Long",imageView.frame.size.height,imageView.frame.size.width);
	//make sizing choices based on your needs, experiment with these. maybe not all the calls below are needed.
    //	if (fill) {
    //		imageView.contentMode = UIViewContentModeScaleAspectFill;
    //	}
    //	else {
    //		imageView.contentMode = UIViewContentModeScaleAspectFit;
    //	}
    //
	
	//imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
	[self addSubview:imageView];
	//imageView.frame = self.bounds;
	//imageView.frame=CGRectMake(0, 0, 100, 100);
	
	//[imageView setNeedsLayout];
	//[self setNeedsLayout];
	
	[data release]; //don't need this any more, its in the UIImageView now
	data=nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
	[activityIndicator stopAnimating];
    
}

//just in case you want to get the image directly, here it is in subviews
- (UIImage*) image {
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
}

@end

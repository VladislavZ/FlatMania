//
//  FMAsynhImageView.h
//  FlatMania
//
//  Created by Vladislav on 02.06.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMAsynhImageView : UIView<NSURLConnectionDelegate,NSURLConnectionDataDelegate,NSURLConnectionDownloadDelegate>{
    NSURLConnection* connection; //keep a reference to the connection so we can cancel download in dealloc
	NSMutableData* data; //keep reference to the data so we can collect it as it downloads
	//but where is the UIImage reference? We keep it in self.subviews - no need to re-code what we have in the parent class
	
	UIActivityIndicatorView* activityIndicator;
	
	Boolean fill;
	
}

- (void)loadImageFromURL:(NSURL*)url;
- (UIImage*) image;

@property(nonatomic,assign)Boolean fill;

@end


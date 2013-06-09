//
//  FMAboutAppViewController.m
//  FlatMania
//
//  Created by Vladislav on 26.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMAboutAppViewController.h"

@interface FMAboutAppViewController ()

@end

@implementation FMAboutAppViewController
@synthesize aboutLabel,aboutScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"O приложении";
    self.view.backgroundColor = [[UIColor alloc] initWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"About"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    self.aboutScrollView.backgroundColor = [[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
    self.aboutScrollView.contentSize = CGSizeMake(self.aboutScrollView.frame.size.width, 2200);
    self.aboutLabel.text = content;
    self.aboutLabel.numberOfLines=0;
    self.aboutLabel.font = [UIFont systemFontOfSize:14];
    [self.aboutLabel sizeToFit];
    self.aboutLabel.textColor = [[UIColor alloc] initWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
    self.aboutLabel.frame = CGRectMake(self.aboutLabel.frame.origin.x, self.aboutLabel.frame.origin.y, self.aboutLabel.frame.size.width, 2100);
    
    UIImage *settingImage = [UIImage imageNamed:@"settings.png"];
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(0, 0, settingImage.size.width, settingImage.size.height);
    [settingButton addTarget:self action:@selector(toggleMenu) forControlEvents:
     UIControlEventTouchUpInside];
    
    [settingButton setBackgroundImage:settingImage forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    // Do any additional setup after loading the view from its nib.
}

-(void)toggleMenu {
    [[NSNotificationCenter defaultCenter] postNotificationName:FMMenuViewShow object:self userInfo:nil];
}

- (void)didReceiveMemoryWarning
{
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAboutScrollView:nil];
    [self setAboutLabel:nil];
    [super viewDidUnload];
}
@end

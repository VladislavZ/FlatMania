//
//  FMAgreementViewController.m
//  FlatMania
//
//  Created by Vladislav on 26.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMAgreementViewController.h"

@interface FMAgreementViewController ()

@end

@implementation FMAgreementViewController
@synthesize agreementLabel,agreementScrollView;

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
    self.title = @"Соглашение";
    NSString* path = [[NSBundle mainBundle] pathForResource:@"agreement"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    self.agreementScrollView.backgroundColor = [[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
    self.agreementScrollView.contentSize = CGSizeMake(self.agreementScrollView.frame.size.width, 2200);
    self.agreementLabel.text = content;
    self.agreementLabel.numberOfLines=0;
    self.agreementLabel.font = [UIFont systemFontOfSize:14];
    [self.agreementLabel sizeToFit];
    self.agreementLabel.textColor = [[UIColor alloc] initWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
    self.agreementLabel.frame = CGRectMake(self.agreementLabel.frame.origin.x, self.agreementLabel.frame.origin.y, self.agreementLabel.frame.size.width, 2100);
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

@end

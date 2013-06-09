//
//  FMInstrucViewController.m
//  FlatMania
//
//  Created by Vladislav on 26.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMInstrucViewController.h"

@interface FMInstrucViewController ()

@end

@implementation FMInstrucViewController
@synthesize instructionLabel,instructionScrollView;

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
    self.title = @"Инструкция";
    self.view.backgroundColor = [[UIColor alloc] initWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"About"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    self.instructionScrollView.backgroundColor = [[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
    self.instructionScrollView.contentSize = CGSizeMake(self.instructionScrollView.frame.size.width, 2200);
    self.instructionLabel.text = content;
    self.instructionLabel.numberOfLines=0;
    self.instructionLabel.font = [UIFont systemFontOfSize:14];
    [self.instructionLabel sizeToFit];
    self.instructionLabel.textColor = [[UIColor alloc] initWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0f];
    self.instructionLabel.frame = CGRectMake(self.instructionLabel.frame.origin.x, self.instructionLabel.frame.origin.y, self.instructionLabel.frame.size.width, 2100);
    
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
    [self setInstructionScrollView:nil];
    [self setInstructionLabel:nil];
    [super viewDidUnload];
}
@end

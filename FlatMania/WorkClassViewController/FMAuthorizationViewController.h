//
//  FMAuthorizationViewController.h
//  FlatMania
//
//  Created by Vladislav on 26.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMSlideViewController.h"
#import "FMAppDelegate.h"
#import "FMFloopView.h"
#import "FBConnect.h"

@interface FMAuthorizationViewController : FMSlideViewController<UITextFieldDelegate,UIWebViewDelegate,FBRequestDelegate, FBDialogDelegate, FBSessionDelegate> {
    UIWebView *authWebView;
    NSString *firstName;
    NSString *lastName;
    NSString *emailString;
    NSString *passwordString;
    NSString *numberPhone;
    NSString *vkIdString;
    NSString *fbIdString;
    NSUserDefaults *userDefaults;
    Facebook *facebook;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTypeView:(int)type;
//validate ImageVie
@property (nonatomic, retain) Facebook *facebook;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIImageView *emailValidate;
@property (weak, nonatomic) IBOutlet UIImageView *firstNameValidate;
@property (weak, nonatomic) IBOutlet UIImageView *secondNameValidate;
@property (weak, nonatomic) IBOutlet UIImageView *passwordValidate;
@property (weak, nonatomic) IBOutlet UIImageView *numberPhoneValidate;


//log in System

@property (weak, nonatomic) IBOutlet UIButton *logUsingFacebook;
- (IBAction)logUsingFacebookSelector:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *loginUsingVK;
- (IBAction)logUsingSelector:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *addVkIDLabel;

@property (weak, nonatomic) IBOutlet UILabel *addFbIdLabel;

- (IBAction)greateAccountMethod:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *greateAccountButton;
@property (weak, nonatomic) IBOutlet UIView *authView;

//greate Account View
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordGreatTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *vkIdButton;
- (IBAction)vkIdSelector:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *fbIdButton;
- (IBAction)fbIdSelector:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *GreateButton;
- (IBAction)greateSelector:(UIButton *)sender;

//greateAccount Parametr



@end

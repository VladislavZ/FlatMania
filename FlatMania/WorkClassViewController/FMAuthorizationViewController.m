//
//  FMAuthorizationViewController.m
//  FlatMania
//
//  Created by Vladislav on 26.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMAuthorizationViewController.h"
//#import "SBJson.h"
#import "SBJsonParser.h"
#import "UIWebView+Clean.h"
#import <QuartzCore/QuartzCore.h>

#define NUMBERS_ONLY @"+1234567890"

@interface FMAuthorizationViewController (){
    BOOL firstaNameValueTrue;
    BOOL lastNameValuetrue;
    BOOL emailValueTrue;
    BOOL passwordValueTrue;
    BOOL numberPhoneValueTrue;
    UITextField *selectTextField;
    NSArray *permissions;
    BOOL logFlag;
    NSURLRequest *request;
    int typeAutorize;
    NSString *accessTokenString;
    BOOL LogUsingFacebok;
    UIView *backgroundView;
}

@end


@implementation FMAuthorizationViewController
@synthesize greateAccountButton;
//greatView
@synthesize firstNameTextField,lastNameTextField,emailTextField,passwordGreatTextField,phoneTextField,vkIdButton,fbIdButton,GreateButton;

@synthesize emailValidate,firstNameValidate,secondNameValidate,numberPhoneValidate,passwordValidate,addVkIDLabel,addFbIdLabel,webView;
@synthesize facebook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTypeView:(int)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        typeAutorize = type;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.webView.hidden=YES;
    logFlag =NO;
    vkIdString=@"";
    fbIdString=@"";
    numberPhone = @"";
    userDefaults = [NSUserDefaults standardUserDefaults];
    permissions = [[NSArray alloc] initWithObjects:@"read_stream",@"publish_stream",@"offline_access",@"publish_actions", nil];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect masterRect = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 0, masterRect.size.width, masterRect.size.height-44-statusBarFrame.size.height);
    self.authView.hidden = YES;
    self.title = @"Авторизация";
    self.view.backgroundColor = [[UIColor alloc] initWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    
    UITapGestureRecognizer *gestureKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(removeKeyboard)];
    [self.authView addGestureRecognizer:gestureKeyBoard];
    
    UIImage *image = [UIImage imageNamed:@"footer-all.png"];
    NSLog(@"%f",image.size.height);
    FMFloopView *footerView =[[FMFloopView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-image.size.height, self.view.frame.size.width, image.size.height) andTypeWindow:typeAutorize];
    [self.view addSubview:footerView];
    
    UIImage *settingImage = [UIImage imageNamed:@"settings.png"];
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(0, 0, settingImage.size.width, settingImage.size.height);
    [settingButton addTarget:self action:@selector(toggleMenu) forControlEvents:
     UIControlEventTouchUpInside];
    
    [settingButton setBackgroundImage:settingImage forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
}

-(void)toggleMenu {
    [[NSNotificationCenter defaultCenter] postNotificationName:FMMenuViewShow object:self userInfo:nil];
}

-(void)removeKeyboard {
    [selectTextField resignFirstResponder];
    if (selectTextField==phoneTextField) {
        [UIView beginAnimations:@"Menu Slide" context:nil];
        [UIView setAnimationDuration:0.2];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+40, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    selectTextField=nil;
}

- (void)didReceiveMemoryWarning
{
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logUsingSelector:(UIButton *)sender {
    LogUsingFacebok = NO;
    logFlag = YES;
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, self.view.frame.size.height-20)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.layer.cornerRadius = 10;
    backgroundView.alpha = 0.6;
    backgroundView.clipsToBounds = YES;
    [self.view addSubview:backgroundView];
        authWebView = [[UIWebView alloc] initWithFrame:CGRectMake(15, 15, self.view.frame.size.width-30, self.view.frame.size.height-40)];
    

    authWebView.tag = 1024;
//    authWebView.scrollView.scrollEnabled=NO;
    authWebView.delegate = self;
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];

    [self.view addSubview:authWebView];
    NSURL *url = [NSURL URLWithString:@"http://oauth.vk.com/authorize?client_id=3644305&scope=wall,offline&redirect_uri=oauth.vk.com/blank.html&display=touch&response_type=token"];
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:url];
//    [request1 setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [authWebView loadRequest:request1];
    //обеспечиваем появление клавиатуры для авторизации
    [self.view.window makeKeyAndVisible];
    //создаем кнопочку для закрытия окна авторизации

}

- (IBAction)vkIdSelector:(UIButton *)sender {
    logFlag = NO;
    LogUsingFacebok=NO;

    authWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    authWebView.tag = 1024;
    authWebView.delegate = self;
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [self.view addSubview:authWebView];
    NSURL *url = [NSURL URLWithString:@"http://oauth.vk.com/authorize?client_id=3644305&scope=wall,offline&redirect_uri=oauth.vk.com/blank.html&display=touch&response_type=token"];
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:url];
    //    [request1 setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [authWebView loadRequest:request1];
    //обеспечиваем появление клавиатуры для авторизации
    [self.view.window makeKeyAndVisible];
    //создаем кнопочку для закрытия окна авторизации
   
}

-(void) closeWebView {
    [[self.view viewWithTag:1024] removeFromSuperview];
    [[self.view viewWithTag:1025] removeFromSuperview];
}

-(void) webViewDidFinishLoad:(UIWebView *)webViews {
    //создадим хеш-таблицу для хранения данных
    NSMutableDictionary* user = [[NSMutableDictionary alloc] init];
    //смотрим на адрес открытой станицы
    NSString *currentURL = webViews.request.URL.absoluteString;
    NSRange textRange =[[currentURL lowercaseString] rangeOfString:[@"access_token" lowercaseString]];
    //смотрим, содержится ли в адресе информация о токене
    if(textRange.location != NSNotFound){
        //Ура, содержится, вытягиваем ее
        NSArray* data = [currentURL componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
        [user setObject:[data objectAtIndex:1] forKey:@"access_token"];
        accessTokenString = [NSString stringWithFormat:@"%@",[data objectAtIndex:1]];
        [user setObject:[data objectAtIndex:3] forKey:@"expires_in"];
        [user setObject:[data objectAtIndex:5] forKey:@"user_id"];
        [self closeWebView];
        self.addVkIDLabel.text = [data objectAtIndex:5];
        vkIdString = [data objectAtIndex:5];
        if (logFlag) {
            [userDefaults setObject:vkIdString forKey:@"vkID"];
            if (![self authorizationWithID:vkIdString]){
                
                NSString *urlString = [NSString stringWithFormat:@"https://api.vk.com/method/users.get?uid=%@", vkIdString] ;
                NSURL *urlinfo = [NSURL URLWithString:urlString];
                NSMutableURLRequest *requestInfo = [NSMutableURLRequest requestWithURL:urlinfo];
                NSHTTPURLResponse *response = nil;
                NSError *error = nil;
                NSData *responseInfoData = [NSURLConnection sendSynchronousRequest:requestInfo returningResponse:&response error:&error];
                NSString *responseString = [[NSString alloc] initWithData:responseInfoData encoding:NSUTF8StringEncoding];
                SBJsonParser *parser = [[SBJsonParser alloc] init];
                NSMutableDictionary *loadDictw = [parser objectWithString:responseString error:nil];
                firstName = [[[loadDictw objectForKey:@"response"]objectAtIndex:0] objectForKey:@"first_name"];
                lastName = [[[loadDictw objectForKey:@"response"]objectAtIndex:0] objectForKey:@"last_name"];
               
                [userDefaults setObject:firstName forKey:@"firstName"];
                [userDefaults setObject:@"" forKey:@"phone"];
                [userDefaults setObject:lastName forKey:@"lastname"];
                [self greateSelector:nil];
            }
                
        }
        [backgroundView removeFromSuperview];
        backgroundView=nil;
               //передаем всю информацию специально обученному классу
        //        [[VkontakteDelegate sharedInstance] loginWithParams:user];
    }
    else {
        //Ну иначе сообщаем об ошибке...
        textRange =[[currentURL lowercaseString] rangeOfString:[@"access_denied" lowercaseString]];
        if (textRange.location != NSNotFound) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ooops! something gonna wrong..." message:@"Check your internet connection and try again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [self closeWebView];
            [backgroundView removeFromSuperview];
            backgroundView=nil;
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated {

}

-(BOOL)authorizationWithID:(NSString*)socID {
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSString *bodyString = [NSString stringWithFormat:@"action=usergetbyaccount&account=%@",socID];
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	////
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSMutableDictionary *loadDict = [parser objectWithString:htmlString error:nil];
    NSLog(@"Id = %@",loadDict);
    if (![[loadDict objectForKey:@"id"] isKindOfClass:[NSNull class]]) {
        [self loadFavorite:[loadDict objectForKey:@"id"]];
        [userDefaults setObject:[loadDict objectForKey:@"id"] forKey:@"LoginId"];
        [userDefaults setObject:[loadDict objectForKey:@"firstname"] forKey:@"firstName"];
        if ([[loadDict objectForKey:@"phone"] isKindOfClass:[NSNull class]])
            [userDefaults setObject:@"" forKey:@"phone"];
        else
            [userDefaults setObject:[loadDict objectForKey:@"phone"] forKey:@"phone"];
        [userDefaults setObject:[loadDict objectForKey:@"lastname"] forKey:@"lastname"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Вы успешно авторизировались"
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        return YES;
    }
    else 
        return NO;
    return NO;
}

-(void)loadFavorite:(NSString*)loginId {
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSString *bodyString =[NSString stringWithFormat:@"action=flatfavoritesgetfull&uid=%@&start=0",loginId];
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	////
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSMutableArray *loadDict = [parser objectWithString:htmlString error:nil];

    if ([loadDict isKindOfClass:[NSMutableDictionary class]]) {
        if ([(NSMutableDictionary*)loadDict objectForKey:@"code"]) {
            loadDict = nil;
        }
        else{
        NSMutableArray *newArray = [[NSMutableArray alloc] init];
        [newArray addObject:loadDict];
        loadDict = newArray;
        }
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loadDict];
    loadDict = nil;
    [userDefaults setObject:data forKey:@"favoritesKey"];
    data =nil;
}

-(NSMutableDictionary*)loadFlatById:(NSString*)flatId {
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSString *bodyString =[NSString stringWithFormat:@"action=flatgetbyid&id=%@",flatId];
    
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSMutableDictionary *flatInfo = [parser objectWithString:htmlString error:nil];
    return flatInfo;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSMutableDictionary *pushControllerDict = [[NSMutableDictionary alloc] init];
    [pushControllerDict setObject:[NSString stringWithFormat:@"%d",typeAutorize] forKey:@"controller"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dfdf" object:self userInfo:pushControllerDict];
}

#pragma mark - textfieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (selectTextField==phoneTextField) {
        [UIView beginAnimations:@"Menu Slide" context:nil];
        [UIView setAnimationDuration:0.2];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+40, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    selectTextField = textField;
    if (textField==phoneTextField) {
        [UIView beginAnimations:@"Menu Slide" context:nil];
        [UIView setAnimationDuration:0.2];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-40, self.view.frame.size.width, self.view.frame.size.height);
                [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField==firstNameTextField){firstName = textField.text;
        firstaNameValueTrue = [self validateName:textField.text];
        if (firstaNameValueTrue) {
            self.firstNameValidate.image = [UIImage imageNamed:@"checked.png"];
        }
        else
            self.firstNameValidate.image = [UIImage imageNamed:@"warrning.png"];
    }
    if (textField==lastNameTextField){ lastName = textField.text;
        lastNameValuetrue = [self validateName:textField.text];
        if (lastNameValuetrue) 
            self.secondNameValidate.image = [UIImage imageNamed:@"checked.png"];
        else
            self.secondNameValidate.image = [UIImage imageNamed:@"warrning.png"];
    }
    if (textField==emailTextField){ emailString = textField.text;
        emailValueTrue = [self validateEmail:textField.text];
        if (emailValueTrue)
            self.emailValidate.image = [UIImage imageNamed:@"checked.png"];
        else
            self.emailValidate.image = [UIImage imageNamed:@"warrning.png"];
    }
    if (textField==passwordGreatTextField){ passwordString=textField.text;
        passwordValueTrue = (textField.text.length>0);
        if (passwordValueTrue) 
            self.passwordValidate.image = [UIImage imageNamed:@"checked.png"];
        else
            self.passwordValidate.image = [UIImage imageNamed:@"warrning.png"];
    }
    if (textField==phoneTextField){ numberPhone = textField.text;
        numberPhoneValueTrue = (textField.text.length>0);
        if (passwordValueTrue)
            self.numberPhoneValidate.image = [UIImage imageNamed:@"checked.png"];
        else
            self.numberPhoneValidate.image = [UIImage imageNamed:@"warrning.png"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    BOOL value = YES;
    if (textField==phoneTextField) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        value = [string isEqualToString:filtered];
    }
    return value;
}

-(void)viewWillAppear:(BOOL)animated {
    
}

#pragma mark -Validate method
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(BOOL) validateName:(NSString*) validName {
    NSString *nameRegex = @"[А-Ъа-ъ]{2,20}";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    
    return [nameTest evaluateWithObject:validName];
}




- (IBAction)fbIdSelector:(UIButton *)sender {
    logFlag=NO;
    LogUsingFacebok=YES;
    [self initFacebook];

        NSString *path = [[NSBundle mainBundle] pathForResource:@"FBpermissions" ofType:@"plist"];
        NSDictionary *settingsDic = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *permissions1 = [settingsDic objectForKey:@"facebookPermissions"];
        [facebook authorize:permissions1 delegate:self];
}
- (void)initFacebook {
    if (!facebook) {
        self.facebook = [[Facebook alloc] initWithAppId:@"442275729183619"];
        facebook.accessToken = [userDefaults objectForKey:@"AccessToken"];
        facebook.expirationDate = [userDefaults objectForKey:@"ExpirationDate"];
    }
}

- (void)fbDidLogin {
    LogUsingFacebok=YES;
	[userDefaults setObject:self.facebook.accessToken forKey:@"AccessToken"];
	[userDefaults setObject:self.facebook.expirationDate forKey:@"ExpirationDate"];
	[userDefaults synchronize];
	[facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void)fbDidLogout {

	[userDefaults removeObjectForKey:@"AccessToken"];
	[userDefaults removeObjectForKey:@"ExpirationDate"];
	[userDefaults removeObjectForKey:@"userName"];
	[userDefaults synchronize];

}

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSDictionary class]]) {
        if ([result objectForKey:@"name"]) {
            NSString *userName = [result objectForKey:@"name"];
            NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
            fbIdString = [result objectForKey:@"id"];
            addFbIdLabel.text = [NSString stringWithFormat:@"%@",fbIdString];
            if (logFlag==YES) {
                [userDefaults setObject:fbIdString forKey:@"fbID"];
                if (![self authorizationWithID:fbIdString]) {
                    
                    firstName = [result objectForKey:@"first_name"];
                    lastName = [result objectForKey:@"last_name"];
                    [userDefaults setObject:firstName forKey:@"firstName"];
                    [userDefaults setObject:@"" forKey:@"phone"];
                    [userDefaults setObject:lastName forKey:@"lastname"];
                    [self greateSelector:nil];
                }
            }
            [defaults setObject:userName forKey:@"userName"];
            [defaults synchronize];
        } else if ([result objectForKey:@"data"]) {
            NSArray *curentResult = [result objectForKey:@"data"];
            
            for (NSDictionary *element in curentResult) {
                NSLog(@"id:%@", [element objectForKey:@"id"]);
                NSLog(@"name:%@", [element objectForKey:@"name"]);
                NSLog(@"photoURL:%@", [element objectForKey:@"picture"]);
                NSLog(@"gender:%@", [element objectForKey:@"gender"]);
            }
        }
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}
//
//-(void)fbDidLogin
//{
//
//
//}
- (IBAction)greateSelector:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSString *bodyString = [NSString stringWithFormat:@"action=userupdate&id=0&firstname=%@&lastname=%@&email=%@&password=%@&phone=%@&vkid=%@&facebookid=%@",firstName,lastName,emailString,passwordString,numberPhone,vkIdString,fbIdString];
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	////
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSMutableDictionary *loadDict = [parser objectWithString:htmlString error:nil];
    if ([loadDict objectForKey:@"code"]) {
        [userDefaults setObject:[loadDict objectForKey:@"id"] forKey:@"LoginId"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Регистрация прошла успешно"
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        

    }

    
}

- (IBAction)logUsingFacebookSelector:(UIButton *)sender {
    logFlag=YES;
    [self initFacebook];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FBpermissions" ofType:@"plist"];
    NSDictionary *settingsDic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *permissions1 = [settingsDic objectForKey:@"facebookPermissions"];
    [facebook authorize:permissions1 delegate:self];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end

//
//  FMRentViewController.m
//  FlatMania
//
//  Created by Vladislav on 14.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMRentViewController.h"
#import "FMImageView.h"
#import "FMDropDounMenu.h"
#import "FMSystemDataClass.h"
#import "FMAnnouncementViewController.h"
#import "FMFloopView.h"
#import "SBJson.h"
#import "UIPopoverController+iPhone.h"
#import "HDPopoverBAckgroundView.h"
#import <AVFoundation/AVFoundation.h>

#define dropDownDistance 55.0f
#define NUMBERS_ONLY @"+1234567890"
@interface FMRentViewController (){
    CGFloat xPositionImage;
    CGFloat yPositionImage;
    
    UIButton *typeFlatButton;
    UIButton *typeHouseButton;
    UIButton *floorNumberButton;
    UIButton *flatFloorButton;
    UIButton *metroButton;
    UIButton *selectButton;
    FMDropDounMenu *dropMenuView;
    UIButton *metroDistanceButton;
    NSString *phoneNumber;
    NSString *firstName;
    NSString *lastName;
    
      NSMutableArray *infoArray;
    CGRect visibleRect;
    NSInteger NumberImage;
    UIImage *imageUpload;
    
    UIImagePickerController *imagePickController;
    UIImagePickerController *imagePickerPhoto;
    
    FMImageView *selectImagesView;
    UITextField *selectTextField;
    NSUserDefaults *userDefaults;
    
    UITextField *phoneNumberTextField;
    NSInteger numberPhotoAdd;
    NSMutableArray *numberImageArrayAdd;
    UIImage *borderImage;
}

@end

@implementation FMRentViewController

@synthesize mainScrollView,imageScrollView;
//@synthesize nameTextField;
@synthesize lineImageView;

@synthesize flatObject,phoneLabel,nameLabel;

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
    numberImageArrayAdd  =[[NSMutableArray alloc] init];
    userDefaults = [NSUserDefaults standardUserDefaults];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect masterRect = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 0, masterRect.size.width, masterRect.size.height-44-statusBarFrame.size.height);
    flatObject.liberal = NO;
    flatObject.privat = NO;
    isLiberal = NO;
    xPositionImage = 10;
    numberPhotoAdd = 0;
    self.flatObject = [[FMFlatObject alloc] init];
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0f];
//navBarButton
     self.title = @"Информация";
    UIImage *imagePhoto = [UIImage imageNamed:@"photo.png"];
    UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imagePhoto.size.width/2, imagePhoto.size.height/2)];
    [photoButton setBackgroundImage:imagePhoto forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(photoSelector) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:photoButton];
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    self.imageScrollView.backgroundColor = [UIColor clearColor];
        
     UIImage *backgroundTextFieldImage = [UIImage imageNamed:@"add-bg-input.png"];
    dropMenuIMage = [UIImage imageNamed:@"add-bg-items.png"];
    if ([userDefaults objectForKey:@"LoginId"]) {
        firstName = [userDefaults objectForKey:@"firstName"];
        lastName = [userDefaults objectForKey:@"lastname"];
        NSString *nameString = [NSString stringWithFormat:@"%@ %@",[userDefaults objectForKey:@"firstName"],[userDefaults objectForKey:@"lastname"]];
        nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-dropMenuIMage.size.width/2, self.nameLabel.frame.origin.y, dropMenuIMage.size.width, 30)];
        nameTextField.delegate = self;
//        nameTextField.keyboardType = UIKeyboardTypePhonePad;
        nameTextField.background = backgroundTextFieldImage;
        if (nameString.length>2)
            nameTextField.text = nameString;
        nameTextField.backgroundColor = [UIColor clearColor];
        nameTextField.placeholder = @"Имя и Фамилия";
        nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
        nameTextField.leftView = paddingView1;
        nameTextField.leftViewMode = UITextFieldViewModeAlways;
        [self.mainScrollView addSubview:nameTextField];
        self.nameLabel.hidden=YES;
        
        NSString *phone = [userDefaults objectForKey:@"phone"];
        phoneNumber = [userDefaults objectForKey:@"phone"];
            phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-dropMenuIMage.size.width/2, self.phoneLabel.frame.origin.y, dropMenuIMage.size.width, 30)];
            phoneNumberTextField.delegate = self;
            phoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;
            phoneNumberTextField.background = backgroundTextFieldImage;
        if (phone.length>3)
        phoneNumberTextField.text = phone;
            phoneNumberTextField.backgroundColor = [UIColor clearColor];
            phoneNumberTextField.placeholder = @"Номер телефона";
            phoneNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
            phoneNumberTextField.leftView = paddingView2;
            phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
            [self.mainScrollView addSubview:phoneNumberTextField];
            self.phoneLabel.hidden=YES;
        
     
    }
    
    borderImage = [UIImage imageNamed:@"image-border.png"];
    
    self.imageScrollView.contentSize = CGSizeMake((borderImage.size.width+15)*5, borderImage.size.height);
    for (NSInteger k=0; k<5; k++) {
        FMImageView *imageViw = [[FMImageView alloc] initWithFrame:CGRectMake(xPositionImage, 10, borderImage.size.width, borderImage.size.height)];
        imageViw.tag=k+1;
        [self.imageScrollView addSubview:imageViw];
        xPositionImage+=borderImage.size.width+15;
    }
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)];
    [self.imageScrollView addGestureRecognizer:gesture];
    
    
    metroDistanceButton = [UIButton buttonItemWithImage:@"add-bg-items.png"
                                                  title:@"Расстояние до метро"
                                                 target:self
                                               selector:@selector(pushDropDownMenu:)
                                               position:CGRectMake(self.view.frame.size.width/2-dropMenuIMage.size.width/2, lineImageView.frame.origin.y+dropDownDistance/2, dropMenuIMage.size.width, dropMenuIMage.size.height)];
    [metroDistanceButton setTitleColor:[[UIColor alloc] initWithRed:133/255.0f green:133/255.0f blue:133/255.0f alpha:1.0f] forState:UIControlStateNormal];
    metroDistanceButton.titleLabel.font = [UIFont systemFontOfSize:16];
    metroDistanceButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    metroDistanceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.mainScrollView addSubview:metroDistanceButton];
    
    metroButton = [UIButton buttonItemWithImage:@"add-bg-items.png"
                                                  title:@"Метро"
                                                 target:self
                                               selector:@selector(pushDropDownMenu:)
                                               position:CGRectMake(self.view.frame.size.width/2-dropMenuIMage.size.width/2, metroDistanceButton.frame.origin.y+dropDownDistance, dropMenuIMage.size.width, 35)];
    [metroButton setTitleColor:[[UIColor alloc] initWithRed:133/255.0f green:133/255.0f blue:133/255.0f alpha:1.0f] forState:UIControlStateNormal];
    metroButton.titleLabel.font = [UIFont systemFontOfSize:16];
    metroButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    metroButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.mainScrollView addSubview:metroButton];
    
    typeFlatButton = [UIButton buttonItemWithImage:@"add-bg-items.png"
                                             title:@"Тип квартиры"
                                            target:self
                                          selector:@selector(pushDropDownMenu:)
                                          position:CGRectMake(self.view.frame.size.width/2-dropMenuIMage.size.width/2, metroButton.frame.origin.y+dropDownDistance, dropMenuIMage.size.width, 35)];
    [typeFlatButton setTitleColor:[[UIColor alloc] initWithRed:133/255.0f green:133/255.0f blue:133/255.0f alpha:1.0f] forState:UIControlStateNormal];
    typeFlatButton.titleLabel.font = [UIFont systemFontOfSize:16];
    typeFlatButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    typeFlatButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.mainScrollView addSubview:typeFlatButton];
    
    
    typeHouseButton = [UIButton buttonItemWithImage:@"add-bg-items.png"
                                              title:@"Тип дома"
                                             target:self 
                                            selector:@selector(pushDropDownMenu:)
                                           position:CGRectMake(self.view.frame.size.width/2-dropMenuIMage.size.width/2, typeFlatButton.frame.origin.y+dropDownDistance, dropMenuIMage.size.width, 35)];
    [typeHouseButton setTitleColor:[[UIColor alloc] initWithRed:133/255.0f green:133/255.0f blue:133/255.0f alpha:1.0f] forState:UIControlStateNormal];
    typeHouseButton.titleLabel.font = [UIFont systemFontOfSize:16];
    typeHouseButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    typeHouseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.mainScrollView addSubview:typeHouseButton];
    flatFloorButton = [UIButton buttonItemWithImage:@"add-bg-items.png"
                                              title:@"Этаж квартиры"
                                             target:self
                                           selector:@selector(pushDropDownMenu:)
                                           position:CGRectMake(self.view.frame.size.width/2-dropMenuIMage.size.width/2, typeHouseButton.frame.origin.y+dropDownDistance, dropMenuIMage.size.width, 35)];
    [flatFloorButton setTitleColor:[[UIColor alloc] initWithRed:133/255.0f green:133/255.0f blue:133/255.0f alpha:1.0f] forState:UIControlStateNormal];
    flatFloorButton.titleLabel.font = [UIFont systemFontOfSize:16];
    flatFloorButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    flatFloorButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.mainScrollView addSubview:flatFloorButton];
    
    floorNumberButton = [UIButton buttonItemWithImage:@"add-bg-items.png"
                                                title:@"Колличество этажей"
                                               target:self
                                             selector:@selector(pushDropDownMenu:)
                                             position:CGRectMake(self.view.frame.size.width/2-dropMenuIMage.size.width/2, flatFloorButton.frame.origin.y+dropDownDistance, dropMenuIMage.size.width, 35)];
    [floorNumberButton setTitleColor:[[UIColor alloc] initWithRed:133/255.0f green:133/255.0f blue:133/255.0f alpha:1.0f] forState:UIControlStateNormal];
    floorNumberButton.titleLabel.font = [UIFont systemFontOfSize:16];
    floorNumberButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    floorNumberButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.mainScrollView addSubview:floorNumberButton];
    
    
    
    
   
    adressTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-backgroundTextFieldImage.size.width/2, floorNumberButton.frame.origin.y+dropDownDistance, floorNumberButton.frame.size.width, 30)];
    adressTextField.delegate = self;
    adressTextField.background = backgroundTextFieldImage;
    adressTextField.backgroundColor = [UIColor clearColor];
    adressTextField.placeholder = @"Адрес квартиры";
    adressTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, adressTextField.frame.size.height)];
    adressTextField.leftView = paddingView2;
    adressTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.mainScrollView addSubview:adressTextField];
    
    priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-backgroundTextFieldImage.size.width/2, adressTextField.frame.origin.y+dropDownDistance, flatFloorButton.frame.size.width, 30)];
    priceTextField.delegate = self;
    priceTextField.placeholder = @"Цена";
    priceTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, priceTextField.frame.size.height)];
    priceTextField.leftView = paddingView3;
    priceTextField.leftViewMode = UITextFieldViewModeAlways;
    priceTextField.background = backgroundTextFieldImage;
    priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    priceTextField.backgroundColor = [UIColor clearColor];
  
    [self.mainScrollView addSubview:priceTextField];
    
    UIImage *liberalImage = [UIImage imageNamed:@"bg-checkbox.png"];
    UIImageView *liberalStateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-liberalImage.size.width/2, priceTextField.frame.origin.y+dropDownDistance, liberalImage.size.width, liberalImage.size.height)];
    liberalStateImageView.image = liberalImage;
    [self.mainScrollView addSubview:liberalStateImageView];
    
    UILabel *liberalStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, priceTextField.frame.origin.y+dropDownDistance, 250, liberalImage.size.height)];
    liberalStateLabel.textColor = [UIColor grayColor];
    liberalStateLabel.backgroundColor = [UIColor clearColor];
    liberalStateLabel.font = [UIFont systemFontOfSize:16];
    liberalStateLabel.text = @"Либеральные условия";
    [self.mainScrollView addSubview:liberalStateLabel];
    
    UIImage *ckekImage = [UIImage imageNamed:@"check.png"];
    UIButton *liberalButton = [UIButton buttonItemWithImage:@"check.png" title:@"" target:self selector:@selector(liberalSelector:) position:CGRectMake(self.mainScrollView.frame.size.width-50, priceTextField.frame.origin.y+dropDownDistance+liberalImage.size.height/2-ckekImage.size.height/2, ckekImage.size.width, ckekImage.size.height)];
    [self.mainScrollView addSubview:liberalButton];
    
    UIImageView *privatStateIMageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-liberalImage.size.width/2, liberalStateLabel.frame.origin.y+dropDownDistance, liberalImage.size.width, liberalImage.size.height)];
    privatStateIMageView.image = liberalImage;
    [self.mainScrollView addSubview:privatStateIMageView];
    
    UILabel *privatLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, liberalStateLabel.frame.origin.y+dropDownDistance, 250, liberalImage.size.height)];
    privatLabel.textColor = [UIColor grayColor];
    privatLabel.backgroundColor = [UIColor clearColor];
    privatLabel.font = [UIFont systemFontOfSize:16];
    privatLabel.text = @"Честное";
    [self.mainScrollView addSubview:privatLabel];
    
    UIButton *privatButton = [UIButton buttonItemWithImage:@"check.png" title:@"" target:self selector:@selector(privatSelector:) position:CGRectMake(self.mainScrollView.frame.size.width-50, liberalStateLabel.frame.origin.y+dropDownDistance+liberalImage.size.height/2-ckekImage.size.height/2, ckekImage.size.width, ckekImage.size.height)];
    [self.mainScrollView addSubview:privatButton];
    
    UIButton *addAncountmentButton = [[UIButton alloc]initWithFrame:CGRectMake(20, privatLabel.frame.origin.y+dropDownDistance, self.mainScrollView.frame.size.width-40, 35)];
    [addAncountmentButton setBackgroundImage:[UIImage imageNamed:@"add-big.png"] forState:UIControlStateNormal];
//    [addAncountmentButton setTitle:@"Разместить объявление" forState:UIControlStateNormal];
    [addAncountmentButton addTarget:self action:@selector(addSelector) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:addAncountmentButton];
    
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, addAncountmentButton.frame.origin.y+dropDownDistance);
    NSLog(@"%f",self.view.frame.size.height);
    UIImage *imageFlooper = [UIImage imageNamed:@"footer-add.png"];
    FMFloopView *footerView =[[FMFloopView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-imageFlooper.size.height, self.view.frame.size.width, imageFlooper.size.height) andTypeWindow:2];
    [self.view addSubview:footerView];
    
    UITapGestureRecognizer *gestureKeyBoard = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(removeKeyboard)];
    [self.mainScrollView addGestureRecognizer:gestureKeyBoard];
}


-(void)removeKeyboard {
  [selectTextField resignFirstResponder];
}


-(void)selectImage:(UITapGestureRecognizer*)gesture {
    CGPoint location = [gesture locationInView:[gesture.view superview]];
    NSInteger numberFlat = (visibleRect.origin.x+location.x)/(borderImage.size.width+15);
    NSLog(@"numberSelctImage = %d",numberFlat);
    NumberImage = numberFlat;
    [numberImageArrayAdd addObject:[NSNumber numberWithInteger:numberFlat]];
    selectImagesView = (FMImageView*)[self.imageScrollView viewWithTag:NumberImage+1];
    if (!selectImagesView.ISsetImage) {
        
        imagePickController=[[UIImagePickerController alloc]init];
        imagePickController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickController.delegate = self;
        imagePickController.allowsEditing=TRUE;
        imagePickController.navigationBarHidden = YES;
        imagePickController.toolbarHidden = YES;
        imagePickController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        self.navigationController.navigationBar.frame = CGRectMake(0, -60, 320, 44);
        self.view.frame = CGRectMake(0, -44, self.view.frame.size.width, self.view.frame.size.height+44);
        [self addChildViewController:imagePickController];
        //    imagePickController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20);
    [self.view addSubview:imagePickController.view];
    }
    else {
        NSLog(@"mainNumberImage = %d    numberFlat = %d",mainNumberImage,numberFlat);
        if (mainNumberImage!=numberFlat) {
            FMImageView *unselectImageView = (FMImageView*)[self.imageScrollView viewWithTag:mainNumberImage+1];
            unselectImageView.layer.borderColor = [UIColor clearColor].CGColor;
            [selectImagesView.layer setBorderWidth:3.0f];
            [flatObject.imageFlatArray addObject:unselectImageView.image];
        }
        mainNumberImage = numberFlat;
        [selectImagesView.layer setBorderColor:[UIColor blueColor].CGColor];
        [selectImagesView.layer setBorderWidth:3.0f];
        [flatObject.imageFlatArray removeObject:selectImagesView.image];
        flatObject.mainImage = selectImagesView.image;
        NSLog(@"count image = %d",[flatObject.imageFlatArray count]);
        
    }
}

-(void)liberalSelector:(UIButton*)button {
    if (!isPrivat) {
    [button setBackgroundImage:[UIImage imageNamed:@"check-active.png"] forState:UIControlStateNormal];
        flatObject.privat = YES;
        isPrivat=YES;
    }
    else{
        [button setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        flatObject.privat = NO;
        isPrivat = NO;
    }
}


-(void)privatSelector:(UIButton*)button {
    if (!isLiberal) {
        [button setBackgroundImage:[UIImage imageNamed:@"check-active.png"] forState:UIControlStateNormal];
        flatObject.liberal = YES;
        isLiberal=YES;
    }
    else{
        [button setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        flatObject.liberal = NO;
        isLiberal = NO;
    }
}

#pragma mark - button Selector
-(void)pushDropDownMenu:(UIButton*)button {
          selectButton = button;
        selectButton.frame = CGRectMake(selectButton.frame.origin.x, selectButton.frame.origin.y, dropMenuIMage.size.width, dropMenuIMage.size.height);
        [selectButton setBackgroundImage:[UIImage imageNamed:@"dropdown-metrodistance-select.png"]
                                forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (button==typeFlatButton) selectType=typeFlat;
        if (button ==metroDistanceButton) selectType=metroDistance;
        if (button==typeHouseButton) selectType=typeHouse;
        if (button==floorNumberButton) selectType=typeNumberFloor;
        if (button==flatFloorButton) selectType=typeFlatFloor;
        if (button==metroButton) selectType = typeMetro;
        infoArray = [[FMSystemDataClass getSystemData] getArrayDromMenuInfoWithTypy:selectType];
        dropMenuView = [[FMDropDounMenu alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-selectButton.frame.size.width/2, button.frame.origin.y+button.frame.size.height, button.bounds.size.width, (([infoArray count]>5)?5:[infoArray count])*dropMenuCellHeight) andType:selectType  andTableViewdata:infoArray];
        UIViewController *popViewController = [[UIViewController alloc] init];
        popViewController.view  =dropMenuView;
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popViewController];
        popoverController.delegate = self;
    popoverController.popoverBackgroundViewClass = [HDPopoverBAckgroundView class];
    popoverController.popoverContentSize = CGSizeMake(dropMenuView.frame.size.width,dropMenuView.frame.size.height);
    [[[popoverController contentViewController] view] setBackgroundColor:[UIColor clearColor]];
    CGRect frame = selectButton.frame;
        frame.origin.y -= self.mainScrollView.bounds.origin.y;
        [popoverController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
     dropMenuView.delegate =self;
//    NSArray* subviews = ((UIView*)[popoverController.contentViewController.view.superview.superview.superview.subviews objectAtIndex:0]).subviews;
//    for(UIView *subview in subviews){
//        [subview removeFromSuperview];
//    }
//    [[[popoverController contentViewController] view] setBackgroundColor:[UIColor blackColor]];
}


-(void)photoSelector {
    for (NSInteger i=0;i<5; i++) {
        BOOL ok = NO;
    for (NSInteger k=0; k<[numberImageArrayAdd count]; k++) {
        if (i==[[numberImageArrayAdd objectAtIndex:k] integerValue]) {
            ok=YES;
        }
    }
        if (!ok){ NumberImage=i; break;}
    }
    [numberImageArrayAdd addObject:[NSNumber numberWithInteger:NumberImage]];
    selectImagesView = (FMImageView*)[self.imageScrollView viewWithTag:NumberImage+1];
    numberPhotoAdd++;
 imagePickerPhoto= [[UIImagePickerController alloc] init];
    
    imagePickerPhoto.delegate = self;
//    imagePickerPhoto.navigationBarHidden = YES;
//    imagePickerPhoto.toolbarHidden = YES;
    imagePickerPhoto.sourceType =
    UIImagePickerControllerSourceTypeCamera;
    
    imagePickerPhoto.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
     self.navigationController.navigationBar.frame = CGRectMake(0, -60, 320, 44);
 self.view.frame = CGRectMake(0, -60, self.view.frame.size.width, self.view.frame.size.height+44);
    imagePickerPhoto.allowsEditing = YES;
    [self.view addSubview:imagePickerPhoto.view];
    [self addChildViewController:imagePickerPhoto];
   }

- (void)didReceiveMemoryWarning
{
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    selectTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField==adressTextField)flatObject.adress = textField.text;
    if (textField==priceTextField) flatObject.price = textField.text;
    if (textField==phoneNumberTextField) { phoneNumber = textField.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:FMAddActivityIndicator object:self userInfo:nil];
        [self performSelector:@selector(updateUserInfo) withObject:nil afterDelay:0.2];
    }
    if (textField ==nameTextField) {
        NSArray *nameArray = [textField.text componentsSeparatedByString:@" "];
        firstName = [nameArray objectAtIndex:0];
        lastName = [nameArray objectAtIndex:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:FMAddActivityIndicator object:self userInfo:nil];
        [self performSelector:@selector(updateUserInfo) withObject:nil afterDelay:0.2];
    
    }
}


-(void)updateUserInfo {
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSString *bodyString = [NSString stringWithFormat:@"action=userupdate&id=%@&firstname=%@&lastname=%@&phone=%@&vkid=%@&facebookid=%@",[userDefaults objectForKey:@"LoginId"],firstName,lastName,phoneNumber,[userDefaults objectForKey:@"vkID"],[userDefaults objectForKey:@"fbID"]];
    
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	////
	[NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
//	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//	SBJsonParser *parser = [[SBJsonParser alloc] init];
//	NSMutableDictionary *loadDict = [parser objectWithString:htmlString error:nil];
    [userDefaults setObject:phoneNumber forKey:@"phone"];
    [[NSNotificationCenter defaultCenter] postNotificationName:FMRemoveActivityIndicator object:self userInfo:nil];

    
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    BOOL value = YES;
    if ((textField==priceTextField)||(textField==phoneNumberTextField)) {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        value = [string isEqualToString:filtered];
    }
    return value;
}


#pragma mark - DropMenu delegate

-(void)selectDropMenuCell:(NSString*)string andIdParametrs:(NSInteger)idParam {
    [popoverController dismissPopoverAnimated:YES];
    [selectButton setBackgroundImage:[UIImage imageNamed:@"add-bg-items.png"] forState:UIControlStateNormal];
    selectButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
    if (selectButton==typeFlatButton) flatObject.typeFlatID = idParam;
    if (selectButton==metroDistanceButton) flatObject.metrodistanceID = idParam;
    if (selectButton==typeHouseButton) flatObject.typeHouseID = idParam;
    if (selectButton==floorNumberButton) flatObject.numberFloor = [string integerValue];
    if (selectButton==flatFloorButton) flatObject.flatFloor = [string integerValue];
    if (selectButton==metroButton) flatObject.metroID = idParam;
    [selectButton setTitle:string forState:UIControlStateNormal];
    if (dropMenuView) {
        [self removeDropMenu];
    }
   
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    [selectButton setBackgroundImage:[UIImage imageNamed:@"add-bg-items.png"] forState:UIControlStateNormal];
//    popoverController = nil;
}

-(void)removeDropMenu {

    
    [dropMenuView removeFromSuperview];
    dropMenuView = nil;
}

#pragma mark - UIScrollViewDelegate 

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    visibleRect.origin = scrollView.contentOffset;
    visibleRect.size = scrollView.bounds.size;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    visibleRect.origin = scrollView.contentOffset;
    visibleRect.size = scrollView.bounds.size;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [imagePickController.view removeFromSuperview];
    imagePickController= nil;
    [imagePickerPhoto.view removeFromSuperview];
    imagePickerPhoto = nil;
     self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 44);
     self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
//    FMImageView *imagesView = (FMImageView*)[self.imageScrollView viewWithTag:3];
//    imagesView.image = image;
//    self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 44);
//    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
//    [imagePickController.view removeFromSuperview];
//    imagePickController= nil;
//    
//}
- (UIImage *)fixrotation:(UIImage *)image{
    
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
     UIImage * pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    imageUpload = [self fixrotation:pickedImage];
    [selectImagesView setIMageViewImage:imageUpload];
    if (NumberImage==0) {
        [selectImagesView.layer setBorderColor:[UIColor blueColor].CGColor];
        [selectImagesView.layer setBorderWidth:3.0f];
        flatObject.mainImage = selectImagesView.image;
    }
    else
    [flatObject.imageFlatArray addObject:imageUpload];
    self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 44);
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
    [[self.childViewControllers lastObject] removeFromParentViewController];
//    if ([self.flatObject.imageFlatArray count]>=5) {
//        FMImageView *imageViw = [[FMImageView alloc] initWithFrame:CGRectMake(xPositionImage, 10, 150, 150)];
//        imageViw.tag=[self.flatObject.imageFlatArray count]+1;
//        [self.imageScrollView addSubview:imageViw];
//        xPositionImage+=imageViw.frame.size.width+15;
//        self.imageScrollView.contentSize = CGSizeMake(160*([self.flatObject.imageFlatArray count]+1), 150);
//    }
    [imagePickerPhoto.view removeFromSuperview];
    imagePickerPhoto = nil;
    [imagePickController.view removeFromSuperview];
    imagePickController= nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addSelector{
    
    if (phoneNumber.length<4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Вы не указали номер телефона"
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        return;
    }
    if (flatObject.adress.length<2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Вы не указали адрес"
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        return;
    }
    if (flatObject.price.length<2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Вы не указали цену"
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        return;
    }
    if (flatObject.flatFloor==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Вы не указали этаж квартиры"
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        return;
    }
    if (flatObject.numberFloor==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Вы не указали колличество этажей"
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        return;
    }
    if (flatObject.flatFloor==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Вы неуказали этаж квартиры"
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        return;
    }
    if (flatObject.typeHouseID==1000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Вы неуказали тип дома"
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        return;
    }
    if (flatObject.typeFlatID==1000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Вы не указали тип квартиры"
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        return;
    }

    if (flatObject.metroID==1000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Вы неуказали метро"
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        return;
    }
    if (flatObject.mainImage==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Вы не добавили фотографию"
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        return;
    }
    if (flatObject.flatFloor>flatObject.numberFloor) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Номер этажа квартиры не может быть больше количества этажей в доме"
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        return;
    }
    
    
       [[NSNotificationCenter defaultCenter] postNotificationName:FMAddActivityIndicator object:self userInfo:nil];

    [self performSelector:@selector(postFlat) withObject:nil afterDelay:0.5];
//    [self postFlat];

   
}

-(void)postFlat{
    
   
    NSURL *url = [NSURL URLWithString:serverUrl];
	NSString *bodyString = [NSString stringWithFormat:@"action=flatupdate&userid=%@&flattypeid=%d&housetypeid=%d&complaint=1&floor=%d&floortotal=%d&metroid=%d&metrodistanceid=%d&address=%@&price=%@&status=1&isgood=%d&isprivate=%d",[userDefaults objectForKey:@"LoginId"],flatObject.typeFlatID,flatObject.typeHouseID,flatObject.flatFloor,flatObject.numberFloor,flatObject.metroID,flatObject.metrodistanceID,flatObject.adress,flatObject.price,flatObject.liberal,flatObject.privat];
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	////
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSMutableDictionary *jsonDictionary = [parser objectWithString:htmlString error:nil];
    
    if ([[jsonDictionary objectForKey:@"code"] integerValue]==0) {
        NSMutableDictionary *pushControllerDict = [[NSMutableDictionary alloc] init];
        [pushControllerDict setObject:[NSString stringWithFormat:@"0"] forKey:@"controller"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dfdf" object:self userInfo:pushControllerDict];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FlatMania" message:@"Обявление не было добавлено"
													   delegate:self cancelButtonTitle:@"Хорошо" otherButtonTitles: nil];
		[alert show];
    }
    for (NSInteger k=0; k<[self.flatObject.imageFlatArray count]; k++) {
        [self loadImageToflatid:[[jsonDictionary objectForKey:@"id"] integerValue] andImage:[self.flatObject.imageFlatArray objectAtIndex:k] andType:0];
    }
    [self loadImageToflatid:[[jsonDictionary objectForKey:@"id"] integerValue] andImage:flatObject.mainImage andType:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:FMRemoveActivityIndicator object:self userInfo:nil];
}

-(void)loadImageToflatid:(NSInteger)flatId andImage:(UIImage*)addImage andType:(BOOL)mainType {
    NSURL *url = [NSURL URLWithString:serverUrl];    
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request1 addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    
    
    NSMutableData *body = [NSMutableData data];
    // Text parameter1
    NSString *param1 = @"flatimageadd";
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"action\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Another text parameter
    NSString *param2 = [NSString stringWithFormat:@"%d",flatId];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"flatid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //image
    NSData *imageData = UIImageJPEGRepresentation(addImage , 0.9);
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: attachment; name=\"userfile\"; filename=\"image122.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    // Another text parameter
    NSString *param3 = [NSString stringWithFormat:@"%d",mainType];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ismain\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:param3] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // set request body
    [request1 setHTTPBody:body];
    [request1 setHTTPMethod: @"POST"];
    [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
//	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

    }

- (void)viewDidUnload {
    [self setNameLabel:nil];
    [self setPhoneLabel:nil];
    [super viewDidUnload];
}
@end

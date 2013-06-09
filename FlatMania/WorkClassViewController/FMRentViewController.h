//
//  FMRentViewController.h
//  FlatMania
//
//  Created by Vladislav on 14.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMSlideViewController.h"
#import "FMDropDounMenu.h"
#import "FMSystemDataClass.h"
#import "FMAnnouncementViewController.h"
#import "FMFloopView.h"
#import "SBJson.h"
#import "UIPopoverController+iPhone.h"
#import "HDPopoverBAckgroundView.h"
#import <AVFoundation/AVFoundation.h>
#import "FMFlatObject.h"
#import "FMMenuViewController.h"
#import "UIButton+UIButton_withImag.h"
#import "FMImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
@class FMMenuViewController;

@interface FMRentViewController : FMSlideViewController<UIScrollViewDelegate,UITextFieldDelegate,FMDropMenuDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,FMImageViewDelegate>{
    FMMenuViewController *menu;
    int selectType;
    UITextField *priceTextField;
    UITextField *adressTextField;
    UITextField *nameTextField;
    BOOL isLiberal;
    BOOL isPrivat;
    NSInteger mainNumberImage;
    UIImage *dropMenuIMage;
    UIPopoverController *popoverController;
}

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (nonatomic,retain) FMFlatObject *flatObject;




@end

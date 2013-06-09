//
//  FMSearchViewController.m
//  FlatMania
//
//  Created by Vladislav on 22.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMSearchViewController.h"
#import "UIButton+UIButton_withImag.h"
#import "FMDropDounMenu.h"
#import "FMSystemDataClass.h"
#import "HDPopoverBAckgroundView.h"
#define startSearchMenuPosition 10
#define distanceButton 10

@interface FMSearchViewController (){
    UIButton *flatTypeButton;
    UIButton *metroName;
    UIButton *metroDistanceButton;
    UIButton *endCurrentButton;
    UIButton *startCurrentButton;
    FMDropDounMenu *dropMenu;
    NSMutableArray *infoArray;
    UIButton *selectButton;
    BOOL sortParametr;
    
}

@property (nonatomic,readwrite) NSInteger idFlatType;
@property (nonatomic,readwrite) NSInteger idMetro;
@property (nonatomic,readwrite) NSInteger metroDistanceId;
@property (nonatomic,readwrite) BOOL trueParametr;
@property (nonatomic,readwrite) BOOL isGoodParametr;
@property (nonatomic,readwrite) NSString *startPrice;
@property (nonatomic,readwrite) NSString *endPrice;
@end

@implementation FMSearchViewController

@synthesize trueParametr,isGoodParametr,idFlatType,idMetro,metroDistanceId,delegate,startPrice,endPrice;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setSearchView {
    self.startPrice = @"0";
    self.endPrice = @"100000";
    self.idFlatType=1000;
    self.idMetro=1000;
    self.metroDistanceId = 1000;
    self.trueParametr = NO;
    self.isGoodParametr = NO;
    sortParametr=NO;
    
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag!=1000) 
        [subview removeFromSuperview];
    }
    UIFont *buttonTittleFont = [UIFont systemFontOfSize:16];
    UIColor *colorTitle = [UIColor colorWithRed:149/255.0f green:149/255.0f blue:149/255.0f alpha:1.0f];
    dropMenuIMage = [UIImage imageNamed:@"dropdown-metrodistance.png"];
    UIImage *flattypeIMage = [UIImage imageNamed:@"dropdown-metrodistance.png"];
    flatTypeButton = [UIButton buttonItemWithImage:@"dropdown-metrodistance.png" title:@"Тип квартиры"
                                            target:self
                                          selector:@selector(pushDropDownMenu:)
                                          position:CGRectMake(self.view.frame.size.width/2-flattypeIMage.size.width/2, startSearchMenuPosition, flattypeIMage.size.width, flattypeIMage.size.height)];
    flatTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    flatTypeButton.titleLabel.font=buttonTittleFont;
    [flatTypeButton setTitleColor:colorTitle forState:UIControlStateNormal];
    flatTypeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:flatTypeButton];
    
    metroName = [UIButton buttonItemWithImage:@"dropdown-metrodistance.png" title:@"Станция метро"
                                       target:self
                                     selector:@selector(pushDropDownMenu:)
                                     position:CGRectMake(self.view.frame.size.width/2-flattypeIMage.size.width/2, flatTypeButton.frame.size.height+flatTypeButton.frame.origin.y+distanceButton, flattypeIMage.size.width, flattypeIMage.size.height)];
    metroName.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    metroName.titleLabel.font=buttonTittleFont;
    [metroName setTitleColor:colorTitle forState:UIControlStateNormal];
    metroName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:metroName];
    
    metroDistanceButton = [UIButton buttonItemWithImage:@"dropdown-metrodistance.png"
                                                  title:@"Расстояние до метро"
                                                 target:self selector:@selector(pushDropDownMenu:)
                                               position:CGRectMake(self.view.frame.size.width/2-flattypeIMage.size.width/2, metroName.frame.origin.y+metroName.frame.size.height+distanceButton,flattypeIMage.size.width, flattypeIMage.size.height)];
    metroDistanceButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    metroDistanceButton.titleLabel.font = buttonTittleFont;
    [metroDistanceButton setTitleColor:colorTitle forState:UIControlStateNormal];
    metroDistanceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:metroDistanceButton];
    UIImage *currentImage = [UIImage imageNamed:@"dropdown-pricefrom.png"];
    startCurrentButton = [UIButton buttonItemWithImage:@"dropdown-pricefrom.png"
                                                 title:@"Цена от"
                                                target:self
                                              selector:@selector(pushDropDownMenu:)
                                              position:CGRectMake(self.view.frame.size.width/2-flattypeIMage.size.width/2, metroDistanceButton.frame.size.height+metroDistanceButton.frame.origin.y+distanceButton, currentImage.size.width, currentImage.size.height)];
    startCurrentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    startCurrentButton.titleLabel.font = buttonTittleFont;
    [startCurrentButton setTitleColor:colorTitle forState:UIControlStateNormal];
    startCurrentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:startCurrentButton];
    
    endCurrentButton = [UIButton buttonItemWithImage:@"dropdown-pricefrom.png"
                                               title:@"Цена до"
                                              target:self
                                            selector:@selector(pushDropDownMenu:)
                                            position:CGRectMake(self.view.frame.size.width/2+flattypeIMage.size.width/2-currentImage.size.width, metroDistanceButton.frame.size.height+metroDistanceButton.frame.origin.y+distanceButton, currentImage.size.width, currentImage.size.height)];
    endCurrentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    endCurrentButton.titleLabel.font=buttonTittleFont;
    [endCurrentButton setTitleColor:colorTitle forState:UIControlStateNormal];
    endCurrentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:endCurrentButton];
    
    UILabel *currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-flattypeIMage.size.width/2,endCurrentButton.frame.origin.y+endCurrentButton.frame.size.height, flattypeIMage.size.width, flattypeIMage.size.height)];
    currentLabel.text = @"Цена указывается в рублях за месяц";
    currentLabel.textColor = [[UIColor alloc] initWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
    currentLabel.textAlignment = NSTextAlignmentCenter;
    currentLabel.backgroundColor = [UIColor clearColor];
    currentLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:currentLabel];
    
    UIImageView *ChestImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-flattypeIMage.size.width/2, currentLabel.frame.origin.y+currentLabel.frame.size.height, flattypeIMage.size.width, flattypeIMage.size.height)];
    ChestImageView.image = [UIImage imageNamed:@"dropdown-black.png"];
    [self.view addSubview:ChestImageView];
    UILabel *chestLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-flattypeIMage.size.width/2,  currentLabel.frame.origin.y+currentLabel.frame.size.height, flattypeIMage.size.width, flattypeIMage.size.height)];
    chestLabel.text = @"  Только честные";
    chestLabel.textColor = colorTitle;
    chestLabel.font = buttonTittleFont;
    chestLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:chestLabel];
    UIImage *chekIMage = [UIImage imageNamed:@"check.png"];
    UIButton *cheastButton = [UIButton buttonItemWithImage:@"check.png" title:@"" target:self selector:@selector(cheakBoxSelector:) position:CGRectMake(self.view.frame.size.width/2+flattypeIMage.size.width/2-chekIMage.size.width*1.3, ChestImageView.frame.origin.y+ChestImageView.frame.size.height/2-chekIMage.size.height/2, chekIMage.size.width, chekIMage.size.height)];
    [self.view addSubview:cheastButton];
    
    UIImageView *liberalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-flattypeIMage.size.width/2,  ChestImageView.frame.origin.y+ChestImageView.frame.size.height+distanceButton, flattypeIMage.size.width, flattypeIMage.size.height)];
    liberalImageView.image = [UIImage imageNamed:@"dropdown-black.png"];
    [self.view addSubview:liberalImageView];
    UILabel *liberalLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-flattypeIMage.size.width/2,  ChestImageView.frame.origin.y+ChestImageView.frame.size.height+distanceButton, flattypeIMage.size.width, flattypeIMage.size.height)];
    liberalLabel.text = @"  Либеральные условия";
    liberalLabel.textColor = colorTitle;
    liberalLabel.font = buttonTittleFont;
    liberalLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:liberalLabel];
    UIButton *liberalButton = [UIButton buttonItemWithImage:@"check.png" title:@"" target:self selector:@selector(liberalSetSelector:) position:CGRectMake(self.view.frame.size.width/2+flattypeIMage.size.width/2-chekIMage.size.width*1.3, liberalImageView.frame.origin.y+liberalImageView.frame.size.height/2-chekIMage.size.height/2, chekIMage.size.width, chekIMage.size.height)];
    [self.view addSubview:liberalButton];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-flattypeIMage.size.width/2, liberalImageView.frame.origin.y+liberalImageView.frame.size.height,flattypeIMage.size.width,flattypeIMage.size.height*2)];
    textLabel.text = @"Возможно заселение с животными, детьми и т.п.";
    textLabel.numberOfLines = 2;
    textLabel.font=[UIFont systemFontOfSize:12];
    textLabel.textColor = colorTitle;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textLabel];
    
    UIImage *lineImage = [UIImage imageNamed:@"search-menu-delemiter.png"];
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-lineImage.size.width/2, textLabel.frame.origin.y+textLabel.frame.size.height, lineImage.size.width, lineImage.size.height)];
    lineImageView.image =lineImage;
    [self.view addSubview:lineImageView];
    UIImage *searchImage = [UIImage imageNamed:@"search-big.png"];
    UIButton *searchButton = [UIButton buttonItemWithImage:@"search-big.png" title:@"" target:self selector:@selector(searchSelector) position:CGRectMake(self.view.frame.size.width/2+flattypeIMage.size.width/2-searchImage.size.width, lineImageView.frame.origin.y+startSearchMenuPosition, searchImage.size.width, searchImage.size.height)];
    [self.view addSubview:searchButton];
    
    UIButton *resetButton = [UIButton buttonItemWithImage:@"button-reset.png" title:@"" target:self selector:@selector(resetSelector) position:CGRectMake(self.view.frame.size.width/2-flattypeIMage.size.width/2, lineImageView.frame.origin.y+startSearchMenuPosition, searchImage.size.width, searchImage.size.height)];
    [self.view addSubview:resetButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect masterRect = self.view.bounds;
    NSLog(@"%f",self.view.frame.size.width);
    
    self.view.frame = CGRectMake(0, 0, masterRect.size.width-53, masterRect.size.height);
    
    [self setSearchView];
    // Do any additional setup after loading the view from its nib.
}

-(void)searchSelector {
    if ([self.startPrice integerValue]>[self.endPrice integerValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Цена \"до\" не может быть меньше цены \"от\""
													   delegate:self cancelButtonTitle:@"Продолжить" otherButtonTitles: nil];
		[alert show];
        return;
    }

    NSString *bodyString = [NSString stringWithFormat:@"action=flatsgetfull&start=0&condition="];
    if (self.idFlatType!=1000) {
        sortParametr =YES;
        bodyString = [bodyString stringByAppendingString:[NSString stringWithFormat:@" Flats.flattypeid=%d",self.idFlatType]];
    }
    
    if (self.idMetro!=1000) {
        if (sortParametr) bodyString = [bodyString stringByAppendingString:@" AND"];
        
        bodyString = [bodyString stringByAppendingString:[NSString stringWithFormat:@" Flats.metroid=%d",self.idMetro]];
        sortParametr =YES;
    }
    
    if (self.metroDistanceId!=1000) {
        if (sortParametr) bodyString = [bodyString stringByAppendingString:@" AND"];
        bodyString = [bodyString stringByAppendingString:[NSString stringWithFormat:@" Flats.metrodistanceid=%d",self.metroDistanceId]];
        sortParametr =YES;
    }
    
    if (![self.startPrice isEqual:@"0"]||![self.endPrice isEqual:@"100000"]) {
        if (sortParametr) bodyString = [bodyString stringByAppendingString:@" AND"];
        bodyString = [bodyString stringByAppendingString:[NSString stringWithFormat:@" Flats.Price between %@ and %@",self.startPrice,self.endPrice]];
        sortParametr =YES;
    }
    if (self.trueParametr) {
    if (sortParametr) bodyString = [bodyString stringByAppendingString:@" AND"];
    bodyString = [bodyString stringByAppendingString:[NSString stringWithFormat:@" Flats.isprivate=%d",self.trueParametr]];
    sortParametr =YES;
    }
    if (self.isGoodParametr) {
    if (sortParametr)
    bodyString = [bodyString stringByAppendingString:@" AND"];
    bodyString = [bodyString stringByAppendingString:[NSString stringWithFormat:@" Flats.isgood=%d",self.isGoodParametr]];
    }
    
    [self.delegate searchResultArray:bodyString];
    sortParametr=NO;
//    [addActive stopAnimating];

}

-(void)resetSelector{
    [self setSearchView];
}

-(void)liberalSetSelector:(UIButton*)button{
    if (!isGoodParametr) {
        [button setBackgroundImage:[UIImage imageNamed:@"check-active.png"] forState:UIControlStateNormal];
    }
    else {
          [button setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    }
    isGoodParametr=!isGoodParametr;
    
}

-(void)cheakBoxSelector:(UIButton*)button {
    if (!trueParametr) {
         [button setBackgroundImage:[UIImage imageNamed:@"check-active.png"] forState:UIControlStateNormal];
    }
    else{[button setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        
    }
trueParametr=!trueParametr;
}



-(void)pushDropDownMenu:(UIButton*)button {
        selectButton = button;
        selectButton.frame = CGRectMake(selectButton.frame.origin.x, selectButton.frame.origin.y,selectButton.frame.size.width, dropMenuIMage.size.height);
        [selectButton setBackgroundImage:[UIImage imageNamed:@"dropdown-metrodistance-select.png"] forState:UIControlStateNormal];
        if (button==flatTypeButton) selectType=typeFlat;
        if (button ==metroDistanceButton) selectType=metroDistance;
        if (button==metroName) selectType = typeMetro;
        if ((button==startCurrentButton)||(button==endCurrentButton)) selectType=priceType;
        infoArray = [[FMSystemDataClass getSystemData] getArrayDromMenuInfoWithTypy:selectType];
    dropMenu = [[FMDropDounMenu alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-selectButton.frame.size.width/2, button.frame.origin.y+button.frame.size.height, button.bounds.size.width, (([infoArray count]>5)?5:[infoArray count])*dropMenuCellHeight) andType:selectType  andTableViewdata:infoArray];
        dropMenu.delegate =self;
    UIViewController *dropViewController = [[UIViewController alloc] init];
    dropViewController.view =dropMenu;
    popoverController = [[UIPopoverController alloc] initWithContentViewController:dropViewController];
    popoverController.delegate = self;
    popoverController.popoverBackgroundViewClass = [HDPopoverBAckgroundView class];
    if (selectType==priceType)
        popoverController.popoverContentSize = CGSizeMake(startCurrentButton.frame.size.width,dropMenu.frame.size.height);
     else
    popoverController.popoverContentSize = CGSizeMake(dropMenu.frame.size.width,dropMenu.frame.size.height);
    [[[popoverController contentViewController] view] setBackgroundColor:[UIColor clearColor]];
    [popoverController presentPopoverWithoutInnerShadowFromRect:selectButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
#pragma mark - UIPopoverController Delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    [selectButton setBackgroundImage:[UIImage imageNamed:@"dropdown-metrodistance.png"] forState:UIControlStateNormal];
}


-(void)selectDropMenuCell:(NSString*)string andIdParametrs:(NSInteger)idParam{
    if (selectButton==flatTypeButton) self.idFlatType = idParam;
    if (selectButton==metroDistanceButton) self.metroDistanceId = idParam;
    if (selectButton==metroName) self.idMetro = idParam;
    if (selectButton==startCurrentButton) self.startPrice = string;
    if (selectButton==endCurrentButton) self.endPrice = string;
    [selectButton setTitleColor:[[UIColor alloc]initWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [selectButton setTitle:string forState:UIControlStateNormal];
    selectButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
        dropMenu=nil;
    [popoverController dismissPopoverAnimated:YES];
        [selectButton setBackgroundImage:[UIImage imageNamed:@"dropdown-metrodistance.png"] forState:UIControlStateNormal];
}


-(void)priceSelector:(UIButton*)priceSelector {
    
}

-(void)buttonSelector:(UIButton*)button {
    
}

- (void)didReceiveMemoryWarning
{
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

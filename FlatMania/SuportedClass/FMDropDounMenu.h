//
//  FMDropDounMenu.h
//  FlatMania
//
//  Created by Vladislav on 14.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMDropMenuDelegate <NSObject>

-(void)selectDropMenuCell:(NSString*)string andIdParametrs:(NSInteger)idParam;

@end

@interface FMDropDounMenu : UIView<UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate>{
    int typeMenu;
    UITableView *tableView;
    UIImageView *dropDownImageView;
    CGRect setFrame;
    id <FMDropMenuDelegate> delegate;
}
@property (nonatomic,retain) NSMutableArray *tableViewInfoArray;
@property (nonatomic,retain) id <FMDropMenuDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andType:(int)type  andTableViewdata:(NSMutableArray*)dataArray;



@end

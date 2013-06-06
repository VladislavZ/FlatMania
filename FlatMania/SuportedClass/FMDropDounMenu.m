//
//  FMDropDounMenu.m
//  FlatMania
//
//  Created by Vladislav on 14.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMDropDounMenu.h"
#import "FMSystemDataClass.h"

@implementation FMDropDounMenu
@synthesize tableViewInfoArray,delegate;

- (id)initWithFrame:(CGRect)frame andType:(int)type  andTableViewdata:(NSMutableArray*)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        typeMenu = type;
//          UIImage *dropMenuImage = [UIImage imageNamed:@"dropdown-bg.png"];
//        if (frame.size.height>dropMenuCellHeight*5) {
//            setFrame = CGRectMake(0, 0, frame.size.width, dropMenuCellHeight*4);
//        }
//        else
        setFrame = frame;
        self.tableViewInfoArray = dataArray;
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, setFrame.size.width, setFrame.size.height)];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.separatorColor = [UIColor grayColor];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self addSubview:tableView];
//        [self openView];
        
    }
    return self;
}


-(void)openView {
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         dropDownImageView.frame = CGRectMake(0, 0, setFrame.size.width, setFrame.size.height);
                         tableView.frame = CGRectMake(tableView.frame.origin.x,tableView.frame.origin.y, setFrame.size.width-10, setFrame.size.height-10);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return dropMenuCellHeight-5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableViewInfoArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (typeMenu==typeNumberFloor||typeMenu==typeFlatFloor||typeMenu==priceType) {
        [self.delegate selectDropMenuCell:[self.tableViewInfoArray objectAtIndex:indexPath.row]  andIdParametrs:0];
    }
    else
    [self.delegate selectDropMenuCell:[[self.tableViewInfoArray objectAtIndex:indexPath.row] objectForKey:@"name"] andIdParametrs:[[[self.tableViewInfoArray objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue]];
}

-(UITableViewCell*)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdenifire = @"Cell";
    UITableViewCell *cell =[tableView1 dequeueReusableCellWithIdentifier:cellIdenifire];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenifire];
    }
    if (typeMenu==typeNumberFloor||typeMenu==typeFlatFloor||typeMenu==priceType) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[tableViewInfoArray objectAtIndex:indexPath.row]];
    }
    else
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[tableViewInfoArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:16];
    return cell;
}


@end

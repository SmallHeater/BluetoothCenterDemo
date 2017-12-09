//
//  BloothCell.m
//  BlothCenterDemo
//
//  Created by xianjunwang on 2017/12/7.
//  Copyright © 2017年 xianjunwang. All rights reserved.
//

#import "BloothCell.h"
//屏幕宽度
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
@implementation BloothCell

#pragma mark  ----  生命周期函数

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.label];
    }
    return self;
}

#pragma mark  ----  懒加载
-(UILabel *)label{
    
    if (!_label) {
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 40)];
        _label.numberOfLines = 0;
        _label.font = [UIFont systemFontOfSize:14.0];
        _label.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _label;
}

@end

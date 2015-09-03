//
//  NTESTextSettingCell.m
//  NIM
//
//  Created by chris on 15/8/18.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESTextSettingCell.h"
#import "UIView+NTES.h"
#import "NTESCommonTableData.h"

@implementation NTESTextSettingCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField           = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.font      = [UIFont systemFontOfSize:17.f];
        _textField.textColor = UIColorFromRGB(0x333333);
        [self addSubview:_textField];
    }
    return self;
}


- (void)refreshData:(NTESCommonTableRow *)rowData tableView:(UITableView *)tableView{
    _textField.delegate    = (id<UITextFieldDelegate>)tableView.viewController;
    _textField.text        = rowData.extraInfo;
    _textField.placeholder = rowData.title;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat textFieldLeft   = 17.f;
    CGFloat textFieldRight  = 17.f;
    CGFloat textFieldTop    = 17.f;
    CGFloat textFieldBottom = 17.f;
    self.textField.width  = self.width - textFieldLeft - textFieldRight;
    self.textField.height = self.height - textFieldTop - textFieldBottom;
    self.textField.centerX = self.width * .5f;
    self.textField.centerY = self.height * .5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if (selected) {
        [self.textField becomeFirstResponder];
    }
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

@end

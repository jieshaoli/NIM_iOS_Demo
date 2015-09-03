//
//  TeamCardOperationItem.m
//  NIM
//
//  Created by chris on 15/3/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESTeamCardOperationItem.h"

@interface NTESTeamCardOperationItem()

@property(nonatomic,copy)   NSString *title;

@property(nonatomic,strong) UIImage  *imageNormal;

@property(nonatomic,strong) UIImage  *imageHighLight;

@property(nonatomic,assign) NTESCardHeaderOpeator opera;

@end

@implementation NTESTeamCardOperationItem

- (instancetype)initWithOperation:(NTESCardHeaderOpeator)opera{
    self = [self init];
    if (self) {
        [self buildWithTeamCardOperation:opera];
    }
    return self;
}

- (void)buildWithTeamCardOperation:(NTESCardHeaderOpeator)opera{
    _opera = opera;
    switch (opera) {
        case CardHeaderOpeatorAdd:
            _title          = @"加入";
            _imageNormal    = [UIImage imageNamed:@"icon_add_normal"];
            _imageHighLight = [UIImage imageNamed:@"icon_add_pressed"];
            break;
        case CardHeaderOpeatorRemove:
            _title          = @"移除";
            _imageNormal    = [UIImage imageNamed:@"icon_remove_normal"];
            _imageHighLight = [UIImage imageNamed:@"icon_remove_pressed"];
            break;
        default:
            break;
    }
}

@end

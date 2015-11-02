//
//  NTESUserDataProvider.m
//  NIM
//
//  Created by amao on 8/13/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESDataProvider.h"

@interface NTESDataProvider()

@property (nonatomic,strong) UIImage *defaultUserAvatar;

@property (nonatomic,strong) UIImage *defaultTeamAvatar;

@end

@implementation NTESDataProvider

- (instancetype)init{
    self = [super init];
    if (self) {
        _defaultUserAvatar = [UIImage imageNamed:@"avatar_user"];
        _defaultTeamAvatar = [UIImage imageNamed:@"avatar_team"];
    }
    return self;
}

- (NIMKitInfo *)infoByUser:(NSString *)userId{
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:userId];
    if (user) {
        //如果本地有数据则直接返回
        NIMKitInfo *info = [[NIMKitInfo alloc] init];
        info.infoId      = userId;
        info.showName    = user.userInfo.nickName.length ? user.userInfo.nickName : userId;
        info.avatarImage = self.defaultUserAvatar;
        info.avatarUrlString = user.userInfo.thumbAvatarUrl;
        return info;
    }else{
        //如果本地没有数据则去自己的应用服务器请求数据
        [[NIMSDK sharedSDK].userManager fetchUserInfos:@[userId] completion:^(NSArray *users, NSError *error) {
            if (!error) {
                [[NIMKit sharedKit] notfiyUserInfoChanged:userId];
            }
        }];
        //先返回一个默认数据,以供网络请求没回来的时候界面可以有东西展示
        NIMKitInfo *info = [[NIMKitInfo alloc] init];
        info.showName    = userId; //本地没有昵称，拿userId代替
        info.avatarImage = self.defaultUserAvatar; //默认占位头像
        return info;
    }
}

- (NIMKitInfo *)infoByTeam:(NSString *)teamId{
    NIMTeam *team    = [[NIMSDK sharedSDK].teamManager teamById:teamId];
    NIMKitInfo *info = [[NIMKitInfo alloc] init];
    info.showName    = team.teamName;
    info.infoId      = teamId;
    info.avatarImage = self.defaultTeamAvatar;
    return info;
}



@end

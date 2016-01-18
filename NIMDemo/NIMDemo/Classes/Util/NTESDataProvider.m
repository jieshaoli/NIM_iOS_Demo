//
//  NTESUserDataProvider.m
//  NIM
//
//  Created by amao on 8/13/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESDataProvider.h"

@interface NTESDataRequestArray : NSObject

@property (nonatomic,assign) NSInteger maxMergeCount; //最大合并数

- (void)requestUserIds:(NSArray *)userIds;

@end


@interface NTESDataProvider()

@property (nonatomic,strong) UIImage *defaultUserAvatar;

@property (nonatomic,strong) UIImage *defaultTeamAvatar;

@property (nonatomic,strong) NTESDataRequestArray *requestArray;

@end

@implementation NTESDataProvider

- (instancetype)init{
    self = [super init];
    if (self) {
        _defaultUserAvatar = [UIImage imageNamed:@"avatar_user"];
        _defaultTeamAvatar = [UIImage imageNamed:@"avatar_team"];
        _requestArray = [[NTESDataRequestArray alloc] init];
        _requestArray.maxMergeCount = 20;
    }
    return self;
}

- (NIMKitInfo *)infoByUser:(NSString *)userId{
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:userId];
    if (user.userInfo) {
        //如果本地有数据则直接返回
        NIMKitInfo *info = [[NIMKitInfo alloc] init];
        info.infoId      = userId;
        if (user.alias.length) {
            //有备注名优先显示备注名
            info.showName = user.alias;
        }else{
            info.showName = user.userInfo.nickName;
        }
        info.avatarImage = self.defaultUserAvatar;
        info.avatarUrlString = user.userInfo.thumbAvatarUrl;
        return info;
    }else{
        //如果本地没有数据则去服务器请求数据
        [self.requestArray requestUserIds:@[userId]];
        
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




@implementation NTESDataRequestArray{
    NSMutableArray *_requstUserIdArray; //待请求池
    BOOL _isRequesting;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _requstUserIdArray = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)requestUserIds:(NSArray *)userIds
{
    for (NSString *userId in userIds)
    {
        if (![_requstUserIdArray containsObject:userId])
        {
            [_requstUserIdArray addObject:userId];
            DDLogInfo(@"should request info for userid %@",userId);
        }
    }
    [self request];
}


- (void)request
{
    static NSUInteger MaxBatchReuqestCount = 10;
    if (_isRequesting || [_requstUserIdArray count] == 0) {
        return;
    }
    _isRequesting = YES;
    NSArray *userIds = [_requstUserIdArray count] > MaxBatchReuqestCount ?
    [_requstUserIdArray subarrayWithRange:NSMakeRange(0, MaxBatchReuqestCount)] : [_requstUserIdArray copy];
    
    DDLogInfo(@"request user ids %@",userIds);
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].userManager fetchUserInfos:userIds
                                        completion:^(NSArray *users, NSError *error) {
                                            [weakSelf afterReuquest:userIds];
                                            if (!error) {
                                                [[NIMKit sharedKit] notfiyUserInfoChanged:userIds];
                                            }
                                        }];
}

- (void)afterReuquest:(NSArray *)userIds
{
    _isRequesting = NO;
    [_requstUserIdArray removeObjectsInArray:userIds];
    [self request];
    
}

@end

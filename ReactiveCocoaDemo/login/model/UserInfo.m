//
//  UserInfo.m
//  ReactiveCocoaDemo
//
//  Created by hky on 15/11/17.
//  Copyright © 2015年 ZeluLi. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *_shareInstance;


@implementation UserInfo


+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[UserInfo alloc] init];
    });
    return _shareInstance;
}

@end

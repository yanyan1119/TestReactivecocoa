//
//  UserInfo.h
//  ReactiveCocoaDemo
//
//  Created by hky on 15/11/17.
//  Copyright © 2015年 ZeluLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;


+ (instancetype)shareInstance;


@end

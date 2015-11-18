
//
//  LoginViewModel.m
//  ReactiveCocoaDemo
//
//  Created by hky on 15/11/17.
//  Copyright © 2015年 ZeluLi. All rights reserved.
//

#import "LoginViewModel.h"

@interface LoginViewModel()

@property (nonatomic, strong) RACSignal *userNameSignal;
@property (nonatomic, strong) RACSignal *passwordSignal;

@end

@implementation LoginViewModel

- (instancetype)init
{
    if (self = [super init])
    {
        _usrInfo = [UserInfo shareInstance];
        _userNameSignal = RACObserve(self,usrInfo.userName);
        _passwordSignal = RACObserve(self,usrInfo.password);
        _successSub = [RACSubject subject];
        _failureSub = [RACSubject subject];
        _errorSub = [RACSubject subject];
    }
    return self;
}

- (RACSignal*)isLoginEnable
{
    return [RACSignal combineLatest:@[_userNameSignal,_passwordSignal]
                             reduce:^id(NSString *userName,NSString *password){
                                 return @(userName.length >= 3 && password.length >= 6);
                             }];
}

- (void)login
{
     [_delegate finishLogin];
    // to do 调用API 登录
    
    //to do 登录成功、失败error 后回传信号
    [_successSub sendNext:@{}];
    [_failureSub sendNext:@{}];
    [_errorSub sendNext:@{}];
}


@end

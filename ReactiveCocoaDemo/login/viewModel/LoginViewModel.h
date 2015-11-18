//
//  LoginViewModel.h
//  ReactiveCocoaDemo
//
//  Created by hky on 15/11/17.
//  Copyright © 2015年 ZeluLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol LoginViewModelDelegate <NSObject>

- (void)finishLogin;

@end

@interface LoginViewModel : NSObject

@property (nonatomic, strong) UserInfo *usrInfo;

@property (nonatomic, strong) RACSubject *successSub;
@property (nonatomic, strong) RACSubject *failureSub;
@property (nonatomic, strong) RACSubject *errorSub;

@property (nonatomic, weak) id <LoginViewModelDelegate>delegate;

- (RACSignal*)isLoginEnable;

- (void)login;


@end

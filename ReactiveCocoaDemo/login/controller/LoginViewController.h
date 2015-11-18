//
//  LoginViewController.h
//  ReactiveCocoaDemo
//
//  Created by hky on 15/11/17.
//  Copyright © 2015年 hky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LoginViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) LoginViewModel *viewModel;

@end

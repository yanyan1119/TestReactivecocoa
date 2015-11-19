//
//  LoginViewController.m
//  ReactiveCocoaDemo
//
//  Created by hky on 15/11/17.
//  Copyright © 2015年 hky. All rights reserved.
//

#import "LoginViewController.h"
#import "UIButton+WLFButton.h"


@interface LoginViewController ()<LoginViewModelDelegate>

@property (nonatomic, strong) UITextField *userNameTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) NSString *valueA;
@property (nonatomic, strong) NSString *valueB;

@end

@implementation LoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"登录";
        self.view.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadSubviews];
    
    [self bindViewModel];
    
    [self combindLates];
    
    [self signalSwitch];
    
    [self filter];
    
    [self mapSignal];
    
    [self distinctUntilChange];
    
    [self RACSubscriberProtocol];
    
    [self removeSubscriber];
    
    //  [self KVOandNotificationAndTargetAction];
    
    [self channelTerminal];
    
    [self delegeTest];
    
    [self concatSignal];
    
    [self mergeSignal];
    
    [self zipSignal];
    
    [self flattenMapSignal];
    
    [self thenSignal];
    
    [self executeSignal];
    
    [self delaySignal];
    
    [self replaySignal];
    
   // [self schedulerSignal];
    
    [self timeOutSignal];
    
    [self retrySignal];
    
    [self throttleSignal];
    
    [self takeUntilSignal];
}

//条件
- (void)takeUntilSignal
{
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            [subscriber sendNext:@"直到世界尽头才能把我们分开"];
        }];
        return nil;
    }] takeUntil:[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"世界尽头到了  嘿嘿 ");
            [subscriber sendNext:@"世界尽头到了"];
        });
        return nil;
    }]] subscribeNext:^(id x) {
        NSLog(@"%@ ",x);
    }];
}

//节流
- (void)throttleSignal
{
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"第一个"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"第二个"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"第三个"];
            [subscriber sendNext:@"第四个"];
            [subscriber sendNext:@"第五个"];
            [subscriber sendNext:@"六个"];
            [subscriber sendNext:@"七个"];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"第八个"];
            [subscriber sendNext:@"第九个"];
            [subscriber sendNext:@"十个"];
        });
        return nil;
    }]throttle:1] subscribeNext:^(id x) {
        NSLog(@"%@都通过了",x);
    }];
}

//重试
- (void)retrySignal
{
    __block NSInteger count = 0;
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (count < 5) {
            count ++;
            NSLog(@"发送失败了，再来一次");
            [subscriber sendError:nil];
        }
        else
        {
            NSLog(@"发送失败了五次");
            [subscriber sendNext:@""];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        NSLog(@"终于发送成功了！");
    } error:^(NSError *error) {
        NSLog(@"发送失败 %@ 次",@(count));
    }];
}

//超时
- (void)timeOutSignal
{
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"我快到了！");
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
            return nil;
        }] delay:10] subscribeNext:^(id x) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }] timeout:8 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
    } error:^(NSError *error) {
         NSLog(@"等了你10S 你还没有来");
    } completed:^{
        
    }];
    
}

//定时哭 默认重复
- (void)schedulerSignal
{
    [[RACSignal interval:5 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        NSLog(@"--- times up!\n current thread:%p",[NSThread currentThread]) ;
    }];
}

//给每个订阅者发送一次同一个事件
- (void)replaySignal
{
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"大导演拍了一部电影《我的男票是程序员》");
        [subscriber sendNext:@"《我的男票是程序员》"];
        return nil;
    }] replay];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"小明看了%@",x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"小红看了%@",x);
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"小杨看了%@",x);
    }];
}

//延时执行
- (void)delaySignal
{
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"sleep for 3 seconds");
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }] delay:3] subscribeNext:^(id x) {
        NSLog(@"3 seconds is up");
    }];
}

- (void)executeSignal
{
    RACCommand *com = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"现在执行！");
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    [com execute:nil];//没有订阅者的时候 也可以执行signalblock里的内容
}

//顺序
- (void)thenSignal
{
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"打开冰箱门");
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"把大象放进冰箱");
            [subscriber sendCompleted];
            return nil;
        }];
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"关上冰箱门");
            [subscriber sendCompleted];
            return nil;
        }];
    }] subscribeCompleted:^{
         NSLog(@"把大象放进冰箱了");
    }];
}

//根据前一个信号的参数创建一个新的信号！
- (void)flattenMapSignal
{
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"==== 打蛋液!");
        [subscriber sendNext:@"蛋液"];
        [subscriber sendCompleted];
        return nil;
    }] flattenMap:^RACStream *(id value) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"---- 把%@倒进锅里煎",value);
            [subscriber sendNext:@"煎蛋"];
            [subscriber sendCompleted];
            return nil;}];
        }]flattenMap:^RACStream *(id value) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSLog(@"---- 把%@装到盘里",value);
                [subscriber sendNext:@"上菜"];
                [subscriber sendCompleted];
                return nil;
            }];
      }] subscribeNext:^(id x) {
          NSLog(@"----- :%@",x);
      }];;
}

//信号合并 被合并信号的第N个信号都发出之后合并输出
- (void)zipSignal
{
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    
    [[subjectA zipWith:subjectB] subscribeNext:^(RACTuple *x) {
        RACTupleUnpack(NSString *stringA,NSString *stringB) = x;
        NSLog(@"---- we are:%@%@",stringA,stringB);
    }];
    
    [subjectA sendNext:@"A"];//无输出
    [subjectA sendNext:@"B"];//无输出
    [subjectB sendNext:@"1"];//输出A1
    [subjectB sendNext:@"2"];//输出B2
    [subjectA sendNext:@"C"];//无输出
    [subjectB sendNext:@"3"];//输出C3
}

//merge
- (void)mergeSignal
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"我去爬山了！"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"我去海边了！"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //被合并的 signalB signalA 同时发送Next事件的时候 按合并的先后顺序处理  ==== merge :我去海边了！  ==== merge :我去爬山了！
    [[RACSignal merge:@[signalB,signalA]]subscribeNext:^(id x) {
        NSLog(@"==== merge :%@",x);
    }];
}

//concat
- (void)concatSignal
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"我去爬山了！"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"我去海边了！"];
        [subscriber sendCompleted];
        return nil;
    }];
    //信号A在信号B之后发送（接收）----- receive next :我去海边了！ ----- receive next :我去爬山了！
    [[signalB concat:signalA] subscribeNext:^(id x) {
        NSLog(@"----- receive next :%@",x);
    }];
}

//委托
-(void)delegeTest
{
    _viewModel.delegate = self;
    [[self rac_signalForSelector:@selector(finishLogin) fromProtocol:@protocol(LoginViewModelDelegate)] subscribeNext:^(id x) {
        NSLog(@"LoginViewModelDelegate");
    }];
}

//
- (void)channelTerminal
{
    RACChannelTerminal *channelA = RACChannelTo(self,valueA);
    RACChannelTerminal *channelB = RACChannelTo(self,valueB);
    [[channelA map:^id(NSString* value) {
        if ([value isEqualToString:@"down"]) {
            return @"up";
        }
        return value;
    }] subscribe:channelB];//channelA 经过map之后 给channelB发送消息
    
    [[channelB map:^id(NSString *value) {
        if ([value isEqualToString:@"left"]) {
            return @"right";
        }
        return value;
    }]subscribe:channelA];//channelB 经过map之后 给channelA发送消息
    
    [[RACObserve(self, valueA) filter:^BOOL(id value) {
        return value?YES:NO;
    }] subscribeNext:^(id x) {
        NSLog(@"he go %@",x);
    }];
    
    [[RACObserve(self, valueB) filter:^BOOL(id value) {
        return value?YES:NO;
    }]subscribeNext:^(id x) {
        NSLog(@"she goes %@",x);
    }];
    
    self.valueA = @"down"; //A 输出 he go down B 输出  she goes up
    self.valueB = @"left";//A 输出 he go right B 输出  she goes left
}

- (void)KVOandNotificationAndTargetAction
{
    //KVO
    [RACObserve(_viewModel, usrInfo.userName) subscribeNext:^(id x) {
        NSLog(@"text is change to :%@",x);
    }];
    
    //target action
    _loginBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"login button is touch!");
        return [RACSignal empty];
    }];
    
    //NSNotification
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"current text is :%@",x);
    }];
}

//RACSignal (Subscription)类别中所有方法的返回值类型都是RACDisposable，它的dispose方法可以让我们手动移除订阅者。当管道的订阅者全部被移除后，管道中的代码不会执行，包括三种事件参数block中的代码和诸如doNext:等副作用的block。可以简单理解为，当管道中的Signal没人订阅，它的事件就不会发出了
- (void)removeSubscriber
{
    RACSubject *subject = [RACSubject subject];
    
    RACDisposable *disp = [subject subscribeNext:^(id x) {
        NSLog(@"---removeSubscriber receive next :%@",x);
    } error:^(NSError *error) {
        NSLog(@"---removeSubscriber receive error :%@",error.localizedDescription);
    } completed:^{
        NSLog(@"---removeSubscriber receive completed");
    }];
    
    [subject sendNext:@"removeSubscriber send next"];
    //---removeSubscriber receive next :removeSubscriber send next
    
    [subject sendError:[NSError errorWithDomain:@"error" code:1 userInfo:@{NSLocalizedDescriptionKey:@"removeSubscriber send error!"}]];
    //---removeSubscriber receive error :removeSubscriber send error!
    
    [disp dispose];//移除订阅者
    
    [subject sendNext:@"removeSubscriber send next after dispose"];//无输出
    [subject sendError:[NSError errorWithDomain:@"error" code:1 userInfo:@{NSLocalizedDescriptionKey:@"removeSubscriber send error after dispose !"}]];//无输出
    
}

//RACSubscriber是一个协议，包含了向订阅者发送事件的方法。 上面工厂方法用于创建一个Signal，当Signal被订阅时，createSignal:的参数block中的内容被执行。block的参数是一个实现RACSubscriber协议的对象，然后向这个订阅者发送了next事件（内容为NSNumber类型的@YES值）和completed事件。
- (void)RACSubscriberProtocol
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"----- subscriber send next"];
        [subscriber sendError:[NSError errorWithDomain:@"error" code:1 userInfo:@{NSLocalizedDescriptionKey:@"subscriber send error!"}]];
        [subscriber sendCompleted];
        return nil;
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"--- subscribe receice next:%@",x);
        //--- sunscribe receice next:----- subscriber send next
    } error:^(NSError *error) {
        NSLog(@"--- subscribe receive error:%@",error.localizedDescription);
        //--- sunscribe receice error:subscriber send error!
    } completed:^{
        NSLog(@"--- subscribe receive completed");
    }];
}

//比较数值流中当前值和上一个值，如果不同，就返回当前值，简单理解为“流”的值有变化时反馈变化的值，求异存同。
- (void)distinctUntilChange
{
    RACSubject *subject = [RACSubject subject];
    
    [[subject distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"==== distinctUntilChanged value:%@",x);
    }];
    
    [subject sendNext:@"hello"];// ==== distinctUntilChanged value:hello
    [subject sendNext:@"hello"];//与上一个值相同 不返回 即不发送信号
    [subject sendNext:@"my name is lily"];// ==== distinctUntilChanged value:my name is lily
    [subject sendNext:@"my name is lily"];//与上一个值相同 不返回 即不发送信号
    [subject sendNext:@"my name is lily"];//与上一个值相同 不返回 即不发送信号
    [subject sendNext:@"my name is lucy"];// ==== distinctUntilChanged value:my name is lucy
}

//会将事件中的数据转换成你想要的数据，返回一个转换事件内容后的instancetype instancetype是程序运行时对象的类型，有可能为RACStream，也可以为其子类RACSignal

- (void)mapSignal
{
    RACSubject *subject = [RACSubject subject];
    
    [[subject map:^id(NSString *value) {
        return @(value.length);
    }] subscribeNext:^(id x) {
        NSLog(@"==== text lenght:%@",x);
    }];
    
    [subject sendNext:@"hello"];//==== text lenght:5
    [subject sendNext:@"hello world"];//==== text lenght:11
    [subject sendNext:@"hello object-c and swift"];//==== text lenght:24
}


//对RACStream中的事件内容进行过滤，返回一个过滤事件内容后的instancetype
- (void)filter
{
    RACSubject *racsub = [RACSubject subject];
    [[racsub filter:^BOOL(NSString *value) {
        return value.length > 3;
    }] subscribeNext:^(id x) {
        NSLog(@"------ value:%@",x);
    }];
    [racsub sendNext:@"y"];//无输出
    [racsub sendNext:@"you"];//无输出
    [racsub sendNext:@"you are"];//  ------ value:you are
    [racsub sendNext:@"you are beautiful"];//------ value:you are beautiful
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//信号开关Switch
- (void)signalSwitch {
    //创建3个自定义信号
    RACSubject *google = [RACSubject subject];
    RACSubject *baidu = [RACSubject subject];
    RACSubject *signalOfSignal = [RACSubject subject];
    
    //获取开关信号
    RACSignal *switchSignal = [signalOfSignal switchToLatest];
    
    //对通过开关的信号量进行操作
    [[switchSignal  map:^id(NSString * value) {
        return [@"https//www." stringByAppendingFormat:@"%@", value];
    }] subscribeNext:^(NSString * x) {
        NSLog(@"%@", x);
    }];
    
    
    //通过开关打开baidu
    [signalOfSignal sendNext:baidu];
    [baidu sendNext:@"baidu.com"];// 输出：https//www.baidu.com
    [google sendNext:@"google.com"];//无输出 打开baidu信号时 goole信号被关闭
    
    //通过开关打开google
    [signalOfSignal sendNext:google];
    [baidu sendNext:@"baidu.com"];//无输出 打开goole信号时 baidu信号被关闭
    [google sendNext:@"google.com"];// 输出：https//www.google.com
}

//信号合并 将一组Signal发出的最新的事件合并成一个Signal，每当这组Signal发出新事件时，reduce的block会执行，将所有新事件的值合并成一个值，并当做合并后Signal的事件发出去。这个方法会返回合并后的Signal。
- (void)combindLates
{
    RACSubject *weekday = [RACSubject subject];
    RACSubject *dates = [RACSubject subject];
    
//    [[RACSignal combineLatest:@[weekday,dates] reduce:^id(NSString *weekdayString,NSString *dateString){
//        return [NSString stringWithFormat:@"今天是%@号 %@",dateString,weekdayString];
//    }] subscribeNext:^(NSString * x) {
//        NSLog(@"===== x:%@",x);
//    }];
    
    //用RACTuple捕获信号量 类似于swift里的元组 效果与上述方法一样
    [[RACSignal combineLatest:@[weekday,dates]] subscribeNext:^(RACTuple *x) {
        RACTupleUnpack_(NSString *weekdayString,NSString *dateString) = x;
        NSLog(@"今天是%@号 %@",dateString,weekdayString);
    }];
    
    [weekday sendNext:@"星期一"];//无输出 因为输入信号中dates 始终没有输入
    [weekday sendNext:@"星期二"];//无输出 因为输入信号中dates 始终没有输入
    [dates sendNext:@"12"];//===== x:今天是12号 星期二
    [weekday sendNext:@"星期三"];//===== x:今天是12号 星期三
    [weekday sendNext:@"星期四"];//===== x:今天是12号 星期四
    [dates sendNext:@"13"];//===== x:今天是13号 星期四
}

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kOffsetY 64 + 40


- (void)loadSubviews
{
    _userNameTF = [[UITextField alloc] initWithFrame:CGRectMake(0, kOffsetY, kScreenWidth, 50)];
    _userNameTF.keyboardType = UIKeyboardTypeNumberPad;
    [_userNameTF setBackgroundColor:[UIColor whiteColor]];
    _userNameTF.placeholder = @"请输入11位手机号码";
    [self.view addSubview:_userNameTF];
    
    _passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(0, kOffsetY + 51, kScreenWidth, 50)];
    [_passwordTF setBackgroundColor:[UIColor whiteColor]];
    _passwordTF.placeholder = @"请输入密码";
    [self.view addSubview:_passwordTF];
    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kOffsetY + 120, kScreenWidth, 50)];
    [_loginBtn setBackgroundColor:[UIColor whiteColor]];
    _loginBtn.enabled = NO;
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setBackgroundColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_loginBtn setBackgroundColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_loginBtn];
    
    @weakify(self)
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel login];
    }];
}

-(void)bindViewModel
{
    _viewModel = [[LoginViewModel alloc] init];
    RAC(_viewModel,usrInfo.userName) = _userNameTF.rac_textSignal;
    RAC(_viewModel,usrInfo.password) = _passwordTF.rac_textSignal;
    RAC(_loginBtn,enabled) = [_viewModel isLoginEnable];
    
    @weakify(self)
    [_viewModel.successSub subscribeNext:^(id x) {
        @strongify(self)
        //to do login success
    }];
    
    [_viewModel.failureSub subscribeNext:^(id x) {
        @strongify(self)
        //to do login failure
    }];
    
    [_viewModel.errorSub subscribeNext:^(id x) {
        @strongify(self)
        //to do login error
    }];
}


- (void)finishLogin
{
}


@end

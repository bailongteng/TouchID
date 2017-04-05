//
//  ViewController.m
//  touchID
//
//  Created by 白白龙腾 on 17/2/27.
//  Copyright © 2017年 bailongteng. All rights reserved.
//

#import "ViewController.h"
#import "registerViewController.h"
#import "userMessage.h"
#import "touchViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "KeychainItemWrapper.h"

@interface ViewController ()<touchViewControllerDelegate>//遵守协议
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (nonatomic , strong)UIButton *touchButton;
@end

static BOOL buttonType = YES;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化正文登陆按钮
    self.touchButton = [[UIButton alloc]init];
    self.touchButton.hidden = buttonType;//隐藏按钮
    self.touchButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 50, [UIScreen mainScreen].bounds.size.height / 2 - 50, 100, 44);//位置
    [self.touchButton setTitle:@"指纹登陆" forState:UIControlStateNormal];//标题
    [self.touchButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [self.touchButton addTarget:self action:@selector(touchButtonClick) forControlEvents:UIControlEventTouchUpInside];//按钮监听的方法
    [self.view addSubview:self.touchButton];
}


//实现代理方法
-(void)testViewController:(touchViewController *)testViewController withButtonType:(BOOL)type{
    buttonType = type;
    
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        if (type) {//touch开启
            self.touchButton.hidden = NO;//显示按钮
        }else{//touch关闭
            self.touchButton.hidden = YES;//隐藏按钮
        }

        [self.touchButton setNeedsDisplay];
    });
}

//忘记密码按钮点击
- (IBAction)forgetPassWordButtonClick:(id)sender {
}

//登陆按钮点击
- (IBAction)enterButtonClick:(UIButton *)sender {
    
    // temp路径
    NSString* tempPath = NSTemporaryDirectory();
    // file路径
    NSString* filePath = [tempPath stringByAppendingPathComponent:@"userMessage.data"];
    // 解档
    userMessage *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    //判断用户名和密码是不是正确
    if ([self.userNameTextField.text isEqualToString:user.name] && [self.passWordTextField.text isEqualToString:user.passWord]) {
        
        touchViewController* vc = [[touchViewController alloc]init];
        vc.redUserName = user.name;//获取用户名
        vc.redPassWord = user.passWord;//获取密码
        vc.delegate = self;//设置代理
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {//错误提示
        [self presentAlertWithTiele:@"提示" message:@"账户或密码错误"];
    }
}

///*
//
// typedef NS_ENUM(NSInteger, LAError)
// {
// //授权失败
// LAErrorAuthenticationFailed = kLAErrorAuthenticationFailed,
//
// //用户取消Touch ID授权
// LAErrorUserCancel           = kLAErrorUserCancel,
//
// //用户选择输入密码
// LAErrorUserFallback         = kLAErrorUserFallback,
//
// //系统取消授权(例如其他APP切入)
// LAErrorSystemCancel         = kLAErrorSystemCancel,
//
// //系统未设置密码
// LAErrorPasscodeNotSet       = kLAErrorPasscodeNotSet,
//
// //设备Touch ID不可用，例如未打开
// LAErrorTouchIDNotAvailable  = kLAErrorTouchIDNotAvailable,
//
// //设备Touch ID不可用，用户未录入
// LAErrorTouchIDNotEnrolled   = kLAErrorTouchIDNotEnrolled,
//
// //用户多次连续使用Touch ID失败，Touch ID被锁，需要用户输入密码解锁，这个错误的交互
// LAErrorTouchIDLockout   NS_ENUM_AVAILABLE(10_11, 9_0) = kLAErrorTouchIDLockout,
//
// //当前软件被挂起取消了授权，但是前者是用户不能控制的挂起，例如突然来了电话，电话应用进入前台，APP被挂起。后者是用户自己切到了别的应用，例如按home键挂起。
// LAErrorAppCancel        NS_ENUM_AVAILABLE(10_11, 9_0) = kLAErrorAppCancel,
//
// //就是授权过程中,LAContext对象被释放掉了，造成的授权失败
// LAErrorInvalidContext   NS_ENUM_AVAILABLE(10_11, 9_0) = kLAErrorInvalidContext
//
// } NS_ENUM_AVAILABLE(10_10, 8_0);
//
//
// */
//
/**
 指纹识别按钮点击
 */
- (void)touchButtonClick {
    
    // 判断用户手机系统是否是 iOS 8.0 以上版本
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        return;
    }
    LAContext *context = [[LAContext alloc]init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        //使用context对象对识别的情况进行评估
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"验证touchID" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"操作失败");
            }
            //识别成功:
            if (success) {
                //这里写登录成功的方法，在这里可以调用keychin,获取账号密码
                KeychainItemWrapper *keyWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Keychain" accessGroup:nil];
                
                NSString *passwordStr = [keyWrapper objectForKey:(id)kSecValueData];//获取指纹保存的密码
                NSString *userName = [keyWrapper objectForKey:(id)kSecAttrAccount];//获取用户名
                
                // temp路径
                NSString* tempPath = NSTemporaryDirectory();
                // file路径
                NSString* filePath = [tempPath stringByAppendingPathComponent:@"userMessage.data"];
                
                // 解档
                userMessage *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
                
                if ([userName isEqualToString:user.name] && [passwordStr isEqualToString:user.passWord]) {
                    
                    dispatch_after(0.2, dispatch_get_main_queue(), ^{
                        //跳转
                        touchViewController *vc = [[touchViewController alloc]init];
                        vc.delegate = self;//设置代理
                        
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    
                }else {//如果账户名或密码不正确弹出提示框
                    [self presentAlertWithTiele:@"提示" message:@"用户名或密码不正确"];
                }
            }else {//弹出验证失败提示框
                NSLog(@"验证失败");
                [self presentAlertWithTiele:@"提示" message:@"绑定失败"];
            }
        }];
        
    }else{//设备不支持指纹识别
        NSLog(@"该设备不支持指纹识别");
        [self presentAlertWithTiele:@"提示" message:@"该设备不支持指纹识别"];
    }
}

/**
 创建aler控制器公共方法

 @param titleString 标题名
 @param messageString 提示信息
 */
- (void)presentAlertWithTiele:(NSString *)titleString message:(NSString *)messageString {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleString message:messageString preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end

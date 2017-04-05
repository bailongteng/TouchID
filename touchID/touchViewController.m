//
//  touchViewController.m
//  touchID
//
//  Created by 白白龙腾 on 17/3/31.
//  Copyright © 2017年 bailongteng. All rights reserved.
//

#import "touchViewController.h"
#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Security/Security.h>
#import "KeychainItemWrapper.h"

static BOOL switchType = NO;//全局开关状态

@interface touchViewController ()
@property (nonatomic , strong)UISwitch *touchSwitch;//全局开关
@end

@implementation touchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //登录界面简单布局
    UILabel *touchLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 100, 120, 44)];
    touchLabel.text = @"开启指纹登陆";
    [self.view addSubview:touchLabel];
    
    //开关按钮
    self.touchSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(200, 110, 100, 44)];
    [self.touchSwitch setOn:switchType];//设置按钮为关闭状态
    [self.touchSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];   // 开关事件切换通知
    [self.view addSubview: self.touchSwitch];
    
    //退出登陆按钮
    UIButton *outButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x - 60, self.view.center.y, 120, 44)];
    [outButton setTitle:@"退出登陆" forState:UIControlStateNormal];
    [outButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [outButton addTarget:self action:@selector(outButtonClick:) forControlEvents:UIControlEventTouchUpInside];//设置按钮点击事件
    [self.view addSubview:outButton];
}

//switch按钮点击
- (void)switchAction:(UISwitch *)sender {
    
    BOOL isButtonOn = [sender isOn];//获得按钮状态
    if (isButtonOn) {//开启
        NSLog(@"开");
        LAContext *context = [[LAContext alloc]init];
        NSError *error = nil;
        //if条件判断设备是否支持TouchID 是否开启Touch id等这个一定要写上
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {//
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                    localizedReason:@"验证touchID"
                              reply:^(BOOL success, NSError *error) {
                                  
                                  if (error) {
                                      NSLog(@"操作失败");
                                  }
                                  
                                  if (success) {
                                      NSLog(@"验证成功");
                                      //验证成功 获取当前账户的账号和密码
                                      //保存在keychain也就是钥匙串中
                                      //初始化一个保存用户帐号的KeychainItemWrapper
                                      KeychainItemWrapper *keychain=[[KeychainItemWrapper alloc] initWithIdentifier:@"Keychain" accessGroup:nil];
                                      [keychain setObject:@"myChainValues" forKey:(id)kSecAttrService];
                                      //保存账号和密码
                                      [keychain setObject:_redUserName forKey:(id)kSecAttrAccount];
                                      
                                      [keychain setObject:_redPassWord forKey:(id)kSecValueData];
                                      //if(成功) {
                                      
                                      //         弹出提示@"绑定成功" 并且把按钮的文字设为@"开启" }
                                      // else (失败) {
                                      
                                      //         弹出提示@"绑定失败"
                                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"绑定成功" preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      // 添加按钮
                                      [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                                          
                                          NSLog(@"点击了确定按钮");
                                      }]];
                                      
                                          switchType = YES;
                                          //执行代理方法
                                          if ([self.delegate respondsToSelector:@selector(testViewController:withButtonType:)]) {
                                              [self.delegate testViewController:self withButtonType:switchType];
                                          }
                                          
                                          [self presentViewController:alert animated:YES completion:nil];
                                      
                                  } else {
                                      NSLog(@"验证失败");
                                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"绑定失败" preferredStyle:UIAlertControllerStyleAlert];
                                      
                                      // 添加按钮
                                      [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                                          NSLog(@"点击了确定按钮");
                                          [self.touchSwitch setOn:NO animated:YES];//绑定失败更改开关状态
                                      }]];
                                      
                                      switchType = NO;
                                      //执行代理方法
                                      if ([self.delegate respondsToSelector:@selector(testViewController:withButtonType:)]) {
                                          [self.delegate testViewController:self withButtonType:switchType];
                                      }
                                      
                                      [self presentViewController:alert animated:YES completion:nil];
                                  }
                              }];
        } else {
            NSLog(@"设备不支持");
        }
    }else {//关闭
        NSLog(@"关");
        //执行代理方法
        
        dispatch_async(dispatch_queue_create(0, 0), ^{
            //执行代理方法
            if ([self.delegate respondsToSelector:@selector(testViewController:withButtonType:)]) {
                switchType = NO;
                [self.delegate testViewController:self withButtonType:switchType];
            }
        });
    }
}

//退出按钮点击
- (void)outButtonClick:(id)sender {
    //跳转到保存有账号用户名的界面 并且判断指纹登陆按钮开关的状态
    //如果开启跳转到可以指纹登陆的界面(界面上可选密码登陆按钮  指纹登陆按钮)
    //如果关闭跳转到只能密码登陆的界面(只有密码登陆,并且可以输入密码)
    dispatch_after(0.2, dispatch_get_main_queue(), ^{
        [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
    });
}

@end

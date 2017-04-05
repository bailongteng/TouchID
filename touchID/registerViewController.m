//
//  registerViewController.m
//  touchID
//
//  Created by 白白龙腾 on 17/2/28.
//  Copyright © 2017年 bailongteng. All rights reserved.
//

#import "registerViewController.h"
#import "userMessage.h"

@interface registerViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//注册完成按钮点击
- (IBAction)saveUserMessageButtonClick:(id)sender {
    userMessage *user = [[userMessage alloc] init];
    
    user.name = self.userNameTextField.text;//获取用户名
    user.passWord = self.passwordTextField.text;//获取密码
    // temp路径
    NSString* tempPath = NSTemporaryDirectory();
    // file路径
    NSString* filePath = [tempPath stringByAppendingPathComponent:@"userMessage.data"];
    
    // RootObject 保存什么对象
    [NSKeyedArchiver archiveRootObject:user toFile:filePath]; //归档保存
    
    [self.navigationController popToRootViewControllerAnimated:YES];//注册完成返回登录界面
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

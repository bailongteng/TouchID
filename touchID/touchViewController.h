//
//  touchViewController.h
//  touchID
//
//  Created by 白白龙腾 on 17/3/31.
//  Copyright © 2017年 bailongteng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class touchViewController;
//定义协议
@protocol  touchViewControllerDelegate<NSObject>
// 协议中的代理方法
// 协议中的代理方法
@optional
- (void)testViewController:(touchViewController*)testViewController withButtonType:(BOOL)type;
@end

@interface touchViewController : UIViewController
@property (nonatomic , strong)NSString *redUserName;//用户名
@property (nonatomic , strong)NSString *redPassWord;//密码
@property(nonatomic,weak)id<touchViewControllerDelegate> delegate;//代理对象
@end

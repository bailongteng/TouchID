//
//  userMessage.h
//  touchID
//
//  Created by 白白龙腾 on 17/2/28.
//  Copyright © 2017年 bailongteng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userMessage : NSObject<NSCoding>
@property (nonatomic, copy) NSString* name;//用户名
@property (nonatomic, copy) NSString* passWord;//密码
@end

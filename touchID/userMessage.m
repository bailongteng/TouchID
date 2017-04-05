//
//  userMessage.m
//  touchID
//
//  Created by 白白龙腾 on 17/2/28.
//  Copyright © 2017年 bailongteng. All rights reserved.
//

#import "userMessage.h"

@implementation userMessage

// 归档
- (void)encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_passWord forKey:@"passWord"];
}

// 解档
- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:@"name"];
        _passWord = [coder decodeObjectForKey:@"passWord"];
    }
    return self;
}


@end

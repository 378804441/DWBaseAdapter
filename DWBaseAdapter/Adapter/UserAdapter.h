//
//  UserAdapter.h
//  适配器模式
//
//  Created by 丁 on 2018/3/20.
//  Copyright © 2018年 丁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWBaseTableAdapter.h"

typedef NS_ENUM(NSInteger, UserModelEnum){
    textType = 0,
    nameType
};

@interface UserAdapter : DWBaseTableAdapter

@end

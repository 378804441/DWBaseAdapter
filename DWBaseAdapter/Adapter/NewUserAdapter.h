//
//  NewUserAdapter.h
//  适配器模式
//
//  Created by 丁 on 2018/3/21.
//  Copyright © 2018年 丁. All rights reserved.
//

#import "DWBaseTableAdapter.h"

typedef NS_ENUM(NSInteger, NewUserModelEnum){
    NewTextType = 0,
    NewNameType
};

@interface NewUserAdapter : DWBaseTableAdapter

@end

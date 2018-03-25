//
//  DWBaseTableViewCell.m
//  DWBaseAdapter
//
//  Created by 丁 on 2018/3/22.
//  Copyright © 2018年 丁巍. All rights reserved.
//

#import "DWBaseTableViewCell.h"
#import <objc/runtime.h>

@implementation DWBaseTableViewCell


/** 获取cell高度 */
-(float)getAutoCellHeight{
    
    /**   动态指定cell 高度时候 需要如下使用
          [self layoutIfNeeded];
     *    self.最底部的控件.frame.origin.y      为自适应cell中的最后一个控件的Y坐标
     *    self.最底部的空间.frame.size.height   为自适应cell中的最后一个控件的高
     *    marginHeight    为自适应cell中的最后一个控件的距离cell底部的间隙
     
     *    return  self.collectionV.frame.origin.y + self.collectionV.frame.size.height;
     */
    
    return 44;
}

@end

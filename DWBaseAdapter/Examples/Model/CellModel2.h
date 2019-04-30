//
//  CellModel2.h
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/4/29.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GDiffObjectProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CellModel2 : NSObject<GDiffObjectProtocol>

@property (nonatomic, copy  ) NSString *title;

@property (nonatomic, assign) CGFloat   height;

@end

NS_ASSUME_NONNULL_END

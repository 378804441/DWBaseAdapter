//
//  ViewAdapterTypeCell4.h
//  DWBaseAdapter
//
//  Created by 丁巍 on 2019/3/28.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWBaseCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ViewAdapterTypeCell4Delegate <NSObject>
@optional
-(void)cell4_clickDelegate;
@end

@interface ViewAdapterTypeCell4 : UITableViewCell<DWBaseCellProtocol>

@property(nonatomic, weak) id<ViewAdapterTypeCell4Delegate> myDelegate;

@end

NS_ASSUME_NONNULL_END

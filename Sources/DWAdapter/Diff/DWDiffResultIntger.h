//
//  DWDiffResultIntger.h
//  GDiffExample
//
//  Created by 丁巍 on 2019/4/13.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DWDiffResultIntger : NSObject

@property (nonatomic, assign, readonly) NSInteger index;

@property (nonatomic, assign, readonly) NSInteger section;

-(void)initResultIntgerWithIndex:(NSInteger)index section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END

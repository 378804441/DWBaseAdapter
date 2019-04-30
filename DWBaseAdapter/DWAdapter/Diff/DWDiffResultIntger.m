//
//  DWDiffResultIntger.m
//  GDiffExample
//
//  Created by 丁巍 on 2019/4/13.
//  Copyright © 2019 GIKI. All rights reserved.
//

#import "DWDiffResultIntger.h"

@interface DWDiffResultIntger()

@property (nonatomic, assign, readwrite) NSInteger index;

@property (nonatomic, assign, readwrite) NSInteger section;

@end

@implementation DWDiffResultIntger

-(void)initResultIntgerWithIndex:(NSInteger)index section:(NSInteger)section{
    self.index   = index;
    self.section = section;
}

@end

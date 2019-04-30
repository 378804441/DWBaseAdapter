//
//  GDiffCore.h
//  GDiffExample
//
//  Created by GIKI on 2018/3/11.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DWIndexManager.h"


typedef NS_ENUM(NSUInteger, GDiffOption) {
    /**
     Compare objects using pointer personality.
     */
    GDiffOptionPointerPersonality,
    /**
     Compare objects using -[NSObject isEqual:].
     */
    GDiffOptionEquality
};

@interface GDiffCore : NSObject

- (DWIndexManager *)diff:(NSArray*)oldArray newArray:(NSArray*)newArray;

@end

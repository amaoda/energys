//
//  RootPageModel.m
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/24.
//  Copyright © 2016年 23444. All rights reserved.
//

#import "RootPageModel.h"


@implementation RootPageModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _myid = [NSString stringWithFormat:@"%@",value];
    }
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}


@end

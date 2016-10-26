//
//  RootPageModel.h
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/24.
//  Copyright © 2016年 23444. All rights reserved.
//

#import <Foundation/Foundation.h>

//[0]	(null)	@"distance" : (no summary)
//[1]	(null)	@"id" : (long)57
//[2]	(null)	@"experience" : @"1 element"
//[3]	(null)	@"name" : @"青涛跆拳道俱乐部（盛岸店）"
//[4]	(null)	@"image" : @"http://7u2h3s.com2.z0.glb.qiniucdn.com/club_multi_555af55f39813"
//[5]	(null)	@"address" : @"无锡市北塘区盛岸西路会岸路5号白金汉爵酒店对面"

@interface RootPageModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *myid;
@property (nonatomic, strong) NSString *experience;
@property (nonatomic, strong) NSString *distance;


@end

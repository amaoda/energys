//
//  Request_AFNetWorking.h
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/19.
//  Copyright © 2016年 23444. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Finish)(NSDictionary *dataDic);
typedef void (^Error)(NSError *requestError);
typedef NS_ENUM(NSInteger, RequestType) {
    GET,
    POST
};

@interface Request_AFNetWorking : NSObject

+ (void)requestWithUrlString:(NSString *)urlString parDic:(NSDictionary *)parDic method:(RequestType )method finish:(Finish)finish error:(Error)requestError;

@end

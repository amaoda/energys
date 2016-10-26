//
//  Request_AFNetWorking.m
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/19.
//  Copyright © 2016年 23444. All rights reserved.
//

#import "Request_AFNetWorking.h"

@implementation Request_AFNetWorking

// 普通请求
+ (void)requestWithUrlString:(NSString *)urlString parDic:(NSDictionary *)parDic method:(RequestType )method finish:(Finish)finish error:(Error)requestError {
    
    if (method == POST) {
        urlString = [NSString stringWithFormat:@"%@%@",REQUEST_SERVER,urlString];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 15.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        [manager POST:urlString parameters:parDic progress:^(NSProgress * _Nonnull uploadProgress) {
            // 请求进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
            finish(dic);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            requestError(error);
        }];
        
    } else{
        // Get请求
        urlString = [NSString stringWithFormat:@"%@%@",REQUEST_SERVER,urlString];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
                 finish(dic);
             }
         
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                 
                 requestError(error);
                 
             }];
    }
}

@end

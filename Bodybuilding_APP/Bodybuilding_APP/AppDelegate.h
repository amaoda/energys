//
//  AppDelegate.h
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/13.
//  Copyright © 2016年 23444. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


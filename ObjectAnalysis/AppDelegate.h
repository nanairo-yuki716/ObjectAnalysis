//
//  AppDelegate.h
//  ObjectAnalysis
//
//  Created by kubo on 2017/11/03.
//  Copyright © 2017年 kubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


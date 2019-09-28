//
//  NSBundle+debugClassInfo.h
//  xxx
//
//  Created by xxx on 9/21/19.
//  Copyright © 2019 xxx. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (debugClassInfo)

/**
 获取当前工程下自己创建的所有类

 @return 数组
 */
+ (NSArray <Class> *)nt_bundleOwnClassesInfo;

/**
 获取当前工程下所有类（含系统类、cocoPods类）
 
 @return 数组
 */
+ (NSArray <NSString *> *)nt_bundleAllClassesInfo;


// 通过类名获取类的方法列表，打印方法名
+ (NSArray <NSString *> *)nt_classMethodList:(NSString *)className;


// 通过类名获取类属性列表，并打印属性名
+ (NSArray <NSString *> *)nt_classPropertyList:(NSString *)className;

// 通过ivar指针获取成员变量列表
+ (NSArray <NSString *> *)nt_classIvarsList:(NSString *)className;

@end

NS_ASSUME_NONNULL_END

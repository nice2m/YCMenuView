//
//  NSBundle+debugClassInfo.m
//  xxx
//
//  Created by xxx on 9/21/19.
//  Copyright © 2019 xxx. All rights reserved.
//

#import "NSBundle+debugClassInfo.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>


@implementation NSBundle (debugClassInfo)

+ (NSArray <Class> *)nt_bundleOwnClassesInfo {
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    unsigned int classCount;
    const char **classes;
    Dl_info info;
    
    dladdr(&_mh_execute_header, &info);
    classes = objc_copyClassNamesForImage(info.dli_fname, &classCount);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_apply(classCount, dispatch_get_global_queue(0, 0), ^(size_t index) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSString *className = [NSString stringWithCString:classes[index] encoding:NSUTF8StringEncoding];
        Class class = NSClassFromString(className);
        [resultArray addObject:class];
        dispatch_semaphore_signal(semaphore);
    });
    
    return resultArray.mutableCopy;
}

+ (NSArray <NSString *> *)nt_bundleAllClassesInfo {
    
    NSMutableArray *resultArray = [NSMutableArray new];

    int classCount = objc_getClassList(NULL, 0);

    Class *classes = NULL;
    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) *classCount);
    classCount = objc_getClassList(classes, classCount);

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_apply(classCount, dispatch_get_global_queue(0, 0), ^(size_t index) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        Class class = classes[index];
        NSString *className = [[NSString alloc] initWithUTF8String: class_getName(class)];
        [resultArray addObject:className];
        dispatch_semaphore_signal(semaphore);
    });

    free(classes);
    
    return resultArray.mutableCopy;
}

+ (NSArray <NSString *> *)nt_classMethodList:(NSString *)className
{
    NSMutableArray * rtArr = [NSMutableArray array];
    u_int count;
    Method* methods = class_copyMethodList(NSClassFromString(className), &count);
    for (int i = 0; i < count; i ++) {
        SEL name = method_getName(methods[i]);
        NSString* strName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
//        NSLog(@"method: %@",strName);
        [rtArr addObject:strName];
    }
    return rtArr;
}

+ (NSArray <NSString *> *)nt_classPropertyList:(NSString *)className
{
    NSMutableArray * rtArr = [NSMutableArray array];

    u_int count;
    objc_property_t* pList = class_copyPropertyList(NSClassFromString(className), &count);
    for (int i = 0; i < count; i ++) {
        const char* name = property_getName(pList[i]);
        NSString* strName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
//        NSLog(@"preperty: %@",strName);
        [rtArr addObject:strName];
    }
    return rtArr;

}

+ (NSArray <NSString *> *)nt_classIvarsList:(NSString *)className
{
    NSMutableArray * rtArr = [NSMutableArray array];
    u_int count;
    Ivar* ivars = class_copyIvarList(NSClassFromString(className), &count);
    for (const Ivar*p = ivars; p < ivars+count; ++p) {
        Ivar const ivar = *p;
        NSString* name = [NSString stringWithUTF8String:ivar_getName(ivar)];
//        NSLog(@"name: %@",name);
        [rtArr addObject:name];

    }
    return rtArr;
}
                                                    
@end


//
//  ApplicationDelegate.m
//  IPAPatch
//
//  Created by Harlans on 2024/9/11.
//  Copyright © 2024 Weibo. All rights reserved.
//

#import "ApplicationDelegate.h"
#import <objc/runtime.h>

@implementation ApplicationDelegate

+ (void)load
{
    [self getApplicationDelegate];
}

+ (id)getApplicationDelegate
{
    int numClasses = objc_getClassList(NULL, 0);
    Class* list = (Class*)malloc(sizeof(Class) * numClasses);
    objc_getClassList(list, numClasses);
    for (int i = 0; i < numClasses; i++)
    {
        if (class_conformsToProtocol(list[i], @protocol(UIApplicationDelegate)))
        {
            NSLog(@"clas %@", list[i]);
            return list[i];
        }
    }
    return nil;
}

@end

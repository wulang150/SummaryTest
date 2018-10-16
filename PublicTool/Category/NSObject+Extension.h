//
//  NSObject+Extension.h
//  XHRuntimeDemo
//
//  Created by craneteng on 16/4/18.
//  Copyright © 2016年 XHTeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

//文档归并
//归并忽略的名称
- (NSArray *)ignoredNames;
- (void)encode:(NSCoder *)aCoder;
- (void)decode:(NSCoder *)aDecoder;

//字典转模型
- (void)setDict:(NSDictionary *)dict;
//直接调用，返回model
+ (instancetype )objectWithDict:(NSDictionary *)dict;
// 告诉数组中都是什么类型的模型对象，如果model有数组，并且数组里面包含另一个model，就得返回这model名称
- (NSString *)arrayObjectClass;

//输出string
- (NSString *)show;
@end

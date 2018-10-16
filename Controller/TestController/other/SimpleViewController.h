//
//  SimpleViewController.h
//  SummaryTest
//
//  Created by  Tmac on 2018/1/30.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Student : NSObject
{
    NSString  *_age;        //实例变量
}
//- (void)setAge:(NSString *)age;
//- (NSString *)age;

@property (nonatomic, strong) NSString  *name;
@end

@interface SimpleViewController : BaseController

@end

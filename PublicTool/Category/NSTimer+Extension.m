//
//  NSTimer+Extension.m
//  Runner
//
//  Created by  Tmac on 16/3/9.
//  Copyright © 2016年 Janson. All rights reserved.
//

#import "NSTimer+Extension.h"

@implementation NSTimer (TFAddition)


-(void)pauseTimer{
    
    if (![self isValid]) {
        return;
    }
    
    [self setFireDate:[NSDate distantFuture]]; //如果给我一个期限，我希望是4001-01-01 00:00:00 +0000
    
    
}


-(void)resumeTimer{
    
    if (![self isValid]) {
        return;
    }
    
    //[self setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    [self setFireDate:[NSDate date]];
    
}

@end

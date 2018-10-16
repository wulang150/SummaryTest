//
//  myButton.m
//  SummaryTest
//
//  Created by  Tmac on 2017/12/4.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "myButton.h"

@implementation myButton


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__FUNCTION__);
    [super touchesBegan:touches withEvent:event];
    [[super superview] touchesBegan:touches withEvent:event];
    
}
@end

//
//  NSMutableData+Extension.h
//  SimpleTest
//
//  Created by  Tmac on 17/3/24.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData (Extension)

//    unsigned char a1 = 255;
//    unsigned short a2 = 16;
//    unsigned int a3 = 32;
//
//    NSArray *arr = @[@"1",@"1",@"0",@"1",@"0",@"1"];   //对于位的操作，使用数组
//
//    NSArray *valueArr = @[arr,
//                          [NSNumber numberWithShort:a2],
//                          [NSNumber numberWithInt:a3],
//                          @"aaaaaaa",
//                          [NSNumber numberWithChar:a1]];
//    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:20];
//
//    [data appendStructWithSizes:@[@"1",@"2",@"4",@"7",@"1"] values:valueArr];
//
//    NSLog(@"data = %@",data);
//数据的拼接
- (void)appendStructWithSizes:(NSArray *)sizeArr values:(NSArray *)values;
@end

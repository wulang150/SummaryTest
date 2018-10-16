//
//  NSMutableData+Extension.m
//  SimpleTest
//
//  Created by  Tmac on 17/3/24.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "NSMutableData+Extension.h"

@implementation NSMutableData (Extension)

- (void)appendStructWithSizes:(NSArray *)sizeArr values:(NSArray *)values
{
    if(sizeArr.count!=values.count)
        return;
    
    for(int i=0;i<sizeArr.count;i++)
    {
        int size = [sizeArr[i] intValue];
        
        [self addNum:size value:values[i]];
    }
    
}

- (void)addNum:(int)size value:(id)value
{
    if([value isKindOfClass:[NSNumber class]])
    {
        NSNumber *num = (NSNumber *)value;
        
        NSLog(@"type = %s",[num objCType]);
        if(strcmp([num objCType], @encode(float)) == 0)
        {
            NSLog(@"real = float");
            float v = [num floatValue];
            [self appendBytes:&v length:size];
        }
        else if(strcmp([num objCType], @encode(double)) == 0)
        {
            NSLog(@"real = double");
            double v = [num doubleValue];
            [self appendBytes:&v length:size];
        }
        else
        {
            long v = [num longValue];
            [self appendBytes:&v length:size];
        }
//        else if(strcmp([num objCType], @encode(double)) == 0)
//        {
//            NSLog(@"real = double");
//        }
//        else if(strcmp([num objCType], @encode(int)) == 0)
//        {
//            NSLog(@"real = int %d",[num intValue]);
//        }
//        else if(strcmp([num objCType], @encode(char)) == 0)
//        {
//            NSLog(@"real = char %c",[num charValue]);
//        }
//        else if(strcmp([num objCType], @encode(short)) == 0)
//        {
//            NSLog(@"real = short %d",[num shortValue]);
//        }
//        else if(strcmp([num objCType], @encode(double)) == 0)
//        {
//            NSLog(@"real = double");
//        }
//        else if(strcmp([num objCType], @encode(long)) == 0)
//        {
//            NSLog(@"real = long %ld",[num longValue]);
//        }
//        else if(strcmp([num objCType], @encode(long long)) == 0)
//        {
//            NSLog(@"real = long long");
//        }
//        switch (size) {
//            case sizeof(char):
//            {
//                unsigned char v = [num unsignedCharValue];
//                [self appendBytes:&v length:size];
//                break;
//            }
//            case sizeof(short):
//            {
//                unsigned short v = [num unsignedCharValue];
//                [self appendBytes:&v length:size];
//                break;
//            }
//            case sizeof(int):
//            {
//                unsigned int v = [num unsignedCharValue];
//                [self appendBytes:&v length:size];
//                break;
//            }
//            case sizeof(long):
//            {
//                unsigned long v = [num unsignedCharValue];
//                [self appendBytes:&v length:size];
//                break;
//            }
//            default:
//                break;
//        }
    }
    
    if([value isKindOfClass:[NSString class]])
    {
        value = (NSString *)value;
//        unsigned char *avec = (unsigned char *)[value UTF8String];
        char *avec = (char *)malloc(size);
        memset(avec, 0, size);
        long len = [value length];
        memcpy(avec, [value UTF8String], len);
        [self appendBytes:avec length:size];
        free(avec);
//        Byte b = 0x00;
//        [self appendBytes:&b length:1];
    }
    
    if([value isKindOfClass:[NSData class]])
    {
        [self appendData:value];
    }
    
    if([value isKindOfClass:[NSArray class]])
    {
        NSArray *arr = (NSArray *)value;
        int a = 0;
        long len = MIN(arr.count,size*8);    //位
        len = MIN(sizeof(a)* 8, len);
        long num = len;
        for(int i = 0;i<num;i++)
        {
            if(i>=arr.count)
                break;
            int v = [[arr objectAtIndex:i] intValue];
            
            a |= v<<--len;
        }
        
        [self appendBytes:&a length:size];
    }
    
}
@end

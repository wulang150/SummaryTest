//
//  NSString+Extension.m
//  ProBand
//
//  Created by star.zxc on 15/11/17.
//  Copyright © 2015年 DONGWANG. All rights reserved.
//

#import "NSString+Extension.h"
#import "NSString+EMOEmoji.h"

//正则表达式
#define STR_EMAIL_REGEX @"^((http://)|(https://))?([A-Za-z0-9]+\\.)*[A-Za-z0-9]+@[A-Za-z0-9]+\\.[A-Za-z]{2,6}$"
#define STR_PHONE_REGEX @"^(13|14|15|17|18)\\d{9}$"
#define STR_CAPCHANUM_REGEX @"\\d{5}"
#define STR_PASSWORD_REGEX @"^[0-9a-zA-Z_]{4,20}$"
#define STR_HOMENUM_REGEX @"^((\\+86(\\s|\\-)\\d{3,4}(\\s|\\-))|(\\d{3,4}(\\s|\\-)))?\\d{5,9}$"
#define STR_WECHAT_REGEX @"^((\\+86(\\s|\\-))?1\\d{10})|([A-Za-z0-9]+)|(((http://)|(https://))?([A-Za-z0-9]+\\.)*[A-Za-z0-9]+@[A-Za-z0-9]+\\.[A-Za-z]{2,6})|(\\d{5,11})$"
#define STR_WEB_REGEX @"^(((http)|(https))://)?([A-Za-z0-9]+\\.)+[A-Za-z0-9]{2,6}$"
#define STR_QQ_REGEX @"^\\d{5,11}$"
#define STR_WEIBO_REGEX @"^([A-Za-z0-9]+)|((\\+86(\\s|\\-))?1\\d{10})|(((http://)|(https://))?([A-Za-z0-9]+\\.)*[A-Za-z0-9]+@[A-Za-z0-9]+\\.[A-Za-z]{2,6})$"

@implementation NSString (Extension)

- (BOOL)containAnotherString:(NSString *)anotherString
{
    if (anotherString == nil) {
        return NO;
    }
    if ([self rangeOfString:anotherString].location != NSNotFound)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//判断是否含有标签符号
- (BOOL)stringContainsEmoji
{
//    __block BOOL returnValue = NO;
//    
//    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
//                               options:NSStringEnumerationByComposedCharacterSequences
//                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//                                const unichar hs = [substring characterAtIndex:0];
//                                if (0xd800 <= hs && hs <= 0xdbff) {
//                                    if (substring.length > 1) {
//                                        const unichar ls = [substring characterAtIndex:1];
//                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
//                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
//                                            returnValue = YES;
//                                        }
//                                    }
//                                } else if (substring.length > 1) {
//                                    const unichar ls = [substring characterAtIndex:1];
//                                    if (ls == 0x20e3) {
//                                        returnValue = YES;
//                                    }
//                                } else {
//                                    if (0x2100 <= hs && hs <= 0x27ff) {
//                                        returnValue = YES;
//                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
//                                        returnValue = YES;
//                                    } else if (0x2934 <= hs && hs <= 0x2935) {
//                                        returnValue = YES;
//                                    } else if (0x3297 <= hs && hs <= 0x3299) {
//                                        returnValue = YES;
//                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
//                                        returnValue = YES;
//                                    }
//                                }
//                            }];
//    
//    return returnValue;
    
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (NSString *)substringToLength:(NSUInteger)length
{
    NSInteger existTextNum = self.length;
    
    
    if (existTextNum > length&&length>0)
    {
//        NSString *s = [self substringToIndex:length];
//        
//        NSString *tmp = [self substringWithRange:NSMakeRange(length-1, 2)];
//        if([tmp stringContainsEmoji])  //如果最后一个是表情符号
//        {
//            s = [self substringToIndex:length-1];
//        }
//        
//        return s;
        
        NSRange rangeIndex = [self rangeOfComposedCharacterSequenceAtIndex:length];
        return [self substringToIndex:(rangeIndex.location)];
    }
    
    return self;
}

- (NSString *)newfilterEmoji
{
    NSString *nsTextContent = self;
    NSArray *emojiRangeArr = [nsTextContent emo_emojiRanges];

    //只要一识别到输入的有表情,就把它替换掉

    if (emojiRangeArr.count == 1)
    {
        for (NSValue *rangeValue in emojiRangeArr)
        {
            NSRange range = [rangeValue rangeValue];
            nsTextContent = [nsTextContent stringByReplacingCharactersInRange:range withString:@""];
        }
    }
    else if (emojiRangeArr.count > 1)//粘贴的情况下
    {
        NSInteger length = 0;
        for (NSInteger i = 0; i < emojiRangeArr.count; i ++)
        {
            NSRange range = [emojiRangeArr[i] rangeValue];
            if (i > 0)
            {
                range = NSMakeRange(range.location - length, range.length);
            }
            length += range.length;

            nsTextContent = [nsTextContent stringByReplacingCharactersInRange:range withString:@""];

        }
    }
    
    return nsTextContent;
}

- (NSString *)filterEmoji
{
    NSUInteger len = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [self UTF8String];
    char *newUTF8 = malloc( sizeof(char) * len );
    int j = 0;
    
    //0xF0(4) 0xE2(3) 0xE3(3) 0xC2(2) 0x30---0x39(4)
    for ( int i = 0; i < len; i++ ) {
        unsigned int c = utf8[i];
        BOOL isControlChar = NO;
        if ( c == 4294967280 ||
            c == 4294967089 ||
            c == 4294967090 ||
            c == 4294967091 ||
            c == 4294967092 ||
            c == 4294967093 ||
            c == 4294967094 ||
            c == 4294967095 ||
            c == 4294967096 ||
            c == 4294967097 ||
            c == 4294967088 ) {
            i = i + 3;
            isControlChar = YES;
        }
        if ( c == 4294967266 || c == 4294967267 ) {
            i = i + 2;
            isControlChar = YES;
        }
        if ( c == 4294967234 ) {
            i = i + 1;
            isControlChar = YES;
        }
        if ( !isControlChar ) {
            newUTF8[j] = utf8[i];
            j++;
        }
    }
    newUTF8[j] = '\0';
    NSString *encrypted = [NSString stringWithCString:(const char*)newUTF8
                                             encoding:NSUTF8StringEncoding];
    free(newUTF8);

    return encrypted;
}

-(NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

- (NSString *)filterNoNum
{
    NSMutableString *mulStr = [[NSMutableString alloc] initWithCapacity:20];
    for(int i=0;i<self.length;i++)
    {
        char a = [self characterAtIndex:i];
        if(a>='0'&&a<='9')
            [mulStr appendFormat:@"%c",a];
    }
    
    return mulStr;
}

- (NSString *)URLDecodedString
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

- (NSString *)trimLeftAndRight
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(BOOL) isValidEmail
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_EMAIL_REGEX];
    return [rexTest evaluateWithObject:self];
}
-(BOOL) isValidPhoneNumber
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_PHONE_REGEX];
    return [rexTest evaluateWithObject:self];
}
-(BOOL) isValidHomeNumber
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_HOMENUM_REGEX];
    return [rexTest evaluateWithObject:self];
}
-(BOOL) isValidWeChat
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_WECHAT_REGEX];
    return [rexTest evaluateWithObject:self];
}
-(BOOL) isValidWeiBo
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_WEIBO_REGEX];
    return [rexTest evaluateWithObject:self];
}
-(BOOL) isValidQQ
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_QQ_REGEX];
    return [rexTest evaluateWithObject:self];
}
-(BOOL) isValidWeb
{
    NSPredicate *rexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", STR_WEB_REGEX];
    return [rexTest evaluateWithObject:self];
}
@end

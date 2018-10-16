//
//  SubLabel.h
//  SummaryTest
//
//  Created by  Tmac on 2018/6/8.
//  Copyright © 2018年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubLabel : UILabel

+ (CGFloat)textHeightWithText:(NSString *)aText width:(CGFloat)aWidth font:(UIFont *)aFont;
@end

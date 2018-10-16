//
//  TKAlertView.h
//  ProBand
//
//  Created by star.zxc on 15/11/6.
//  Copyright © 2015年 DONGWANG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKAlertView : UIView
{
    CGRect _messageRect;
    NSString *_text;
    UIImage *_image;
}

- (id) init;
- (void) setMessageText:(NSString*)str;
- (void) setImage:(UIImage*)image;
@end

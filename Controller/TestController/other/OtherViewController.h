//
//  OtherViewController.h
//  SimpleTest
//
//  Created by  Tmac on 2017/11/30.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyModel : NSObject

- (void)gainMoney:(NSString *)name;

- (void)show;

+ (void)staticMethod;
@end

@interface MyCal : NSObject

@property(nonatomic,strong) NSString *name;
- (void)gainMoney:(NSString *)name;
@end

@interface OtherViewController : BaseController

@end

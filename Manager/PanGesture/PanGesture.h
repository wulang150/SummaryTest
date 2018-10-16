//
//  PanGesture.h
//  SummaryTest
//
//  Created by  Tmac on 2017/7/3.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :NSInteger {
    
    PanMoveDirectionNone = 1,
    
    PanMoveDirectionUp,
    
    PanMoveDirectionDown,
    
    PanMoveDirectionRight,
    
    PanMoveDirectionLeft
    
} PanMoveDirection;

@class PanGesture;

@protocol PanGestureDelegate <NSObject>

@required
- (void)didPanDirection:(PanGesture *)panGesture direction:(NSInteger)direction;

@end

@interface PanGesture : UIPanGestureRecognizer

@property(nonatomic) CGFloat moveLimitHor; //横向滑动这个距离才有效
@property(nonatomic) CGFloat moveLimitVer;
@property(nonatomic,weak) id<PanGestureDelegate> GesDelegate;

@end

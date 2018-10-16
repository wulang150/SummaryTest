//
//  PanGesture.m
//  SummaryTest
//
//  Created by  Tmac on 2017/7/3.
//  Copyright © 2017年 Tmac. All rights reserved.
//

#import "PanGesture.h"


@interface PanGesture()
<UIGestureRecognizerDelegate>
{
    PanMoveDirection direction;
}
@end

@implementation PanGesture

- (id)init
{
    if(self = [super initWithTarget:self action:@selector(handleSwipe:)])
    {
        self.delegate = self;
        self.moveLimitHor = 20;
        self.moveLimitVer = 20;
    }
    
    return self;
}

//保证拖动手势和其他上的拖动手势互不影响
-(BOOL)gestureRecognizer:(UIGestureRecognizer*) gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer
{
    return YES;
}

#pragma mark - //手势的方法
- (void)handleSwipe:(UIPanGestureRecognizer *)gesture
{
    if(![self.GesDelegate respondsToSelector:@selector(didPanDirection:direction:)])
        return;
    
    CGPoint translation = [gesture translationInView:gesture.view];
    if (gesture.state ==UIGestureRecognizerStateBegan)
    {
        
        direction = PanMoveDirectionNone;
        
    }
    else if (gesture.state == UIGestureRecognizerStateChanged && direction == PanMoveDirectionNone)
    {
        
        direction = [self determineCameraDirectionIfNeeded:translation];
        
        switch (direction) {
                
            case PanMoveDirectionDown:
            {
                break;
            }
                
            case PanMoveDirectionUp:
            {
                break;
            }
                
            case PanMoveDirectionRight:
            {
                NSLog(@"Start moving right");
                
                
            }
                break;
                
            case PanMoveDirectionLeft:
            {
                NSLog(@"Start moving left");
                
                break;
            }
                
            default:
                
                break;
                
        }
        
        [self.GesDelegate didPanDirection:self direction:direction];
        
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
        
    {
        // now tell the camera to stop
        
        NSLog(@"Stop");
        
    }
}

- (PanMoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation
{
    // determine if horizontal swipe only if you meet some minimum velocity
    
    
    if (fabs(translation.x) > self.moveLimitHor)
    {
        
        BOOL gestureHorizontal = NO;
        
        if (translation.y ==0.0)
            
            gestureHorizontal = YES;
        
        else
            
            gestureHorizontal = (fabs(translation.x / translation.y) >5.0);
        
        if (gestureHorizontal)
            
        {
            
            if (translation.x >0.0)
                
                return PanMoveDirectionRight;
            
            else
                
                return PanMoveDirectionLeft;
            
        }
        
    }
    
    
    else if (fabs(translation.y) > self.moveLimitVer)
        
    {
        
        BOOL gestureVertical = NO;
        
        if (translation.x ==0.0)
            
            gestureVertical = YES;
        
        else
            
            gestureVertical = (fabs(translation.y / translation.x) >5.0);
        
        if (gestureVertical)
            
        {
            
            if (translation.y >0.0)
                
                return PanMoveDirectionDown;
            
            else
                return PanMoveDirectionUp;
            
        }
        
    }
    
    return PanMoveDirectionNone;
    
}
@end

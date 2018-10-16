/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */


#import "UIImageView+HeadImage.h"

#import "UIImageView+WebCache.h"
#import "UIImage+MultiFormat.h"
#import "UIImage+GIF.h"
#import "SDWebImageManager.h"

@implementation UIImageView (HeadImage)


- (void)imageWithUrl:(NSString *)url placeholderImage:(UIImage*)placeholderImage
{
    if (placeholderImage == nil) {
        placeholderImage = [UIImage imageNamed:@"default_portrait_msg"];
    }
    self.layer.cornerRadius = 6;
    self.clipsToBounds = YES;
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage completed:nil];
  
}


- (void)gifImageWithUrl:(NSString *)url
{
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        if(image)
        {
            self.image = image;
//            NSData *data = UIImagePNGRepresentation(image);
//            self.image = [UIImage sd_animatedGIFWithData:data];
            
        }
        else
            self.image = [UIImage imageNamed:@"default_group_portrait"];
    }];
    
//    [[FDNetManager shareInstance] downloadFilewithURL:url filePath:nil withResult:^(BOOL succ, NSData *data, CGFloat percent) {
//        
//        if(succ)
//        {
//            if(data)
//                self.image = [UIImage sd_animatedGIFWithData:data];
//        }
//        else
//            self.image = [UIImage imageNamed:@"default_group_portrait"];
//    }];
}

@end


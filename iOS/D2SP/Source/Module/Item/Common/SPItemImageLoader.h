//
//  SPItemImageLoader.h
//  D2SP
//
//  Created by wwwbbat on 2017/8/10.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

@import Foundation;
#import "SPItem.h"

@class YYCache;

typedef NS_ENUM(NSUInteger, SPImageType) {
    SPImageTypeNormal,
    SPImageTypeLarge,
    SPImageTypeIngame,
};

typedef void(^SPItemCacheCompletion)(NSString *urlString);

YG_EXTERN YYCache *normalImageCache(void);
YG_EXTERN YYCache *largeImageCache(void);
YG_EXTERN YYCache *qiniuCache(void);
YG_EXTERN YYCache *cacheForImageType(SPImageType type);
YG_EXTERN UIImage *placeholderImage(CGSize size);

YG_EXTERN CGSize const kNonePlaceholderSize;

@interface SPItemImageLoader : NSObject

+ (void)setSDWebImageUseYYMemoryCache;

+ (void)loadItemImage:(SPItem *)item
                 size:(CGSize)size
                 type:(SPImageType)type
            imageView:(UIImageView *)imageView;

+ (void)loadItemImage:(SPItem *)item
                 size:(CGSize)size
                 type:(SPImageType)type
                layer:(CALayer *)layer;

+ (void)prefetchItemImages:(NSArray *)itemImages;

+ (void)clearMemory;

@end


@interface SPItem (ImageURL)
- (NSString *)itemImageIconName;
- (NSString *)qiniuImageURLString;
- (NSURL *)qiniuSmallURL;
- (NSURL *)qiniuLargeURL;
- (NSURL *)qiniuURLOfType:(SPImageType)type;
@end

//
//  SVGAPlayer.h
//  SVGAPlayer
//
//  Created by 崔明辉 on 16/6/17.
//  Copyright © 2016年 UED Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVGAVideoEntity, SVGAPlayer;

@protocol SVGAPlayerDelegate <NSObject>

@optional
- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player ;

- (void)svgaPlayer:(SVGAPlayer *)player didAnimatedToFrame:(NSInteger)frame;
- (void)svgaPlayer:(SVGAPlayer *)player didAnimatedToPercentage:(CGFloat)percentage;

- (void)svgaPlayerDidAnimatedToFrame:(NSInteger)frame API_DEPRECATED("Use svgaPlayer:didAnimatedToFrame: instead", ios(7.0, API_TO_BE_DEPRECATED));
- (void)svgaPlayerDidAnimatedToPercentage:(CGFloat)percentage API_DEPRECATED("Use svgaPlayer:didAnimatedToPercentage: instead", ios(7.0, API_TO_BE_DEPRECATED));

@end

typedef void(^SVGAPlayerDynamicDrawingBlock)(CALayer *contentLayer, NSInteger frameIndex);

@interface SVGAPlayer : UIView

@property (nonatomic, weak) id<SVGAPlayerDelegate> delegate;
@property (nonatomic, strong) SVGAVideoEntity *videoItem;
@property (nonatomic, assign) IBInspectable int loops;
@property (nonatomic, assign) IBInspectable BOOL clearsAfterStop;
@property (nonatomic, copy) NSString *fillMode;
@property (nonatomic, copy) NSRunLoopMode mainRunLoopMode;

- (void)startAnimation;
- (void)startAnimationWithRange:(NSRange)range reverse:(BOOL)reverse;
- (void)pauseAnimation;
- (void)stopAnimation;
- (void)clear;
- (void)stepToFrame:(NSInteger)frame andPlay:(BOOL)andPlay;
- (void)stepToPercentage:(CGFloat)percentage andPlay:(BOOL)andPlay;

#pragma mark - Dynamic Object

- (void)setImage:(UIImage *)image forKey:(NSString *)aKey;
- (void)setImageWithURL:(NSURL *)URL forKey:(NSString *)aKey;
- (void)setImage:(UIImage *)image forKey:(NSString *)aKey referenceLayer:(CALayer *)referenceLayer; // deprecated from 2.0.1
- (void)setAttributedText:(NSAttributedString *)attributedText forKey:(NSString *)aKey;
- (void)setDrawingBlock:(SVGAPlayerDynamicDrawingBlock)drawingBlock forKey:(NSString *)aKey;
- (void)setHidden:(BOOL)hidden forKey:(NSString *)aKey;
- (void)clearDynamicObjects;

@end

// SPM 把 SVGAPlayer.h 当 umbrella header (同名), 文件末尾 re-export 其他 public header
// 让 `@import SVGAPlayer;` / `#import "SVGAPlayer.h"` 一并暴露 SVGAParser 等类
// 放在末尾因为 SVGAImageView/SVGAContentLayer 等头依赖 SVGAPlayer 已先声明
#import "SVGA.h"
#import "SVGAAudioEntity.h"
#import "SVGAAudioLayer.h"
#import "SVGABezierPath.h"
#import "SVGABitmapLayer.h"
#import "SVGAContentLayer.h"
#import "SVGAExporter.h"
#import "SVGAImageView.h"
#import "SVGAParser.h"
#import "SVGAVectorLayer.h"
#import "SVGAVideoEntity.h"
#import "SVGAVideoSpriteEntity.h"
#import "SVGAVideoSpriteFrameEntity.h"

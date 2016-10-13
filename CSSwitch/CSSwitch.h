//
//  CSSwitch.h
//  PairDaysMatter
//
//  Created by SurfBoy on 01/10/2016.
//  Copyright © 2016 CrazySurfboy. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

// 状态
typedef NS_ENUM(NSUInteger, CSSwitchState) {

    CSSwitchStateOn,
    CSSwitchStateOff
};


// 大小
typedef NS_ENUM(NSUInteger, CSSwitchSize) {
    
    CSSwitchSizeBig,
    CSSwitchSizeNormal,
    CSSwitchSizeSmall
};


// 样式
typedef NS_ENUM(NSUInteger, CSSwitchStyle) {
    
    CSSwitchStyleLight,
    CSSwitchStyleDark,
    CSSwitchStyleDefault
};



@class CSSwitch;

typedef void(^CSSwitchStateChangedBlock)(CSSwitchState switchState);


@interface CSSwitch : UIControl

@property (nonatomic, copy) CSSwitchStateChangedBlock switchStateChangedBlock; // 值更改变化 Blcok


/**
 *  初始化并默认设置 (CSSwitchSizeNormal，CSSwitchStyleDefault，CSSwitchStateOn)
 *  
 *  @return instancetype
 */
- (instancetype)init;



/**
 *  初始化
 *
 *  @param CSSwitchSize
 *  @param CSSwitchState
 *
 */
- (instancetype)initWithSize:(CSSwitchSize)size state:(CSSwitchState)state;



/**
 *  初始化
 *
 *  @param CSSwitchSize
 *  @param CSSwitchStyle
 *  @param CSSwitchState
 */
- (instancetype)initWithSize:(CSSwitchSize)size style:(CSSwitchStyle)style state:(CSSwitchState)state;



/**
 *  设置打开与关闭
 *
 *  @param 是否打开
 *  @param 是否需要动画效果
 */
- (void)setOn:(BOOL)on animated:(BOOL)animated;


@end

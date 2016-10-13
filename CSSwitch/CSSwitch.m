//
//  CSSwitch.m
//  PairDaysMatter
//
//  Created by SurfBoy on 01/10/2016.
//  Copyright © 2016 CrazySurfboy. All rights reserved.
//

#import "CSSwitch.h"

// 颜色
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 alpha:1.0]
#define UIColorFromHexAlpha(hex, a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:(a)]


@interface CSSwitch()

@property (nonatomic, strong) UIButton *switchThumb;
@property (nonatomic, strong) UIView *track;

// 位置
@property (nonatomic, assign) float thumbOnPosition;
@property (nonatomic, assign) float thumbOffPosition;
@property (nonatomic, assign) float bounceOffset;

// State
@property (nonatomic) BOOL isOn;
@property (nonatomic) BOOL isEnabled;
@property (nonatomic) BOOL isBounceEnabled;


// Color
@property (nonatomic, strong) UIColor *thumbOnTintColor;
@property (nonatomic, strong) UIColor *thumbOffTintColor;
@property (nonatomic, strong) UIColor *trackOnTintColor;
@property (nonatomic, strong) UIColor *trackOffTintColor;
@property (nonatomic, strong) UIColor *thumbDisabledTintColor;
@property (nonatomic, strong) UIColor *trackDisabledTintColor;

// Size
@property (nonatomic) CGFloat trackThickness;
@property (nonatomic) CGFloat thumbSize;

@end


@implementation CSSwitch

#pragma mark - Switch init

// 初始
- (instancetype)init {

  self = [self initWithSize:CSSwitchSizeNormal
                      style:CSSwitchStyleDefault
                      state:CSSwitchStateOff];
  
  return self;
}



// 初始化
- (instancetype)initWithSize:(CSSwitchSize)size state:(CSSwitchState)state {
        
    // 默认样式设置
    self = [self initWithSize:size
                        style:CSSwitchStyleDefault
                        state:state];
    
    return self;
}


// 初始化
- (instancetype)initWithSize:(CSSwitchSize)size style:(CSSwitchStyle)style state:(CSSwitchState)state {
    
    // 样式选择
    [self switchStyle:style];
    
    // init
    self.isEnabled = YES;
    self.isBounceEnabled = YES;
    self.bounceOffset = 3.0f;
    CGRect frame;
    CGRect trackFrame = CGRectZero;
    CGRect thumbFrame = CGRectZero;
    
    // 设置相对应的大小
    switch (size) {
            
        case CSSwitchSizeBig:
            frame = CGRectMake(0, 0, 50, 40);
            self.trackThickness = 23.0;
            self.thumbSize = 31.0;
            break;
            
        case CSSwitchSizeNormal:
            frame = CGRectMake(0, 0, 40, 30);
            self.trackThickness = 17.0;
            self.thumbSize = 24.0;
            break;
            
        case CSSwitchSizeSmall:
            frame = CGRectMake(0, 0, 30, 25);
            self.trackThickness = 13.0;
            self.thumbSize = 18.0;
            break;
            
        default:
            frame = CGRectMake(0, 0, 40, 30);
            self.trackThickness = 13.0;
            self.thumbSize = 20.0;
            break;
    }
    
    // Track Frame
    trackFrame.size.height = self.trackThickness;
    trackFrame.size.width = frame.size.width;
    trackFrame.origin.x = 0.0;
    trackFrame.origin.y = (frame.size.height - trackFrame.size.height) / 2;
    thumbFrame.size.height = self.thumbSize;
    thumbFrame.size.width = thumbFrame.size.height;
    thumbFrame.origin.x = 0.0;
    thumbFrame.origin.y = (frame.size.height - thumbFrame.size.height) / 2;
    
    // Actual initialization with selected size
    self = [super initWithFrame:frame];
    
    // track
    self.track = [[UIView alloc] initWithFrame:trackFrame];
    self.track.layer.cornerRadius = MIN(self.track.frame.size.height, self.track.frame.size.width) / 2;
    [self addSubview:self.track];
    
    // thumb
    self.switchThumb = [[UIButton alloc] initWithFrame:thumbFrame];
    self.switchThumb.layer.cornerRadius = self.switchThumb.frame.size.height/2;
    
    // Add events for 0action
    [self.switchThumb addTarget:self action:@selector(onTouchUpOutsideOrCanceled:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
    [self.switchThumb addTarget:self action:@selector(switchThumbTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.switchThumb addTarget:self action:@selector(onTouchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.switchThumb addTarget:self action:@selector(onTouchUpOutsideOrCanceled:withEvent:) forControlEvents:UIControlEventTouchCancel];
    [self addSubview:self.switchThumb];
    
    // thumb 打开与关闭的位置
    self.thumbOnPosition = self.frame.size.width - self.switchThumb.frame.size.width;
    self.thumbOffPosition = self.switchThumb.frame.origin.x;
    
    // 状态设置
    switch (state) {
        case CSSwitchStateOn:
            self.isOn = YES;
            self.switchThumb.backgroundColor = self.thumbOnTintColor;
            self.track.backgroundColor = self.trackOnTintColor;
            CGRect thumbFrame = self.switchThumb.frame;
            thumbFrame.origin.x = self.thumbOnPosition;
            self.switchThumb.frame = thumbFrame;
            break;
            
        default:
            self.isOn = NO;
            self.switchThumb.backgroundColor = self.thumbOffTintColor;
            self.track.backgroundColor = self.trackOffTintColor;
            break;
    }
    
    // 点击区域
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(switchAreaTapped:)];
    [self addGestureRecognizer:singleTap];

    return self;
}


// 设置默认样式
- (void)switchStyle:(CSSwitchStyle)style {

    switch (style) {

        case CSSwitchStyleLight:
            self.thumbOnTintColor  = [UIColor colorWithRed:0./255. green:134./255. blue:117./255. alpha:1.0];
            self.thumbOffTintColor = [UIColor colorWithRed:237./255. green:237./255. blue:237./255. alpha:1.0];
            self.trackOnTintColor = [UIColor colorWithRed:90./255. green:178./255. blue:169./255. alpha:1.0];
            self.trackOffTintColor = [UIColor colorWithRed:129./255. green:129./255. blue:129./255. alpha:1.0];
            self.thumbDisabledTintColor = [UIColor colorWithRed:175./255. green:175./255. blue:175./255. alpha:1.0];
            self.trackDisabledTintColor = [UIColor colorWithRed:203./255. green:203./255. blue:203./255. alpha:1.0];
            break;

        case CSSwitchStyleDark:
            self.thumbOnTintColor  = [UIColor colorWithRed:109./255. green:194./255. blue:184./255. alpha:1.0];
            self.thumbOffTintColor = [UIColor colorWithRed:175./255. green:175./255. blue:175./255. alpha:1.0];
            self.trackOnTintColor = [UIColor colorWithRed:72./255. green:109./255. blue:105./255. alpha:1.0];
            self.trackOffTintColor = [UIColor colorWithRed:94./255. green:94./255. blue:94./255. alpha:1.0];
            self.thumbDisabledTintColor = [UIColor colorWithRed:50./255. green:51./255. blue:50./255. alpha:1.0];
            self.trackDisabledTintColor = [UIColor colorWithRed:56./255. green:56./255. blue:56./255. alpha:1.0];
            break;

        default:
            self.thumbOnTintColor  = UIColorFromHex(0x50D2C2);
            self.thumbOffTintColor = UIColorFromHex(0xBEBEC1);
            self.trackOnTintColor = UIColorFromHexAlpha(0x50D2C2, 0.5);
            self.trackOffTintColor = UIColorFromHexAlpha(0x261D21, 0.1);
            self.thumbDisabledTintColor = UIColorFromHex(0x50D2C2);
            self.trackDisabledTintColor = UIColorFromHex(0x50D2C2);
            break;
    }
}



#pragma mark - Touch

// Change switch state if necessary, with the animated option parameter
- (void)setOn:(BOOL)on animated:(BOOL)animated {

    // On
    if (on == YES) {

        if (animated == YES) {

            // set on with animation
            [self changeThumbStateONwithAnimation];
        }
        else {

            // set on without animation
            [self changeThumbStateONwithoutAnimation];
        }
    }

    // Off
    else {
        if (animated == YES) {

            // set off with animation
            [self changeThumbStateOFFwithAnimation];
        }
        else {

            // set off without animation
            [self changeThumbStateOFFwithoutAnimation];
        }
    }
}



// Change thumb state when touchUPOutside action is detected
- (void)onTouchUpOutsideOrCanceled:(UIButton*)btn withEvent:(UIEvent*)event {
    
    UITouch *touch = [[event touchesForView:btn] anyObject];
    CGPoint prevPos = [touch previousLocationInView:btn];
    CGPoint pos = [touch locationInView:btn];
    float dX = pos.x-prevPos.x;
    
    //Get the new origin after this motion
    float newXOrigin = btn.frame.origin.x + dX;
    
    if (newXOrigin > (self.frame.size.width - self.switchThumb.frame.size.width)/2) {

        [self changeThumbStateONwithAnimation];
    }
    else {

        [self changeThumbStateOFFwithAnimation];
    }
}


// switch 区域的点击
- (void)switchAreaTapped:(UITapGestureRecognizer *)recognizer {

    [self switchThumbTapped];
}


//  更改状态
- (void)changeThumbState {

    if (self.isOn == YES) {
        [self changeThumbStateOFFwithAnimation];
    }
    else {
        [self changeThumbStateONwithAnimation];
    }
}



// Thumb 事件
- (void)switchThumbTapped {
    
    // Block
    if (self.switchStateChangedBlock) {

        if (self.isOn == YES) {

            self.switchStateChangedBlock(CSSwitchStateOff);
        }
        else{

            self.switchStateChangedBlock(CSSwitchStateOn);
        }
    }

    // change State
    [self changeThumbState];
}


// 拖动事件
- (void)onTouchDragInside:(UIButton*)btn withEvent:(UIEvent*)event {
    
    //This code can go awry if there is more than one finger on the screen
    UITouch *touch = [[event touchesForView:btn] anyObject];
    CGPoint prevPos = [touch previousLocationInView:btn];
    CGPoint pos = [touch locationInView:btn];
    float dX = pos.x - prevPos.x;
    
    //Get the original position of the thumb
    CGRect thumbFrame = btn.frame;
    
    thumbFrame.origin.x += dX;

    //Make sure it's within two bounds
    thumbFrame.origin.x = MIN(thumbFrame.origin.x,self.thumbOnPosition);
    thumbFrame.origin.x = MAX(thumbFrame.origin.x,self.thumbOffPosition);
    
    //Set the thumb's new frame if need to
    if(thumbFrame.origin.x != btn.frame.origin.x) {

        btn.frame = thumbFrame;
    }
}



#pragma mark - Animated


// 打开带动画效果
- (void)changeThumbStateONwithAnimation {
    
    // switch movement animation
    [UIView animateWithDuration:0.15f delay:0.05f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGRect thumbFrame = self.switchThumb.frame;
        thumbFrame.origin.x = self.thumbOnPosition + self.bounceOffset;
        self.switchThumb.frame = thumbFrame;
        if (self.isEnabled == YES) {
            
            self.switchThumb.backgroundColor = self.thumbOnTintColor;
            self.track.backgroundColor = self.trackOnTintColor;
        }
        else {
            
            self.switchThumb.backgroundColor = self.thumbDisabledTintColor;
            self.track.backgroundColor = self.trackDisabledTintColor;
        }
        
        self.userInteractionEnabled = NO;
    }
    completion:^(BOOL finished) {

        // change state to ON
        if (self.isOn == NO) {
            
            self.isOn = YES; // Expressly put this code here to change surely and send action correctly
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        
        self.isOn = YES;
        
        [UIView animateWithDuration:0.15f animations:^{
            
            // Bounce to the position
            CGRect thumbFrame = self.switchThumb.frame;
            thumbFrame.origin.x = self.thumbOnPosition;
            self.switchThumb.frame = thumbFrame;
        }
        completion:^(BOOL finished){
            
            self.userInteractionEnabled = YES;
        }];
    }];
}


// 打开
- (void)changeThumbStateONwithoutAnimation {

    CGRect thumbFrame = self.switchThumb.frame;
    thumbFrame.origin.x = self.thumbOnPosition;
    self.switchThumb.frame = thumbFrame;
    if (self.isEnabled == YES) {

        self.switchThumb.backgroundColor = self.thumbOnTintColor;
        self.track.backgroundColor = self.trackOnTintColor;
    }
    else {

        self.switchThumb.backgroundColor = self.thumbDisabledTintColor;
        self.track.backgroundColor = self.trackDisabledTintColor;
    }
    
    if (self.isOn == NO) {

        self.isOn = YES;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    self.isOn = YES;
}



// 关闭带动画效果
- (void)changeThumbStateOFFwithAnimation {

    // switch movement animation
    [UIView animateWithDuration:0.15f
                          delay:0.05f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{

                         CGRect thumbFrame = self.switchThumb.frame;
                         thumbFrame.origin.x = self.thumbOffPosition - self.bounceOffset;
                         self.switchThumb.frame = thumbFrame;
                         if (self.isEnabled == YES) {

                             self.switchThumb.backgroundColor = self.thumbOffTintColor;
                             self.track.backgroundColor = self.trackOffTintColor;
                         }
                         else {

                             self.switchThumb.backgroundColor = self.thumbDisabledTintColor;
                             self.track.backgroundColor = self.trackDisabledTintColor;
                         }
                         self.userInteractionEnabled = NO;
                     }
                     completion:^(BOOL finished){
                         // change state to OFF
                         if (self.isOn == YES) {
                             self.isOn = NO; // Expressly put this code here to change surely and send action correctly
                             [self sendActionsForControlEvents:UIControlEventValueChanged];
                         }
                         self.isOn = NO;

                         // Bouncing effect: Move thumb a bit, for better UX
                         [UIView animateWithDuration:0.15f
                                          animations:^{
                                              // Bounce to the position
                                              CGRect thumbFrame = self.switchThumb.frame;
                                              thumbFrame.origin.x = self.thumbOffPosition;
                                              self.switchThumb.frame = thumbFrame;
                                          }
                                          completion:^(BOOL finished){
                                              self.userInteractionEnabled = YES;
                                          }];
                     }];
}



// 关闭
- (void)changeThumbStateOFFwithoutAnimation {

    CGRect thumbFrame = self.switchThumb.frame;
    thumbFrame.origin.x = self.thumbOffPosition;
    self.switchThumb.frame = thumbFrame;
    if (self.isEnabled == YES) {

        self.switchThumb.backgroundColor = self.thumbOffTintColor;
        self.track.backgroundColor = self.trackOffTintColor;
    }
    else {

        self.switchThumb.backgroundColor = self.thumbDisabledTintColor;
        self.track.backgroundColor = self.trackDisabledTintColor;
    }
    
    if (self.isOn == YES) {
        self.isOn = NO;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    self.isOn = NO;
}

@end

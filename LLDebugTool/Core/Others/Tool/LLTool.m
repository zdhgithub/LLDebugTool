//
//  LLTool.m
//
//  Copyright (c) 2018 LLDebugTool Software Foundation (https://github.com/HDB-Li/LLDebugTool)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "LLTool.h"
#import "LLConfig.h"
#import "LLMacros.h"
#import "LLFactory.h"
#import "UIView+LL_Utils.h"
#import "LLFormatterTool.h"
#import "LLDebugTool.h"

static CGFloat _toastTime = 2.0;

static UILabel *_toastLabel = nil;
static UILabel *_loadingLabel = nil;
static NSTimer *_loadingTimer = nil;

static unsigned long long _absolutelyIdentity = 0;

@implementation LLTool

#pragma mark - Class Method
+ (NSString *)absolutelyIdentity {
    @synchronized (self) {
        _absolutelyIdentity++;
        return [NSString stringWithFormat:@"%lld",_absolutelyIdentity];
    }
}

+ (BOOL)createDirectoryAtPath:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager  defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            [self log:[NSString stringWithFormat:@"Create folder fail, path = %@, error = %@",path,error.description]];
            NSAssert(!error, error.description);
            return NO;
        }
        return YES;
    }
    return YES;
}

+ (CGRect)rectWithPoint:(CGPoint)point otherPoint:(CGPoint)otherPoint {
    
    CGFloat x = MIN(point.x, otherPoint.x);
    CGFloat y = MIN(point.y, otherPoint.y);
    CGFloat maxX = MAX(point.x, otherPoint.x);
    CGFloat maxY = MAX(point.y, otherPoint.y);
    CGFloat width = maxX - x;
    CGFloat height = maxY - y;
    // Return rect nearby
    CGFloat gap = 1 / 2.0;
    if (width == 0) {
        width = gap;
    }
    if (height == 0) {
        height = gap;
    }
    return CGRectMake(x, y, width, height);
}

+ (void)toastMessage:(NSString *)message {
    if (_toastLabel) {
        [_toastLabel removeFromSuperview];
        _toastLabel = nil;
    }
    
    __block UILabel *label = [LLFactory getLabel:[UIApplication sharedApplication].delegate.window frame:CGRectMake(20, 0, LL_SCREEN_WIDTH - 40, 100) text:message font:17 textColor:[UIColor whiteColor]];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.alpha = 0;
    label.backgroundColor = [UIColor blackColor];
    label.LL_horizontalPadding = 10;
    label.LL_verticalPadding = 5;
    [label sizeToFit];
    
    [label LL_setCornerRadius:5];
    label.center = CGPointMake(LL_SCREEN_WIDTH / 2.0, LL_SCREEN_HEIGHT / 2.0);
    _toastLabel = label;
    [UIView animateWithDuration:0.25 animations:^{
        label.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_toastTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.1 animations:^{
                _toastLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [_toastLabel removeFromSuperview];
                _toastLabel = nil;
            }];
        });
    }];
}

+ (void)loadingMessage:(NSString *)message {
    if (_loadingLabel) {
        [_loadingLabel removeFromSuperview];
        _loadingLabel = nil;
    }
    
    __block UILabel *label = [LLFactory getLabel:[UIApplication sharedApplication].delegate.window frame:CGRectMake(20, 0, LL_SCREEN_WIDTH - 40, 100) text:message font:17 textColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.LL_horizontalPadding = 10;
    label.LL_verticalPadding = 5;
    [label sizeToFit];
    
    [label LL_setCornerRadius:5];
    label.center = CGPointMake(LL_SCREEN_WIDTH / 2.0, LL_SCREEN_HEIGHT / 2.0);
    label.alpha = 0;
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].delegate.window addSubview:label];
    _loadingLabel = label;
    [UIView animateWithDuration:0.25 animations:^{
        label.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    [self startLoadingMessageTimer];
}

+ (void)hideLoadingMessage {
    if (_loadingLabel.superview) {
        [self removeLoadingMessageTimer];
        [UIView animateWithDuration:0.1 animations:^{
            _loadingLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [_loadingLabel removeFromSuperview];
            _loadingLabel = nil;
        }];
    }
}

+ (void)startLoadingMessageTimer {
    [self removeLoadingMessageTimer];
    _loadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(loadingMessageTimerAction:) userInfo:nil repeats:YES];
}

+ (void)removeLoadingMessageTimer {
    if ([_loadingTimer isValid]) {
        [_loadingTimer invalidate];
        _loadingTimer = nil;
    }
}

+ (void)loadingMessageTimerAction:(NSTimer *)timer {
    if (_loadingLabel.superview) {
        if ([_loadingLabel.text hasSuffix:@"..."]) {
            _loadingLabel.text = [_loadingLabel.text substringToIndex:_loadingLabel.text.length - 3];
        } else {
            _loadingLabel.text = [_loadingLabel.text stringByAppendingString:@"."];
        }
    } else {
        [self removeLoadingMessageTimer];
    }
}

+ (NSString *)stringFromFrame:(CGRect)frame {
    return [NSString stringWithFormat:@"{{%@, %@}, {%@, %@}}",[[LLFormatterTool sharedTool] formatNumber:@(frame.origin.x)],[[LLFormatterTool sharedTool] formatNumber:@(frame.origin.y)],[[LLFormatterTool sharedTool] formatNumber:@(frame.size.width)],[[LLFormatterTool sharedTool] formatNumber:@(frame.size.height)]];
}

+ (UIInterfaceOrientationMask)infoPlistSupportedInterfaceOrientationsMask
{
    NSArray<NSString *> *supportedOrientations = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"];
    UIInterfaceOrientationMask supportedOrientationsMask = 0;
    if ([supportedOrientations containsObject:@"UIInterfaceOrientationPortrait"]) {
        supportedOrientationsMask |= UIInterfaceOrientationMaskPortrait;
    }
    if ([supportedOrientations containsObject:@"UIInterfaceOrientationMaskLandscapeRight"]) {
        supportedOrientationsMask |= UIInterfaceOrientationMaskLandscapeRight;
    }
    if ([supportedOrientations containsObject:@"UIInterfaceOrientationMaskPortraitUpsideDown"]) {
        supportedOrientationsMask |= UIInterfaceOrientationMaskPortraitUpsideDown;
    }
    if ([supportedOrientations containsObject:@"UIInterfaceOrientationLandscapeLeft"]) {
        supportedOrientationsMask |= UIInterfaceOrientationMaskLandscapeLeft;
    }
    return supportedOrientationsMask;
}

+ (UIWindow *)topWindow {
    UIWindow *topWindow = [UIApplication sharedApplication].delegate.window;
    for (UIWindow *win in [UIApplication sharedApplication].windows) {
        if (!win.isHidden && win.windowLevel > topWindow.windowLevel) {
            topWindow = win;
        }
    }
    return topWindow;
}

+ (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].delegate.window;
}

+ (void)log:(NSString *)string {
    if ([LLConfig sharedConfig].isShowDebugToolLog) {
        NSLog(@"%@ %@",string,@"Open an issue in \"https://github.com/HDB-Li/LLDebugTool\" if you need to get more help.");
    }
}

@end

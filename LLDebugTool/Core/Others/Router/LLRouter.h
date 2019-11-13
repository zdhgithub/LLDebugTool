//
//  LLRouter.h
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

#import <Foundation/Foundation.h>

#import "LLConfig.h"

NS_ASSUME_NONNULL_BEGIN

/// Router
@interface LLRouter : NSObject

/// Set LLCrashHelper enable.
/// @param isEnable Is enable.
+ (void)setCrashHelperEnable:(BOOL)isEnable;

/// Set LLLogHelper enable.
/// @param isEnable Is enable.
+ (void)setLogHelperEnable:(BOOL)isEnable;

/// Set LLNetworkHelper enable.
/// @param isEnable Is enable.
+ (void)setNetworkHelperEnable:(BOOL)isEnable;

/// Set LLAppInfoHelper enable.
/// @param isEnable Is enable.
+ (void)setAppInfoHelperEnable:(BOOL)isEnable;

/// Set LLScreenshotHelper enable.
/// @param isEnable Is enable.
+ (void)setScreenshotHelperEnable:(BOOL)isEnable;

/// Call LLLogHelper if enable.
/// @param file File name.
/// @param function Function name.
/// @param lineNo Line No.
/// @param level Level.
/// @param onEvent Event.
/// @param message Message.
+ (void)logInFile:(NSString *)file function:(NSString *)function lineNo:(NSInteger)lineNo level:(LLConfigLogLevel)level onEvent:(NSString *)onEvent message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
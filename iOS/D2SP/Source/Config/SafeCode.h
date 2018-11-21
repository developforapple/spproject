//
//  SafeCode.h
//  Laidian
//
//  Created by Jay on 2018/2/1.
//  Copyright © 2018年 来电科技. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef NS_NOESCAPE
    #if __has_attribute(noescape)
        #define NS_NOESCAPE __attribute__((noescape))
    #else
        #define NS_NOESCAPE
    #endif
#endif

#ifndef FINAL_CLASS
    #if __has_attribute(objc_subclassing_restricted)
        #define FINAL_CLASS __attribute__((objc_subclassing_restricted))
    #else
        #define FINAL_CLASS
    #endif
#endif

NS_ASSUME_NONNULL_BEGIN

typedef void (^SafeCodeBlock)(void);

// 对应NSException的reason
FOUNDATION_EXPORT NSErrorUserInfoKey const SafeCodeErrorReasonKey;
// 对应NSException的callStackSymbols
FOUNDATION_EXPORT NSErrorUserInfoKey const SafeCodeErrorCallStackSymbolsKey;
// 对应NSException的callStackReturnAddresses
FOUNDATION_EXPORT NSErrorUserInfoKey const SafeCodeErrorCallStackReturnAddressesKey;

/**
 本类主要用于在swift中catch到Objective-C的异常。
 使用类方法时，swift中使用 do{ try SafeCode.try{...} }catch{...}语句。
 使用函数时，swift中要用 if let error = safeCode(...) {} 语句
 */
FINAL_CLASS
@interface SafeCode : NSObject
+ (instancetype)new NS_UNAVAILABLE NS_SWIFT_UNAVAILABLE("unavailable");
- (instancetype)init NS_UNAVAILABLE NS_SWIFT_UNAVAILABLE("unavailable");

/**
 执行Block，处理Block中可能发生的异常

 @param tryBlock 需要执行的代码
 @param error 发生的异常
 @return 是否执行成功
 */
+ (BOOL)try:(NS_NOESCAPE SafeCodeBlock)tryBlock
      error:(__autoreleasing NSError * _Nullable *)error;

@end

/**
 执行Block，处理Block中可能发生的异常
 
 @param tryBlock 需要执行的代码
 @return catch到的异常
 */
FOUNDATION_EXPORT
NSError * _Nullable
safeCode(NS_NOESCAPE SafeCodeBlock tryBlock);

NS_ASSUME_NONNULL_END

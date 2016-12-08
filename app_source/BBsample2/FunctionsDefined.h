//
//  FunctionsDefined.h
//  BBsample1
//
//  Created by Val F on 13/04/09.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import <Foundation/NSString.h>

@interface FunctionsDefined : NSObject

+ (NSArray *) httpConnectFromData:(NSString *)data url:(NSURL *)url;

+ (NSURLRequest *)postRequest:(NSString *)data url:(NSURL *)url timeout:(int)time;

+ (NSString *) sinceFromData:(NSString *)data;

+ (BOOL)findKatakana:(NSString *)str;

+ (BOOL)validEmail:(NSString *)str;

+ (NSString *)urlencode:(NSString *)plainString;

+ (NSString *)urldecode:(NSString *)escapedUrlString;

+ (BOOL)chkNumeric:(NSString *)checkString;

@end

//
//  FunctionsDefined.m
//  BBsample1
//
//  Created by Val F on 13/04/09.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import "FunctionsDefined.h"

@interface FunctionsDefined ()

@end

@implementation FunctionsDefined

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

//urlとpostするデータを入れて結果を配列で返します
+ (NSArray *) httpConnectFromData: (NSString *)data url:(NSURL *)url{
    //indicatorつける
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;//きいてない
    NSLog(@"start");
    //入力したpostdata
    NSData *postData = [data dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"theReply: %@", theReply);
    NSError* jsonError=nil;
    //jsonデコードしたやつをreturn
    NSArray* statuses=[NSJSONSerialization JSONObjectWithData:POSTReply options:NSJSONReadingMutableContainers error:&jsonError];
    
    NSLog(@"stop");
    //indicatorけす
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;//きいてない
    return statuses;
}

//postするリクエストを作るお
+ (NSURLRequest *)postRequest:(NSString *)data url:(NSURL *)url timeout:(int)time{
    //入力したpostdata
    NSData *postData = [data dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setTimeoutInterval:time];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    return request;
}

+ (NSString *) sinceFromData:(NSString *)data{
    //時間計算
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormater dateFromString:data];
    NSTimeInterval since = [now timeIntervalSinceDate:date];
    NSString *time;
    if(since >= 86400){
        time = [NSString stringWithFormat:@"%d 日前", (int)since/86400];
    }else if(since >= 3600){
        time = [NSString stringWithFormat:@"%d 時間前", (int)since/3600];
    }else if(since >= 60){
        time = [NSString stringWithFormat:@"%d 分前", (int)since/60];
    }else{
        time = @"たった今";
    }
    return time;
}

//全角カタカナだけかどうか判定
+ (BOOL)findKatakana:(NSString *)str {

    __block NSMutableString* temp = [NSMutableString stringWithCapacity:str.length];

    [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop){
         
         const unichar high = [substring characterAtIndex: 0];
         
         // surrogate pair
         if (0xd800 <= high && high <= 0xdbff) {
             //do nothing
             // not surrogate pair
         } else {
             [temp appendString: !(0x30A0 <= high && high <= 0x30FF)? @"": substring]; // U+30A0-30FF
         }
     }];

    //return temp;
    //カタカナ以外が存在したらNO
    if([str isEqualToString:temp]){
        return YES;
    }else{
        NSLog(@"not katakana = %@", temp);
        return NO;
    }
}

+ (BOOL)validEmail:(NSString *)str{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ MATCHES '^[0-9a-zA-Z][0-9a-zA-Z_+-.]+@[0-9a-zA-Z][0-9a-zA-Z_.-]+.[a-zA-Z]+$'", str];
    BOOL matched = [predicate evaluateWithObject:nil];
    return matched;
}

+ (NSString *)urlencode:(NSString *)plainString
{
	//URLエンコードする
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
																				 (__bridge CFStringRef)plainString,
																				 NULL,
																				 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				 kCFStringEncodingUTF8);
}

+ (NSString *)urldecode:(NSString *)escapedUrlString
{
	//URLデコードする
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
																								 (__bridge CFStringRef)escapedUrlString,
																								 CFSTR(""),
																								 kCFStringEncodingUTF8);
}

// 数字のみか （引数は文字列なので注意）
+ (BOOL)chkNumeric:(NSString *)checkString
{
    @autoreleasepool
    {
        NSCharacterSet *digitCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        bool ret = [self chkCompareString:checkString baseString:digitCharSet];
        return ret;
    }
}

+ (BOOL)chkCompareString:(NSString *)checkString baseString:(NSCharacterSet *)baseString
{
    @autoreleasepool
    {
        NSScanner *aScanner = [NSScanner localizedScannerWithString:checkString];
        // NSScannerはﾃﾞﾌｫﾙﾄでは前後のｽﾍﾟｰｽなどを読み飛ばしてくれるのだが､あえて-setCharactersToBeSkipped:でnilを渡して抑制している｡
        [aScanner setCharactersToBeSkipped:nil];
        
        [aScanner scanCharactersFromSet:baseString intoString:NULL];
        return [aScanner isAtEnd];
    }
}


@end
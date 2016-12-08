//
//  AsyncConnection.h
//  BBsample1
//
//  Created by Val F on 13/04/05.
//  Copyright (c) 2013年 ****. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AsyncConnectionDelegate;

@interface AsyncConnection : NSObject{
    //NSURLRequest *request;
}

//+ (id)instance;

- (void)asyncConnect:(NSURLRequest *)request;

@property (nonatomic, assign) id <AsyncConnectionDelegate> delegate;
//@property (nonatomic, retain) NSURLRequest *request;

@end


@protocol AsyncConnectionDelegate
- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response;
@end
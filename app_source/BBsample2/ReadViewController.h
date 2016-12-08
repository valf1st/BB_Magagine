//
//  ReadViewController.h
//  BBsample1
//
//  Created by FukudaAkali on 2015/03/16.
//  Copyright (c) 2015年 FukudaAkali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FunctionsDefined.h"
#import "AsyncConnection.h"

@interface ReadViewController : UIViewController<UIScrollViewDelegate, AsyncConnectionDelegate>{
    AsyncConnection *async;
    IBOutlet UIProgressView *pv;
}

@property(nonatomic, retain) IBOutlet UIProgressView *pv;
@property(nonatomic, retain) IBOutlet UIImageView *iv1, *iv2, *iv3;

- (void) progress:(NSNumber *)amount;
- (void) preview:(NSString *)path;

@property (strong, nonatomic) IBOutlet UIScrollView *ssv;
@property (strong, nonatomic) IBOutlet UIImageView *iv;

@property (nonatomic,copy) NSString *cid;
@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *page;

@end

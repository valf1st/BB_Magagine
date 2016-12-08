//
//  DownloadViewController.h
//  BBsample1
//
//  Created by FukudaAkali on 2015/02/27.
//  Copyright (c) 2015年 FukudaAkali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncConnection.h"
#import "FunctionsDefined.h"
#import "ReadViewController.h"

@interface DownloadViewController : UIViewController<AsyncConnectionDelegate>{
    AsyncConnection *async;
    IBOutlet UIProgressView *pv;
}

@property(nonatomic, retain) IBOutlet UIProgressView *pv;
@property(nonatomic, retain) IBOutlet UIImageView *iv, *iv1, *iv2, *iv3;

- (void) progress:(NSNumber *)amount;
- (void) preview:(NSString *)path;

@end

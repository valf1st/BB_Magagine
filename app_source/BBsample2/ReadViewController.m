//
//  ReadViewController.m
//  BBsample1
//
//  Created by FukudaAkali on 2015/03/16.
//  Copyright (c) 2015年 FukudaAkali. All rights reserved.
//

#import "ReadViewController.h"

@interface ReadViewController ()

@end

@implementation ReadViewController

@synthesize pv;
@synthesize iv1, iv2, iv3;

UIScrollView *sv;
int width, height, pc;
int k=1;
NSString *tn1, *tn2;
NSInteger currentpage;
NSArray *links;
UIView *blackview;

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    [UINavigationBar appearance].barTintColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    width = [[UIScreen mainScreen] bounds].size.width;
    height = [[UIScreen mainScreen] bounds].size.height;
    currentpage = 1;

    self.view.backgroundColor = [UIColor blackColor];

    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    [UINavigationBar appearance].barTintColor = [UIColor blackColor];
    //ナビゲーションバーにボタンを追加
    UIButton *mailbtn = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 80, 44)];
    [mailbtn setBackgroundImage:[UIImage imageNamed:@"Info.png"] forState:UIControlStateNormal];
    [mailbtn addTarget:self action:@selector(review:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* barbtn = [[UIBarButtonItem alloc] initWithCustomView:mailbtn];
    self.navigationItem.rightBarButtonItems = @[barbtn];

    int stbar = [[UIApplication sharedApplication] statusBarFrame].size.height;
    int nvbar = self.navigationController.navigationBar.frame.size.height;
    float y = (float)(height-stbar-nvbar-width*1.294)/2 + stbar + nvbar;
    NSLog(@"y = %f", y);

    NSLog(@"num = %@", _num);
    int num = _num.intValue;
    int fpage = _page.intValue;
    //pages
    NSString *homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSError *error;
    //NSArray *list = [fileManager contentsOfDirectoryAtPath:homeDir error:&error];
    if([FunctionsDefined chkNumeric:_cid]){
        NSString *dir = [NSString stringWithFormat:@"%@/%@", homeDir, _cid];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *er;
        NSArray *pages = [fm contentsOfDirectoryAtPath:dir error:&er];

        //scrollview
        //sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, width, width*1.294)];
        pc = (int)[pages count];
        if(num > pc){
            NSLog(@"not complete!");
            sv.contentSize = CGSizeMake(width*(pc+1), width*1.294);
            //黒くする
            blackview = [[UIView alloc] initWithFrame:CGRectMake(width*pc, 0, width, height)];
            blackview.backgroundColor = [UIColor blackColor];
            [sv addSubview:blackview];
        }else{
            sv.contentSize = CGSizeMake(width*pc, width*1.294);
        }
        sv.backgroundColor = [UIColor blackColor];
        sv.pagingEnabled = YES;
        sv.delegate = self;
        sv.tag = 100;
        [self.view addSubview:sv];
        sv.contentOffset = CGPointMake(0, width*fpage);

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *directory = [paths objectAtIndex:0];
        NSString *filename = [NSString stringWithFormat:@"data%@.plist", _cid];
        NSString *filePath = [directory stringByAppendingPathComponent:filename];
        links = [[NSArray alloc] initWithContentsOfFile:filePath];
        NSLog(@"array = %@", links);

        for (int i=0 ; i<[pages count] ; i++) {
            NSString *page = [NSString stringWithFormat:@"%@/%@", dir, [pages objectAtIndex:i]];
            //NSLog(@"page = %@", page);
            UIImage *image = [UIImage imageWithContentsOfFile:page];

            _ssv = [[UIScrollView alloc] initWithFrame:CGRectMake(width*i, 0, width, width*1.294)];
            _ssv.pagingEnabled = NO;
            _ssv.backgroundColor = [UIColor grayColor];
            [sv addSubview:_ssv];
            _ssv.delegate = self;
            _ssv.delaysContentTouches = NO;
            _ssv.maximumZoomScale = 20.0;
            _ssv.minimumZoomScale = 1.0;
            //_ssv.zoomScale = 1.0;
            _ssv.tag = -i-1;

            _iv = [[UIImageView alloc] initWithImage:image];
            _iv.frame = CGRectMake(0, 0, width, width*1.294);
            [_ssv addSubview:_iv];
            _iv.tag = i+1;

            //リンクはる
            for(int j=0 ; j<[links count] ; j++){
                NSArray *link = [links objectAtIndex:j];
                int linkpage = [[link valueForKeyPath:@"page"] intValue];
                int section = [[link valueForKeyPath:@"section"] intValue];
                if(linkpage == i+1){
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    if(section == 1){
                        btn.frame = CGRectMake(0, 0, width/2, width*0.3235);
                    }else if(section == 2){
                        btn.frame = CGRectMake(width/2, 0, width/2, width*0.3235);
                    }else if(section == 3){
                        btn.frame = CGRectMake(0, width*0.3235, width/2, width*0.3235);
                    }else if(section == 4){
                        btn.frame = CGRectMake(width/2, width*0.3235, width/2, width*0.3235);
                    }else if(section == 5){
                        btn.frame = CGRectMake(0, width*0.647, width/2, width*0.3235);
                    }else if(section == 6){
                        btn.frame = CGRectMake(width/2, width*0.647, width/2, width*0.3235);
                    }else if(section == 7){
                        btn.frame = CGRectMake(0, width*0.9705, width/2, width*0.3235);
                    }else if(section == 8){
                        btn.frame = CGRectMake(width/2, width*0.9705, width/2, width*0.3235);
                    }
                    [btn setBackgroundImage:[UIImage imageNamed:@"link.png"] forState:UIControlStateNormal];
                    [_ssv addSubview:btn];
                    [btn addTarget:self action:@selector(gotolink:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag = j;
                }
            }
        }
        //[sv setContentOffset: CGPointMake(sv.contentOffset.x, 0)];<-きかない
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [sv setContentOffset: CGPointMake(sv.contentOffset.x, 0)];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    int tag = (int)currentpage;
    NSLog(@"tag = %d", tag);
    UIImageView *iv = (UIImageView *)[sv viewWithTag:tag];
    return iv;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    if(scrollView.tag == 100){
        NSInteger page = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width) + 1;
        if (currentpage != page){
            NSLog(@"page moved %ld", (long)page);
            [sv setContentOffset: CGPointMake(sv.contentOffset.x, 0)];

            int tag = (int)currentpage;
            UIImageView *iv = (UIImageView *)[sv viewWithTag:tag];
            iv.transform = CGAffineTransformIdentity;
            iv.frame = CGRectMake(0, 0, width, width*1.294);
            UIScrollView *ssv = (UIScrollView *)[sv viewWithTag:-tag];
            ssv.contentSize = CGSizeMake(width, width*1.294);

            currentpage = page;

            //続きをダウンロード
            if(currentpage == pc+1){
                //プログレスバー出す
                pv = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
                pv.frame = CGRectMake(60, height-width*0.90, width-120, 30);
                pv.trackTintColor = [UIColor whiteColor];
                pv.progress = 0;
                [blackview addSubview:pv];
                //通信
                NSString *data = [NSString stringWithFormat:@"cid=%@&page=%d", _cid, (int)pc];
                NSURL *url = [NSURL URLWithString:URL_DOWNLOAD_REST];
                NSURLRequest *request = [FunctionsDefined postRequest:data url:url timeout:30];
                async = [AsyncConnection alloc];
                async.delegate = self;
                [async asyncConnect:request];
            }
        }
    }
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        NSLog(@"response = %@", response);
        
        //NSString *cid = [response valueForKeyPath:@"cid"];
        
        NSArray *images = [response valueForKey:@"images"];
        for(int i=0 ; i<[images count] ; i++){
            NSString *filename = [images objectAtIndex:i];
            NSLog(@"filename = %@", filename);
            NSString *str = [NSString stringWithFormat:@"%@/%@", URL_CONTENTS, filename];
            NSArray *file = [filename componentsSeparatedByString:@"/"];
            NSString *folder = [file objectAtIndex:0];
            
            NSLog(@"str = %@", str);
            NSURL *url = [NSURL URLWithString:str];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageWithData:data];
            NSData *jpg = UIImageJPEGRepresentation(img, 0.8f);
            
            NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            dir = [dir stringByAppendingPathComponent:folder];
            NSLog(@"dir = %@", dir); //Documents/1
            [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:nil];
            
            NSString *path = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], filename];
            NSLog(@"path = %@", path);
            if ([jpg writeToFile:path atomically:YES]) {
                NSLog(@"save OK");
                [self performSelectorInBackground:@selector(preview:) withObject:path];
                //pv.progress = (i+1)/[response count];
                float f = (float)(i+1)/[images count];
                NSLog(@"float = %f", f);
                NSString *num = [NSString stringWithFormat:@"%f", f];
                NSLog(@"num = %@", num);
                [self performSelectorInBackground:@selector(progress:) withObject:num];
                if(f >= 1.00){
                    [blackview removeFromSuperview];
                    //ダウンロード済んだら自動でいちど戻ってからまたreadページへ
                    //戻る
                    [self.navigationController popViewControllerAnimated:YES];
                    // 通知の受取側に送る値を作成する
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                         _cid, @"cid",
                                         [NSString stringWithFormat:@"%d", pc], @"page",
                                         _num, @"num", nil];
                    // 通知を作成する
                    NSNotification *n =
                    [NSNotification notificationWithName:@"d_rest" object:self userInfo:dic];
                    // 通知実行！
                    [[NSNotificationCenter defaultCenter] postNotification:n];
                    /*ReadViewController *read= [self.storyboard instantiateViewControllerWithIdentifier:@"read"];
                    read.cid = [NSString stringWithFormat:@"%d", [cid intValue]];
                    [self.navigationController pushViewController:read animated:YES];
                    [pv removeFromSuperview];
                    [blackview removeFromSuperview];*/
                }
            } else {
                NSLog(@"save NG");
            }
        }
    }
}

// バックグラウンドでprogressを変更
- (void)progress:(NSString *)amount {
    NSLog(@"progress called with amount %@", amount);
    pv.progress = [amount floatValue];
}

- (void)preview:(NSString *)path {
    if(k == 1){
        iv1 = [[UIImageView alloc]initWithFrame:CGRectMake(12, height-width*0.8, width*0.255, width*0.33)];
        iv1.image = [UIImage imageWithContentsOfFile:path];
        [blackview addSubview:iv1];
        /*iv = [[UIImageView alloc]initWithFrame:CGRectMake((width-height*0.466)/2, 70, height*0.466, height*0.6)];
        iv.image = [UIImage imageWithContentsOfFile:path];
        [blackview addSubview:iv];*/
    }else if(k == 2){
        iv2 = [[UIImageView alloc]initWithFrame:CGRectMake(width/3+12, height-width*0.8, width*0.255, width*0.33)];
        iv2.image = [UIImage imageWithContentsOfFile:path];
        [blackview addSubview:iv2];
        tn1 = path;
    }else if(k == 3){
        iv3 = [[UIImageView alloc]initWithFrame:CGRectMake(width/3*2+12, height-width*0.8, width*0.255, width*0.33)];
        iv3.image = [UIImage imageWithContentsOfFile:path];
        [blackview addSubview:iv3];
        tn2 = path;
    }else if(k > 3){
        if(k%2 == 0){
            iv1.image = [UIImage imageWithContentsOfFile:tn1];
            iv2.image = [UIImage imageWithContentsOfFile:tn2];
            tn1 = path;
        }else{
            iv1.image = [UIImage imageWithContentsOfFile:tn2];
            iv2.image = [UIImage imageWithContentsOfFile:tn1];
            tn2 = path;
        }
        iv3.image = [UIImage imageWithContentsOfFile:path];
    }
    k = k+1;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    if(scrollView.tag == 100){
        CGPoint origin = [scrollView contentOffset];
        [scrollView setContentOffset:CGPointMake(origin.x, 0.0)];
    }
}

- (void)gotolink:(UIButton *)sender{
    //NSLog(@"safari %ld", sender.tag);
    NSArray *link = [links objectAtIndex:sender.tag];
    NSString *linkid = [link valueForKeyPath:@"link_id"];
    NSString *str = [NSString stringWithFormat:@"%@/%@", URL_JUMP, linkid];
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)review:(UIBarButtonItem*)sender {
    ReadViewController *info = [self.storyboard instantiateViewControllerWithIdentifier:@"info"];
    [self.navigationController pushViewController:info animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

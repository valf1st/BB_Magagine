//
//  DownloadViewController.m
//  BBsample1
//
//  Created by FukudaAkali on 2015/02/27.
//  Copyright (c) 2015年 FukudaAkali. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController ()

@end

@implementation DownloadViewController
@synthesize pv;
@synthesize iv, iv1, iv2, iv3;

int ct; //通信の種別。1はリスト読み込み，2はダウンロード。
int i = 1;
int height, width, stbar, nvbar;
UIScrollView *vsv;
UIView *blackview;
NSString *tn1, *tn2;
NSMutableDictionary *pagecount;

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"List";

    height = [[UIScreen mainScreen] bounds].size.height;
    width = [[UIScreen mainScreen] bounds].size.width;
    stbar = [[UIApplication sharedApplication] statusBarFrame].size.height;
    nvbar = self.navigationController.navigationBar.frame.size.height;

    pagecount = [NSMutableDictionary dictionary];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if([ud objectForKey:@"cache"] == nil){
        NSLog(@"get them!");
        ct = 1;
        NSString *data = [NSString stringWithFormat:@""];
        NSURL *url = [NSURL URLWithString:URL_DLIST];
        //通信
        NSURLRequest *request = [FunctionsDefined postRequest:data url:url timeout:30];
        async = [AsyncConnection alloc];
        async.delegate = self;
        [async asyncConnect:request];
    }else{
        NSLog(@"draw them!");
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"cache"]];
        NSLog(@"array = %@", array);
        [self draw:array];

        //キャッシュのをとりあえず表示↑したあとで新しいのとりにいく。
        NSLog(@"get them!");
        ct = 1;
        NSString *data = [NSString stringWithFormat:@""];
        NSURL *url = [NSURL URLWithString:URL_DLIST];
        //通信
        NSURLRequest *request = [FunctionsDefined postRequest:data url:url timeout:30];
        async = [AsyncConnection alloc];
        async.delegate = self;
        [async asyncConnect:request];
    }

    //ナビゲーションバーにボタンを追加
    UIButton *mailbtn = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 80, 44)];
    [mailbtn setBackgroundImage:[UIImage imageNamed:@"Info.png"] forState:UIControlStateNormal];
    [mailbtn addTarget:self action:@selector(review:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* mbbtn = [[UIBarButtonItem alloc] initWithCustomView:mailbtn];
    self.navigationItem.rightBarButtonItems = @[mbbtn];

    UIButton *rlbtn = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 44, 44)];
    [rlbtn setBackgroundImage:[UIImage imageNamed:@"Rotation.png"] forState:UIControlStateNormal];
    [rlbtn addTarget:self action:@selector(reload:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rbbtn = [[UIBarButtonItem alloc] initWithCustomView:rlbtn];
    self.navigationItem.leftBarButtonItems = @[rbbtn];

    //通知をうけて続きをダウンロードしたreadviewに再度飛ぶ
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(readrest:) name:@"d_rest" object:nil];
}

- (void)didFinishWithAsyncConnect:(BOOL)load value:(NSArray *)response{
    if(load){
        if(ct == 1){
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSMutableArray* array = [NSMutableArray array];
            for(int i=0 ; i<[response count] ; i++){
                [array addObject:[response objectAtIndex:i]];
            }
            NSData *cache = [NSKeyedArchiver archivedDataWithRootObject:array];
            [ud setObject:cache forKey:@"cache"];
            [ud synchronize];
            NSArray *viewsToRemove = [self.view subviews];
            for (UIView *v in viewsToRemove) {
                [v removeFromSuperview];
            }
            [self draw:response];
        }else{
            NSLog(@"response = %@", response);

            NSString *cid = [response valueForKeyPath:@"cid"];

            NSArray *links = [response valueForKey:@"links"];
            if(links == nil || [links isEqual:[NSNull null]]){
                NSLog(@"リンクなし");
            }else{
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *directory = [paths objectAtIndex:0];
                NSString *filename = [NSString stringWithFormat:@"data%@.plist", cid];
                NSString *filePath = [directory stringByAppendingPathComponent:filename];
                BOOL successful = [links writeToFile:filePath atomically:NO];
                if (successful) {
                    NSLog(@"データの保存に成功");
                }
            }

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
                        //ダウンロード済んだら自動でreadページへ
                        ReadViewController *read= [self.storyboard instantiateViewControllerWithIdentifier:@"read"];
                        read.cid = [NSString stringWithFormat:@"%d", [cid intValue]];
                        read.num = [pagecount objectForKey:[NSString stringWithFormat:@"%d", [cid intValue]]];
                        read.page = @"1";
                        [self.navigationController pushViewController:read animated:YES];
                        [pv removeFromSuperview];
                        [blackview removeFromSuperview];
                    }
                } else {
                    NSLog(@"save NG");
                }
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
    if(i == 1){
        iv1 = [[UIImageView alloc]initWithFrame:CGRectMake(12, height-width*0.33-7, width*0.255, width*0.33)];
        iv1.image = [UIImage imageWithContentsOfFile:path];
        [blackview addSubview:iv1];
        iv = [[UIImageView alloc]initWithFrame:CGRectMake((width-height*0.466)/2, 70, height*0.466, height*0.6)];
        iv.image = [UIImage imageWithContentsOfFile:path];
        [blackview addSubview:iv];
    }else if(i == 2){
        iv2 = [[UIImageView alloc]initWithFrame:CGRectMake(width/3+12, height-width*0.33-7, width*0.255, width*0.33)];
        iv2.image = [UIImage imageWithContentsOfFile:path];
        [blackview addSubview:iv2];
        tn1 = path;
    }else if(i == 3){
        iv3 = [[UIImageView alloc]initWithFrame:CGRectMake(width/3*2+12, height-width*0.33-7, width*0.255, width*0.33)];
        iv3.image = [UIImage imageWithContentsOfFile:path];
        [blackview addSubview:iv3];
        tn2 = path;
    }else if(i > 3){
        if(i%2 == 0){
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
    i = i+1;
}

- (void)download:(UIButton*)sender{
    //ほんとにないか確認
    NSString *homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *dir = [NSString stringWithFormat:@"%@/%ld", homeDir, (long)sender.tag];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *er;
    NSArray *pages = [fm contentsOfDirectoryAtPath:dir error:&er];
    if(!(pages == nil || [pages isEqual:[NSNull null]])){
        if([pages count]>1){
            ReadViewController *read= [self.storyboard instantiateViewControllerWithIdentifier:@"read"];
            read.cid = [NSString stringWithFormat:@"%ld", (long)sender.tag];
            read.num = [pagecount objectForKey:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
            read.page = @"1";
            [self.navigationController pushViewController:read animated:YES];
        }
    }else{
        ct = 2;
        NSString *data = [NSString stringWithFormat:@"cid=%ld", (long)sender.tag];
        NSURL *url = [NSURL URLWithString:URL_DOWNLOAD];

        //黒くする
        blackview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        blackview.backgroundColor = [UIColor blackColor];
        [self.view addSubview:blackview];
        //待ち画像
        UIImage * loading = [UIImage imageNamed:@"Loading.png"];
        UIImageView *liv1 = [[UIImageView alloc] initWithImage:loading];
        UIImageView *liv2 = [[UIImageView alloc] initWithImage:loading];
        UIImageView *liv3 = [[UIImageView alloc] initWithImage:loading];
        liv1.frame = CGRectMake(0, height-width*0.365, width/3, width*0.365);
        liv2.frame = CGRectMake(width/3, height-width*0.365, width/3, width*0.365);
        liv3.frame = CGRectMake(width/3*2, height-width*0.365, width/3, width*0.365);
        [blackview addSubview:liv1];
        [blackview addSubview:liv2];
        [blackview addSubview:liv3];
        
        //プログレスバー出す
        pv = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        pv.frame = CGRectMake(60, height-width*0.70, width-120, 30);
        pv.trackTintColor = [UIColor whiteColor];
        pv.progress = 0;
        [self.view addSubview:pv];
        //pv.tag = -100;
        
        //通信
        NSURLRequest *request = [FunctionsDefined postRequest:data url:url timeout:30];
        async = [AsyncConnection alloc];
        async.delegate = self;
        [async asyncConnect:request];
    }
}

//描画
- (void)draw:(NSArray *)array{
    int h = self.view.frame.size.height;
    NSLog(@"height = %d, h = %d", height, h);
    float y = 0.00;
    vsv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, stbar+nvbar, width, height-stbar-nvbar)];
    //sv.backgroundColor = [UIColor cyanColor];
    vsv.pagingEnabled = YES;
    //sv.delegate = self;
    [self.view addSubview:vsv];

    for(int i=0 ; i<[array count] ; i++){
        NSString *contentinfo = [array objectAtIndex:i];
        if([contentinfo valueForKeyPath:@"content_id"]){
            NSString *contents_id = [contentinfo valueForKeyPath:@"content_id"];
            NSLog(@"strid = %@", contents_id);

            //ダウンロード済みの判定
            NSString *dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *last = [NSString stringWithFormat:@"%@/%@", contents_id, [contentinfo valueForKeyPath:@"last"]];
            [pagecount setObject:[contentinfo valueForKeyPath:@"num"] forKey:contents_id];
            NSString *file = [dir stringByAppendingPathComponent:last];
            if([[NSFileManager defaultManager] fileExistsAtPath:file]){
                // ダウンロード済み
                NSString *directory = [NSString stringWithFormat:@"%@/%@", dir, contents_id];
                NSFileManager *fm = [NSFileManager defaultManager];
                NSError *er;
                NSArray *pages = [fm contentsOfDirectoryAtPath:directory error:&er];
                NSString *cover = [NSString stringWithFormat:@"%@/%@", directory, [pages objectAtIndex:0]];
                NSLog(@"cover = %@", cover);
                UIImage *image = [UIImage imageWithContentsOfFile:cover];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                UILabel *label = [[UILabel alloc] init];
                label.textColor = [UIColor darkGrayColor];
                label.text = [contentinfo valueForKeyPath:@"volume"];
                label.textAlignment = NSTextAlignmentCenter;
                UIButton *bar = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *view = [UIImage imageNamed:@"View.png"];
                [bar setBackgroundImage:view forState:UIControlStateNormal];
                if(i == 0){
                    btn.frame = CGRectMake(15, 40, width/2-10, (width/2-10)*1.294);
                    y = 40.0 + (width/2-10)*1.294;
                    label.frame = CGRectMake(width/2+5, 40, width/2-20, 30);
                    bar.frame = CGRectMake(width/2+10, y-(width/2-25)*0.247, width/2-25, (width/2-25)*0.247);
                    
                    UILabel *caption = [[UILabel alloc] initWithFrame:CGRectMake(width/2+10, 80, width/2-10, 160)];
                    caption.font = [UIFont fontWithName:@"AppleGothic" size:12];
                    [caption setText:[contentinfo valueForKeyPath:@"caption"]];
                    [caption setLineBreakMode:NSLineBreakByWordWrapping];
                    [caption setNumberOfLines:0];
                    [vsv addSubview:caption];
                }else if(i == 1){
                    btn.frame = CGRectMake(15, y+50, width/2-25, (width/2-25)*1.294);
                    label.frame = CGRectMake(20, y+20, 140, 30);
                    bar.frame = CGRectMake(20, y+60+(width/2-25)*1.294, 126, 31);
                }else if(i == 2){
                    btn.frame = CGRectMake(width/2+10, y+50, width/2-25, (width/2-25)*1.294);
                    label.frame = CGRectMake(width/2+15, y+20, 140, 30);
                    bar.frame = CGRectMake(width/2+15, y+60+(width/2-25)*1.294, 126, 31);
                }else if(i == 3){
                    btn.frame = CGRectMake(15, y+95, width/2-25, (width/2-25)*1.294);
                    label.frame = CGRectMake(20, y+65, 140, 30);
                    bar.frame = CGRectMake(20, y+105+(width/2-25)*1.294, 126, 31);
                }
                [btn setBackgroundImage:image forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(read:) forControlEvents:UIControlEventTouchUpInside];
                [bar addTarget:self action:@selector(read:) forControlEvents:UIControlEventTouchUpInside];
                [vsv addSubview:btn];
                btn.tag = [contents_id intValue];
                bar.tag = [contents_id intValue];
                [vsv addSubview:label];
                [vsv addSubview:bar];
            }else{
                // 未ダウンロード
                NSInteger cid = contents_id.integerValue;
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                UIButton *bar = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *free = [UIImage imageNamed:@"Free.png"];
                [bar setBackgroundImage:free forState:UIControlStateNormal];
                UILabel *label = [[UILabel alloc] init];
                label.textColor = [UIColor darkGrayColor];
                label.text = [contentinfo valueForKeyPath:@"volume"];
                label.textAlignment = NSTextAlignmentCenter;
                if(i == 0){
                    btn.frame = CGRectMake(15, 40, width/2-10, (width/2-10)*1.294);
                    y = 40.0 + (width/2-10)*1.294;
                    label.frame = CGRectMake(width/2+5, 50, width/2-20, 30);
                    bar.frame = CGRectMake(width/2+10, y-(width/2-25)*0.247, width/2-25, (width/2-25)*0.247);
                    
                    UILabel *caption = [[UILabel alloc] initWithFrame:CGRectMake(width/2+10, 60, width/2-10, 160)];
                    caption.adjustsFontSizeToFitWidth = YES;
                    caption.font = [UIFont fontWithName:@"AppleGothic" size:12];
                    [caption setText:[contentinfo valueForKeyPath:@"caption"]];
                    [caption setLineBreakMode:NSLineBreakByWordWrapping];
                    [caption setNumberOfLines:0];
                    [vsv addSubview:caption];
                }else if(i == 1){
                    btn.frame = CGRectMake(15, y+50, width/2-25, (width/2-25)*1.294);
                    label.frame = CGRectMake(20, y+20, 140, 30);
                    bar.frame = CGRectMake(20, y+60+(width/2-25)*1.294, 126, 31);
                }else if(i == 2){
                    btn.frame = CGRectMake(width/2+10, y+50, width/2-25, (width/2-25)*1.294);
                    label.frame = CGRectMake(width/2+15, y+20, 140, 30);
                    bar.frame = CGRectMake(width/2+15, y+60+(width/2-25)*1.294, 126, 31);
                }else if(i == 3){
                    btn.frame = CGRectMake(15, y+95, width/2-25, (width/2-25)*1.294);
                    label.frame = CGRectMake(20, y+65, 140, 30);
                    bar.frame = CGRectMake(20, y+105+(width/2-25)*1.294, 126, 31);
                }
                NSString *imgurl = [NSString stringWithFormat:@"%@/%@/thumb.jpg", URL_CONTENTS, contents_id];
                NSLog(@"imgurl = %@", imgurl);
                NSURL *url = [NSURL URLWithString:imgurl];
                NSData * imgdata = [NSData dataWithContentsOfURL:url];
                UIImage *img = [UIImage imageWithData:imgdata];
                [btn setBackgroundImage:img forState:UIControlStateNormal];
                [vsv addSubview:btn];
                [btn addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
                [bar addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = cid;
                bar.tag = cid;
                [vsv addSubview:bar];
                [vsv addSubview:label];
            }
        }
        if(i == 0){
            UIImage *oi = [UIImage imageNamed:@"OtherIssues.png"];
            UIImageView *oiv = [[UIImageView alloc] initWithImage:oi];
            oiv.frame = CGRectMake(10, y+30, width-20, width/10-2);
            [vsv addSubview:oiv];
            vsv.contentSize = CGSizeMake(width, 700);
            y = y + 30.0 + width/10-2;
        }else if(i == 1){
            UIImage *dl = [UIImage imageNamed:@"Dotline.png"];
            UIImageView *dlv = [[UIImageView alloc] initWithImage:dl];
            dlv.frame = CGRectMake(width/2, y+30, (width/2-25)*0.0083, (width/2-25)*1.7);
            [vsv addSubview:dlv];
        }else if(i == 2){
            vsv.contentSize = CGSizeMake(width, 700);
            y = y + 50 + (width/2-25)*1.294;
            vsv.contentSize = CGSizeMake(width, y+width);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)read:(UIButton *)sender {
    ReadViewController *read= [self.storyboard instantiateViewControllerWithIdentifier:@"read"];
    read.cid = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    read.num = [pagecount objectForKey:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
    read.page = @"1";
    //ページ遷移
    //ViewController *rem = [self.storyboard instantiateViewControllerWithIdentifier:@"read"];
    [self.navigationController pushViewController:read animated:YES];
}

- (void)review:(UIBarButtonItem*)sender {
    DownloadViewController *info = [self.storyboard instantiateViewControllerWithIdentifier:@"info"];
    [self.navigationController pushViewController:info animated:YES];
}

- (void)reload:(UIBarButtonItem*)sender {
    NSLog(@"get them again!");
    ct = 1;
    NSString *data = [NSString stringWithFormat:@""];
    NSURL *url = [NSURL URLWithString:URL_DLIST];
    //通信
    NSURLRequest *request = [FunctionsDefined postRequest:data url:url timeout:30];
    async = [AsyncConnection alloc];
    async.delegate = self;
    [async asyncConnect:request];
}

-(void)readrest:(NSNotification*)center{
    //通知パラメータ受け取る
    NSString *cid = [center.userInfo objectForKey:@"cid"];
    NSString *page = [center.userInfo objectForKey:@"page"];
    NSString *num = [center.userInfo objectForKey:@"num"];
    //遷移
    ReadViewController *read= [self.storyboard instantiateViewControllerWithIdentifier:@"read"];
    read.cid = cid;
    read.num = num;
    read.page = page;
    //ページ遷移
    //ViewController *rem = [self.storyboard instantiateViewControllerWithIdentifier:@"read"];
    [self.navigationController pushViewController:read animated:YES];
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

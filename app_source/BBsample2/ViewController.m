//
//  ViewController.m
//  BBsample2
//
//  Created by FukudaAkali on 2015/03/16.
//  Copyright (c) 2015年 FukudaAkali. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor blueColor]}];
    self.navigationItem.title = @"TOP";

    //ナビゲーションバーにボタンを追加
    UIButton *mailbtn = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 60, 44)];
    [mailbtn setBackgroundImage:[UIImage imageNamed:@"Plus.png"] forState:UIControlStateNormal];
    [mailbtn addTarget:self action:@selector(review:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* barbtn = [[UIBarButtonItem alloc] initWithCustomView:mailbtn];
    self.navigationItem.rightBarButtonItems = @[barbtn];
    
    UIButton *rmbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rmbtn.frame = CGRectMake(60, 170, 200, 35);
    [rmbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rmbtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [rmbtn setTitle:@"Download" forState:UIControlStateNormal];
    rmbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:rmbtn];
    [rmbtn addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated{
    NSString *homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:homeDir error:&error];
    // ファイルやディレクトリの一覧を表示する
    int j = 0;
    for (NSString *path in list) {
        if([FunctionsDefined chkNumeric:path]){
            NSString *dir = [NSString stringWithFormat:@"%@/%@", homeDir, path];
            NSFileManager *fm = [NSFileManager defaultManager];
            NSError *er;
            NSArray *pages = [fm contentsOfDirectoryAtPath:dir error:&er];
            for (int i=0 ; i<[pages count] ; i++) {
                if(i == 0){
                    NSString *cover = [NSString stringWithFormat:@"%@/%@", dir, [pages objectAtIndex:i]];
                    NSLog(@"cover = %@", cover);
                    UIImage *image = [UIImage imageWithContentsOfFile:cover];
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 300+100*j, 150, 210)];
                    [btn setBackgroundImage:image forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(read:) forControlEvents:UIControlEventTouchUpInside];
                    btn.tag = [path intValue];
                    [self.view addSubview:btn];
                }
            }
            j = j + 1;
        }
        NSLog(@"path = %@", path);
    }
}

- (void)download:(id)sender {
    //ページ遷移
    ViewController *rem = [self.storyboard instantiateViewControllerWithIdentifier:@"dl"];
    [self.navigationController pushViewController:rem animated:YES];
}

- (void)read:(UIButton *)sender {
    ReadViewController *read= [self.storyboard instantiateViewControllerWithIdentifier:@"read"];
    read.cid = [NSString stringWithFormat:@"%d", sender.tag];
    //ページ遷移
    //ViewController *rem = [self.storyboard instantiateViewControllerWithIdentifier:@"read"];
    [self.navigationController pushViewController:read animated:YES];
}

- (void)review:(UIBarButtonItem*)sender {
    ViewController *info = [self.storyboard instantiateViewControllerWithIdentifier:@"info"];
    [self.navigationController pushViewController:info animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

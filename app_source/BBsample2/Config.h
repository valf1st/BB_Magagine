//
//  Config.h
//  BBsample2
//
//  Created by FukudaAkali on 2015/03/16.
//  Copyright (c) 2015年 FukudaAkali. All rights reserved.
//

#define MAIN_URL @"http://bbsample.vf-1st.biz"

//ダウンロード可能一覧
#define URL_DLIST [NSString stringWithFormat:@"%@/dlist", MAIN_URL]

//コンテンツ画像
#define URL_CONTENTS [NSString stringWithFormat:@"%@/contents", MAIN_URL]
//ダウンロード
#define URL_DOWNLOAD [NSString stringWithFormat:@"%@/dlist/download", MAIN_URL]
//続きをダウンロード
#define URL_DOWNLOAD_REST [NSString stringWithFormat:@"%@/dlist/drest", MAIN_URL]
//リンク
#define URL_JUMP [NSString stringWithFormat:@"%@/count/link", MAIN_URL]
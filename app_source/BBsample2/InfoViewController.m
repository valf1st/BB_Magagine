//
//  InfoViewController.m
//  BBsample2
//
//  Created by FukudaAkali on 2015/04/17.
//  Copyright (c) 2015年 FukudaAkali. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor blueColor]}];
    self.navigationItem.title = @"Info";

    int width = [[UIScreen mainScreen] bounds].size.width;
    int height = [[UIScreen mainScreen] bounds].size.height;
    //int stbar = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //int nvbar = self.navigationController.navigationBar.frame.size.height;

    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    sv.pagingEnabled = YES;
    [self.view addSubview:sv];

    UIImage *logo = [UIImage imageNamed:@"Logo.png"];
    UIImageView *logov = [[UIImageView alloc] initWithImage:logo];
    logov.frame = CGRectMake(70, 80, width-140, (width-140)*0.39);
    [sv addSubview:logov];

    UILabel *labelv = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, width-50, 30)];
    [labelv setText:@"Version 1.0"];
    labelv.textAlignment = NSTextAlignmentCenter;
    labelv.font = [UIFont fontWithName:@"AppleGothic" size:12];
    [sv addSubview:labelv];
    UILabel *labela = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, width-50, 30)];
    [labela setText:@"Bento Box Communications Inc."];
    labela.textAlignment = NSTextAlignmentCenter;
    labela.font = [UIFont fontWithName:@"AppleGothic" size:12];
    [sv addSubview:labela];

    UIButton *hbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hbtn setBackgroundImage:[UIImage imageNamed:@"Home.png"] forState:UIControlStateNormal];
    hbtn.frame = CGRectMake(width*0.2-25, 200, 50, 50);
    hbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sv addSubview:hbtn];
    [hbtn addTarget:self action:@selector(gotohome:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *fbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fbtn setBackgroundImage:[UIImage imageNamed:@"FB.png"] forState:UIControlStateNormal];
    fbtn.frame = CGRectMake(width*0.4-25, 200, 50, 50);
    fbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sv addSubview:fbtn];
    [fbtn addTarget:self action:@selector(gotofb:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *tbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tbtn setBackgroundImage:[UIImage imageNamed:@"TW.png"] forState:UIControlStateNormal];
    tbtn.frame = CGRectMake(width*0.6-25, 200, 50, 50);
    tbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sv addSubview:tbtn];
    [fbtn addTarget:self action:@selector(gototw:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *mbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mbtn setBackgroundImage:[UIImage imageNamed:@"Mail.png"] forState:UIControlStateNormal];
    mbtn.frame = CGRectMake(width*0.8-25, 208, 50, 37);
    mbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sv addSubview:mbtn];
    [mbtn addTarget:self action:@selector(mailc:) forControlEvents:UIControlEventTouchUpInside];

    UIImage *tac = [UIImage imageNamed:@"TaC.png"];
    UIImageView *tacv = [[UIImageView alloc] initWithImage:tac];
    tacv.frame = CGRectMake(10, 260, width-20, (width-20)*0.124);
    [sv addSubview:tacv];

    UILabel *labelm = [[UILabel alloc] initWithFrame:CGRectMake(20, 280, width-50, 2800)];
    [labelm setText:@"PLEASE READ THESE TERMS AND CONDITIONS OF USE CAREFULLY BEFORE USING THIS WEBSITE AS THEY CONTAIN THE LEGAL TERMS THAT GOVERN YOUR USE OF BENTO BOX MAGAZINE VIEWER AND RELATED SITES.\n\nAccess to and use of BENTO BOX magazine viewer is subject to BENTO BOX COMMUNICATIONS INC’s Privacy Code, Commenting Guidelines and the terms and conditions set out below (collectively, the “Terms and Conditions”). If you do not agree with these Terms and Conditions, please do not access or use BENTO BOX magazine viewer.\n\nWe reserve the right to change these Terms and Conditions from time to time by updating this posting. Please check the Terms and Conditions periodically for changes. Your continued use of BENTO BOX magazine viewer following the posting of these Terms and Conditions will mean you accept those changes.\n\nRestrictions on Use of Materials\n\nBENTO BOX magazine viewer and its contents are the property of BENTO BOX COMMUNICATIONS INC. (“BENTO BOX MAGAZINE”) or its licensors and are protected, without limitation, pursuant to Canadian and foreign copyright and trademark laws.\n\nReproduction, duplication, or distribution of BENTO BOX magazine viewer and/or all or any part of their contents for anything other than your personal, non-commercial use is a violation not only of these Terms and Conditions but also of copyright and trademark laws (unless you have written permission from BENTO BOX MAGAZINE). The content on BENTO BOX magazine viewer is made available to you for non-commercial, personal, or educational purposes only. Nothing contained herein shall be construed as conferring any right under any copyright of BENTO BOX MAGAZINE or any other person who owns the copyright in the content provided on BENTO BOX magazine viewer.\n\nAll trademarks and trade names are trademarks or registered trademarks of BENTO BOX MAGAZINE or its affiliated companies or are the trademarks of their respective owners. The display of trademarks or trade names on each of the websites does not convey or create any license or other rights in these marks or names. Any unauthorized use of these trademarks and trade names is strictly prohibited.\n\nJurisdiction and Governing Law\n\nBENTO BOX magazine viewer is controlled and operated by BENTO BOX MAGAZINE. Its offices are located in Canada. If you choose to access these Websites from another location, you are responsible for compliance with local laws, if and to the extent local laws are applicable.\n\nThese Terms and Conditions shall be governed by and construed in accordance with the laws of Canada, without giving effect to any principles of conflicts of law. You agree that any action at law or in equity arising out of or in connection with these Terms and Conditions or BENTO BOX magazine viewer shall be filed only in the provincial or federal courts located in Canada and hereby submit to the nonexclusive jurisdiction of such courts. You also agree that regardless of any statute or law to the contrary, any claim or cause of action arising out of or related to use of BENTO BOX magazine viewer or the Terms and   Conditions must be filed within one (1) year after such claim or cause of action arose or be forever barred.\n\nExcept where prohibited by applicable law, you agree to waive any right you may have to commence or participate in any class action against us related to any claim and, where applicable, you also agree to opt out of any class proceedings against us.\n\nUser Conduct, Indemnification and Licence Granted\n\nYOU AGREE TO INDEMNIFY AND HOLD HARMLESS EACH OF BENTO BOX MAGAZINE, ITS PARENT, AFFILIATES, AND RELATED COMPANIES AND THEIR RESPECTIVE OFFICERS, DIRECTORS, EMPLOYEES AND AGENTS FROM AND AGAINST ANY AND ALL CLAIMS, ACTIONS OR DEMANDS, INCLUDING WITHOUT LIMITATION REASONABLE LEGAL AND ACCOUNTING FEES RESULTING FROM OR RELATED TO ANY BREACH OF THESE TERMS AND CONDITIONS, YOUR ACCESS TO OR USE OF BENTO BOX MAGAZINE VIEWER OR YOUR USE OF OR RELIANCE ON OR PUBLICATION, COMMUNICATION OR DISTRIBUTION OF ANYTHING FROM BENTO BOX MAGAZINE VIEWER.\n\nYou shall use your best efforts to cooperate with us in the defence of any claim. We reserve the right, at our own expense, to assume the exclusive control of any matter otherwise subject to indemnification by you.\n\nTermination of Access\n\nYou agree that BENTO BOX MAGAZINE, in its sole discretion, may suspend or terminate the use of BENTO BOX magazine viewer and remove and discard any Postings at its convenience or for any reason. You agree that any suspension and/or termination of your access to BENTO BOX magazine viewer may be effected without prior notice and that BENTO BOX MAGAZINE will not be liable to you or to any other person as a result of any such suspension or termination.\n\nLinks to Third Party Sites\n\nUsers may, through hypertext or other computer “links,” gain access to other sites on the Internet which are not part of BENTO BOX magazine viewer and which are not controlled by BENTO BOX MAGAZINE. BENTO BOX MAGAZINE is providing these links to you only as a convenience, and the inclusion of any link does not imply endorsement by BENTO BOX MAGAZINE of the site. BENTO BOX MAGAZINE ASSUMES NO RESPONSIBILITY FOR ANY MATERIAL OUTSIDE OF BENTO BOX MAGAZINE VIEWER WHICH MAY BE ACCESSED THROUGH ANY SUCH LINK.\n\nDISCLAIMER OF WARRANTIES AND LIMITATION OF LIABILITY\n\nTO THE FULLEST EXTENT PERMITTED BY LAW, BENTO BOX MAGAZINE IS PROVIDING BENTO BOX MAGAZINE VIEWER ON AN “AS IS” AND “AS AVAILABLE” BASIS AND MAKES NO WARRANTIES OR REPRESENTATIONS, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, IN ANY CONNECTION WITH BENTO BOX MAGAZINE VIEWER, THEIR CONTENTS, OR ANY WEBSITE OR CONTENTS WITH WHICH IT IS LINKED.  BENTO BOX MAGAZINE DOES NOT WARRANT THAT THE FUNCTION OF BENTO BOX MAGAZINE VIEWER OR THEIR CONTENTS WILL BE UNINTERRUPTED OR ERROR FREE, THAT DEFECTS WILL BE CORRECTED, OR THAT BENTO BOX MAGAZINE VIEWER OR THE SERVERS THAT MAKE IT AVAILABLE ARE FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS.\n\nTO THE FULLEST EXTENT PERMITTED BY LAW, UNDER NO CIRCUMSTANCES, INCLUDING, BUT NOT LIMITED TO, NEGLIGENCE, SHALL BENTO BOX MAGAZINE BE LIABLE FOR ANY LOSS OF USE, LOSS OF DATA, LOSS OF INCOME OR PROFIT, LOSS OF OR DAMAGE TO PROPERTY, OR FOR ANY DAMAGES OF ANY KIND OR CHARACTER (INCLUDING WITHOUT LIMITATION ANY COMPENSATORY, INCIDENTAL, DIRECT, INDIRECT, SPECIAL, PUNITIVE, OR CONSEQUENTIAL DAMAGES), EVEN IF BENTO BOX MAGAZINE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES OR LOSSES, ARISING OUT OF OR IN CONNECTION WITH THE USE OF BENTO BOX MAGAZINE VIEWER, THEIR CONTENTS, OR ANY WEBSITE OR CONTENTS WITH WHICH IT IS LINKED. IN NO EVENT SHALL BENTO BOX MAGAZINE’S TOTAL LIABILITY FOR ALL DAMAGES, LOSSES, AND CAUSES OF ACTION, WHETHER IN CONTRACT, TORT (INCLUDING, BUT NOT LIMITED TO, NEGLIGENCE), OR OTHERWISE, EXCEED THE AMOUNT PAID BY YOU FOR ACCESSING THIS SITE.\n\nMedical/Health Information Disclaimer\n\nSome of BENTO BOX magazine viewer may contain medical and health information.  Such information is for informational purposes only and is not to be used or construed as a substitute for professional medical advice, diagnosis or treatment."];
    [labelm setLineBreakMode:NSLineBreakByWordWrapping];
    labelm.font = [UIFont fontWithName:@"AppleGothic" size:11];
    [labelm setNumberOfLines:0];
    [sv addSubview:labelm];

    sv.contentSize = CGSizeMake(width, 3000);
}

- (void)gotohome:(UIButton *)sender{
    NSString *str = [NSString stringWithFormat:@"http://google.co.uk"];
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)gotofb:(UIButton *)sender{
    NSString *str = [NSString stringWithFormat:@"http://google.co.uk"];
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)gototw:(UIButton *)sender{
    NSString *str = [NSString stringWithFormat:@"http://google.co.uk"];
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)mailc:(id)sender {
    // メールビュー生成
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    // メール件名
    [picker setSubject:@"About Bento Box mag app"];
    // メール本文
    NSString *body = [NSString stringWithFormat:@"Contents:\nName:\n\nDetails:\n\niOS: %@\nTerminal Model: %@\nVer: %@", [UIDevice currentDevice].systemVersion, [UIDevice currentDevice].model, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [picker setMessageBody:body isHTML:NO];
    // メールビュー表示
    [self presentViewController:picker animated:YES completion:nil];
}

// アプリ内メーラーのデリゲートメソッド
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            // キャンセル
            break;
        case MFMailComposeResultSaved:
            // 保存 (ここでアラート表示するなど何らかの処理を行う)
            break;
        case MFMailComposeResultSent:
            // 送信成功 (ここでアラート表示するなど何らかの処理を行う)
            break;
        case MFMailComposeResultFailed:
            // 送信失敗 (ここでアラート表示するなど何らかの処理を行う)
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  GJCFCoreTextDemoViewController.m
//  GJCommonFoundation
//
//  Created by ZYVincent on 14-9-21.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "GJCFCoreTextDemoViewController.h"
#import <CoreText/CoreText.h>
#import "GJCFCoreTextAttributedStringStyle.h"
#import "GJCFCoreTextParagraphStyle.h"
#import "GJCFCoreTextContentView.h"
#import "GJCFCoreTextKeywordAttributedStringStyle.h"
#import "GJCFCoreTextImageAttributedStringStyle.h"

@interface GJCFCoreTextDemoViewController ()

@property (nonatomic,strong)GJCFCoreTextContentView *contentTextView;

@end

@implementation GJCFCoreTextDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentTextView = [[GJCFCoreTextContentView alloc]initWithFrame:(CGRect){10,100,300,40}];
    self.contentTextView.isLongPressShowSelectedState = YES;
    self.contentTextView.shadowColor = [UIColor lightGrayColor];
    self.contentTextView.shadowOffset = CGSizeMake(0, 0.3);
    [self.view addSubview:self.contentTextView];
    
    NSString *testString = @"这[微笑][微笑]我额们敢见关键字什么的[微笑]关[微笑][微笑]我额们敢见关键字什么的[微笑]我额们敢见关键字什么的[微笑][微笑]哈啊啊啊啊啊啊啊喀什卡德罗夫就阿萨德发";
    
    NSMutableString *mString = [NSMutableString stringWithString:testString];
    NSLog(@"mtableString before:%@",mString);

    NSMutableArray *resultArray = [NSMutableArray array];
    [self parseEmoji:[mString mutableCopy] withEmojiTempString:nil withResultArray:resultArray];
    
    [self.contentTextView appendImageTag:@"imageTag"];
    
    for (NSDictionary *emojiItem in resultArray) {
        
        NSString *emoji = [emojiItem objectForKey:@"emoji"];

        NSLog(@"emojiRange:%@",emoji);
        
        /* 替换表情为空格 */
        [mString replaceOccurrencesOfString:emoji withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, mString.length)];
    }
    NSLog(@"mtableString:%@",mString);
    
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc]initWithString:mString];
    
    GJCFCoreTextAttributedStringStyle *attributedStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
    attributedStyle.foregroundColor = [UIColor blackColor];
    attributedStyle.font = [UIFont systemFontOfSize:18];
    attributedStyle.characterGap = 1.f;
    [contentString insertAttributedStringStyle:attributedStyle range:[contentString range]];
    
    /* 段落属性 */
    GJCFCoreTextParagraphStyle *paragraphStyle = [[GJCFCoreTextParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = kCTLineBreakByCharWrapping;
    paragraphStyle.mutilRowHeight = 1.2f;
    [contentString insertParagraphStyle:paragraphStyle range:[contentString range]];

    /* 寻找关键字的范围数组 */
    GJCFCoreTextKeywordAttributedStringStyle *keywordStyle = [[GJCFCoreTextKeywordAttributedStringStyle alloc]init];
    keywordStyle.keyword = @"关键字";
    keywordStyle.keywordColor = [UIColor blueColor];
    keywordStyle.font = [UIFont boldSystemFontOfSize:16];
    keywordStyle.preGap = 1.f;
    keywordStyle.endGap = 3.f;
    keywordStyle.innerGap = 0.f;
    keywordStyle.underLineColor = [UIColor redColor];
    keywordStyle.underLineStyle = kCTUnderlinePatternDash;
    [contentString setKeywordEffectByStyle:keywordStyle];
    
    /* 寻找关键字的范围数组 */
    GJCFCoreTextKeywordAttributedStringStyle *keywordStyle1 = [[GJCFCoreTextKeywordAttributedStringStyle alloc]init];
    keywordStyle1.keyword = @"我们";
    keywordStyle1.keywordColor = [UIColor redColor];
    keywordStyle1.font = [UIFont boldSystemFontOfSize:20];
    keywordStyle1.preGap = 1.f;
    keywordStyle1.endGap = 20.f;
    keywordStyle1.innerGap = 0.f;
    keywordStyle1.underLineColor = [UIColor blueColor];
    keywordStyle1.underLineStyle = kCTUnderlinePatternDot;
    [contentString setKeywordEffectByStyle:keywordStyle1];
    
    NSMutableArray *imageInfos = [NSMutableArray array];
    for (NSDictionary *emojiItem in resultArray) {
        
        NSString *emoji = [emojiItem objectForKey:@"emoji"];
        NSRange tempRange = [[emojiItem objectForKey:@"temp"] rangeValue];
        
        
        /* 插入图片 */
        GJCFCoreTextImageAttributedStringStyle *imageStyle = [[GJCFCoreTextImageAttributedStringStyle alloc]init];
        imageStyle.imageTag = @"imageTag";
        imageStyle.imageName = [NSString stringWithFormat:@"%@.jpg",emoji];
        imageStyle.imageSourceString = emoji;
        
        /* 给表情创造一点间隔 */
        NSDictionary *imageInfo = @{kGJCFCoreTextImageInfoRangeKey:[NSValue valueWithRange:tempRange],kGJCFCoreTextImageInfoStringKey:emoji};
        [contentString replaceCharactersInRange:tempRange withAttributedString:[imageStyle imageAttributedString]];

        [imageInfos addObject:imageInfo];
    }


    [self.contentTextView setContentAttributedString:contentString];
    [self.contentTextView replaceAllImageInfosWithArray:imageInfos];
    [self.contentTextView sizeToFit];
    
    /* 增加事件响应 */
    [self.contentTextView appenTouchObserverForKeyword:@"关键字" withHanlder:^(NSString *keyword,NSRange keywordRange){
       
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"点击:%@,范围:%@",keyword,NSStringFromRange(keywordRange)] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }];
    
    /* 增加长按事件监测 */
    __weak typeof(self)weakSelf = self;
    [self.contentTextView setLongPressEventHandler:^(GJCFCoreTextContentView *textView, NSString *contentString) {
       
        [weakSelf longPressEvent:contentString textView:textView];
        
    }];
    
    /* 增加事件响应 */
    [self.contentTextView appenTouchObserverForKeyword:@"我们" withHanlder:^(NSString *keyword,NSRange keywordRange){
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"点击:%@,范围:%@",keyword,NSStringFromRange(keywordRange)] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }];
    
    /* 支持整体点击事件 */
    [self.contentTextView setTapActionHandler:^(GJCFCoreTextContentView *textView) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"整体点击" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }];
    

    
//    [self.contentTextView appendRoundCorner:2.f backgroundColor:[UIColor orangeColor] forKeyword:@"关键字"];
//    [self.contentTextView appendRoundCorner:2.f backgroundColor:[UIColor purpleColor] forKeyword:@"我们"];
    
    /* 测试一行情况下的真实宽度 */
//    GJCFCoreTextContentView *oneLineTextView = [[GJCFCoreTextContentView alloc]initWithFrame:CGRectMake(30, 457, 320, 80)];
//    oneLineTextView.isTailMode = YES;
//    oneLineTextView.isOneLineTailMode = NO;
//    NSString *onlineString = @"测试一行情测试一行情测试一行情测试一行情测试一行情测试一行情测试一行情测试一行情测试一行情情测试一行情测试一行情情测试一行情测试一行情情测试一行情测试一行情情测试一行情测试一行情情测试一行情测试一行情情测试一行情测试一行情情测试一行情测试一行情";
//    GJCFCoreTextAttributedStringStyle *onlineStyle = [[GJCFCoreTextAttributedStringStyle alloc]init];
//    onlineStyle.font = [UIFont systemFontOfSize:16];
//    
//    //一行情况下要获取紧凑完整的宽高建议这么做
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:onlineString attributes:[onlineStyle attributedDictionary]];
//    oneLineTextView.backgroundColor = [UIColor orangeColor];
//    
//    [oneLineTextView setContentAttributedString:attributedString];
//    [oneLineTextView sizeToFit];
//    [self.view addSubview:oneLineTextView];    
}

- (void)useTextContentViewLikeLabel
{
    GJCFCoreTextContentView *textLabel = [[GJCFCoreTextContentView alloc]init];
    textLabel.frame = CGRectMake(5, 100, 100, 150);
    textLabel.backgroundColor = [UIColor grayColor];
    textLabel.text = @"测试一行情测试一行情测试一行情测试一行情测试一行情测试一行情测试一行情测试一行情测试一行情情测试一行情测试";
    
    [self.view addSubview:textLabel];
}

- (void)parseEmoji:(NSMutableString *)originString withEmojiTempString:(NSMutableString *)tempString withResultArray:(NSMutableArray *)resultArray
{
    if (!tempString) {
        tempString = [originString mutableCopy];
    }
    
    NSString *regex = @"\\[([\u4E00-\u9FA5]{2})\\]";
    
    NSRegularExpression *emojiRegexExp = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *originResult = [emojiRegexExp firstMatchInString:originString options:NSMatchingReportCompletion range:NSMakeRange(0, originString.length)];
    NSTextCheckingResult *tempResult = [emojiRegexExp firstMatchInString:tempString options:NSMatchingReportCompletion range:NSMakeRange(0, tempString.length)];
 
    if (!resultArray) {
        resultArray = [NSMutableArray array];
    }
    
    while (originResult) {
        
        /* 表情名字 */
        NSString *emoji = [originString substringWithRange:originResult.range];
        
        if ([emoji isEqualToString:@"xxxx"]) {
            break;
        }
        
        /* 真实占位 */
        NSRange emojiRange = originResult.range;
        
        /* 替换真实占位的表情为空格，取得空格占位 */
        NSRange replaceRange = NSMakeRange(tempResult.range.location, 1);
        
        /* 替换占位，寻找下一个 */
        [tempString replaceCharactersInRange:tempResult.range withString:@" "];
        [originString replaceCharactersInRange:originResult.range withString:@"xxxx"];
        
        NSDictionary *item = @{@"emoji":emoji,@"origin":[NSValue valueWithRange:emojiRange],@"temp":[NSValue valueWithRange:replaceRange]};
        
        NSLog(@"each item +++++++ :%@",item);
        
        [resultArray addObject:item];
        
        [self parseEmoji:originString withEmojiTempString:tempString withResultArray:resultArray];
    }
}

- (void)copyContent:(UIMenuItem *)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.contentTextView.contentAttributedString.string];
    self.contentTextView.selected = NO;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)longPressEvent:(NSString *)contentString textView:(GJCFCoreTextContentView *)textView
{
    NSLog(@"will copyString:%@",contentString);
    
    [self becomeFirstResponder];
    UIMenuController *popMenu = [UIMenuController sharedMenuController];
    UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyContent:)];
    NSArray *menuItems = @[item1];
    [popMenu setMenuItems:menuItems];
    [popMenu setArrowDirection:UIMenuControllerArrowDown];
    
    [popMenu setTargetRect:self.contentTextView.frame inView:self.view];
    [popMenu setMenuVisible:YES animated:YES];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyContent:)) {
        return YES;
    }
    return NO; //隐藏系统默认的菜单项
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

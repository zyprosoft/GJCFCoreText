//
//  TVGDebugConsoleViewController.m
//  GJCFUitils
//
//  Created by ZYVincent on 15/7/6.
//  Copyright (c) 2015年 ZYProSoft. All rights reserved.
//

#import "TVGDebugConsoleViewController.h"

@interface TVGDebugConsoleViewController ()

@property (nonatomic,strong)UITextView *consoleTextView;

@end

@implementation TVGDebugConsoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.consoleTextView = [[UITextView alloc]init];
    self.consoleTextView.frame = self.view.bounds;
    self.consoleTextView.showsVerticalScrollIndicator = YES;
    self.consoleTextView.font = [UIFont systemFontOfSize:16.f];
    self.consoleTextView.textColor = [UIColor blackColor];
    self.consoleTextView.editable = NO;
    [self.view addSubview:self.consoleTextView];
    
}

- (void)addDebugMessage:(NSString *)message
{
    NSMutableString *text = [NSMutableString stringWithString:self.consoleTextView.text];
    
    [text appendFormat:@"%@\n",message];
    
    self.consoleTextView.text = text;
}

@end

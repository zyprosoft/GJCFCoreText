// TVGDebugLogger.m
//  TVGBaseProject
//
//  Created by ZYVincent on 14-8-20.
//
//  Copyright (c) 2014年 liyi. All rights reserved. 2014年 TVG Monkey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TVGDebugLogger.h"

@interface TVGDebugTask(Private)
@end

@implementation TVGDebugTask

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self.target];
    [self cancel];
}
- (void)main
{
    if (!self.target || !self.action) {
        [self cancel];
        return;
    }
    NSLog(@"TVGDebugLogger 开始调试 ===========> %@",NSStringFromSelector(self.action));
    NSLog(@"target:%@",self.target);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self.target respondsToSelector:self.action]) {
            [self.target performSelector:self.action];
        }
    });
}

+ (instancetype)taskWithMethod:(NSString *)method
{
   return [TVGDebugTask taskWithMethod:method performDelay:0.f];
}

+ (instancetype)taskWithMethod:(NSString *)method performDelay:(NSTimeInterval)aDelayTime
{
    if (!method) {
        return nil;
    }
    TVGDebugTask *aTask = [[TVGDebugTask alloc]init];
    aTask.action = NSSelectorFromString(method);
    aTask.delayTime = aDelayTime;
    return aTask;
}

@end

@interface TVGDebugLogger ()
@property (nonatomic,strong)NSOperationQueue *taskQueue;
@property (nonatomic,assign)NSTimeInterval lastActionTime;
@property (nonatomic,weak)UIViewController *rootController;
@end

@implementation TVGDebugLogger

- (id)init
{
    if (self = [super init]) {
        self.taskTimeInterval = 2.0f;
        self.lastActionTime = 0.f;
        self.taskQueue = [[NSOperationQueue alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(outLogOnTextView:) name:TVGLoggerPreNoti object:nil];
    }
    return self;
}

- (void)dealloc
{
    [self.taskQueue cancelAllOperations];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

+ (instancetype)debugLoggerWithRootController:(UIViewController*)aRootController
{
    
    if (!aRootController) {
        return nil;
    }
    TVGDebugLogger *aLogger = [[TVGDebugLogger alloc]init];
    
    UIView *showView = aRootController.view;
    UITextView *loggerTextView = (UITextView*)[showView viewWithTag:TVGLoggerTextViewTag];
    if (loggerTextView) {
        aLogger.logOutPutTextView = loggerTextView;
    }else{
        loggerTextView = [[UITextView alloc]init];
        loggerTextView.frame = showView.bounds;
        loggerTextView.textColor = [UIColor colorWithRed:0/255.f green:255/255.f blue:0/255.f alpha:1];
        loggerTextView.font = [UIFont systemFontOfSize:13];
        loggerTextView.tag = TVGLoggerTextViewTag;
        loggerTextView.backgroundColor = [UIColor blackColor];
        loggerTextView.editable = NO;
        loggerTextView.showsVerticalScrollIndicator = YES;
        [showView addSubview:loggerTextView];
        aLogger.logOutPutTextView = loggerTextView;
    }
    aLogger.rootController = aRootController;
    
    NSLog(@"$TVG$:%@",aLogger);
    return aLogger;
}

- (void)outLogOnTextView:(NSNotification*)noti
{
    NSLog(@"$TVG$->收到log信号");
    if (self.logOutPutTextView) {
            
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSObject *logObj = noti.object;
            if (logObj) {
                NSString *logObjDes = [logObj description];
                NSMutableString *logInfo = [NSMutableString stringWithString:self.logOutPutTextView.text];
                [logInfo appendFormat:@"%@\n",logObjDes];
                self.logOutPutTextView.text = logInfo;
                
                if (self.logOutPutTextView.contentSize.height >= self.logOutPutTextView.frame.size.height-40) {
                    CGFloat offsetY = self.logOutPutTextView.contentSize.height-self.logOutPutTextView.frame.size.height;
                    [self.logOutPutTextView scrollRectToVisible:CGRectOffset(self.logOutPutTextView.frame, 0, offsetY) animated:YES];
                }
            }
            
        });
    }
}

- (void)addTask:(TVGDebugTask *)aTask
{
    if (!aTask || ![aTask isKindOfClass:[TVGDebugTask class]]) {
        return;
    }
    self.lastActionTime = self.lastActionTime + self.taskTimeInterval;
    aTask.delayTime = self.lastActionTime;
    aTask.target = self.rootController;
    [self.taskQueue addOperation:aTask];
    NSLog(@"$TVG$->添加一个测试任务:%@",aTask);
}

- (void)clearAllTask
{
    [self.taskQueue cancelAllOperations];
}

@end

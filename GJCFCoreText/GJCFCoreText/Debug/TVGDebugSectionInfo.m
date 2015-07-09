// TVGDebugSectionInfo.m
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

#import "TVGDebugSectionInfo.h"

@implementation TVGDebugSectionInfo

+ (instancetype)debugSectionInfoWithTitle:(NSString *)aTitle withTestsArra:(NSArray *)aTestArray
{
    if (!aTitle) {
        NSLog(@"TVGDebugSectionInfo 没有设置测试模块标题");
        aTitle = @"";
    }
    TVGDebugSectionInfo *aInfo = [[TVGDebugSectionInfo alloc]init];
    if (!aTestArray) {
        aInfo.testsArray = [NSMutableArray array];
    }else{
        aInfo.testsArray = [NSMutableArray arrayWithArray:aTestArray];
    }
    aInfo.title = aTitle;
    return aInfo;
}

- (void)addDebugModel:(TVGDebugModel*)aDebugModel
{
    if (!aDebugModel || ![aDebugModel isKindOfClass:[TVGDebugModel class]]) {
        return;
    }
    [self.testsArray addObject:aDebugModel];
}

- (void)removeDebugModel:(TVGDebugModel*)aDebugModel
{
    if (!aDebugModel || ![aDebugModel isKindOfClass:[TVGDebugModel class]]) {
        return;
    }
    [self.testsArray removeObject:aDebugModel];
}

- (void)addDebugModelArrary:(NSArray*)aDebugArray
{
    [aDebugArray enumerateObjectsUsingBlock:^(TVGDebugModel *obj, NSUInteger idx, BOOL *stop) {
       
        [self addDebugModel:obj];
        
    }];
}

- (TVGDebugModel*)debugModelAtIndex:(NSInteger)index
{
    if (index < 0 || index > self.testsArray.count-1) {
        return nil;
    }
    return [self.testsArray objectAtIndex:index];
}

- (NSInteger)debugModelCount
{
    return self.testsArray.count;
}

@end

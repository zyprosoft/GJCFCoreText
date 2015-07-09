// TVGDebugModel.m
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

#import "TVGDebugModel.h"

@implementation TVGDebugModel

+ (instancetype)debugModelWithTitle:(NSString *)aTitle withClassName:(NSString *)aClassName
{
    if (!aTitle) {
        NSLog(@"TVGDebugModel 初始化的时候没有设置标题");
        aTitle = @"";
    }
    if (!aClassName) {
        NSAssert(aClassName==nil, @"className 不能为传递为空!");
        aClassName = @"";
    }
    if (![aClassName hasSuffix:@"ViewController"]) {
        NSAssert(aClassName==nil, @"className 参数必须以ViewController结尾");
        aClassName = @"";
    }
    TVGDebugModel *aModel = [[TVGDebugModel alloc]init];
    aModel.title = aTitle;
    aModel.className = aClassName;
    
    return aModel;
}

@end

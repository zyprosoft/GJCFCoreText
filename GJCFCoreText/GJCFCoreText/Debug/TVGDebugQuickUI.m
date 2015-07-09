// TVGDebugQuickUI.m
//
//  TVGBaseProject
//
//  Created by ZYVincent on 14-8-30.
//
//Copyright (c) TVG Monkey 2014年
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//   http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "TVGDebugQuickUI.h"

@implementation UIView(TVGFrameUitil)

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setTop:(CGFloat)top
{
    CGRect makeFrame = CGRectOffset(self.frame, 0, top);
    self.frame = makeFrame;
}

- (void)setLeft:(CGFloat)left
{
    CGRect makeFrame = CGRectOffset(self.frame, left, 0);
    self.frame = makeFrame;
}

@end
@implementation TVGDebugQuickUI

+ (UIButton*)buttonAddOnView:(UIView*)aView title:(NSString*)aTitle target:(id)target selector:(SEL)action;
{
    if (!aView) {
        NSLog(@"#警告:快速创建Button时没有可以用来add的superView");
    }
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = (CGRect){0,0,150,35};
    [aButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [aButton setTitle:aTitle forState:UIControlStateNormal];
    [aButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (aView) {
        [aView addSubview:aButton];
    }
    
    return aButton;
}

+ (UILabel*)labelAddOnView:(UIView*)aView title:(NSString*)aTitle;
{
    if (!aView) {
        NSLog(@"#警告:快速创建Label时没有可以用来add的superView");
    }
    
    UILabel *aLabel = [[UILabel alloc]initWithFrame:(CGRect){0,0,90,35}];
    aLabel.backgroundColor = [UIColor whiteColor];
    aLabel.textColor = [UIColor darkTextColor];
    aLabel.numberOfLines = 0;
    aLabel.adjustsFontSizeToFitWidth = YES;
    
    if (aView) {
        [aView addSubview:aLabel];
    }
    
    return aLabel;
}

@end

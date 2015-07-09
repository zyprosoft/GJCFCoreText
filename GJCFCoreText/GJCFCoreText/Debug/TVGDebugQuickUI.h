// TVGDebugQuickUI.h
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

#import <Foundation/Foundation.h>

@interface UIView (TVGFrameUitil)

@property (nonatomic,assign)CGFloat top;

@property (nonatomic,assign)CGFloat left;

@end

@interface TVGDebugQuickUI : NSObject

+ (void)applicationShowMsg:(NSString*)aMessage;

+ (UIButton*)buttonAddOnView:(UIView*)aView title:(NSString*)aTitle target:(id)target selector:(SEL)action;

+ (UILabel*)labelAddOnView:(UIView*)aView title:(NSString*)aTitle;

+ (NSString*)checkLeakNotiWithClassName:(NSString*)className;

@end

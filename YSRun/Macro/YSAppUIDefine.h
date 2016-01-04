//
//  YSAppUIDefine.h
//  YSRun
//
//  Created by moshuqi on 15/12/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#ifndef YSAppUIDefine_h
#define YSAppUIDefine_h

//  iphone5的屏幕宽高
#define iPhone5ScreenPtWidth        320
#define iPhone5ScreenPtHeight       568

#define ScreenPtWidth       [UIApplication sharedApplication].keyWindow.frame.size.width
#define ScreenPtheight      [UIApplication sharedApplication].keyWindow.frame.size.height

#define ActualLength(x) (x / iPhone5ScreenPtHeight * ScreenPtheight)
#define ActualFontSize(fontSize) (fontSize * (ScreenPtheight / iPhone5ScreenPtHeight))

#endif /* YSAppUIDefine_h */

//
//  YSAppMacro.h
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#ifndef YSAppMacro_h
#define YSAppMacro_h

// 颜色相关

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)  RGBA(r,g,b,1.0)

#define GreenBackgroundColor   RGB(4,181,108)
#define LightgrayBackgroundColor RGB(245, 245, 245)

#define ButtonCornerRadius 5

const static NSString *MapAPIKey = @"e8be3a280e6fc3c2651ebef77e7a0fa5";

#endif /* AppMacro_h */

//
//  YSUtilsMacro.h
//  YSRun
//
//  Created by moshuqi on 15/10/19.
//  Copyright © 2015年 msq. All rights reserved.
//

#ifndef YSUtilsMacro_h
#define YSUtilsMacro_h

// 打印方法
#ifdef DEBUG
#define YSLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])    //会输出Log所在函数的函数名
#else
#define YSLog(...) do { } while (0)
#endif


#endif /* YSUtilsMacro_h */

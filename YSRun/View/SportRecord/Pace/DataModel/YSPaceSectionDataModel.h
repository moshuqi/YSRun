//
//  YSPaceSectionDataModel.h
//  YSRun
//
//  Created by moshuqi on 16/1/26.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface YSPaceSectionDataModel : NSObject

@property (nonatomic, assign) CGFloat section;  // 第几公里，最后一段时显示为浮点数
@property (nonatomic, assign) CGFloat progress; // 进度条显示的百分百
@property (nonatomic, assign) CGFloat pace;     // 该公里段内的配速
@property (nonatomic, assign) NSInteger useTime;    // 公里段内使用的时间，秒
@property (nonatomic, assign) NSInteger locationCount;  // 一共有几个定位点
@property (nonatomic, assign) BOOL isLastSection;   // 是否为最后一段距离

@end

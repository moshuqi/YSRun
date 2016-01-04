//
//  YSGraphCanvas.h
//  YSRun
//
//  Created by moshuqi on 15/12/9.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSGraphData;

@interface YSGraphCanvas : UIView

//- (id)initWithFrame:(CGRect)frame pointArray:(NSArray *)pointArray;
- (id)initWithFrame:(CGRect)frame graphData:(YSGraphData *)graphData;
- (UIImage *)getGraphImageWithSize:(CGSize)size;

@end

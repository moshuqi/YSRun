//
//  YSChart.m
//  PieChartDemo
//
//  Created by moshuqi on 15/11/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSChart.h"

@implementation YSChart

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setChartElementVisible:(BOOL)elementVisible percentVisible:(BOOL)percentVisible
{
    if ((self.elementLabelArray == nil) ||
        ([self.elementLabelArray count] < 1))
    {
        [self addElementLabel];
    }
    
    if ([self.elementLabelArray count] < 1)
    {
        return;
    }
    
    if (!elementVisible && !percentVisible)
    {
        for (UILabel *label in self.elementLabelArray)
        {
            label.text = @"";
        }
    }
    else
    {
        NSInteger count = [self.elementLabelArray count];
        for (NSInteger i = 0; i < count; i++)
        {
            UILabel *label = self.elementLabelArray[i];
            label.numberOfLines = 1;
            
            NSMutableString *text = [NSMutableString stringWithFormat:@""];
            if (elementVisible)
            {
                NSString *elementName = [self.chartData getElementNameAtIndex:i];
                [text appendString:elementName];
                
                if (percentVisible)
                {
                    CGFloat percent = [self.chartData getElementPercentAtIndex:i];
                    NSString *percentText = [NSString stringWithFormat:@"\n%.1f%%", percent * 100];
                    [text appendString:percentText];
                    
                    label.numberOfLines = 0;
                }
            }
            else
            {
                CGFloat percent = [self.chartData getElementPercentAtIndex:i];
                NSString *percentText = [NSString stringWithFormat:@"%.1f%%", percent * 100];
                [text appendString:percentText];
            }
            
            label.text = text;
        }
    }
}

- (void)addElementLabel
{
    if (self.elementLabelArray)
    {
        for (UILabel *label in self.elementLabelArray)
        {
            [label removeFromSuperview];
        }
        [self.elementLabelArray removeAllObjects];
    }
    else
    {
        self.elementLabelArray = [NSMutableArray array];
    }
    
    NSInteger count = [self.chartData elementCount];
    for (NSInteger i = 0; i < count; i++)
    {
        UILabel *label = [UILabel new];
        label.frame = [self getElementLabelFrameAtIndex:i];
        
        label.textColor = [UIColor whiteColor];
        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        [self.elementLabelArray addObject:label];
    }
}

- (CGRect)getElementLabelFrameAtIndex:(NSInteger)index
{
    // 子类重载
    return CGRectZero;
}

@end

//
//  YSPaceDataTableView.m
//  YSRun
//
//  Created by moshuqi on 16/1/27.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSPaceDataTableView.h"
#import "YSPaceSectionDataModel.h"
#import "YSPaceDataItem.h"
#import "YSAppMacro.h"
#import "YSDevice.h"

@interface YSPaceDataTableView ()

@property (nonatomic, strong) UILabel *distanceLabel;   // “公里”标签
@property (nonatomic, strong) UILabel *paceLabel;       // “配速”标签

@property (nonatomic, strong) NSArray *sectionDataModelArray;

@end

@implementation YSPaceDataTableView

- (id)initWithFrame:(CGRect)frame sectionDataModelArray:(NSArray *)sectionDataModelArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.sectionDataModelArray = sectionDataModelArray;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addLabels];
        [self addItems];
    }
    
    return self;
}

- (void)addLabels
{
    // 添加标签
    
    self.distanceLabel = [self createLabelWithTitle:@"公里"];
    [self addSubview:self.distanceLabel];
    
    self.paceLabel = [self createLabelWithTitle:@"配速"];
    [self addSubview:self.paceLabel];
    
    // 添加自动布局约束
    
    // 高度约束
    [self addHeightConstraintsWithLabel:self.distanceLabel];
    [self addHeightConstraintsWithLabel:self.paceLabel];
    
    // 边缘约束
    [self addLabelsEdgeConstraints];
}

- (void)addLabelsEdgeConstraints
{
    // 标签与父视图、标签与标签之间的边缘约束
    NSDictionary *viewsDictionary = @{@"distanceLabel" : self.distanceLabel,
                                      @"paceLabel" : self.paceLabel};
    
    // 垂直约束
    NSArray *distanceLabelConstraints_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[distanceLabel]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    NSArray *paceLabelConstraints_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[paceLabel]"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:viewsDictionary];
    
    [self addConstraints:distanceLabelConstraints_V];
    [self addConstraints:paceLabelConstraints_V];
    
    // 水平约束
    NSArray *constraints_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[distanceLabel(paceLabel)][paceLabel]|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    [self addConstraints:constraints_H];
}

- (void)addHeightConstraintsWithLabel:(UILabel *)label
{
    // 给标签加上高度约束
    NSArray *constraints = [self getConstraintsWithView:label height:YSPaceDataTableViewLabelHeight];
    [self addConstraints:constraints];
}

- (NSArray *)getConstraintsWithView:(UIView *)view height:(CGFloat)height
{
    // 宽高约束
    NSString *viewKey = @"view";
    NSDictionary *viewsDictionary = @{viewKey : view};
    
    NSString *verticalVFL = [NSString stringWithFormat:@"V:[%@(%@)]", viewKey, @(height)];
    NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:verticalVFL
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    
    return heightConstraints;
}

- (UILabel *)createLabelWithTitle:(NSString *)title
{
    UILabel *label = [UILabel new];
    label.text = title;
//    label.backgroundColor = [UIColor redColor];
    
    label.textColor = [self textColor];
    label.font = [UIFont systemFontOfSize:[self labelFontSize]];
    label.adjustsFontSizeToFitWidth = YES;
    
    // 需要用代码实现自动布局
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    return label;
}

- (void)addItems
{
    YSPaceDataItem *previousItem = nil;
    
    for (YSPaceSectionDataModel *model in self.sectionDataModelArray)
    {
        YSPaceDataItem *item = [[[UINib nibWithNibName:@"YSPaceDataItem" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        [item setupWithPaceSectionDataModel:model];
        
        item.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:item];
        
        if (previousItem)
        {
            NSArray *constraints_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousItem][item(height)]"
                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
                                                                             metrics:@{@"height" : @(YSPaceDataTableViewItemHeight)}
                                                                               views:NSDictionaryOfVariableBindings(previousItem, item)];
            [self addConstraints:constraints_V];
            
            
        }
        else
        {
            // 第一个item
            NSDictionary *viewsDictionary = @{@"distanceLabel" : self.distanceLabel,
                                              @"item" : item};
            NSArray *constraints_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[distanceLabel][item(height)]"
                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
                                                                             metrics:@{@"height" : @(YSPaceDataTableViewItemHeight)}
                                                                               views:viewsDictionary];
            [self addConstraints:constraints_V];
        }
        
        NSArray *constraints_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[item]|"
                                                                         options:NSLayoutFormatDirectionLeadingToTrailing
                                                                         metrics:nil
                                                                           views:NSDictionaryOfVariableBindings(item)];
        [self addConstraints:constraints_H];
        
        previousItem = item;
    }
}

- (UIColor *)textColor
{
    UIColor *color = RGB(81, 81, 81);
    return color;
}

- (CGFloat)labelFontSize
{
    CGFloat fontSize = 12;
    if ([YSDevice isPhone6Plus])
    {
        fontSize = 16;
    }
    
    return fontSize;
}

@end

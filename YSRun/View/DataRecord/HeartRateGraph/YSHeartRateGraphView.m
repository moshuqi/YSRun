//
//  YSHeartRateGraphView.m
//  YSRun
//
//  Created by moshuqi on 15/11/25.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSHeartRateGraphView.h"
#import "YSTimeShaftView.h"
#import "YSGraph.h"
#import "YSAppMacro.h"
#import "YSGraphData.h"
//#import "YSChart.h"
#import "YSStatisticsDefine.h"
#import "YSGraphCanvas.h"

@interface YSHeartRateGraphView ()

@property (nonatomic, weak) IBOutlet YSTimeShaftView *timeShartView;
//@property (nonatomic, strong) YSGraph *graph;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UIImageView *graphImageView;

@property (nonatomic, weak) IBOutlet UIImageView *helpIcon;

@end

@implementation YSHeartRateGraphView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSHeartRateGraphView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLabel.text = @"心率图表：";
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = RGB(136, 136, 136);
    
    // 问号图标带有点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.helpIcon addGestureRecognizer:tap];
}

- (void)setupWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime dictDataArray:(NSArray *)dictDataArray
{
    [self.timeShartView setupWithStartTime:startTime endTime:endTime];
    [self.timeShartView setupLabelTextColor:RGB(136, 136, 136) fontSize:12];
    
    YSGraphData *graphData = [[YSGraphData alloc] initWithDataArray:dictDataArray];
    [graphData setBackgroundWithTopColor:AnaerobicExerciseColor middleColor:EfficientReduceFatColor bottomColor:JoggingColor];
    
//    // 先临时这样处理，将来优化会把self.graph去掉。
//    self.graph = [[YSGraph alloc] initWithFrame:self.graphImageView.frame];
//    [self.graph setupWithGraphData:graphData];
//    
//    NSArray *points = [self.graph getPoints];
    YSGraphCanvas *canvas = [[YSGraphCanvas alloc] initWithFrame:self.graphImageView.bounds graphData:graphData];
    
    // 先贴上背景图片，曲线图在子线程绘制完成后再显示。
    UIImage *defaultImage = [UIImage imageNamed:@"graph_background_image"];
    self.graphImageView.image = defaultImage;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        UIImage *graphImage = [canvas getGraphImageWithSize:self.graphImageView.bounds.size];
        dispatch_async(dispatch_get_main_queue(), ^(){
            self.graphImageView.image = graphImage;
        });
    });
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(tapHelpFromPoint:)])
    {
        CGPoint point = CGPointMake(self.helpIcon.center.x, self.helpIcon.center.y);
        [self.delegate tapHelpFromPoint:point];
    }
}


@end

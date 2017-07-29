//
//  YSResultTipView.m
//  YSRun
//
//  Created by moshuqi on 16/2/23.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "YSResultTipView.h"

@interface YSResultTipView ()

@property (nonatomic, weak) IBOutlet UILabel *tipLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation YSResultTipView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSResultTipView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addGesture];
    
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.font = [UIFont systemFontOfSize:20];
}

- (void)addGesture
{
    // 添加点击手势，点击时显示有关效果的说明
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(showHelpFromPoint:)])
    {
        // 传的point为当前视图的点，在父视图进行使用时需要进行坐标系的转换
        CGFloat x = self.imageView.center.x;
        CGFloat y = self.imageView.center.y + CGRectGetHeight(self.imageView.frame) / 2;
        CGPoint point = CGPointMake(x, y);
        
        [self.delegate showHelpFromPoint:point];
    }
}

- (void)showTipWithRating:(NSInteger)rating
{
    // 根据评分等级显示对应的文本提示
    
    NSString *text;
    switch (rating)
    {
        case 0:
            text = @"没有跑步成绩";
            break;
            
        case 1:
            text = @"跑步效果一般";
            break;
            
        case 2:
            text = @"跑步效果一般";
            break;
            
        default:
            text = @"跑步效果完美";
            break;
    }
    
    self.tipLabel.text = text;
}

@end

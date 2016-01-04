//
//  UMChatTableViewCell.m
//  Feedback
//
//  Created by amoblin on 14/7/31.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import "UMChatTableViewCell.h"
#import "UMOpenMacros.h"

@interface UMChatTableViewCell ()

@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *timestampLabel;

@end

@implementation UMChatTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.font = [UIFont systemFontOfSize:14.0f];
        self.messageLabel.numberOfLines = 0;
//        self.messageLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.messageLabel];

        self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        self.timestampLabel.backgroundColor = [UIColor clearColor];
        self.timestampLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.contentView addSubview:self.timestampLabel];

        self.messageBackgroundView = [[UIImageView alloc] initWithFrame:self.messageLabel.frame];
        self.messageBackgroundView.image = [[UIImage imageNamed:@"bubble_min.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        [self.contentView insertSubview:self.messageBackgroundView belowSubview:self.textLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCell:(NSDictionary *)info {
    self.messageLabel.text = info[@"content"];

    if ([info[@"type"] isEqualToString:@"user_reply" ]) {
        // ME
//        self.iconImageView.backgroundColor = UM_UIColorFromHex(0xDBDBDB);
    } else {
        // DEV
//        self.iconImageView.backgroundColor = UM_UIColorFromHex(0x0FB0AA);
    }

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[info[@"created_at"] doubleValue] / 1000];
    self.detailTextLabel.text = [self humanableInfoFromDate:date];
    
}

- (void)setMessageBackgroundView:(UIImageView *)messageBackgroundView {
    if (_messageBackgroundView) {
        [_messageBackgroundView removeFromSuperview];
    }

    if (!messageBackgroundView) {
        _messageBackgroundView = nil;
        return;
    }

    /*
    messageBackgroundView.frame = CGRectMake(0.0f,
                                              0.0f,
                                              CGRectGetWidth(self.messageLabel.bounds),
                                              CGRectGetHeight(self.messageLabel.bounds));
    [messageBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
     */
    [self.contentView insertSubview:messageBackgroundView belowSubview:self.messageLabel];
//    [self.contentView jsq_pinAllEdgesOfSubview:messageBubbleImageView];
    [self setNeedsUpdateConstraints];

    _messageBackgroundView = messageBackgroundView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect textLabelFrame = self.messageLabel.frame;
    textLabelFrame.size.width = 215;
    self.messageLabel.frame = textLabelFrame;

    CGSize labelSize = [self.messageLabel.text sizeWithFont:[UIFont systemFontOfSize:14.0f]
                                       constrainedToSize:CGSizeMake(215, MAXFLOAT)
                                           lineBreakMode:NSLineBreakByWordWrapping];

    textLabelFrame.size.height = labelSize.height + 6;
    textLabelFrame.origin.y = 20.0f;
    if (self.isRightAlign) {
        textLabelFrame.origin.x = self.bounds.size.width - labelSize.width - 35 + 10;
        self.messageBackgroundView.frame = CGRectMake(textLabelFrame.origin.x - 8, textLabelFrame.origin.y - 4, labelSize.width + 20, labelSize.height + 15);
        self.timestampLabel.frame = CGRectMake(textLabelFrame.origin.x - 80, textLabelFrame.origin.y , 70, 20);
    } else {
        textLabelFrame.origin.x = 20;
        self.messageBackgroundView.frame = CGRectMake(5, textLabelFrame.origin.y - 4, labelSize.width + 25, labelSize.height + 15);
        self.timestampLabel.frame = CGRectMake(textLabelFrame.origin.x + labelSize.width + 10, textLabelFrame.origin.y + textLabelFrame.size.height - 18.0, 70, 20);
    }
    self.messageLabel.frame = textLabelFrame;

//    _timestampLabel.frame = CGRectMake(textLabelFrame.origin.x - 75, textLabelFrame.origin.y + textLabelFrame.size.height - 18.0, 65, 20);
}

- (NSString *)humanableInfoFromDate: (NSDate *) theDate {
    NSString *info;

    NSTimeInterval delta = - [theDate timeIntervalSinceNow];
    if (delta < 60) {
        // 1分钟之内
        info = UM_Local(@"Just now");
    } else {
        delta = delta / 60;
        if (delta < 60) {
            // n分钟前
            info = [NSString stringWithFormat:UM_Local(@"%d minutes ago"), (NSUInteger)delta];
        } else {
            delta = delta / 60;
            if (delta < 24) {
                // n小时前
                info = [NSString stringWithFormat:UM_Local(@"%d hours ago"), (NSUInteger)delta];
            } else {
                delta = delta / 24;
                if ((NSInteger)delta == 1) {
                    //昨天
                    info = UM_Local(@"Yesterday");
                } else if ((NSInteger)delta == 2) {
                    info = UM_Local(@"The day before yesterday");
                } else {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MM-dd"];
                    info = [dateFormatter stringFromDate:theDate];
//                    info = [NSString stringWithFormat:@"%d天前", (NSUInteger)delta];
                }
            }
        }
    }
    return info;
}


@end

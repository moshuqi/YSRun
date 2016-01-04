//
//  UMPostTableViewCell.m
//  Feedback
//
//  Created by amoblin on 14/9/10.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import "UMPostTableViewCell.h"
#import "UMFeedback.h"
#import "UMOpenMacros.h"

@interface UMPostTableViewCell ()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *durationLabel;
//@property (strong, nonatomic) UIImageView *statusImageView;

@end

@implementation UMPostTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.playRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
        [self.playRecordButton setBackgroundImage:[[UIImage imageNamed:@"bubble_min.png"] stretchableImageWithLeftCapWidth:18 topCapHeight:10]
                               forState:UIControlStateNormal];
        [self.playRecordButton setImage:[UIImage imageNamed:@"umeng_fb_audio_play_default"] forState:UIControlStateNormal];
        [self.playRecordButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 70)];
//        [self.playRecordButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [self.playRecordButton setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:self.playRecordButton];
        
        self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 5, 30, 30)];
        self.durationLabel.font = [UIFont systemFontOfSize:12.0];
        self.durationLabel.textColor = UM_UIColorFromRGB(100, 100, 100);
        [self addSubview:self.durationLabel];

        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UM_UIColorFromHex(0xD8D8D8);
        self.lineView.autoresizingMask = 0x3f;
        [self addSubview:self.lineView];
        
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [UIFont systemFontOfSize:14.0f];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:11];
        self.detailTextLabel.textColor = UM_UIColorFromHex(0x9B9B9B);
        
        self.iconImageView = [[UIImageView alloc] init];
        [self addSubview:self.iconImageView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconImageView.frame = CGRectMake(0, 0, 3, self.bounds.size.height);
    NSInteger scale = [UIScreen mainScreen].scale;
    self.lineView.frame = CGRectMake(0, self.bounds.size.height - 1.0/scale, self.bounds.size.width, 1.0/scale);
//    self.detailTextLabel.frame = CGRectMake(0, 0, 320, 20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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


- (void)configCell:(NSDictionary *)info {
    [_thumbImageButton setHidden:YES];
    
    if ([info[@"type"] isEqualToString:@"user_reply" ]) {
        // ME
        self.iconImageView.backgroundColor = UM_UIColorFromHex(0xDBDBDB);
    } else {
        // DEV
        self.iconImageView.backgroundColor = UM_UIColorFromHex(0x0FB0AA);
    }
    if (info[@"audio"]) {
        [self.playRecordButton setHidden:NO];
        [self.durationLabel setHidden:NO];
        [self setDuration:info[@"audio_length"]];
        if (UM_IOS_8_OR_LATER) {
            self.textLabel.text = @"\n";
        } else {
            self.textLabel.text = @"\n\n";
        }
    }
    else {
        [self.playRecordButton setHidden:YES];
        [self.durationLabel setHidden:YES];
        if (info[@"pic_id"])
        {
            UIImage *thumbImage = [[UMFeedback sharedInstance] thumbImageByID:info[@"pic_id"]];
            if (thumbImage)
            {
                if (!_thumbImageButton)
                {
                    self.thumbImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self addSubview:_thumbImageButton];
                }
                [_thumbImageButton setHidden:NO];
                [_thumbImageButton setFrame:CGRectMake(13.f, 5.f, thumbImage.size.width, thumbImage.size.height)];
                [_thumbImageButton setImage:thumbImage forState:UIControlStateNormal];
                
            }
            self.textLabel.text = UM_IOS_8_OR_LATER ? @"\n\n" : @"\n\n\n";
        }
        else
        {
            self.textLabel.text = info[@"content"];
        }
    }
    if ([info[@"is_failed"] boolValue]) {
        self.textLabel.textColor = UM_UIColorFromHex(0xff0000);
        self.detailTextLabel.textColor = UM_UIColorFromHex(0xff0000);
    } else {
        self.textLabel.textColor = UM_UIColorFromHex(0x000000);
        self.detailTextLabel.textColor = UM_UIColorFromHex(0x000000);
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[info[@"created_at"] doubleValue] / 1000];
    self.detailTextLabel.text = [self humanableInfoFromDate:date];
}

- (void)setDuration:(NSNumber *)duration {
    self.durationLabel.text = [NSString stringWithFormat:@"%ld\"", (long)duration.integerValue];
}

@end

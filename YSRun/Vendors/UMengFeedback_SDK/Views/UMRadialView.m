//
//  UMRadialView.m
//  UMFeedback
//
//  Created by amoblin on 14/11/10.
//
//

#import "UMRadialView.h"
#import "UMOpenMacros.h"
#define SIZE 34
#define PADDING 8

@interface UMRadialView()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *countLabel;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UIButton *playPauseButton;

@end
@implementation UMRadialView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UM_UIColorFromRGBA(100, 100, 100, 0.8);
        self.layer.cornerRadius= 5;
        self.layer.masksToBounds = YES;
        
        [self.infoLabel setHidden:NO];
        
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"umeng_fb_audio_dialog_content"]];
        self.imageView.frame = CGRectMake(self.frame.size.width/2 - 32, 30, 64, 64);
        [self addSubview:self.imageView];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 32, 30, 64, 64)];
        self.countLabel.font = [UIFont systemFontOfSize:40];
        self.countLabel.textColor = [UIColor whiteColor];
        self.countLabel.backgroundColor = [UIColor clearColor];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.countLabel];
        
        /*
        self.closeButton = [self buttonWithImageName:@"cancel"];
        [self addSubview:self.closeButton];
        
        self.sendButton = [self buttonWithImageName:@"save"];
        [self addSubview:self.sendButton];
        
        self.playPauseButton = [self buttonWithImageName:@""];
        [self addSubview:self.playPauseButton];
         */
    }
    return self;
}

- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100, 110, 200, 30)];
        
        label.layer.cornerRadius = 17;
        label.layer.masksToBounds = YES;
//        _infoLabel.backgroundColor = UM_UIColorFromRGB(200, 200, 200);
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"00:00";
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];

        _infoLabel = label;
    }
    return _infoLabel;
}

- (UIButton *)buttonWithImageName:(NSString *)imageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button setBackgroundImage:[UIImage imageNamed:@"first"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.layer.cornerRadius = SIZE/2;
    button.backgroundColor = [UIColor whiteColor];
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.infoLabel.frame = CGRectMake(self.frame.size.width/2 - 100, 110, 200, 30);
    self.imageView.frame = CGRectMake(self.frame.size.width/2 - 32, 30, 64, 64);
    
    self.countLabel.frame = CGRectMake(self.frame.size.width/2 - 32, 30, 64, 64);
    
    self.closeButton.frame = CGRectMake(PADDING, 105-SIZE/2, SIZE, SIZE);
    self.sendButton.frame = CGRectMake(105-SIZE/2, PADDING, SIZE, SIZE);
    self.playPauseButton.frame = CGRectMake(105-SIZE/2, 105-SIZE/2, SIZE, SIZE);
}

- (void)showRecordInfo {
    [self.countLabel setHidden:YES];

    [self.imageView setHidden:NO];
    self.imageView.image = [UIImage imageNamed:@"umeng_fb_audio_dialog_content"];
    self.infoLabel.text = UM_Local(@"Swipe up to cancel");
}

- (void)showCancelInfo {
    self.imageView.image = [UIImage imageNamed:@"umeng_fb_audio_dialog_cancel"];
    self.infoLabel.text = UM_Local(@"Release to cancel");
}

- (void)showWarningView {
    self.infoLabel.text = UM_Local(@"Too short!");
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.8];
}

- (void)showCountSecondInfo:(NSInteger)second {
    [self.imageView setHidden:YES];

    [self.countLabel setHidden:NO];
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)second];
    self.infoLabel.text = UM_Local(@"限时倒数");
}

- (void)dismiss {
    [self setHidden:YES];
}

@end

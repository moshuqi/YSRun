//
//  UMChatToolBar.m
//  Feedback
//
//  Created by amoblin on 14/7/30.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import "UMChatToolBar.h"
#import "UMRadialView.h"
#import "UMRecorder.h"
#import "UMOpenMacros.h"
#import "UMFeedback.h"

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface UMChatToolBar() <RecorderDelegate, UITextViewDelegate>

@property (strong, nonatomic) UITextField *inputTextField;
//@property (strong, nonatomic) UILabel *editorTitle;
//@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *contactInfoKeys;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;

//@property (strong, nonatomic) UILabel *waveLabel;
@property (nonatomic) BOOL isShowingInfo;

//@property (strong, nonatomic) UIButton *toggleButton;
@property (nonatomic) BOOL isTextMode;

@end

@implementation UMChatToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.barTintColor = UM_UIColorFromRGB(245, 245, 245);
        self.isTextMode = YES;
        self.contactInfoKeys = @[@"QQ", @"Email", @"Tel", @"Others"];

        if ( ! UM_IOS_7_OR_LATER) {
            self.tintColor = UM_UIColorFromRGB(245, 245, 245);
        }

        /*
        self.toggleButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 5, 35, 35)];
        [self.toggleButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
        [self.toggleButton setImage:[UIImage imageNamed:@"ToolViewInputText"] forState:UIControlStateSelected];
        [self.toggleButton addTarget:self
                              action:@selector(toggleButtonPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.toggleButton];
         */

        /*
        self.inputTextField = [[UITextField alloc]
                               initWithFrame:CGRectMake(45, 8, 223, 28)];
        self.inputTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.inputTextField];
         */

        self.recordButton = [[UIButton alloc] initWithFrame:CGRectMake(45, 8, 263, 28)];

        self.recordButton.layer.borderWidth = 0.5f;
        self.recordButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.recordButton.layer.cornerRadius = 5.0f;

        [self.recordButton setTitle:UM_Local(@"Hold to speak") forState:UIControlStateNormal];
//        [self.recordButton setBackgroundColor:UM_UIColorFromRGB(238, 238, 238)];
        [self.recordButton setTitleColor:UM_UIColorFromRGB(88, 88, 88) forState:UIControlStateNormal];
        [self.recordButton setHidden:YES];

        [self addSubview:self.recordButton];

        if (UM_IOS_7_OR_LATER) {
            self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        } else {
            self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        [self.rightButton setTitleColor:UM_UIColorFromRGB(180.0, 180.0, 180.0)
                               forState:UIControlStateDisabled];

//        [self.rightButton setBackgroundColor:[UIColor grayColor]];
//        [self.rightButton setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
        [self.rightButton setTitle:UM_Local(@"Send") forState:UIControlStateNormal];
        [self.rightButton setEnabled:NO];
        [self addSubview:self.rightButton];
        
        self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.plusButton setImage:[UIImage imageWithContentsOfFile:
                                   [[NSBundle mainBundle] pathForResource:@"umeng_add_photo@2x.png" ofType:nil]]
                         forState:UIControlStateNormal];
        self.plusButton.hidden = YES;
        [self addSubview:self.plusButton];

        self.inputTextView = [[UMTextView alloc] init];
        self.inputTextView.delegate = self;
        self.inputTextView.placeholder = UM_Local(@"Feedback");
        self.inputTextView.layer.zPosition = 500;
        [self addSubview:self.inputTextView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeTextViewText:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
    }
    return self;
}

/*
- (UILabel *)waveLabel {
    if (_waveLabel == nil) {
        _waveLabel = [[UILabel alloc] init];
        _waveLabel.layer.cornerRadius = 17;
        _waveLabel.layer.masksToBounds = YES;
        _waveLabel.backgroundColor = UM_UIColorFromRGB(200, 200, 200);
        _waveLabel.font = [UIFont systemFontOfSize:12.0];
        _waveLabel.textColor = [UIColor whiteColor];
        _waveLabel.text = @"00:00   ";
        _waveLabel.textAlignment = NSTextAlignmentRight;
        [_waveLabel setHidden:YES];
        [self addSubview:_waveLabel];
    }
    return _waveLabel;
}
 */

- (UIButton *)leftButton {
    if (_leftButton == nil) {
        if (UM_IOS_7_OR_LATER) {
//            _leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
            _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_leftButton setTitleColor:UM_UIColorFromRGB(0, 122.0, 255.0) forState:UIControlStateNormal];
        } else {
            _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_leftButton setTitleColor:UM_UIColorFromRGB(0, 122.0, 255.0) forState:UIControlStateNormal];
        }
        [_leftButton addTarget:self
                        action:@selector(toggleInputTypeButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
//        [_leftButton setHidden:YES];
        [self addSubview:_leftButton];
    }
    return _leftButton;
}

- (UISegmentedControl *)segmentedControl {
    if (_segmentedControl == nil) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[UM_Local(@"QQ"), UM_Local(@"Phone"), UM_Local(@"Email"), UM_Local(@"Other")]];
        _segmentedControl.tintColor = [UIColor grayColor];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self
                              action:@selector(segmentedControlValueChangedAction:)
                    forControlEvents:UIControlEventValueChanged];
        [self addSubview:_segmentedControl];
    }
    return _segmentedControl;
}

/*
- (UILabel *)editorTitle {
    if (_editorTitle == nil) {
        _editorTitle = [UILabel new];
        _editorTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _editorTitle.text = NSLocalizedString(@"QQ", nil);
        _editorTitle.textAlignment = NSTextAlignmentCenter;
        _editorTitle.backgroundColor = [UIColor clearColor];
        _editorTitle.font = [UIFont boldSystemFontOfSize:15.0];
        _editorTitle.userInteractionEnabled = YES;
    
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [_editorTitle addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [_editorTitle addGestureRecognizer:swipeRight];
        
        _editorTitle.layer.zPosition = 300;
        [self addSubview:self.editorTitle];
    }
    return _editorTitle;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [UIPageControl new];
        _pageControl.numberOfPages = self.contactInfoKeys.count;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        
        [_pageControl addTarget:self
                         action:@selector(pageControlValueChangedAction:)
               forControlEvents:UIControlEventValueChanged];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [_pageControl addGestureRecognizer:swipeLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [_pageControl addGestureRecognizer:swipeRight];
        
        _pageControl.layer.zPosition = 400;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}
 */

/*
- (void)swipe:(UISwipeGestureRecognizer *)swipeRecognizer {
    if ([swipeRecognizer direction] == UISwipeGestureRecognizerDirectionLeft) {
        self.pageControl.currentPage += 1;
    } else if ([swipeRecognizer direction] == UISwipeGestureRecognizerDirectionRight) {
        self.pageControl.currentPage -= 1;
    }
    [self pageControlValueChangedAction:self.pageControl];
}

- (void)pageControlValueChangedAction:(UIPageControl *)pageControl {
}
 */

- (void)segmentedControlValueChangedAction:(UISegmentedControl *)segmentedControl {
    [self updateInfoAtIndex:segmentedControl.selectedSegmentIndex];
    [self.inputTextView resignFirstResponder];
    [self.inputTextView becomeFirstResponder];
}

- (void)updateInfoAtIndex:(NSUInteger)index {
//    self.editorTitle.text = self.contactInfoKeys[index];
    switch (index) {
        case 0:
            self.inputTextView.text = [self.contactInfo valueForKeyPath:@"contact.qq"];
            self.inputTextView.keyboardType = UIKeyboardTypeNumberPad;
            self.inputTextView.placeholder = UM_Local(@"for QQ number");
            break;
        case 1:
            self.inputTextView.text = [self.contactInfo valueForKeyPath:@"contact.phone"];
            self.inputTextView.keyboardType = UIKeyboardTypeNumberPad;
            self.inputTextView.placeholder = UM_Local(@"for phone number");
            break;
        case 2:
            self.inputTextView.text = [self.contactInfo valueForKeyPath:@"contact.email"];
            self.inputTextView.keyboardType = UIKeyboardTypeEmailAddress;
            self.inputTextView.placeholder = UM_Local(@"for email address");
            break;
        case 3:
            self.inputTextView.text = [self.contactInfo valueForKeyPath:@"contact.plain"];
            self.inputTextView.keyboardType = UIKeyboardTypeDefault;
            self.inputTextView.placeholder = UM_Local(@"anything else?");
            break;
        default:
            break;
    }
//    [self.inputTextView reloadInputViews];
}

- (void)setIsEditMode:(BOOL)isEditMode {
    _isEditMode = isEditMode;
    if (isEditMode) {
        if (self.isAudioInput) {
            [self.recordButton setHidden:YES];
            [self.inputTextView setHidden:NO];
            [self.inputTextView becomeFirstResponder];
            [self.rightButton setHidden:NO];
        }
        if (!_textValid) {
            self.plusButton.hidden = YES;
        }
        /*
        CGFloat delta = self.frame.size.height - 44;
        CGRect f = self.frame;
        frame.origin.y += delta;
        frame.size.height = 44;
        self.frame = frame;
        [self setNeedsLayout];
         */
        
//        self.inputTextView
//        [self.leftButton setHidden:NO];
        [self.leftButton setTitle:UM_Local(@"Cancel") forState:UIControlStateNormal];
        [self.leftButton setImage:nil forState:UIControlStateNormal];
        [self.segmentedControl setHidden:NO];
//        [self.editorTitle setHidden:NO];
//        [self.pageControl setHidden:NO];
        [self.rightButton setTitle:UM_Local(@"Send") forState:UIControlStateNormal];
        /*
        CGRect frame = self.frame;
        frame.size.height = 82;
        self.frame = frame;
         */
        [self updateInfoAtIndex:self.segmentedControl.selectedSegmentIndex];
    } else {
        // 从编辑联系信息界面切换到文本输入界面，不支持切换到语音输入界面
        self.isAudioInput = NO;
        [self.segmentedControl setHidden:YES];
        [self.leftButton setHidden:NO];
        
        [self.leftButton setTitle:nil forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
//        [self.editorTitle setHidden:YES];
//        [self.pageControl setHidden:YES];
        self.inputTextView.placeholder = UM_Local(@"Feedback");
        [self.rightButton setTitle:UM_Local(@"Send") forState:UIControlStateNormal];
        CGRect frame = self.frame;
        frame.size.height = 44;
        self.frame = frame;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = 60;
    CGFloat paddingRight = 3;
    
    CGSize plusSize = CGSizeMake(25.f, 25.f);
    if (self.isEditMode) {
        self.leftButton.frame = CGRectMake(5, 4, width, 40);
        self.rightButton.frame = CGRectMake(self.frame.size.width - width - paddingRight, self.frame.size.height - 42, width, 40);

        CGFloat inputAreaWidth = self.frame.size.width - 16 - width*2;
        self.inputTextView.frame = CGRectMake(5+width+4*2, 10, inputAreaWidth, self.frame.size.height-38-8*2);
//        CGFloat centerX = self.frame.size.width / 2;
//        CGFloat titleWidth = 180;
//        self.editorTitle.frame = CGRectMake(centerX - titleWidth/2 , 4, titleWidth, 40);
//        self.pageControl.frame = CGRectMake(centerX - titleWidth/2 , 4, titleWidth, 70);
        CGFloat height = 28.0f;
        self.segmentedControl.frame = CGRectMake(5, self.frame.size.height-height-8, self.frame.size.width-5*2, height);

        self.rightButton.frame = CGRectMake(self.frame.size.width - width - paddingRight, 4, width, 40);
        
        CGRect plusFrame = CGRectMake(self.frame.size.width - width - paddingRight + 8,
                                      self.inputTextView.center.y - plusSize.height / 2,
                                      plusSize.width,
                                      plusSize.height);
        self.plusButton.frame = plusFrame;
    } else {
        CGFloat leftButtonWidth = 30;
        self.leftButton.frame = CGRectMake(5, self.frame.size.height - 35, leftButtonWidth, 30);
        self.rightButton.frame = CGRectMake(self.frame.size.width - width - paddingRight - 4*2, self.frame.size.height-42, width, 40);
        
        
        if (self.isAudioEnabled) {
            CGFloat inputAreaWidth = self.frame.size.width - 5 - leftButtonWidth - width - paddingRight * 2 - 4*2 - paddingRight;
            self.inputTextView.frame = CGRectMake(5 + leftButtonWidth + 4*2, 8, inputAreaWidth, self.frame.size.height-16);
            //        self.waveLabel.frame = CGRectMake(20, 5, inputAreaWidth-100, self.frame.size.height-10);
        } else {
            CGFloat inputAreaWidth = self.frame.size.width - 5 - width - paddingRight * 2 - paddingRight;
            self.inputTextView.frame = CGRectMake(5, 8, inputAreaWidth, self.frame.size.height-16);
            //        self.waveLabel.frame = CGRectMake(20, 5, inputAreaWidth-100, self.frame.size.height-10);
        }
        CGRect frame = self.inputTextView.frame;
        frame.size.width += width - 10;
        self.recordButton.frame = frame;
        
        CGRect plusFrame = CGRectMake(self.frame.size.width - width - paddingRight + 8,
                                      self.frame.size.height-35,
                                      plusSize.width,
                                      plusSize.height);
        self.plusButton.frame = plusFrame;
    }
}

- (NSString *)textContent {
    return [self.inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)reset {
    self.isShowingInfo = NO;
    self.isAudioInput = NO;
//    [self.waveLabel setHidden:YES];
//    self.waveLabel.textColor = [UIColor whiteColor];
//    [self.inputTextView setHidden:NO];
}

- (void)cleanInputText {
    self.inputTextView.text = @"";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"] && self.isEditMode) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didChangeTextViewText:(NSNotification *)notification
{
    UMTextView *textView = (UMTextView *)notification.object;
    
    // Skips this it's not the expected textView.
    if (![textView isEqual:self.inputTextView]) {
        return;
    }

    [self textDidUpdate:YES];
    
    if ( ! self.isEditMode) {
        return;
    }

    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            [self.contactInfo setValue:textView.text forKeyPath:@"contact.qq"];
            break;
        case 1:
            [self.contactInfo setValue:textView.text forKeyPath:@"contact.phone"];
            break;
        case 2:
            [self.contactInfo setValue:textView.text forKeyPath:@"contact.email"];
            break;
        case 3:
            [self.contactInfo setValue:textView.text forKeyPath:@"contact.plain"];
            break;
        default:
            break;
    }
}

- (void)textDidUpdate:(BOOL)animated
{
    [self checkRightButton];

    if (self.textValid) {
        self.rightButton.hidden = NO;
        self.plusButton.hidden = YES;
        [self.rightButton setEnabled:YES];
        [self.rightButton setTitle:UM_Local(@"Send") forState:UIControlStateNormal];
        [self.rightButton setTitleColor:UM_UIColorFromRGB(0, 122.0, 255.0) forState:UIControlStateNormal];
//        [self.rightButton setImage:nil forState:UIControlStateNormal];
    } else {
        if (self.isAudioInput) {
            self.plusButton.hidden = YES;
            self.rightButton.hidden = YES;
        } else {
            self.plusButton.hidden = _isEditMode ? YES : NO;
            self.rightButton.hidden = _isEditMode ? NO : YES;
        }
//        [self.rightButton setEnabled:NO];
//        [self.rightButton setTitle:nil forState:UIControlStateNormal];
//        [self.rightButton setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
    }
}

- (BOOL)checkRightButton
{
    NSString *text = [self.inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length > UM_CONTENT_MAX_LENGTH || text.length == 0) {
        self.textValid = NO;
    } else {
        self.textValid = YES;
    }
    return self.textValid;
}

/*
- (void)showRecordInfo {
    if (self.isShowingInfo) {
        return;
    }
    self.isShowingInfo = YES;
    
//    self.waveLabel.textColor = [UIColor grayColor];
//    self.waveLabel.textAlignment = NSTextAlignmentCenter;
//    self.waveLabel.backgroundColor = [UIColor clearColor];
//    [self.waveLabel setHidden:NO];
    
    [self.inputTextView setHidden:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reset];
    });
}
 */

- (void)toggleInputTypeButtonPressed:(UIButton *)sender {
    if (self.isEditMode) {
        return;
    }
    self.isAudioInput = ! self.isAudioInput;
    if (self.isAudioInput) {
        [self cleanInputText];
        [self.leftButton setImage:[UIImage imageNamed:@"ToolViewInputText"]
                         forState:UIControlStateNormal];
        [self.recordButton setHidden:NO];
        [self.inputTextView setHidden:YES];
        [self.inputTextView resignFirstResponder];
        [self.rightButton setHidden:YES];
        self.plusButton.hidden = YES;
    } else {
        [self.leftButton setImage:[UIImage imageNamed:@"ToolViewInputVoice"]
                         forState:UIControlStateNormal];
        [self.recordButton setHidden:YES];
        [self.inputTextView setHidden:NO];
        [self.inputTextView becomeFirstResponder];
        
        [self.rightButton setHidden:_textValid ? NO : YES];
        self.plusButton.hidden = _textValid ? YES : NO;
    }
    
    if (self.isAudioInput) {
        
        if ([[UMFeedback sharedInstance] audioEnabled]) {
            if ( UM_IOS_7_OR_LATER) {
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:AudioAuthCheckKey];
                }];
            }
        }
    }
}

- (void)dealloc {
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

@end

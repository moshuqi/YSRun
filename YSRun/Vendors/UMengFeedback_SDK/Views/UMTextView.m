//
//  UMTextView.m
//  UMFeedback
//
//  Created by amoblin on 14/10/9.
//
//

#import "UMTextView.h"
#import "UMOpenMacros.h"

NSString * const UMTextViewSelectionDidChangeNotification = @"com.umeng.TextViewController.TextView.DidChangeSelection";
NSString * const UMTextViewContentSizeDidChangeNotification = @"com.umeng.TextViewController.TextView.DidChangeContentSize";


@interface UMTextView ()
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation UMTextView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.cornerRadius = 5.0f;

    // reference to iMessage UI
    self.font = [UIFont systemFontOfSize:17.0];
    self.contentInset = UIEdgeInsetsMake(-4, 1, -4, -1);
    
    
    // reference to JSQMessage
//    self.font = [UIFont systemFontOfSize:16.0];
//    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    self.editable = YES;
//    self.selectable = YES;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.directionalLockEnabled = YES;
    self.dataDetectorTypes = UIDataDetectorTypeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeTextView:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    
    [self addObserver:self
           forKeyPath:NSStringFromSelector(@selector(contentSize))
              options:NSKeyValueObservingOptionNew
              context:NULL];

    if (self.text.length == 0 && self.placeholder.length > 0) {
        self.placeholderLabel.hidden = NO;
        [self sendSubviewToBack:self.placeholderLabel];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self scrollsToTop];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
}
 */

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel)
    {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 4, 250, 28)];
        _placeholderLabel.clipsToBounds = NO;
        _placeholderLabel.autoresizesSubviews = NO;
        _placeholderLabel.numberOfLines = 1;
        _placeholderLabel.font = self.font;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.hidden = NO;
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (UIColor *)placeholderColor
{
    return self.placeholderLabel.textColor;
}

#pragma mark - Setters

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)color
{
    self.placeholderLabel.textColor = color;
}

#pragma mark - Overrides

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
}


#pragma mark - Observers & Notifications

- (void)didChangeTextView:(NSNotification *)notification
{
    if (self.placeholder.length > 0) {
        self.placeholderLabel.hidden = (self.text.length > 0) ? YES : NO;
//        [self setNeedsDisplay];
    }
    
//    [self flashScrollIndicatorsIfNeeded];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self] && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UMTextViewContentSizeDidChangeNotification object:self userInfo:nil];
    }
}

- (void)dealloc {
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))];
    
    _placeholderLabel = nil;
}
@end

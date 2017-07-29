//
//  HTHorizontalSelectionList.m
//  Hightower
//
//  Created by Erik Ackermann on 7/31/14.
//  Copyright (c) 2014 Hightower Inc. All rights reserved.
//

#import "HTHorizontalSelectionList.h"
#import "HTHorizontalSelectionListScrollView.h"

@interface HTHorizontalSelectionList ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *selectionIndicatorBar;

@property (nonatomic, strong) NSLayoutConstraint *leftSelectionIndicatorConstraint, *rightSelectionIndicatorConstraint;

@property (nonatomic, strong) UIView *bottomTrim;

@property (nonatomic, strong) NSMutableDictionary *buttonColorsByState;

@end

#define kHTHorizontalSelectionListHorizontalMargin 20
#define kHTHorizontalSelectionListInternalPadding 25

#define kHTHorizontalSelectionListSelectionIndicatorHeight 3

#define kHTHorizontalSelectionListTrimHeight 0.5

@implementation HTHorizontalSelectionList

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setupSubviews];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    _scrollView = [[HTHorizontalSelectionListScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_scrollView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_scrollView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_scrollView)]];
    
    _contentView = [[UIView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_contentView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    //        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
    //                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
    //                                                                     metrics:nil
    //                                                                       views:NSDictionaryOfVariableBindings(_contentView)]];
    //
    //        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|"
    //                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
    //                                                                     metrics:nil
    //                                                                       views:NSDictionaryOfVariableBindings(_contentView)]];
    
    _bottomTrim = [[UIView alloc] init];
//    _bottomTrim.backgroundColor = [UIColor blackColor];
    _bottomTrim.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_bottomTrim];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomTrim]|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_bottomTrim)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomTrim(height)]|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:@{@"height" : @(kHTHorizontalSelectionListTrimHeight)}
                                                                   views:NSDictionaryOfVariableBindings(_bottomTrim)]];
    
    self.buttonInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.selectionIndicatorStyle = HTHorizontalSelectionIndicatorStyleBottomBar;
    
    _buttons = [NSMutableArray array];
    
    _selectionIndicatorBar = [[UIView alloc] init];
    _selectionIndicatorBar.translatesAutoresizingMaskIntoConstraints = NO;
    _selectionIndicatorBar.backgroundColor = [UIColor blackColor];
    
    _buttonColorsByState = [NSMutableDictionary dictionary];
    _buttonColorsByState[@(UIControlStateNormal)] = [UIColor colorWithRed:81 / 255.0 green:81 / 255.0 blue:81 / 255.0 alpha:1.0];

}

#pragma mark - Custom Getters and Setters

- (void)setSelectionIndicatorColor:(UIColor *)selectionIndicatorColor {
    self.selectionIndicatorBar.backgroundColor = selectionIndicatorColor;

    if (!self.buttonColorsByState[@(UIControlStateSelected)]) {
        self.buttonColorsByState[@(UIControlStateSelected)] = selectionIndicatorColor;
    }
}

- (UIColor *)selectionIndicatorColor {
    return self.selectionIndicatorBar.backgroundColor;
}

- (void)setBottomTrimColor:(UIColor *)bottomTrimColor {
    self.bottomTrim.backgroundColor = bottomTrimColor;
}

- (UIColor *)bottomTrimColor {
    return self.bottomTrim.backgroundColor;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    self.buttonColorsByState[@(state)] = color;
}

#pragma mark - Public Methods

- (void)reloadData {
    for (UIButton *button in self.buttons) {
        [button removeFromSuperview];
    }

    [self.selectionIndicatorBar removeFromSuperview];
    [self.buttons removeAllObjects];

    NSInteger totalButtons = [self.dataSource numberOfItemsInSelectionList:self];

    if (totalButtons < 1) {
        return;
    }

    UIButton *previousButton;

    for (NSInteger index = 0; index < totalButtons; index++) {
        NSString *buttonTitle = [self.dataSource selectionList:self titleForItemWithIndex:index];

        UIButton *button = [self selectionListButtonWithTitle:buttonTitle];
        [self.contentView addSubview:button];

        if (previousButton) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton]-padding-[button]"
                                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                     metrics:@{@"padding" : @(kHTHorizontalSelectionListInternalPadding)}
                                                                                       views:NSDictionaryOfVariableBindings(previousButton, button)]];
            
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(previousButton)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button,previousButton)];
            [self.contentView addConstraints:constraints];
            
        } else {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[button]"
                                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                     metrics:@{@"margin" : @(kHTHorizontalSelectionListHorizontalMargin)}
                                                                                       views:NSDictionaryOfVariableBindings(button)]];
        }

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0.0]];

        previousButton = button;

        [self.buttons addObject:button];
    }

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton]-margin-|"
                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
                                                                             metrics:@{@"margin" : @(kHTHorizontalSelectionListHorizontalMargin)}
                                                                               views:NSDictionaryOfVariableBindings(previousButton)]];

    if (totalButtons > 0) {
        UIButton *selectedButton = self.buttons[self.selectedButtonIndex];
        selectedButton.selected = YES;

        switch (self.selectionIndicatorStyle) {
            case HTHorizontalSelectionIndicatorStyleBottomBar: {
                [self.contentView addSubview:self.selectionIndicatorBar];

                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_selectionIndicatorBar(height)]|"
                                                                                         options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                         metrics:@{@"height" : @(kHTHorizontalSelectionListSelectionIndicatorHeight)}
                                                                                           views:NSDictionaryOfVariableBindings(_selectionIndicatorBar)]];

                [self alignSelectionIndicatorWithButton:selectedButton];
                break;
            }

            case HTHorizontalSelectionIndicatorStyleButtonBorder: {
                selectedButton.layer.borderColor = self.selectionIndicatorColor.CGColor;
                break;
            }
        }
    }

    [self sendSubviewToBack:self.bottomTrim];

    [self updateConstraintsIfNeeded];
}

- (void)layoutSubviews {
    if (!self.buttons.count) {
        [self reloadData];
    }

    [super layoutSubviews];
}

#pragma mark - Private Methods

- (UIButton *)selectionListButtonWithTitle:(NSString *)buttonTitle {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentEdgeInsets = self.buttonInsets;
    [button setTitle:buttonTitle forState:UIControlStateNormal];

    for (NSNumber *controlState in [self.buttonColorsByState allKeys]) {
        [button setTitleColor:self.buttonColorsByState[controlState] forState:controlState.integerValue];
    }

    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button sizeToFit];

    if (self.selectionIndicatorStyle == HTHorizontalSelectionIndicatorStyleButtonBorder) {
        button.layer.borderWidth = 1.0;
        button.layer.cornerRadius = 3.0;
        button.layer.borderColor = [UIColor clearColor].CGColor;
        button.layer.masksToBounds = YES;
    }

    [button addTarget:self
               action:@selector(buttonWasTapped:)
     forControlEvents:UIControlEventTouchUpInside];

    button.translatesAutoresizingMaskIntoConstraints = NO;
    return button;
}

- (void)setupSelectedButton:(UIButton *)selectedButton oldSelectedButton:(UIButton *)oldSelectedButton {
    switch (self.selectionIndicatorStyle) {
        case HTHorizontalSelectionIndicatorStyleBottomBar: {
            [self.contentView removeConstraint:self.leftSelectionIndicatorConstraint];
            [self.contentView removeConstraint:self.rightSelectionIndicatorConstraint];

            [self alignSelectionIndicatorWithButton:selectedButton];
            [self layoutIfNeeded];
            break;
        }

        case HTHorizontalSelectionIndicatorStyleButtonBorder: {
            selectedButton.layer.borderColor = self.selectionIndicatorColor.CGColor;
            oldSelectedButton.layer.borderColor = [UIColor clearColor].CGColor;
            break;
        }
    }
}

- (void)alignSelectionIndicatorWithButton:(UIButton *)button {
    self.leftSelectionIndicatorConstraint = [NSLayoutConstraint constraintWithItem:self.selectionIndicatorBar
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:button
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:0.0];
    [self.contentView addConstraint:self.leftSelectionIndicatorConstraint];

    self.rightSelectionIndicatorConstraint = [NSLayoutConstraint constraintWithItem:self.selectionIndicatorBar
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:button
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0
                                                                           constant:0.0];
    [self.contentView addConstraint:self.rightSelectionIndicatorConstraint];
}

#pragma mark - Action Handlers

- (void)buttonWasTapped:(id)sender {
    NSInteger index = [self.buttons indexOfObject:sender];
    if (index != NSNotFound) {
        if (index == self.selectedButtonIndex) {
            return;
        }

        UIButton *oldSelectedButton = self.buttons[self.selectedButtonIndex];
        oldSelectedButton.selected = NO;
        self.selectedButtonIndex = index;

        UIButton *tappedButton = (UIButton *)sender;
        tappedButton.selected = YES;

        [self layoutIfNeeded];
        [UIView animateWithDuration:0.4
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self setupSelectedButton:tappedButton oldSelectedButton:oldSelectedButton];
                         }
                         completion:nil];
        
//        [self setupSelectedButton:tappedButton oldSelectedButton:oldSelectedButton];

        [self.scrollView scrollRectToVisible:CGRectInset(tappedButton.frame, -kHTHorizontalSelectionListHorizontalMargin, 0)
                                    animated:YES];

        if ([self.delegate respondsToSelector:@selector(selectionList:didSelectButtonWithIndex:)]) {
            [self.delegate selectionList:self didSelectButtonWithIndex:index];
        }
    }
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 

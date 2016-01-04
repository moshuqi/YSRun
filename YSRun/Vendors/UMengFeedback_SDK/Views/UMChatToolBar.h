//
//  UMChatToolBar.h
//  Feedback
//
//  Created by amoblin on 14/7/30.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMTextView.h"
#import "UMRecorder.h"

@class UMTextView;
@class UMRadialView;
@interface UMChatToolBar : UIToolbar

@property (strong, nonatomic) UMTextView *inputTextView;

@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *recordButton;
@property (strong, nonatomic) UIButton *plusButton;
@property (nonatomic) BOOL textValid;

@property (nonatomic) BOOL isAudioEnabled;
@property (nonatomic) BOOL isAudioInput;

@property (strong, nonatomic) NSString *audioPath;
@property (strong, nonatomic) NSMutableDictionary *contactInfo;


@property (nonatomic) BOOL isEditMode;

- (NSString *)textContent;
//- (void)showRecordInfo;

- (void)cleanInputText;
@end

//
//  UMFeedbackViewController.m
//  Feedback
//
//  Created by amoblin on 14/7/30.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import "UMFeedbackViewController.h"
#import "UMOpenMacros.h"
#import "UMChatToolBar.h"
#import "UMChatTableViewCell.h"
#import "UMPostTableViewCell.h"
#import "UMRadialView.h"
#import "UMFeedback.h"
#import "UMFullScreenPhotoView.h"

#import <AVFoundation/AVFoundation.h>

//#import "MessagesBubbleImageFactory.h"
//#import "UIColor+JSQMessages.h"
//#import <AFNetworking.h>
#define MAX_RECORD_DURATION 60.0

static void * kJSQMessagesKeyValueObservingContext = &kJSQMessagesKeyValueObservingContext;
const CGFloat kMessagesInputToolbarHeightDefault = 44.0f;

@interface UMFeedbackViewController () <UITableViewDataSource, UITableViewDelegate, UMFeedbackDataDelegate, UINavigationBarDelegate, UIAlertViewDelegate, RecorderDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIWebViewDelegate>

#if __has_feature(objc_arc)
@property(nonatomic, weak) id <ChatViewDelegate> delegate;
#else
@property(nonatomic, unsafe_unretained) id <ChatViewDelegate> delegate;
#endif

@property (nonatomic, strong) UIView *feedbackView;
@property (nonatomic, strong) UIWebView *faqView;
@property (nonatomic, strong) UIActivityIndicatorView *faqViewIndicator;

@property (nonatomic, strong) UIButton *faqButton;
@property (nonatomic, strong) UIButton *feedbackButton;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic) NSInteger topOffset;
@property (nonatomic) CGFloat topViewOffset;

@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UITableView *mTableView;
@property (strong, nonatomic) UIImageView *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView *incomingBubbleImageView;
@property (strong, nonatomic) UMChatToolBar *inputToolBar;

@property (strong, nonatomic) UIView *infoView;
@property (strong, nonatomic) UIButton *infoButton;
@property (strong, nonatomic) UILabel *infoLabel;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (strong, nonatomic) UMFeedback *feedback;
@property (nonatomic) UIBarStyle previousBarStyle;
@property (strong, nonatomic) UIColor *titleColor;

@property (assign, nonatomic) BOOL isObserving;
@property (assign, nonatomic) BOOL isKeyboardShow;

@property (strong, nonatomic) UMRecorder *recorder;
@property (nonatomic) NSUInteger playRecordButtonAnimationIndex;
@property (strong, nonatomic) NSTimer *playRecordButtonAnimationTimer;


@property (strong, nonatomic) UMRadialView *radialView;
@property (strong, nonatomic) UMFullScreenPhotoView *fullScreenView;
@property (assign, nonatomic) UIInterfaceOrientation currentOrientation;
@end

@implementation UMFeedbackViewController
{
    BOOL needNavButton;
}


- (id)init {
    self = [super init];
    if (self) {
        self.title = UM_Local(@"Feedback");
        _feedback = [UMFeedback sharedInstance];
        _delegate = (id<ChatViewDelegate>)self.feedback;
        
        needNavButton = NO;
    }
    return self;
}

- (void)reloadViewFrame
{
    NSInteger originY = 0;
    if (!UM_IOS_7_OR_LATER || ( UM_IOS_8_OR_LATER) ) {
        originY = 0;
    } else {
        if (_currentOrientation == UIInterfaceOrientationLandscapeLeft
            || _currentOrientation == UIInterfaceOrientationLandscapeRight){
            originY = 20;
        }
    }
    CGSize size = [self getViewSize:_currentOrientation];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    frame.origin.y = self.topViewOffset + originY;
    frame.size.height -= self.topViewOffset + originY;
    
    NSInteger _navButtonHeight = needNavButton ? 44.f : 0.f;
    
    _feedbackButton.frame = CGRectMake(0, frame.origin.y, frame.size.width / 2.f, _navButtonHeight);
    _faqButton.frame = CGRectMake(frame.size.width / 2.f, frame.origin.y, frame.size.width / 2.f, _navButtonHeight);
    NSInteger lineHeight = 2.f;
    _lineView.frame = CGRectMake(_faqButton.selected ? frame.size.width / 2 : 0.f , frame.origin.y + _navButtonHeight - lineHeight, frame.size.width / 2.f, lineHeight);
    
    frame.origin.y += _navButtonHeight;
    frame.size.height -= _navButtonHeight;
    
    _feedbackView.frame = frame;
    _faqView.frame =frame;
    _faqViewIndicator.center = CGPointMake(_faqView.frame.size.width / 2.f, _faqView.frame.size.height / 2.f);
    
}
- (void)loadViewFrame
{
    self.faqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_faqButton addTarget:self action:@selector(touchFaqView) forControlEvents:UIControlEventTouchUpInside];
    [_faqButton setTitle:@"常见问题" forState:UIControlStateNormal];
    [_faqButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_faqButton setTitleColor:UM_UIColorFromRGB(36, 184, 187) forState:UIControlStateSelected];
    [self.view addSubview:_faqButton];
    
    self.feedbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_feedbackButton addTarget:self action:@selector(touchFeedbackView) forControlEvents:UIControlEventTouchUpInside];
    [_feedbackButton setTitle:@"意见反馈" forState:UIControlStateNormal];
    [_feedbackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_feedbackButton setTitleColor:UM_UIColorFromRGB(36, 184, 187) forState:UIControlStateSelected];
    [self.view addSubview:_feedbackButton];
    
    self.lineView = [[UIView alloc] init];
    _lineView.backgroundColor = UM_UIColorFromRGB(36, 184, 187);
    [self.view addSubview:_lineView];
    
    self.faqView = [[UIWebView alloc] init];
    _faqView.delegate = self;
    _faqView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_faqView];
    
    self.feedbackView = [[UIView alloc] init];
    _feedbackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_feedbackView];
    
    [self reloadViewFrame];
    [self touchFeedbackView];

}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    _currentOrientation = UIInterfaceOrientationUnknown;
    
    [self loadViewFrame];
    //        self.view.backgroundColor = UM_UIColorFromRGB(238.0, 238.0, 238.0);
    /*
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(tapViewAction:)];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tapGesture];
     */
    
    CGFloat height = _feedbackView.frame.size.height - 44 - 0;
    if (self.modalStyle) {
        height -= self.topViewOffset;
        self.mTableView = [[UITableView alloc]
                           initWithFrame:CGRectMake(0, self.topViewOffset, _feedbackView.frame.size.width, height)];
    } else {
        self.mTableView = [[UITableView alloc]
                           initWithFrame:CGRectMake(0, 0, _feedbackView.frame.size.width, height)];
    }
    [self.mTableView registerClass:[UMPostTableViewCell class]
        forCellReuseIdentifier:@"postCellId"];
    [self.mTableView registerClass:[UMChatTableViewCell class]
        forCellReuseIdentifier:@"chatCellId"];
    //        self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    self.mTableView.allowsSelection = YES;
    
    /*
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //seconds
//    lpgr.delegate = self;
    [self.mTableView addGestureRecognizer:lpgr];
     */
    
    [self.mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.mTableView setSeparatorColor:[UIColor redColor]];
    
    [_feedbackView addSubview:self.mTableView];
    
    CGFloat y = _feedbackView.frame.size.height - 44;
    self.inputToolBar = [[UMChatToolBar alloc] initWithFrame:CGRectMake(0, y, _feedbackView.frame.size.width, 44)];
    self.inputToolBar.isAudioEnabled = [[UMFeedback sharedInstance] audioEnabled];
    [_feedbackView addSubview:self.inputToolBar];
    
    [self.inputToolBar.rightButton addTarget:self
                                      action:@selector(sendButtonPressed:)
                            forControlEvents:UIControlEventTouchUpInside];
    
    [self.inputToolBar.plusButton addTarget:self
                                      action:@selector(presentPhotoLibrary:)
                            forControlEvents:UIControlEventTouchUpInside];
    
    /*
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(sendButtonLongPressed:)];
//    longPressGesture.minimumPressDuration = 0;
//    longPressGesture.delaysTouchesBegan = NO;
//    [self.inputToolBar.recordButton addGestureRecognizer:longPressGesture];
     */
    [self.inputToolBar.recordButton addTarget:self action:@selector(recordButtonDragExitAction:) forControlEvents:UIControlEventTouchDragExit];
    [self.inputToolBar.recordButton addTarget:self action:@selector(recordButtonDragEnterAction:) forControlEvents:UIControlEventTouchDragEnter];
    [self.inputToolBar.recordButton addTarget:self action:@selector(recordButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.inputToolBar.recordButton addTarget:self action:@selector(recordButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBar.recordButton addTarget:self
                                     action:@selector(recordButtonTouchDownAction:)
                           forControlEvents:UIControlEventTouchDown];

    [self.inputToolBar.leftButton addTarget:self
                                     action:@selector(leftButtonPressed:)
                           forControlEvents:UIControlEventTouchUpInside];
    
    if (self.modalStyle) {
        [self setModalStyle];
        if (self.titleColor) {
            self.navBar.titleTextAttributes = @{NSForegroundColorAttributeName: self.titleColor};
        }
    } else {
        if (self.titleColor) {
            self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: self.titleColor};
        }
    }
    [self setHidesBottomBarWhenPushed:YES];
    [self updateLayoutWithOrientation:self.interfaceOrientation];
    
    /*
    [self.radialView.closeButton addTarget:self
                                    action:@selector(hideRecordView)
                          forControlEvents:UIControlEventTouchUpInside];
     */
//    self.radialView.layer.zPosition = 1000;
    [self.radialView setHidden:YES];
    [_feedbackView addSubview:self.radialView];
}

/*
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}
 */
- (UMRadialView *)radialView {
    CGFloat sideLength = 150;
    CGRect frame = CGRectMake(_feedbackView.frame.size.width/2 - sideLength/2, _feedbackView.frame.size.height / 2 - sideLength/2, sideLength, sideLength);
    // 105+24  * 210
    if (_radialView == nil) {
        _radialView = [[UMRadialView alloc] initWithFrame:frame];
    }
    _radialView.frame = frame;
    return _radialView;
}

- (NSMutableDictionary*) mutableDeepCopy:(NSDictionary *)dict {
    NSUInteger count = [dict count];
    NSMutableArray *cObjects = [[NSMutableArray alloc] initWithCapacity:count];
    NSMutableArray *cKeys = [[NSMutableArray alloc] initWithCapacity:count];;
    
    NSEnumerator *e = [dict keyEnumerator];
    unsigned int i = 0;
    id thisKey;
    while ((thisKey = [e nextObject]) != nil) {
        id obj = [dict objectForKey:thisKey];
        
        // Try to do a deep mutable copy, if this object supports it
        if ([[obj class] isKindOfClass:[NSDictionary class]])
            cObjects[i] = [self mutableDeepCopy:obj];
        
        // Then try a shallow mutable copy, if the object supports that
        else if ([obj respondsToSelector:@selector(mutableCopyWithZone:)])
            cObjects[i] = [obj mutableCopy];
        
        // If all else fails, fall back to an ordinary copy
        else
            cObjects[i] = [obj copy];
        
        // I don't think mutable keys make much sense, so just do an ordinary copy
        cKeys[i] = [thisKey copy];
        
        ++i;
    }
    
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithObjects:cObjects forKeys:cKeys];
    
    // The newly-created dictionary retained these, so now we need to balance the above copies
    for (unsigned int i = 0; i < count; ++i) {
    }
    
    return ret;
}


/*
- (NSMutableDictionary *)mutableDeepCopy:(NSDictionary *)dict
{
    NSMutableDictionary * ret = [[NSMutableDictionary alloc]
                                 initWithCapacity:[dict count]];
    NSMutableArray * array;
    for (id key in [dict allKeys])
    {
        array = [(NSArray *)[dict objectForKey:key] mutableCopy];
        [ret setValue:array forKey:key];
    }
    return ret;
}
 */

- (void)setModalStyle {
    UINavigationBar *bar;
    if (UM_IOS_7_OR_LATER) {
        bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    } else {
        bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    }
//    bar.backgroundColor = UM_UIColorFromRGB(122.0, 122.0, 122.0);
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:UM_Local(@"Feedback")];
    [bar setItems:@[item]];
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:UM_Local(@"Close")
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(close:)];
    if (_titleColor) {
        item.rightBarButtonItem.tintColor = _titleColor;
    }
    [bar setDelegate:self];
    self.navBar = bar;
    [self.view addSubview:bar];
    
//    CGFloat height = self.view.frame.size.height - 44 - 64;
//    self.mTableView.frame = CGRectMake(0, 64, self.view.frame.size.width, height);
}

- (void)setBackButton:(UIButton *)button {
    [button addTarget:self action:@selector(backToPrevious) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)setTitleColor:(UIColor *)color {
    _titleColor = color;
}

- (void)backToPrevious {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateLayoutWithOrientation:toInterfaceOrientation];
}

- (NSInteger)topOffset {
    if (UM_IOS_7_OR_LATER) {
        return 20;
    } else {
        return 0;
    }
}

- (void)updateLayoutWithOrientation:(UIInterfaceOrientation)orientation {
    
    CGSize viewSize = [self getViewSize:orientation];
    
    _currentOrientation = orientation;
    if (_fullScreenView)
    {
        _fullScreenView.orientation = orientation;
        [_fullScreenView resetViewFrame];
    }
    [self reloadViewFrame];

    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown: {
            CGFloat viewWidth, viewHeight;
            viewWidth = viewSize.width;
            viewHeight= viewSize.height;

            self.navBar.frame = CGRectMake(0, self.topOffset, viewWidth, 44);
            
            CGRect frame = self.inputToolBar.frame;
            
            frame.size.width = viewWidth;
            if (self.inputToolBar.isEditMode) {
                frame.size.height = 82;
            } else {
                frame.size.height = 44;
            }
            frame.origin.y = _feedbackView.frame.size.height - frame.size.height;
    
            self.inputToolBar.frame = frame;
//            [self.inputToolBar setNeedsLayout];

            CGFloat inputToolbarHeight = self.inputToolBar.frame.size.height;
            if (self.modalStyle) {
                self.mTableView.frame = CGRectMake(0, 0, viewWidth, _feedbackView.frame.size.height - inputToolbarHeight);
            } else {
                self.mTableView.frame = CGRectMake(0, 0, viewWidth, _feedbackView.frame.size.height - inputToolbarHeight);
            }

            self.infoButton.frame = CGRectMake(viewWidth - 100, 0, 100, 40);
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            CGFloat viewWidth, viewHeight, originY;
            viewWidth = viewSize.width;
            viewHeight= viewSize.height;
            if (!UM_IOS_7_OR_LATER || ( UM_IOS_8_OR_LATER && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) ) {
                originY = 0;
            } else {
                originY = 20;
            }
            self.navBar.frame = CGRectMake(0, originY, viewWidth, 32);
            
            if (self.inputToolBar.isEditMode) {
                self.inputToolBar.frame = CGRectMake(0, _feedbackView.frame.size.height - 82, viewWidth, 82);
            } else {
                self.inputToolBar.frame = CGRectMake(0, _feedbackView.frame.size.height - 44, viewWidth, 44);
            }
            self.infoButton.frame = CGRectMake(_feedbackView.frame.size.width - 100, 0, 100, 40);

            CGFloat inputToolbarHeight = self.inputToolBar.frame.size.height;
            if (self.modalStyle) {
                if (!UM_IOS_7_OR_LATER || ( UM_IOS_8_OR_LATER && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) ) {
                    self.mTableView.frame = CGRectMake(0, 0, viewWidth, _feedbackView.frame.size.height - inputToolbarHeight);
                } else {
                    self.mTableView.frame = CGRectMake(0, 0, viewWidth, _feedbackView.frame.size.height - inputToolbarHeight);
                }
            } else {
                self.mTableView.frame = CGRectMake(0, 0, viewWidth, _feedbackView.frame.size.height - inputToolbarHeight);
            }
            break;
        }
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameAction:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowAction:)
                                                 name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideAction:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    /*
    self.outgoingBubbleImageView = [MessagesBubbleImageFactory
                                    outgoingMessageBubbleImageViewWithColor:UM_UIColorFromRGB(90, 180, 255)];

    self.incomingBubbleImageView = [MessagesBubbleImageFactory
                                    incomingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
     */
    
}
 

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"topic and replies count: %d", self.topicAndReplies.count);

    self.feedback.delegate = self;
    self.mTableView.delegate = self;
    [self refreshData];
    [self scrollToBottomAnimated:YES];
    self.previousBarStyle = self.navigationController.navigationBar.barStyle;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    
    self.inputToolBar.contactInfo = [self mutableDeepCopy:[[UMFeedback sharedInstance] getUserInfo]];
    self.infoLabel.text = [NSString stringWithFormat:UM_Local(@"QQ: %@ Phone: %@ \nEmail: %@ Other: %@"),
                           [self.inputToolBar.contactInfo valueForKeyPath:@"contact.qq"],
                           [self.inputToolBar.contactInfo valueForKeyPath:@"contact.phone"],
                           [self.inputToolBar.contactInfo valueForKeyPath:@"contact.email"],
                           [self.inputToolBar.contactInfo valueForKeyPath:@"contact.plain"]];

    self.inputToolBar.inputTextView.text = @"";

    UIEdgeInsets insets = self.mTableView.contentInset;
    insets.bottom = 0;
    self.mTableView.contentInset = insets;
    [self.view endEditing:YES];
    [self updateLayoutWithOrientation:self.interfaceOrientation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self jsq_addObservers];
    [self scrollToBottomAnimated:YES];
//    NSLog(@"topic and replies count: %d", self.topicAndReplies.count);

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = self.previousBarStyle;
    [self.view endEditing:YES];
    
    
    BOOL audioAuthCheck = [[[NSUserDefaults standardUserDefaults] objectForKey:AudioAuthCheckKey] boolValue];
    if ([[UMFeedback sharedInstance] audioEnabled] && audioAuthCheck) {
        [self stopRecordAndPlayback];
    }
    [self.mTableView becomeFirstResponder];
    [self.inputToolBar.inputTextView endEditing:YES];
    [_faqViewIndicator stopAnimating];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self jsq_removeObservers];

    self.mTableView.delegate = nil;
    [self.inputToolBar.inputTextView endEditing:YES];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)topicAndReplies {
    return self.feedback.topicAndReplies;
}

- (void)tapViewAction:(UITapGestureRecognizer *)tapGesture {
    [self.view endEditing:YES];
//    [self.inputTextField endEditing:YES];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.mTableView];
    
    NSIndexPath *indexPath = [self.mTableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self setIsEditMode:YES];
    } else {
    }
}

- (void)setIsEditMode:(BOOL)isEditMode {
    [self.inputToolBar setIsEditMode:isEditMode];
    [self.inputToolBar.inputTextView resignFirstResponder];
    [self updateLayoutWithOrientation:self.interfaceOrientation];
    if (isEditMode) {
        [self.inputToolBar.inputTextView becomeFirstResponder];
    } else {
        self.inputToolBar.inputTextView.keyboardType = UIKeyboardTypeDefault;
        [self.inputToolBar.inputTextView resignFirstResponder];
    }
}

- (void)leftButtonPressed:(UIButton *)sender {
    if (self.inputToolBar.isEditMode) {
        [self setIsEditMode:NO];
        [self.inputToolBar cleanInputText];
        self.inputToolBar.contactInfo = [self mutableDeepCopy:[[UMFeedback sharedInstance] getUserInfo]];
    } else {
        /*
        [sender setSelected:self.inputToolBar.isTextMode];
        self.isTextMode =  ! self.inputToolBar.isTextMode;
        if (self.isTextMode) {
            [self.inputToolBar.inputTextView becomeFirstResponder];
        } else {
            [self.inputToolBar endEditing:YES];
        }
        [self.leftButton setHidden:self.isTextMode];
         */
    }
}

- (void)presentPhotoLibrary:(UIButton *)button
{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum | UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:imagePicker animated:YES];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    NSString *type = info[UIImagePickerControllerMediaType];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary
        || picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        [_feedback post:@{UMFeedbackMediaTypeImage: image}];
        
        [picker dismissModalViewControllerAnimated:YES];
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)sendButtonPressed:(UIButton *)button {
    if (self.inputToolBar.isEditMode) {
        [self setIsEditMode:NO];
        
        self.infoLabel.text = [NSString stringWithFormat:UM_Local(@"QQ: %@ Phone: %@ \nEmail: %@ Other: %@"),
                          [self.inputToolBar.contactInfo valueForKeyPath:@"contact.qq"],
                          [self.inputToolBar.contactInfo valueForKeyPath:@"contact.phone"],
                          [self.inputToolBar.contactInfo valueForKeyPath:@"contact.email"],
                          [self.inputToolBar.contactInfo valueForKeyPath:@"contact.plain"]];
        [self.inputToolBar cleanInputText];
        if ([self.delegate respondsToSelector:@selector(updateUserInfo:)]) {
            [self.delegate updateUserInfo:self.inputToolBar.contactInfo];
        }
        return;
    }

    // INFO: reply_id to mark the reply content and when post back to replace it.

    NSDictionary *info;
    if ([self.inputToolBar textValid]) {
        NSString *content = [self.inputToolBar textContent];
        [self.inputToolBar cleanInputText];
        
        info = @{@"content": content};
        [self setIsEditMode:NO];
    } else {
        // audio
        info = @{};
    }
    [self sendData:info];
    
}

- (void)sendData:(NSDictionary *)info
{
    [self.mTableView reloadData];
    [self scrollToBottomAnimated:YES];
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:self.topicAndReplies.count-1 inSection:0];
    
    if ([self.delegate respondsToSelector:@selector(sendButtonPressed:)]) {
        [self.delegate sendButtonPressed:info];
    }
    self.currentIndexPath = [NSIndexPath indexPathForRow:self.topicAndReplies.count-1 inSection:0];
    [self.mTableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)updateData:(BOOL)reloadData
{
    if (reloadData)
    {
    }
}

#pragma mark Umeng Feedback delegate

- (void)updateTableView:(NSError *)error
{
    [self.mTableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)getFinishedWithError:(NSError *)error
{
    [self updateTableView:error];
}

- (void)updateTextField:(NSError *)error
{
    if (!error)
    {
//        [self.inputToolBar reset];
    }

    [self updateData:YES];
}


- (void)postFinishedWithError:(NSError *)error
{
    if (error != nil) {
        if (error.code == -1009) {
            NSString *info = error.userInfo[NSLocalizedDescriptionKey];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:info
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:UM_Local(@"OK"), nil];
            [alertView show];
        }
    }
    if ([[[UMFeedback sharedInstance] getUserInfo][@"is_failed"] boolValue]) {
        self.infoLabel.textColor = [UIColor redColor];
    } else {
        self.infoLabel.textColor = [UIColor blackColor];
    }

    [self updateTextField:error];
//    [self updateTableView:error];
    if (self.currentIndexPath) {
        [self.mTableView reloadData];
//        [self.mTableView reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [_feedback get];
}

#pragma mark - Keybaord Show Hide Notification

- (void)keyboardWillChangeFrameAction:(NSNotification*)aNotification {
}

- (void)keyboardWillShowAction:(NSNotification *)aNotification {
    [self keyboardAction:aNotification isShow:YES];
}

- (void)keyboardWillHideAction:(NSNotification *)aNotification {
    self.isKeyboardShow = NO;
    [self keyboardAction:aNotification isShow:NO];
}

- (void)keyboardDidShow {
    self.isKeyboardShow = YES;
}

- (void)keyboardAction:(NSNotification *)aNotification isShow:(BOOL)isShow {
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;

    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    CGRect frame = self.inputToolBar.frame;

    if (UM_IOS_8_OR_LATER) {
        frame.origin.y = (_feedbackView.frame.size.height - (isShow ? keyboardEndFrame.size.height : 0)) - self.inputToolBar.frame.size.height;
    } else {
        if (isShow) {
            frame.origin.y = _feedbackView.frame.size.height - keyboardFrame.size.height - frame.size.height;
        } else {
            frame.origin.y = _feedbackView.frame.size.height - frame.size.height;
        }
    }
    self.inputToolBar.frame = frame;

    UIEdgeInsets inset = [self.mTableView contentInset];
    if (isShow) {
        inset.bottom = keyboardFrame.size.height + 10 + self.inputToolBar.frame.size.height - 44;
    } else {
        inset.bottom = 10 + self.inputToolBar.frame.size.height - 44;
    }
    [self.mTableView setContentInset:inset];

//    CGRect tableViewFrame = self.tableView.frame;
//    tableViewFrame.size.height = keyboardFrame.origin.y - 64 - 44;
//    self.tableView.frame = tableViewFrame;

    if (isShow) {
        [self scrollToBottomAnimated:YES];
    }

    [UIView commitAnimations];
}

- (CGSize)getViewSize:(UIInterfaceOrientation) interfaceOrientation {
    // for iOS < 8.0
    CGFloat viewWidth, viewHeight, navHeight;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown: {
            viewWidth = [UIScreen mainScreen].bounds.size.width;
            viewHeight= [UIScreen mainScreen].bounds.size.height;
            navHeight = 44;
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            CGFloat originY;
            navHeight = 32;
            if (UM_IOS_8_OR_LATER ) {
                viewWidth = [UIScreen mainScreen].bounds.size.width;
                viewHeight= [UIScreen mainScreen].bounds.size.height;
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    originY = 20;
                } else {
                    originY = 0;
                }
            } else {
                originY = 20;
                viewWidth = [UIScreen mainScreen].bounds.size.height;
                viewHeight = [UIScreen mainScreen].bounds.size.width;
            }
            break;
        }
        default:break;
    }
    if (!UM_IOS_7_OR_LATER) {
        viewHeight -= 20;

        if ( ! self.modalStyle) {
            viewHeight -= navHeight;
        }
    }
    
    return CGSizeMake(viewWidth, viewHeight);
}

- (void)close:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)jsq_addObservers
{
    if (self.isObserving) {
        return;
    }

    if (UM_IOS_7_OR_LATER) {
        [self.inputToolBar.inputTextView addObserver:self
                                          forKeyPath:NSStringFromSelector(@selector(contentSize))
                                             options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                             context:kJSQMessagesKeyValueObservingContext];
    }

    self.isObserving = YES;
}

- (void)jsq_removeObservers
{
    if (!_isObserving) {
        return;
    }

    @try {
        [_inputToolBar.inputTextView removeObserver:self
                                         forKeyPath:NSStringFromSelector(@selector(contentSize))
                                            context:kJSQMessagesKeyValueObservingContext];
    }
    @catch (NSException * __unused exception) { }

    _isObserving = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kJSQMessagesKeyValueObservingContext) {
        if (self.inputToolBar.isEditMode) {
            return;
        }
        if (object == self.inputToolBar.inputTextView
            && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {

            CGSize oldContentSize = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue];
            CGSize newContentSize = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];

            CGFloat dy = newContentSize.height - oldContentSize.height;
            /*
            if ( dy > 0 && dy < 10) {
                return;
            }
             */

            [self adjustInputToolbarForComposerTextViewContentSizeChange:dy];
//            if (self.automaticallyScrollsToMostRecentMessage) {
                [self scrollToBottomAnimated:NO];
//            }
        }
    }
}

- (void)scrollToBottomAnimated:(BOOL)animated {
//        CGFloat offset = MAX(0, self.tableView.contentSize.height - keyboardFrame.origin.y + 64 + 44);
//        [self.tableView setContentOffset:CGPointMake(0, offset) animated:NO];
    if ([self.mTableView numberOfRowsInSection:0] > 1)
    {
        NSUInteger lastRowNumber = [self.mTableView numberOfRowsInSection:0] - 1;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.mTableView scrollToRowAtIndexPath:ip
                               atScrollPosition:UITableViewScrollPositionBottom
                                       animated:animated];
    }
}

- (CGFloat)topViewOffset {
    CGFloat top = 0;
    
    /*
    if ([self respondsToSelector:@selector(topLayoutGuide)])
        top = self.topLayoutGuide.length;
     */

    if (UM_IOS_7_OR_LATER) {
        switch (_currentOrientation) {
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                top = 64;
                break;
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                top = 32;
                return top;
                break;
            default:
                break;
        }
    } else {
        if (self.modalStyle) {
            top += 44;
        }
    }
    return top;
}

- (BOOL)inputToolbarHasReachedMaximumHeight
{
    return (CGRectGetMinY(self.inputToolBar.frame) == self.topViewOffset);
}

- (void)adjustInputToolbarForComposerTextViewContentSizeChange:(CGFloat)dy
{
    BOOL contentSizeIsIncreasing = (dy > 0);
//        NSLog(@"offset: %f", self.inputToolBar.inputTextView.contentOffset.y);

    if ([self inputToolbarHasReachedMaximumHeight]) {
        BOOL contentOffsetIsPositive = (self.inputToolBar.inputTextView.contentOffset.y > -dy);
//        NSLog(@"offset: %f", self.inputToolBar.inputTextView.contentOffset.y);

        if (contentSizeIsIncreasing || contentOffsetIsPositive) {
            [self scrollComposerTextViewToBottomAnimated:YES];
            return;
        }
        dy += self.inputToolBar.inputTextView.contentOffset.y + 8;
    }

    CGFloat toolbarOriginY = CGRectGetMinY(self.inputToolBar.frame);
    CGFloat newToolbarOriginY = toolbarOriginY - dy;

    //  attempted to increase origin.Y above topLayoutGuide
    if (newToolbarOriginY <= self.topViewOffset) {
        dy = toolbarOriginY - self.topViewOffset;
        [self scrollComposerTextViewToBottomAnimated:YES];
    }

//    NSLog(@"%s: %f", __func__, dy);
    [self adjustInputToolbarHeightByDelta:dy];

    if (dy < 0) {
        [self scrollComposerTextViewToBottomAnimated:NO];
    }
}

- (void)adjustInputToolbarHeightByDelta:(CGFloat)dy
{
    NSInteger offset = dy;
    CGRect frame = self.inputToolBar.frame;
    frame.size.height += dy;
    if (frame.size.height < kMessagesInputToolbarHeightDefault) {
        dy = 0;
        frame.size.height = kMessagesInputToolbarHeightDefault;
        if (self.inputToolBar.isAudioInput) {
            frame.origin.y = _feedbackView.frame.size.height - kMessagesInputToolbarHeightDefault;
        }
    }

    frame.origin.y -= dy;
    self.inputToolBar.frame = frame;

    CGRect inputTextViewFrame = self.inputToolBar.inputTextView.frame;
    inputTextViewFrame.size.height += dy;
    self.inputToolBar.inputTextView.frame = inputTextViewFrame;
    [self.inputToolBar.inputTextView scrollsToTop];

//        [self.mTableView setNeedsDisplay];
    CGRect sendButtonFrame = self.inputToolBar.rightButton.frame;
    sendButtonFrame.origin.y += dy;
    self.inputToolBar.rightButton.frame = sendButtonFrame;
    sendButtonFrame = self.inputToolBar.plusButton.frame;
    sendButtonFrame.origin.y += dy;
    self.inputToolBar.plusButton.frame = sendButtonFrame;

    UIEdgeInsets inset =  self.mTableView.contentInset;
    // 当编辑框回位时，重置tableview bottom
    inset.bottom += (offset < 0) ? -inset.bottom : dy;
    [self.mTableView setContentInset:inset];
}

- (void)scrollComposerTextViewToBottomAnimated:(BOOL)animated
{
    UITextView *textView = self.inputToolBar.inputTextView;
//    CGPoint contentOffsetToShowLastLine = CGPointMake(0.0f, textView.contentSize.height - CGRectGetHeight(textView.bounds));
    CGPoint contentOffsetToShowLastLine = textView.contentOffset;
    contentOffsetToShowLastLine.y = textView.contentSize.height - CGRectGetHeight(textView.bounds);

    [textView setContentOffset:contentOffsetToShowLastLine animated:animated];

    /*
    if (!animated) {
        textView.contentOffset = contentOffsetToShowLastLine;
        return;
    }
    [UIView animateWithDuration:0.01
                          delay:0.01
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         textView.contentOffset = contentOffsetToShowLastLine;
                     }
                     completion:nil];
     */
}

#pragma mark - UITableView DataSource & Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isKeyboardShow) {
        [self.view endEditing:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicAndReplies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"postCellId";
    UMPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId
                                                                forIndexPath:indexPath];
    /*
    static NSString *chatCellId = @"chatCellId";
    UMChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCellId
                                                                forIndexPath:indexPath];
    NSDictionary *info = self.topicAndReplies[indexPath.row];
    if ([info[@"type"] isEqualToString:@"user_reply" ]) {
        cell.isRightAlign = YES;
        cell.messageBackgroundView = [[UIImageView alloc] initWithImage:self.outgoingBubbleImageView.image
                                                       highlightedImage:self.outgoingBubbleImageView.highlightedImage];
    } else {
        cell.isRightAlign = NO;
        cell.messageBackgroundView = [[UIImageView alloc] initWithImage:self.incomingBubbleImageView.image
                                                       highlightedImage:self.incomingBubbleImageView.highlightedImage];
    }
     */
    [cell configCell:self.topicAndReplies[indexPath.row]];
    cell.playRecordButton.tag = indexPath.row;
    [cell.playRecordButton addTarget:self
                              action:@selector(playRecordButtonPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
    
    cell.thumbImageButton.tag = indexPath.row;
    [cell.thumbImageButton addTarget:self
                              action:@selector(thumbButtonPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.infoView;
}

- (UIView *)infoView {
    if (_infoView == nil) {
        UIView *view = [UIView new];
        view.backgroundColor = UM_UIColorFromRGB(238.0, 238.0, 238.0);
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 5, _feedbackView.frame.size.width - 80 - 10, 30)];
        infoLabel.numberOfLines = 0;
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.font = [UIFont systemFontOfSize:12.0];
        infoLabel.text = [NSString stringWithFormat:UM_Local(@"QQ: %@ Phone: %@ \nEmail: %@ Other: %@"),
                          [self.inputToolBar.contactInfo valueForKeyPath:@"contact.qq"],
                          [self.inputToolBar.contactInfo valueForKeyPath:@"contact.phone"],
                          [self.inputToolBar.contactInfo valueForKeyPath:@"contact.email"],
                          [self.inputToolBar.contactInfo valueForKeyPath:@"contact.plain"]];
        if ([self.inputToolBar.contactInfo[@"is_failed"] boolValue]) {
            infoLabel.textColor = [UIColor redColor];
        } else {
            infoLabel.textColor = [UIColor blackColor];
        }
        self.infoLabel = infoLabel;
        [view addSubview:infoLabel];

        UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(_feedbackView.frame.size.width - 100, 0, 100, 40)];
        infoButton.backgroundColor = [UIColor clearColor];
        infoButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        infoButton.titleLabel.numberOfLines = 0;
        [infoButton setTitle:UM_Local(@"Update info") forState:UIControlStateNormal];
        [infoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [infoButton addTarget:self action:@selector(sectionTapped:) forControlEvents:UIControlEventTouchUpInside];
        self.infoButton = infoButton;
        [view addSubview:infoButton];

        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTapped:)]];

        _infoView = view;
    }
    return _infoView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    if ([self.topicAndReplies[indexPath.row][@"is_failed"] boolValue]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:UM_Local(@"Send again?")
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:UM_Local(@"Cancel")
                                                  otherButtonTitles:UM_Local(@"Resend"), nil];
        [alertView show];
    } else {
    }
    [self.view endEditing:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSDictionary *info = self.topicAndReplies[self.mTableView.indexPathForSelectedRow.row];
        if ([self.delegate respondsToSelector:@selector(sendButtonPressed:)]) {
            [self.delegate sendButtonPressed:info];
        }
    }
}

- (void)sectionTapped:(UIButton *)btn {
//    [btn setHidden:YES];
    [self setIsEditMode:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = self.topicAndReplies[indexPath.row][@"content"];
    if (content.length > 0) {
        CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:14.0f]
                               constrainedToSize:CGSizeMake(self.mTableView.frame.size.width - 40, MAXFLOAT)
                                   lineBreakMode:NSLineBreakByWordWrapping];
        return labelSize.height + 28;
    } else {
        if (self.topicAndReplies[indexPath.row][@"pic_id"])
        {
            return 77;
        }
        return 60;
    }
}

#pragma mark - Events

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_faqViewIndicator stopAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_faqViewIndicator stopAnimating];
}

- (void)touchFaqView
{
    _faqButton.selected = YES;
    _feedbackButton.selected = NO;
    _feedbackView.hidden = YES;
    _faqView.hidden = NO;
    
    CGRect frame = _lineView.frame;
    frame.origin.x = _feedbackView.frame.size.width / 2.f;
    _lineView.frame = frame;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[UMFeedback FAQWebUrl]];
    [_faqView loadRequest:request];
    if (!_faqViewIndicator) {
        _faqViewIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _faqViewIndicator.hidesWhenStopped = YES;
        [_faqView addSubview:_faqViewIndicator];
    }
    _faqViewIndicator.center = CGPointMake(_faqView.frame.size.width / 2.f, _faqView.frame.size.height / 2.f);
    [_faqViewIndicator startAnimating];
    
    [self.view endEditing:YES];
}

- (void)touchFeedbackView
{
    _faqButton.selected = NO;
    _feedbackButton.selected = YES;
    _feedbackView.hidden = NO;
    _faqView.hidden = YES;
    [_faqViewIndicator stopAnimating];
    
    CGRect frame = _lineView.frame;
    frame.origin.x = 0.f;
    _lineView.frame = frame;
    [self.view endEditing:YES];
}


- (void)thumbButtonPressed:(UIButton *) sender
{
    UMPostTableViewCell *cell = (UMPostTableViewCell *)[self.mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    CGRect rectInView = [cell convertRect:cell.thumbImageButton.frame toView:self.view];
    
//    CGRect rectInWindow = [self.view convertRect:rectInView toView:nil];
    
    [self.inputToolBar.inputTextView resignFirstResponder];
    UIImage *image = [_feedback imageByID:self.topicAndReplies[sender.tag][@"pic_id"]];
    if (image)
    {
        UIWindow* window = [UIApplication sharedApplication].keyWindow;

        __block UMFeedbackViewController *weakSelf = self;
        self.fullScreenView = [[UMFullScreenPhotoView alloc] initWithFrame:window.bounds];
        _fullScreenView.orientation = _currentOrientation;
        [window addSubview:_fullScreenView];
        [_fullScreenView addImage:image forRect:rectInView dismissCallBack:^{
            weakSelf.fullScreenView = nil;
        }];
    }
}

- (void)playRecordButtonPressed:(UIButton *) sender {
    if (self.recorder.isPlaying) {
        // Stop Playback
        [self stopPlayback];

        NSString *replyId = self.topicAndReplies[sender.tag][@"reply_id"];
        if ( ! [self.recorder.currentReplyId isEqualToString:replyId]) {
            // Start Playback
            [self startPlaybackWithSender:sender];
        }
    } else {
        // Start Playback
        [self startPlaybackWithSender:sender];
    }
}

- (void)stopPlayback {
    [self.recorder stopPlayback];
    if ([self.playRecordButtonAnimationTimer isValid]) {
        if ([[self.playRecordButtonAnimationTimer userInfo] isKindOfClass:[UIButton class]]) {
            [[self.playRecordButtonAnimationTimer userInfo] setImage:[UIImage imageNamed:@"umeng_fb_audio_play_default"]
                                                            forState:UIControlStateNormal];
        }
        [self.playRecordButtonAnimationTimer invalidate];
    }
}

- (void)startPlaybackWithSender:(UIButton *)sender {
    NSString *replyId = self.topicAndReplies[sender.tag][@"reply_id"];
    [self.recorder startPlaybackWithReplyId:replyId];
    self.playRecordButtonAnimationIndex = 0;
    self.playRecordButtonAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.3333 target:self selector:@selector(playRecordButtonAnimationAction:) userInfo:sender repeats:YES];
    [self.playRecordButtonAnimationTimer fire];
}

- (void)playRecordButtonAnimationAction:(NSTimer *)timer {
    NSString *imageName = [NSString stringWithFormat:@"umeng_fb_audio_play_%02lu", (unsigned long)(self.playRecordButtonAnimationIndex % 3 + 1)];
    self.playRecordButtonAnimationIndex++;
    [(UIButton *)[timer userInfo] setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)refreshData {
    if ([self.delegate respondsToSelector:@selector(reloadData)]) {
        [self.delegate reloadData];
    }
}


/*
- (NSString *)filePath
{
    NSError *error;
    NSString *parentPath = [[self recordingsDirectory] stringByAppendingPathComponent:@"feedbackid_1"];
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:parentPath
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return [parentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",self.dialogId, FILE_NAME_EXTENSION]];
}
 */

- (UMRecorder *)recorder {
    return [[UMFeedback sharedInstance] getRecorder];
}

- (NSString *)audioPath {
    return self.recorder.filePath;
}

- (void)recordButtonDragExitAction:(UIButton *)sender {
    [self showCancelView];
    [sender setTitle:UM_Local(@"Hold to speak") forState:UIControlStateNormal];
}

- (void)showCancelView {
    [self.radialView showCancelInfo];
}

- (void)showWarningView {
    [self.radialView showWarningView];
}

- (void)showCountInfo:(NSInteger)second {
    [self.radialView showCountSecondInfo:second];
}

- (void)showRecordView {
    [self.radialView showRecordInfo];
//    [self.radialView show];
//    [self.inputTextView setHidden:YES];
    [self.radialView setHidden:NO];
}

- (void)recordButtonTouchUpOutside:(UIButton *)sender {
    [sender setBackgroundColor:nil];
    [sender setTitle:UM_Local(@"Hold to speak") forState:UIControlStateNormal];
    [self.recorder cancelRecording];
    [self hideRecordView];
}

- (void)recordButtonTouchUpInside:(UIButton *)sender {
    [sender setBackgroundColor:nil];
    if ( ! [self.recorder isRecording]) {
        return;
    }

    [sender setTitle:UM_Local(@"Hold to speak") forState:UIControlStateNormal];
    [self.recorder stopRecording];
    if (self.recorder.duration < UM_TIME_LIMIT) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showWarningView];
        });
    } else {
        [self hideRecordView];
    }
    if (self.recorder.audioData != nil) {
        [self sendButtonPressed:nil];
    }
}

#pragma mark - Recorder Delegate
- (void)updateDuration:(NSTimeInterval)interval {
    CGFloat rest = MAX_RECORD_DURATION - interval;
    if (rest <= 10 && rest >= 0) {
        [self showCountInfo:(NSInteger)rest];
    }
    if (rest <= 0) {
        [self recordButtonTouchUpInside:self.inputToolBar.recordButton];
    }
//    self.infoLabel.text = [NSString stringWithFormat:@"%f", interval];
//    self.radialView.infoLabel.text = [NSString stringWithFormat:@"%f", interval];
}

- (void)audioPlayerDidFinishPlaying {
    [[self.playRecordButtonAnimationTimer userInfo] setImage:[UIImage imageNamed:@"umeng_fb_audio_play_default"] forState:UIControlStateNormal];
    [self.playRecordButtonAnimationTimer invalidate];
}

- (void)recordButtonDragEnterAction:(UIButton *)sender {
    [self showRecordView];
//    [self.inputToolBar showInfo:UM_Local(@"Swipe up to cancel")];
}

- (void)hideRecordView {
    [self.radialView setHidden:YES];
}

- (void)recordButtonTouchDownAction:(UIButton *)sender {
    self.recorder.delegate = self;
    if ( UM_IOS_7_OR_LATER) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                [self startRecordWithSender:sender];
            }
            else {
                // Microphone disabled code
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:UM_Local(@"Permission denied") message:UM_Local(@"Setting Permission for recording in Settings -> Privacy -> Microphone") delegate:self cancelButtonTitle:nil otherButtonTitles:UM_Local(@"OK"), nil];
                [alert show];
            }
        }];
    } else {
        [self startRecordWithSender:sender];
    }
}

- (void)startRecordWithSender:(UIButton *)sender {
    [self stopPlayback];
    
    [sender setTitle:UM_Local(@"Release to stop") forState:UIControlStateNormal];
    [sender setBackgroundColor:UM_UIColorFromHex(0xDBDBDB)];
    //    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showRecordView];
    });
    [self.recorder startRecording];
}

- (void)sendButtonLongPressed:(UILongPressGestureRecognizer*)gesture {
    if ([gesture state] ==  UIGestureRecognizerStateBegan) {
        [self recordButtonTouchDownAction:nil];
    } else if ([gesture state] ==  UIGestureRecognizerStateEnded) {
        [self recordButtonTouchUpInside:nil];
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)stopRecordAndPlayback {
    [self stopPlayback];
    [self recordButtonTouchUpOutside:self.inputToolBar.recordButton];
}

@end

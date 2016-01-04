//
//  UMFeedback.h
//  UMFeedback
//
//  Created by ming hua on 2012-03-19.
//  Updated by ming hua on 2013-04-17.
//  Updated by cui guilin on 2014-09-12.
//  Version 2.3.4
//  Copyright (c) 2014年 umeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMRecorder.h"
#import <UIKit/UIKit.h>

extern NSString *const UMFBCheckFinishedNotification;
extern NSString *const UMFBWebViewDismissNotification;


extern NSString *const UMFeedbackMediaTypeImage;

@protocol UMFeedbackDataDelegate;

#pragma mark - Feedback Object
@interface UMFeedback : NSObject <RecorderDelegate>

/**
 *  UMFeedback Data Delegate
 */
@property (nonatomic, weak) NSObject <UMFeedbackDataDelegate> *delegate;

/**
 *  the new replies
 */
@property (nonatomic, strong) NSMutableArray *theNewReplies;

/**
 *  the topic and replies, also contains the failed one
 */
@property (nonatomic, strong) NSMutableArray *topicAndReplies;

#pragma mark Settings

/**
 *  A Boolean value indicating whether the feedback log is printed(YES) or not (NO). The default value is NO.
 *
 *  @param value YES to print long while NO to do not print.
 */
+ (void)setLogEnabled:(BOOL)value;

+ (BOOL)feedbackLogEnabled;
- (BOOL)audioEnabled;

/**
 *  set feedback app key. you can find out the app key at: http://www.umeng.com/apps/setting
 *
 *  @param appkey
 */
+ (void)setAppkey:(NSString *)appkey;

/**
 *  User Id
 *
 *  @return <#return value description#>
 */
+ (NSString *)uuid;

/**
 *  message type for UMessage alias message type
 *
 *  @return <#return value description#>
 */
+ (NSString *)messageType;

#pragma mark Show Feedback View

/**
 *  get the default feedback view controller
 *
 *  @return
 */
+ (UIViewController *)feedbackViewController;

/**
 *  get the default modal feedback view controller
 *
 *  @return
 */
+ (UIViewController *)feedbackModalViewController;

/**
 * get the url of FAQ, which displayed in UIWebView
 *
 * @return NSURL
 */
+ (NSURL *)FAQWebUrl;


+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

#pragma mark Umeng Feedback Data Api

/**
 *  the UMFeedback singleton
 *
 *  @return
 */
+ (UMFeedback *)sharedInstance;


- (void)setBackButton:(UIButton *)button;

// For iOS 7 and later
/**
 *  set Navigationbar title color and close button tint color
 *
 *  @param color <#color description#>
 */
- (void)setTitleColor:(UIColor *)color;


// 数据接口

/**
 *  get feedback replies from server
 *  @param: completion call back block
 */
- (void)get:(void (^)(NSError *error))completionCallback;


/**
 *  post feedback reply to server
 *
 *  @param feedback_dictionary 
 *  @param completion call back block
 */
- (void)post:(NSDictionary *)feedback_dictionary completion:(void (^)(NSError *error))completionCallback;



// set custom remark info
/**
 *  set custom user info
 *
 *  @param remarkInfo custom user info
 */
- (void)setRemarkInfo:(NSDictionary *)remarkInfo;

/**
 *  update user info
 *
 *  @param info dictionary
 *  @param completion call back block
 */
- (void)updateUserInfo:(NSDictionary *)info completion:(void (^)(NSError *error))completionCallback;
- (NSDictionary *)getUserInfo;

// 推送相关
- (void)setFeedbackViewController:(UIViewController *)controller shouldPush:(BOOL)shouldPush;

// for record and playback
- (void)stopRecordAndPlayback;
- (void)playRecordWithReplyId:(NSString *)replyId;
- (UMRecorder *)getRecorder;

/**
 * @brief 由反馈内容中pic字段的imageID获取缩略图
 *
 * @param image id
 *
 * @return 缩略图
 */
- (UIImage *)thumbImageByID:(NSString *)imageID;

/**
 * @brief 由反馈内容中pic字段的imageID获取反馈原图
 *
 * @param image id
 *
 * @return 反馈原图
 */
- (UIImage *)imageByID:(NSString *)imageID;


// 不建议使用的
- (void)get;
- (void)post:(NSDictionary *)feedback_dictionary;
- (void)updateUserInfo:(NSDictionary *)info;

+ (void)showFeedback:(UIViewController *)viewController withAppkey:(NSString *)appKey;
+ (void)showFeedback:(UIViewController *)viewController withAppkey:(NSString *)appKey dictionary:(NSDictionary *)dictionary;
+ (void)checkWithAppkey:(NSString *)appkey;
- (void)setAppkey:(NSString *)appKey delegate:(id<UMFeedbackDataDelegate>)newDelegate;

@end




#pragma mark - Feedback Data Delegate

@protocol UMFeedbackDataDelegate <NSObject>

@optional
/**
 *  trigger when fetch data from server
 *
 *  @param error
 */
- (void)getFinishedWithError: (NSError *)error;

/**
 *  trigger when post data to server is finished
 *
 *  @param error
 */
- (void)postFinishedWithError:(NSError *)error;

- (void)stopRecordAndPlayback;
@end
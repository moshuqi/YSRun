//
//  YSThirdPartShareSelectView.h
//  YSRun
//
//  Created by moshuqi on 16/1/29.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YSShareSelectType)
{
    YSShareSelectTypeWXCircleOfFriends = 1,     // 微信朋友圈
    YSShareSelectTypeWXFriends,                 // 微信好友
    YSShareSelectTypeSinaWeibo,                 // 新浪微博
    YSShareSelectTypeQQZone,                    // QQ空间
    YSShareSelectTypeQQFriends                  // QQ好友
};

@protocol YSThirdPartShareSelectViewDelegate <NSObject>

@required
- (void)shareType:(YSShareSelectType)type;

@end

@interface YSThirdPartShareSelectView : UIView

@property (nonatomic, weak) id<YSThirdPartShareSelectViewDelegate> delegate;

@end

//
//  YSIconActionSheet.h
//  YSRun
//
//  Created by moshuqi on 15/12/9.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>

#define YSIconActionSheetItemIconKey                    @"YSIconActionSheetItemIconKey"
#define YSIconActionSheetItemTextKey                    @"YSIconActionSheetItemTextKey"
#define YSIconActionSheetItemSelectorStringKey          @"YSIconActionSheetItemSelectorStringKey"
#define YSIconActionSheetItemObjectKey                  @"YSIconActionSheetItemObjectKey"

typedef void(^YSIconActionSheetCallbackBlock)();

@interface YSIconActionSheet : NSObject

- (id)initWithDictArray:(NSArray *)dictArray;
- (void)showIconActionSheet;
- (void)hideIconActionSheet;

@end

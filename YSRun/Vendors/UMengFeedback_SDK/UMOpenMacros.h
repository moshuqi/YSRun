//
//  Macros.h
//  UMFeedback
//
//  Created by Umeng on 15/5/19.
//
//


#ifndef UMFeedback_UMOpenMacros_h
#define UMFeedback_UMOpenMacros_h

#define UM_TIME_LIMIT 1
#define UM_CONTENT_MAX_LENGTH 2000
#define kFEEDBACK_LOCALIZABLE_TABLE @"UMFeedbackLocalizable"
#define AudioAuthCheckKey @"audioAuthAlreadyRequested"
#define UM_Local(key) NSLocalizedStringFromTable(key, kFEEDBACK_LOCALIZABLE_TABLE, nil)
#define UM_UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UM_UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UM_UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UM_IOS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define UM_IOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define UM_IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#endif
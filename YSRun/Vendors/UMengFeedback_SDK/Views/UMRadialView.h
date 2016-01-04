//
//  UMRadialView.h
//  UMFeedback
//
//  Created by amoblin on 14/11/10.
//
//

#import <UIKit/UIKit.h>

@interface UMRadialView : UIView

@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UILabel *infoLabel;

- (void)showRecordInfo;
- (void)showCancelInfo;
- (void)showCountSecondInfo:(NSInteger)second;

- (void)showWarningView;
@end

//
//  YSPaceDataTableView.h
//  YSRun
//
//  Created by moshuqi on 16/1/27.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YSPaceDataTableViewLabelHeight  44
#define YSPaceDataTableViewItemHeight   56

@interface YSPaceDataTableView : UIView

- (id)initWithFrame:(CGRect)frame sectionDataModelArray:(NSArray *)sectionDataModelArray;

@end

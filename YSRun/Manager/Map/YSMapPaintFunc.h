//
//  YSMapPaintFunc.h
//  YSRun
//
//  Created by moshuqi on 15/12/1.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MAMapView;

@interface YSMapPaintFunc : NSObject

- (UIImage *)screenshotWithAnnotationArray:(NSArray *)annotationArray size:(CGSize)size;
- (void)drawPathWithAnnotationArray:(NSArray *)annotationArray inMapView:(MAMapView *)mapView;

@end

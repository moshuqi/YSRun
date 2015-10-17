//
//  MAMapServices.h
//  MapKit_static
//
//  Created by AutoNavi.
//  Copyright (c) 2013年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAMapServices : NSObject

+ (MAMapServices *)sharedServices;

/// API Key, 在创建MAMapView之前需要先绑定key.
@property (nonatomic, copy) NSString *apiKey;

/// SDK 版本号, 形式如v3.0.0
@property (nonatomic, readonly) NSString *SDKVersion;

@end

//
//  XMGBaiduTool.h
//  集成百度地图
//
//  Created by 1 on 15/12/22.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef void(^ResultBlock)(NSArray <BMKPoiInfo *>*poiInfos);

@interface XMGBaiduTool : NSObject
single_interface(XMGBaiduTool)


- (void)poiSearchWithKeyword:(NSString *)key andCoordinate:(CLLocationCoordinate2D)center resultBlock:(ResultBlock)block;


- (void)addAnnotationWith:(CLLocationCoordinate2D)coordinate title:(NSString *)title subTitle:(NSString *)subTitle toMapView:(BMKMapView *)mapView;

- (void)removeAllAnnotaitonsFromMapView:(BMKMapView *)mapView;

@end

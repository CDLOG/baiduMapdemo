//
//  XMGBaiduTool.m
//  集成百度地图
//
//  Created by 1 on 15/12/22.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGBaiduTool.h"

@interface XMGBaiduTool()<BMKPoiSearchDelegate>

/** 检索对象*/
@property(nonatomic ,strong) BMKPoiSearch *searcher;

@property (nonatomic, copy) ResultBlock block;

@end

@implementation XMGBaiduTool

single_implementation(XMGBaiduTool)

/**
 *  检索对象懒加载方法
 */
- (BMKPoiSearch *)searcher
{
    if (!_searcher) {
        //初始化检索对象
        _searcher = [[BMKPoiSearch alloc] init];
        // 设置代理
        _searcher.delegate = self;
    }
    return _searcher;
}


- (void)poiSearchWithKeyword:(NSString *)key andCoordinate:(CLLocationCoordinate2D)center resultBlock:(ResultBlock)block
{
    
    /**
     记录需要执行的block, 在合适的地方执行
     */
    self.block = block;
    
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0; // 页数
    option.pageCapacity = 20; // 每一页的容量
    option.location = center;
    option.keyword = key; // 搜索关键字
    BOOL flag = [self.searcher poiSearchNearBy:option];
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
    
}


- (void)addAnnotationWith:(CLLocationCoordinate2D)coordinate title:(NSString *)title subTitle:(NSString *)subTitle toMapView:(BMKMapView *)mapView
{
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = coordinate;
    annotation.title = title;
    annotation.subtitle = subTitle;
    [mapView addAnnotation:annotation];

}


- (void)removeAllAnnotaitonsFromMapView:(BMKMapView *)mapView
{
    [mapView removeAnnotations:mapView.annotations];
}

#pragma mark - BMKPoiSearchDelegate

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSLog(@"获取到数据");
        self.block(poiResultList.poiInfoList);
    
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}


@end

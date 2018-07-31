//
//  HelloMap.m
//  BaiduMapDemo
//
//  Created by 陈乐杰 on 2018/7/31.
//  Copyright © 2018年 nst. All rights reserved.
//

#import "HelloMap.h"
#import "XMGBaiduTool.h"
@interface HelloMap ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

//定位
@property (strong,nonatomic) BMKLocationService * locService;
@end

@implementation HelloMap
- (IBAction)startLocation:(id)sender {
    [self.locService startUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view from its nib.
}
-(BMKLocationService *)locService
{
    if (!_locService) {
        _locService = [[BMKLocationService alloc]init];
        [self.locService startUserLocationService];
        _mapView.showsUserLocation = YES;//先打开显示的定位图层
        [_mapView setMapType:BMKMapTypeStandard];
        _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
//        改变地图缩放等级
        [_mapView setZoomLevel:19];
    }
    return _locService;
}

/**
 *  当长按地图的时候调用
 *
 *  @param mapView    地图
 *  @param coordinate 按的点对应的经纬度坐标
 */
- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate
{
    
    CLLocationCoordinate2D center = coordinate;    ///< 中心点经纬度坐标
    BMKCoordinateSpan span = (BMKCoordinateSpan){0.016310, 0.012271};
    BMKCoordinateRegion region = (BMKCoordinateRegion){center, span};
    [self.mapView setRegion:region animated:YES];

    // poi检索
    [[XMGBaiduTool sharedXMGBaiduTool] poiSearchWithKeyword:@"小吃" andCoordinate:coordinate resultBlock:^(NSArray<BMKPoiInfo *> *poiInfos) {
        
        
        [[XMGBaiduTool sharedXMGBaiduTool] removeAllAnnotaitonsFromMapView:self.mapView];
        //在这里遍历结果集, 添加大头针
        [poiInfos enumerateObjectsUsingBlock:^(BMKPoiInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [[XMGBaiduTool sharedXMGBaiduTool] addAnnotationWith:obj.pt title:obj.name subTitle:obj.address toMapView:self.mapView];
            
        }];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}


#pragma mark BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

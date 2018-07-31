//
//  HelloMap.m
//  BaiduMapDemo
//
//  Created by 陈乐杰 on 2018/7/31.
//  Copyright © 2018年 nst. All rights reserved.
//

#import "HelloMap.h"

@interface HelloMap ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

//定位
@property (strong,nonatomic) BMKLocationService * locService;
@end

@implementation HelloMap
- (IBAction)startLocation:(id)sender {
    [self.locService startUserLocationService];
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
        _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
    }
    return _locService;
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
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
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

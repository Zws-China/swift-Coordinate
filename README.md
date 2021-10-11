# Coordinate
swift经纬度转换，坐标系转换💯 WGS-84(国际标准)、GCJ-02(火星坐标) 、百度坐标相互转换

此转换库为本地坐标转换库，不需要依赖网络资源，快速转换。可在极短时间内转换大量坐标。<br>
如果使用过程中有问题，请issue我 (｡♥‿♥｡)  <br>
如果觉得对你还有些用，顺手点一下star吧 (｡♥‿♥｡) <br>

# Demo截图
![在这里插入图片描述](https://img-blog.csdnimg.cn/0945952dd6264aada4af77e93093f887.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAV1NfUHJvZ3JhbWVy,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)
# 方法
提供以下方法

```ruby
/**
 *  判断经纬度是否超出中国境内
 */
static func isLocationOutOfChina(_ location: CLLocationCoordinate2D) -> Bool
 
/**
 *  将WGS-84(国际标准)转为GCJ-02(火星坐标):
 */
static func transformFromWGSToGCJ(_ wgsLoc: CLLocationCoordinate2D) -> CLLocationCoordinate2D

/**
 *  将GCJ-02(火星坐标)转为百度坐标:
 */
static func transformFromGCJToBaidu(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D 

/**
 *  将百度坐标转为GCJ-02(火星坐标):
 */
static func transformFromBaiduToGCJ(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D 

/**
 *  将GCJ-02(火星坐标)转为WGS-84:
 */
static func transformFromGCJToWGS(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D 

```
# 如何使用
下载此项目，将项目中的WSCoordinate.swift添加到您的项目中。


在您需要转换的地方使用
```ruby

    //将WGS-84(国际标准)转为GCJ-02(火星坐标)
    let WGSToGCJ = WSCoordinate.transformFromWGSToGCJ(32.0806670849, 118.9060163095)
    
    // 将GCJ-02(火星坐标)转为百度坐标
    let GCJToBaidu = WSCoordinate.transformFromGCJToBaidu(32.0806670849, 118.9060163095)

    //将百度坐标转为GCJ-02(火星坐标)
    let baiduToGCJ = WSCoordinate.transformFromBaiduToGCJ(32.0806670849, 118.9060163095);

    //将GCJ-02(火星坐标)转为WGS-84
    let GCJToWGS = WSCoordinate.transformFromGCJToWGS(coordinate)(32.0806670849, 118.9060163095);

```
方法的返回值是一个CLLocationCoordinate2D结构体，格式为
```ruby
public struct CLLocationCoordinate2D {

    public var latitude: CLLocationDegrees

    public var longitude: CLLocationDegrees

    public init()

    public init(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
}
```
通过.latitude和.longitude可得到转换后的经纬度。

#### github下载地址：[https://github.com/Zws-China/swift-Coordinate](https://github.com/Zws-China/swift-Coordinate)

如果使用过程中有问题，请issue我 (｡♥‿♥｡)  <br>
如果觉得对你还有些用，顺手点一下star吧 (｡♥‿♥｡)   你的支持是我继续的动力。<br>


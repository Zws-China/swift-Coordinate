//
//  WSCoordinate.swift
//  demo
//
//  Created by zws on 2021/10/9.
//

import UIKit
import CoreLocation

class WSCoordinate: NSObject {
    static let a = 6378245.0;
    static let ee = 0.00669342162296594323;
    static let pi = 3.14159265358979324;
    static let xPi = Double.pi * 3000.0 / 180.0;

    
    /// 判断是否超出中国区域
    /// - Parameter location: 经纬度
    /// - Returns: 返回true代表超出中国，false代表在中国境内
    static func isLocationOutOfChina(_ location: CLLocationCoordinate2D) -> Bool {
        if location.longitude < 72.004 || location.longitude > 137.847 || location.latitude < 0.8293 || location.latitude > 55.8271 {
            return true
        }
        return false
    }
    
    /**
     *  将WGS-84(国际标准)转为GCJ-02(火星坐标):
     */
    static func transformFromWGSToGCJ(_ wgsLoc: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        var adjustLoc: CLLocationCoordinate2D = CLLocationCoordinate2D()
        if self.isLocationOutOfChina(wgsLoc) {
            adjustLoc = wgsLoc
        }
        else
        {
            var adjustLat = self.transformLatWith(x: wgsLoc.longitude - 105.0, y: wgsLoc.latitude - 35.0)
            var adjustLon = self.transformLonWith(x: wgsLoc.longitude - 105.0, y: wgsLoc.latitude - 35.0)
            let radLat = wgsLoc.latitude / 180.0 * pi
            var magic = sin(radLat)
            magic = 1 - ee * magic * magic
            let sqrtMagic = sqrt(magic)
            adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi)
            adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi)
            adjustLoc.latitude = wgsLoc.latitude + adjustLat
            adjustLoc.longitude = wgsLoc.longitude + adjustLon
        }
        return adjustLoc
    }

    /**
     *  将GCJ-02(火星坐标)转为百度坐标:
     */
    static func transformFromGCJToBaidu(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let z = sqrt(p.longitude * p.longitude + p.latitude * p.latitude) + 0.00002 * sin(p.latitude * xPi)
        let theta = atan2(p.latitude, p.longitude) + 0.000003 * cos(p.longitude * xPi)
        var geoPoint: CLLocationCoordinate2D = CLLocationCoordinate2D()
        geoPoint.latitude  = (z * sin(theta) + 0.006)
        geoPoint.longitude = (z * cos(theta) + 0.0065)
        return geoPoint
    }
    
    /**
     *  将百度坐标转为GCJ-02(火星坐标):
     */
    static func transformFromBaiduToGCJ(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let x = p.longitude - 0.0065, y = p.latitude - 0.006
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * xPi)
        let theta = atan2(y, x) - 0.000003 * cos(x * xPi)
        var geoPoint: CLLocationCoordinate2D = CLLocationCoordinate2D()
        geoPoint.latitude  = z * sin(theta)
        geoPoint.longitude = z * cos(theta)
        return geoPoint
    }
    
    /**
     *  将GCJ-02(火星坐标)转为WGS-84:
     */
    static func transformFromGCJToWGS(_ p: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let threshold = 0.00001
        
        // The boundary
        var minLat = p.latitude - 0.5
        var maxLat = p.latitude + 0.5
        var minLng = p.longitude - 0.5
        var maxLng = p.longitude + 0.5
        
        var delta = 1.0
        let maxIteration = 30
        // Binary search
        while(true)
        {
            let leftBottom  = self.transformFromWGSToGCJ(CLLocationCoordinate2DMake(minLat, minLng))
            let rightBottom = self.transformFromWGSToGCJ(CLLocationCoordinate2DMake(minLat, maxLng))
            let leftUp      = self.transformFromWGSToGCJ(CLLocationCoordinate2DMake(maxLat, minLng))
            let midPoint    = self.transformFromWGSToGCJ(CLLocationCoordinate2DMake((minLat + maxLat) / 2.0, (minLng + maxLng) / 2.0))
            delta = fabs(midPoint.latitude - p.latitude) + fabs(midPoint.longitude - p.longitude)
            
            if(maxIteration-1 <= 0 || delta <= threshold)
            {
                return CLLocationCoordinate2DMake((minLat + maxLat) / 2.0, (minLng + maxLng) / 2.0)
            }
            
            if(isContains(p, leftBottom, midPoint))
            {
                maxLat = (minLat + maxLat) / 2.0
                maxLng = (minLng + maxLng) / 2.0
            }
            else if(isContains(p, rightBottom, midPoint))
            {
                maxLat = (minLat + maxLat) / 2.0
                minLng = (minLng + maxLng) / 2.0
            }
            else if(isContains(p, leftUp, midPoint))
            {
                minLat = (minLat + maxLat) / 2.0
                maxLng = (minLng + maxLng) / 2.0
            }
            else
            {
                minLat = (minLat + maxLat) / 2.0
                minLng = (minLng + maxLng) / 2.0
            }
        }
        
    }
    
    static func isContains(_ point: CLLocationCoordinate2D, _ p1: CLLocationCoordinate2D, _ p2: CLLocationCoordinate2D) -> Bool {
        return (point.latitude >= min(p1.latitude, p2.latitude) && point.latitude <= max(p1.latitude, p2.latitude)) && (point.longitude >= min(p1.longitude,p2.longitude) && point.longitude <= max(p1.longitude, p2.longitude))
    }
    static func transformLatWith(x: Double, y: Double) -> Double {
        var lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
        lat += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
        lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0
        lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0
        return lat
    }
    static func transformLonWith(x: Double, y: Double) -> Double {
        var lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
        lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
        lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0
        lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0
        return lon
    }
    
}




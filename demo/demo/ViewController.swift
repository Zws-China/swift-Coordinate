//
//  ViewController.swift
//  demo
//
//  Created by zws on 2021/10/9.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let coordinate = CLLocationCoordinate2DMake(32.0806670849, 118.9060163095)
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let WGSToGCJ = WSCoordinate.transformFromWGSToGCJ(coordinate)
        label1.text = "\(WGSToGCJ.latitude),\(WGSToGCJ.longitude)"
        
        
        let GCJToBaidu = WSCoordinate.transformFromGCJToBaidu(coordinate)
        label2.text = "\(GCJToBaidu.latitude),\(GCJToBaidu.longitude)"
        
        
        let baiduToGCJ = WSCoordinate.transformFromBaiduToGCJ(coordinate)
        label3.text = "\(baiduToGCJ.latitude),\(baiduToGCJ.longitude)"
        
        
        let GCJToWGS = WSCoordinate.transformFromGCJToWGS(coordinate)
        label4.text = "\(GCJToWGS.latitude),\(GCJToWGS.longitude)"
        
    }


    
    
    
    
    
    
}


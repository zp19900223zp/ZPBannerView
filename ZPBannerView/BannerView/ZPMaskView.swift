//
//  ZPMaskView.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/6/13.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit

/**
 枚举
 */
enum ZPBannerSrollDirection {
    case unknow
    case left
    case right
}

class ZPMaskView: UIView {

    var maskRadius : CGFloat = 0
    var direction : ZPBannerSrollDirection = .unknow
    func setRaidus(raidus:CGFloat, direction:ZPBannerSrollDirection) {
        self.maskRadius = raidus
        self.direction = direction
        if direction != .unknow {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        if direction != .unknow {
            let ctx = UIGraphicsGetCurrentContext()
            if direction == .left{
                ctx?.addArc(center: CGPoint(x: self.center.x + rect.width/2, y: self.center.y), radius: maskRadius, startAngle: 0, endAngle: .pi * 2, clockwise: false)
            }else{
                ctx?.addArc(center: CGPoint(x: self.center.x - rect.width / 2, y: self.center.y), radius: maskRadius, startAngle: 0, endAngle: .pi * 2, clockwise: false)
            }
            ctx?.setFillColor(UIColor.white.cgColor)
            ctx?.fillPath()
        }
    }
    
}

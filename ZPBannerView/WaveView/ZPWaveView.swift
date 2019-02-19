//
//  ZPWaveView.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/7/20.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit

@objc public protocol ZPWaveViewDelegate : class {
    /**
     中间浪的高度
     */
    @objc func centerWaveHeight(height:CGFloat)
}

class ZPWaveView: UIView {

    /**
     浪的曲度
     */
    @objc var waveCurvature:CGFloat = 1.5
    
    /**
     浪速
     */
    @objc var waveSpeed:CGFloat = 0.5
    
    /**
     浪高
     */
    @objc var waveHeight:CGFloat = 10{
        didSet{
            var frame = self.bounds
            frame.origin.y = frame.size.height - self.waveHeight
            frame.size.height = self.waveHeight
            realWaveLayer.frame = frame
            realWaveLayer.fillColor = self.realWaveColor.cgColor
            
            maskWaveLayer.frame = frame
            maskWaveLayer.fillColor = self.maskWaveColor.cgColor
        }
    }
    
    /**
     *  实浪颜色
     */
    @objc var realWaveColor:UIColor = UIColor.white
    
    /**
     *  遮罩浪颜色
     */
    @objc var maskWaveColor:UIColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1.0)
    
    public weak var delegate:ZPWaveViewDelegate?
    
    var timer:CADisplayLink?
    
    var offset : CGFloat = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 真实浪
    private lazy var realWaveLayer : CAShapeLayer = {
        let realWaveLayer = CAShapeLayer()
        var frame = self.bounds
        frame.origin.y = frame.size.height - self.waveHeight
        frame.size.height = self.waveHeight
        realWaveLayer.frame = frame
        realWaveLayer.fillColor = self.realWaveColor.cgColor
        return realWaveLayer;
    }()
    
    // 遮罩浪
    private lazy var maskWaveLayer:CAShapeLayer = {
        let  maskWaveLayer = CAShapeLayer()
        frame.origin.y = frame.size.height - self.waveHeight
        frame.size.height = self.waveHeight
        maskWaveLayer.frame = frame
        maskWaveLayer.fillColor = self.maskWaveColor.cgColor
        return maskWaveLayer
    }()
    
    func initData(){
        self.layer.addSublayer(self.realWaveLayer)
        self.layer.addSublayer(self.maskWaveLayer)
    }
    
    
    
    public func stopWaveAnimation(){
        self.timer = CADisplayLink(target: self, selector: #selector(wave))
        self.timer?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    public func startWaveAnimation(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func wave(){
        self.offset += self.waveHeight
        let width:CGFloat = self.frame.width
        let height:CGFloat = self.waveHeight
        
        //path1
        let path1:CGMutablePath = CGMutablePath()
        path1.move(to: CGPoint(x: 0, y: height))
        var path1y:CGFloat = 0.0
        
        // path2
        let path2:CGMutablePath = CGMutablePath()
        path2.move(to: CGPoint(x: 0, y: height))
        var path2y:CGFloat = 0.0;
        let width1 = Int(width)
        for x in 0...width1 {
            path1y = CGFloat(Float(height) * sinf(self.getSinfWithPercent(percent: 5.0, widthX: Float(x))))
            path1.addLine(to: CGPoint(x: CGFloat(x), y: path1y))
            
            path2y = CGFloat(Float(height) * sinf(self.getSinfWithPercent(percent: 3.2, widthX: Float(x))))
            path2.addLine(to: CGPoint(x: CGFloat(x), y: path2y))
        }
        
        // 变化的中间的y值
        let centX = self.bounds.size.width / 2.0
        let centY = CGFloat(Float(height) * sinf(self.getSinfWithPercent(percent: 5.0, widthX: Float(centX))))
        delegate?.centerWaveHeight(height: centY)
        
        path1.addLine(to: CGPoint(x: width, y: height))
        path1.addLine(to: CGPoint(x: 0, y: height))
        self.realWaveLayer.path = path1
        self.realWaveLayer.fillColor = self.realWaveColor.cgColor
        
        path2.addLine(to: CGPoint(x: width, y: height))
        path2.addLine(to: CGPoint(x: 0, y: height))
        self.maskWaveLayer.path = path2
        self.maskWaveLayer.fillColor = self.maskWaveColor.cgColor
        
    }
    
    func getSinfWithPercent(percent:Float, widthX:Float) -> Float{
        return (Float(self.waveCurvature) * widthX + Float(self.offset) * percent) / 100
    }

}

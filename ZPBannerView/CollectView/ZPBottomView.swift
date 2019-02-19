//
//  ZPBottomView.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/6/26.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit

@objc protocol ZPBottomViewDelegate :NSObjectProtocol {
    
    @objc func scrollViewExcursion(excursion:CGFloat)
    
    // 结束滑动
    @objc func endScrollViewExcursion(excursion:CGFloat)
}

class ZPBottomView: UIView,UIScrollViewDelegate {
    
    var scrollView:UIScrollView?
    let dataArray:Array<String> = ["读书","写字","看电视","玩游戏","侏罗纪公园","上山","下海","旅游","供桌","工作","图表","数组","字典","字符串"]
    weak var delegate:ZPBottomViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    func setUI() {
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        scrollView?.contentSize = CGSize(width: self.frame.size.width *  CGFloat(dataArray.count), height: self.frame.size.height)
        scrollView?.isPagingEnabled = true
        scrollView?.delegate = self
        self.addSubview(scrollView!)
        
        for i in 0..<dataArray.count {
            let bottomVC = ZPBottomViewController()
//            bottomVC.titleStr = dataArray[i]
            bottomVC.view.frame = CGRect(x: self.frame.size.width * CGFloat(i), y: 0, width: self.frame.size.width, height: self.frame.size.height)
            scrollView?.addSubview(bottomVC.view)
        }
    }
    
    // 滑动过程
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if delegate != nil && (self.delegate?.responds(to: #selector(self.delegate?.scrollViewExcursion(excursion:))))!{
            delegate?.scrollViewExcursion(excursion: scrollView.contentOffset.x)
        }
    }
    
    // 结束滑动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if delegate != nil && (self.delegate?.responds(to: #selector(self.delegate?.endScrollViewExcursion(excursion:))))!{
            delegate?.endScrollViewExcursion(excursion: scrollView.contentOffset.x)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  ZPCollectViewViewController.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/6/21.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit

class ZPCollectViewViewController: UIViewController,ZPPageViewDelegate {
    
    

    var topView:UIView?
    var scrollView:ZPScrollView?
    var bottomScrollView:ZPBottomView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setUI()
    }
    
    private lazy var titles: [String] = {
        return ["热门", "精彩推荐", "科技控", "游戏", "汽车", "财经童话时间", "搞笑", "图片"]
    }()

    private lazy var viewControllers: [UIViewController] = {
        var vcs = [UIViewController]()
        for _ in titles {
            vcs.append(ZPBottomViewController())
        }
        return vcs
    }()

    private lazy var layout: ZPLayout = {
        let layout = ZPLayout()
        layout.titleViewBgColor = UIColor(r: 255, g: 239, b: 213)
        layout.titleColor = UIColor(r: 0, g: 0, b: 0)
        layout.titleSelectColor = UIColor(r: 255, g: 0, b: 0)
        layout.bottomLineColor = UIColor.red
        layout.pageBottomLineColor = UIColor(r: 230, g: 230, b: 230)
//        layout.isAverage = true
        return layout
    }()

    private lazy var pageView : ZPPageView = {
        let pageView = ZPPageView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 64), currentViewController: self, viewControllers: viewControllers, titles: titles, layout:layout)
        pageView.isClickScrollAnimation = true
        pageView.delegate = self
        return pageView
    }()

    func setUI(){
        topView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64))
        topView?.backgroundColor = UIColor.black
        self.view.addSubview(topView!)
        view.addSubview(pageView)
        
        let backButton:UIButton = UIButton.init(type: UIButtonType.custom)
        backButton.frame = CGRect(x: 16, y: 0, width: 100, height: 64)
        backButton.setTitle("返回", for: UIControlState.normal)
        backButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(backButton(_:)), for: UIControlEvents.touchUpInside)
        topView?.addSubview(backButton)
    }
    
    func scrollViewExcursion(excursion: CGFloat) {
        scrollView?.locationOfMobile(location: excursion)
    }
    
    func endScrollViewExcursion(excursion: CGFloat) {
        scrollView?.endScrollView(location: excursion)
    }
    
    @objc func backButton(_ button:UIButton){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



//
//  ZPTableViewController.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/6/15.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit

class ZPTableViewController: UIViewController,ZPRightViewDelegate,ZPLeftViewDelegate {
    

    var topView:UIView?
    var leftView:ZPLeftView?
    var rightView:ZPRightView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setUI()
    }
    
    func setUI(){
        topView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64))
        topView?.backgroundColor = UIColor.black
        self.view.addSubview(topView!)
        
        let backButton:UIButton = UIButton.init(type: UIButtonType.custom)
        backButton.frame = CGRect(x: 16, y: 0, width: 100, height: 64)
        backButton.setTitle("返回", for: UIControlState.normal)
        backButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(backButton(_:)), for: UIControlEvents.touchUpInside)
        topView?.addSubview(backButton)
        
        leftView = ZPLeftView.init(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width / 4.0, height: self.view.frame.size.height - 64))
        leftView?.delegate = self
        self.view.addSubview(leftView!)
        
        rightView = ZPRightView.init(frame: CGRect(x: self.view.frame.size.width / 4.0, y: 64, width: (self.view.frame.size.width / 4.0)*3, height: self.view.frame.size.height - 64))
        rightView?.delegate = self
        self.view.addSubview(rightView!)
    }

    func selectIndex(index: Int) {
        leftView?.selectLeftIndex(index: index)
    }
    
    func selectLeftIndex(index: Int) {
        rightView?.selectRightIndex(index: index)
    }
    
    @objc func backButton(_ sender:UIButton){
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

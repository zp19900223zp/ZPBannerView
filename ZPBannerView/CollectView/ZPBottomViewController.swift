//
//  ZPBottomViewController.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/6/26.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit

class ZPBottomViewController: UIViewController {

    var titleLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       titleLabel = UILabel.init(frame: CGRect(x: self.view.frame.size.width / 2 - 50, y: self.view.frame.size.height / 2 - 30, width: 100, height: 60))
        titleLabel?.font = UIFont.systemFont(ofSize: 24)
        titleLabel?.textColor = UIColor.black
        titleLabel?.textAlignment = .center
//        titleLabel?.text = titleStr
        self.view.addSubview(titleLabel!)
    }
    
    public func titleStr(title:String){
        titleLabel?.text = title
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

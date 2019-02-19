//
//  ZPFoldViewController.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/6/14.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit

class ZPFoldViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let button = UIButton(type: UIButtonType.system)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100);
        button.backgroundColor = UIColor.yellow
        button.addTarget(self, action: #selector(selectB(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)
        
        let rightButton = UIButton(type: UIButtonType.custom)
        rightButton.frame = CGRect(x: 200, y: 100, width: 100, height: 100)
        rightButton.backgroundColor = UIColor.red
        rightButton.addTarget(self, action: #selector(rightButton(_ :)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(rightButton)
        
        let bottomButton = UIButton(type: UIButtonType.custom)
        bottomButton.frame = CGRect(x: 100, y: 200, width: 100, height: 100)
        bottomButton.backgroundColor = UIColor.blue
        bottomButton.addTarget(self, action: #selector(bottomButton(_ :)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(bottomButton)
        
        let rightButton1 = UIButton(type: UIButtonType.custom)
        rightButton1.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
        rightButton1.backgroundColor = UIColor.black
        self.view.addSubview(rightButton1)
        rightButton1.addTarget(self, action: #selector(rightButton1(_ :)), for: UIControlEvents.touchUpInside)
        
    }
    
    @objc func selectB(_ sender:UIButton){
        let foldVC = ZPFoldTableViewController.init(nibName: "ZPFoldTableViewController", bundle: nil)
        self.present(foldVC, animated: true, completion: nil)
    }
    
    @objc func rightButton(_ button:UIButton){
        let tableVC = ZPTableViewController()
        self.present(tableVC, animated: true, completion: nil)
    }
    
    @objc func bottomButton(_ button:UIButton){
        let collectionVC = ZPCollectViewViewController()
        self.present(collectionVC, animated: true, completion: nil)
    }
    
    @objc func rightButton1(_ button:UIButton){
        // 点击黑色的小块
        let waveVC = ZPWaveViewController()
        self.present(waveVC, animated: true, completion: nil)
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

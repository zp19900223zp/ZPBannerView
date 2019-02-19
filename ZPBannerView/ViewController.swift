//
//  ViewController.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/6/13.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ZPBannerViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var banner:ZPBannerView?
    var tableView:UITableView?
    let dataArray:Array = ["折叠菜单", "滑动菜单", "侧滑菜单"]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        banner?.adjustWhenControllerViewWillAppera()
    }
    
    func clickBanner(index: Int) {
        print(index)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        banner = ZPBannerView.init(frame: CGRect(x: 0, y: 0, width: mainW, height: mainW * 47 / 75))
        banner?.selectImage = #imageLiteral(resourceName: "home_banner_select")
        banner?.unselectImage = #imageLiteral(resourceName: "home_banner_unselect")
        banner?.delegate = self
        self.view.addSubview(banner!)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5) {
            self.setBanner()
        }
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: mainW * 47 / 75, width: mainW, height: mainH - (mainW * 47 / 75)), style: UITableViewStyle.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(UINib.init(nibName: "ZPRootTableViewCell", bundle: nil), forCellReuseIdentifier: "ZPRootTableViewCell")
        self.view.addSubview(tableView!)
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZPRootTableViewCell", for: indexPath) as!ZPRootTableViewCell
        cell.titleLabel.text = self.dataArray[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let foldVC = ZPFoldTableViewController.init(nibName: "ZPFoldTableViewController", bundle: nil)
            self.present(foldVC, animated: true, completion: nil)
        }else if indexPath.row == 1 {
            let tableVC = ZPTableViewController()
            self.present(tableVC, animated: true, completion: nil)
        }else if indexPath.row == 2 {
            let collectionVC = ZPCollectViewViewController()
            self.present(collectionVC, animated: true, completion: nil)
        }
     }
    
    func setBanner(){
        let model1 = ZPBannerModel()
        model1.img = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/6265b5b9bf8686f009cf44c366cfa4abd26b1a79.png"
        model1.bgImg = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/9bc42ce40490c854eab2e9969ac8e328caab0a17.png"
        
        
        let model2 = ZPBannerModel()
        model2.img = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/16f7ab6124ae4688f0adef43ff3ab3b1f09ccc67.png"
        model2.bgImg = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/81e9ad49cba8dc479a09d146a1fabf4b9ef3504d.png"
        
        let model3 = ZPBannerModel()
        model3.img = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/6265b5b9bf8686f009cf44c366cfa4abd26b1a79.png"
        model3.bgImg = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/9bc42ce40490c854eab2e9969ac8e328caab0a17.png"
        
        
        let model4 = ZPBannerModel()
        model4.img = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/16f7ab6124ae4688f0adef43ff3ab3b1f09ccc67.png"
        model4.bgImg = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/81e9ad49cba8dc479a09d146a1fabf4b9ef3504d.png"
    
        banner?.setBanner(banners: [model1,model2,model3,model4])
        
        
//        let button = UIButton.init(type: UIButtonType.custom)
//        button.frame = CGRect(x: 0, y: 300, width: 100, height: 100)
//        button.backgroundColor = UIColor.red
//        button.addTarget(self, action: #selector(selectQuestion(_:)), for: UIControlEvents.touchUpInside)
//        self.view.addSubview(button)
    }
    
    @objc func selectQuestion(_ sender:UIButton){
        let foldVC = ZPFoldViewController()
        self .present(foldVC, animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ZPRightView.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/6/15.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit

@objc protocol ZPRightViewDelegate : NSObjectProtocol{
    @objc func selectIndex(index:Int)
}

class ZPRightView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    
    weak var delegate:ZPRightViewDelegate?
    var rightTableView:UITableView?
    var dataRightList:NSMutableArray = []
    let titleRightList :[String] = ["蔬","菜","水","果","鲜","花","大","米","饭","运","筹","帷","幄","掌","握","提","案","评","议","米"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        for i in 1..<20{
            let str = titleRightList[i]
            let titileStr = "果蔬"+str+"家"
            dataRightList.add(titileStr)
        }
        setUI()
    }
    
    func setUI() {
        rightTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), style: UITableViewStyle.plain)
        
        rightTableView?.delegate = self
        rightTableView?.dataSource = self
        rightTableView?.register(UINib.init(nibName: "ZPRightTableViewCell", bundle: nil), forCellReuseIdentifier: "ZPRightTableViewCell")
        self.addSubview(rightTableView!)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 890
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init()
        headerView.backgroundColor = UIColor.yellow
        let label = UILabel.init(frame: CGRect(x: 150, y: 0, width: 100, height: 30))
        label.text = dataRightList[section] as? String
        label.textAlignment = .center
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataRightList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZPRightTableViewCell", for: indexPath) as! ZPRightTableViewCell
        return cell
    }
    
    public func selectRightIndex(index:Int)  {
        self.rightTableView?.scrollToRow(at: NSIndexPath.init(row: 0, section: index) as IndexPath, at: UITableViewScrollPosition.top, animated: true)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index:Int = Int(scrollView.contentOffset.y / 940)
        if delegate != nil && (self.delegate?.responds(to: #selector(self.delegate?.selectIndex(index:))))!{
            delegate?.selectIndex(index: index)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

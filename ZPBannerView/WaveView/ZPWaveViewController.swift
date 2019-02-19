//
//  ZPWaveViewController.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/7/20.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit

class ZPWaveViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ZPWaveViewDelegate {

    private lazy var tableView : UITableView = {
       let tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.tableHeaderView = headerView
        return tableView
    }()
    
    private lazy var headerView:ZPWaveView = {
       let headerView = ZPWaveView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 200))
        headerView.delegate = self
        headerView.backgroundColor = UIColor(r: 248, g: 64, b: 87)
        headerView.addSubview(self.iconImageView)
        headerView.startWaveAnimation()
        return headerView
        
    }()
    
    private lazy var iconImageView:UIImageView = {
        let iconImageView = UIImageView(frame: CGRect(x: self.headerView.frame.width / 2 - 30, y: 0, width: 60, height: 60))
        iconImageView.layer.borderColor = UIColor.white.cgColor
        iconImageView.layer.borderWidth = 2
        iconImageView.layer.cornerRadius = 20
        return iconImageView
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "这头像好浪~~~~ "
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.headerView.stopWaveAnimation()
    }
    
    func centerWaveHeight(height: CGFloat) {
        var iconFrame = self.iconImageView.frame
        iconFrame.origin.y = self.headerView.frame.height - self.iconImageView.frame.height + height - self.headerView.waveHeight
        self.iconImageView.frame = iconFrame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
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

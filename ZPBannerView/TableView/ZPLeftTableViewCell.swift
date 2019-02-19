//
//  ZPLeftTableViewCell.swift
//  ZPBannerView
//
//  Created by AOHY on 2018/6/15.
//  Copyright © 2018年 Config. All rights reserved.
//

import UIKit

class ZPLeftTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var leftView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

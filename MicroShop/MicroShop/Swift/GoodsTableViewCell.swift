//
//  GoodsTableViewCell.swift
//  MicroShop
//
//  Created by abc on 15/6/24.
//  Copyright (c) 2015年 App. All rights reserved.
//

import UIKit

class GoodsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cover: UIImageView!
    
    @IBOutlet weak var goods_name: UILabel!
    
    @IBOutlet weak var goods_price: UILabel!

    @IBOutlet weak var goods_commission: UILabel!
    
    @IBOutlet weak var goods_sales: UILabel!
    
    @IBOutlet weak var zf: UIButton!
    @IBOutlet weak var sj: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

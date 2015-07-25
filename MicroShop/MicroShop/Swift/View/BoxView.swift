//
//  BoxView.swift
//  MicroShop
//
//  Created by abc on 15/6/24.
//  Copyright (c) 2015年 App. All rights reserved.
//

import UIKit

class BoxView: UIView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderColor = UIColor(red:147/255.0, green:153/255.0, blue:155/255.0, alpha: 1).CGColor
        self.layer.borderWidth = CGFloat(0.5)
        
        self.layer.cornerRadius = CGFloat(4)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

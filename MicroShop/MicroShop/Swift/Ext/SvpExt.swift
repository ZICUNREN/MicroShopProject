//
//  SvpExt.swift
//  MicroShop
//
//  Created by abc on 15/6/24.
//  Copyright (c) 2015年 App. All rights reserved.
//
// MARK: - SVProgressHUD 扩展
extension SVProgressHUD{
    
    /// 显示加载
    class func showLoad(message:String){
    
        SVProgressHUD.setBackgroundColor(UIColor(red:0, green:0, blue:0, alpha: 0.6))
        SVProgressHUD.setForegroundColor(UIColor(red:243/255.0, green:247/255.0, blue:251/255.0, alpha: 1))
        SVProgressHUD.showWithStatus(message)
    }
    /// 正确提示
    class func alertSuccess(message:String){
        SVProgressHUD.setBackgroundColor(UIColor(red:0, green:0, blue:0, alpha: 0.5))
        SVProgressHUD.setForegroundColor(UIColor(red:243/255.0, green:247/255.0, blue:251/255.0, alpha: 1))
        SVProgressHUD.showSuccessWithStatus(message)
    }
    /// 错误提示
    class func alertError(message:String){
        SVProgressHUD.setBackgroundColor(UIColor(red:0, green:0, blue:0, alpha: 0.5))
        SVProgressHUD.setForegroundColor(UIColor(red:243/255.0, green:247/255.0, blue:251/255.0, alpha: 1))
        SVProgressHUD.showErrorWithStatus(message)
    }
    
}

//
//  FeedBackViewController.swift
//  MicroShop
//
//  Created by abc on 15/6/24.
//  Copyright (c) 2015年 App. All rights reserved.
//

import UIKit

class FeedBackViewController: UIViewController,UITextViewDelegate{
    
    
    @IBOutlet weak var content_cont: UILabel!
    
    @IBOutlet weak var content_input: UITextView!
    
    
    @IBOutlet weak var contact_input: UITextField!
    
    @IBOutlet weak var sub: UIButton!
    
    var content:String?
    var contact:String? = ""
    
    var is_ck:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "用户反馈"
        
        
        self.content_input.delegate = self
        
        self.sub.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textViewDidChange(textView: UITextView) {
            
        var content_ch:NSString = textView.text
        var c:Int = content_ch.length
        if c >= 500{
           self.is_ck = false
            var c_c = c - 500
            self.content_cont.text = "已超出\(c_c)"
            self.sub.enabled = false
            
        }else if c <= 0{
            self.is_ck = false
            self.content_cont.text = "(0/500)"
            self.sub.enabled = false
        }else{
            self.is_ck = true
            self.content = content_ch as String
            self.content_cont.text = "(\(c)/500)"
            self.sub.enabled = true
        }
        
    }
    
    @IBAction func sub_send(sender: AnyObject) {
        
        if is_ck{
            
            SVProgressHUD.showLoad("正在提交")
            
            self.contact = contact_input.text
            var  authcode = OCToSwift.sharedManager().userToken()
            var par = ["authcode":authcode,"content":self.content,"contact":self.contact]
            
            var action_url:String = "\(HomeURL)\(User_Feedback)";
            
            
            NetworkInterface.shareInstance().requestForPost(action_url, parms: par, complete: { (re) -> Void in
                
                
                let code:Int? = re["code"] as? Int
                let message = re["message"] as! String
                if code == 1{
                    self.contact_input.text = ""
                    self.content_input.text = ""
                    self.is_ck = false
                    self.sub.enabled = false
                    
                    SVProgressHUD.alertSuccess(message)
                }else{
                    
                    SVProgressHUD.alertError(message)
                }
                
                
                
            }, error: { (error) -> Void in
                
                SVProgressHUD.alertError("请求错误")
                
            })
            
            
            
        }else{
            SVProgressHUD.alertError("填写内容有误")
        }
        
    }

}

//
//  GoodsViewController.swift
//  MicroShop
//
//  Created by abc on 15/6/23.
//  Copyright (c) 2015年 App. All rights reserved.
//

import UIKit

class GoodsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    
    
    @IBOutlet weak var tableiew: UITableView!
    
    @IBOutlet weak var hederView: UIView!
    
    
    @IBOutlet weak var typeView: UIView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var class_btn: UIButton!
    @IBOutlet weak var order_nav: UISegmentedControl!
    var model:SYWebURLModel = SYWebURLModel()
    
    var tableData:[JSON] = []
    
    var class_list_data:[JSON] = []
    
    
    var getUrl = "\(HomeURL)\(Supply_Goods_URL)"
    
    
    var page = 1
    
    var order:Int = 1
    
    var name:String?
    var goods_class_id:Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "产品"
        
        self.tableiew.dataSource = self
        self.tableiew.delegate = self
        
        self.searchbar.delegate = self
        
        self.tableiew.separatorInset = UIEdgeInsetsZero
        self.tableiew.layoutMargins = UIEdgeInsetsZero
        
        
        self.tableiew.tableHeaderView = hederView

        
        
        self.tableiew.addHeaderWithCallback { () -> Void in
            self.reLoad()
        }
        self.tableiew.addFooterWithCallback { () -> Void in
            self.nextPage()
            
        }
        
        SVProgressHUD.showLoad("加载中")
        
        
        model = SYGettingWebURLData.sharedManager().getWebURLData();
        
        
        reLoad()
        
    }
    
    
    func reLoad(){
        page = 1
        var  authcode = OCToSwift.sharedManager().userToken()
        getUrl = "\(getUrl)&authcode=\(authcode)&order=\(order)&p=\(page)"
        
        if let pre_name = name{
            getUrl = "\(getUrl)&name=\(pre_name)"
        }
        if let pre_class_id = goods_class_id{
            getUrl = "\(getUrl)&class=\(pre_class_id)"
        }
        
        
        NetworkInterface.shareInstance().requestForGet(getUrl, complete: { (re:[NSObject : AnyObject]!) -> Void in
            
            SVProgressHUD.dismiss()
            
            
            let json = JSON(re)
            
            if let class_data = json["data"]["class_list"].array{
                
                self.class_list_data = class_data
            }
            
            if let data = json["data"]["list"].array{
                
                
                self.tableData = data
                
                self.tableiew.reloadData()
                self.tableiew.endRefreshing()
            }else{
                self.tableiew.loadAll()
            }
            
            }) { (error:NSError!) -> Void in
            
                self.tableiew.endRefreshing()
                
        }
    }
    
    func nextPage(){
        page = page+1
        var  authcode = OCToSwift.sharedManager().userToken()
        getUrl = "\(getUrl)&authcode=\(authcode)&order=\(order)&p=\(page)"
        
        if let pre_name = name{
            getUrl = "\(getUrl)&name=\(pre_name)"
        }
        if let pre_class_id = goods_class_id{
            getUrl = "\(getUrl)&class=\(pre_class_id)"
        }
                
        NetworkInterface.shareInstance().requestForGet(getUrl, complete: { (re:[NSObject : AnyObject]!) -> Void in
            
            let json = JSON(re)
            if let class_data = json["data"]["class_list"].array{
                self.class_list_data = class_data
            }
            
            if let data = json["data"]["list"].array{
                
                
                        self.tableData = self.tableData+data
                
                self.tableiew.reloadData()
                self.tableiew.endRefreshing()
                
                if data.count <= 0{
                    self.tableiew.loadAll()
                }
                
            }else{
                self.tableiew.loadAll()
            }
            
            
            }) { (error:NSError!) -> Void in
                
                self.tableiew.endRefreshing()
                
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 45
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return typeView
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let rowData = tableData[indexPath.row]
        
        let cell:GoodsTableViewCell? = self.tableiew.dequeueReusableCellWithIdentifier("goodscell") as? GoodsTableViewCell
        
        
        cell?.zf?.tag = indexPath.row
        cell?.sj?.tag = indexPath.row
        
        
        let is_sell:Int = rowData["is_sell"].intValue
        if is_sell == 1{
            cell?.sj.setTitle("已上架", forState: UIControlState.Normal)
            cell?.sj.setBackgroundImage(UIImage(named: "gray_btn"), forState: UIControlState.Normal)
        }else{
            cell?.sj.setTitle("上架", forState: UIControlState.Normal)
            cell?.sj.setBackgroundImage(UIImage(named: "red_btn"), forState: UIControlState.Normal)
            
        
        }
        
        cell?.goods_name?.text = rowData["goods_name"].string!
        let price = rowData["goods_price"].string!
        cell?.goods_price?.text = "¥\(price)"
        let commission = rowData["goods_commission"].string!
        cell?.goods_commission?.text = "佣金:\(commission)"
        let sales = rowData["goods_sales"].string!
        cell?.goods_sales?.text = "销量:\(sales)"
        
        cell?.cover?.layer.cornerRadius = 3
        cell?.cover?.sd_setImageWithURL(NSURL(string: rowData["cover"].string!))
        
        
        cell?.separatorInset = UIEdgeInsetsZero
        cell?.layoutMargins = UIEdgeInsetsZero
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableiew.deselectRowAtIndexPath(indexPath, animated: true)
        var rowData = tableData[indexPath.row]
        
        let goods_id:Int = rowData["goods_id"].intValue
        
        var url = model.Spread_Good_Detail
        
        
        
        let mainStoryboard = UIStoryboard(name: "Html", bundle: NSBundle.mainBundle())
        let vc : SYGeneralHtmlViewController = mainStoryboard.instantiateViewControllerWithIdentifier("generalHtmlVC") as! SYGeneralHtmlViewController
        vc.hidesBottomBarWhenPushed = true
        
        vc.url = "\(url)&good_id=\(goods_id)"
        vc.navTitle = "产品详情"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        var name = searchBar.text
        
        searchBar.resignFirstResponder()
        
        if let name_str = name{
            self.name = name_str
            SVProgressHUD.showLoad("搜索中")
            self.reLoad()
        }
        
        
    }
    
    @IBAction func order_click(sender: AnyObject) {
        var select:Int =  sender.selectedSegmentIndex+1
        if select != order{
            order = select
            SVProgressHUD.showLoad("加载中")
            self.reLoad()
        }
        
    }
    

    @IBAction func zf_click(sender: UIButton) {
        
        var row:Int = sender.tag
        
        var rowData = tableData[row]
        
        var goods_id:String? = rowData["goods_id"].string!
        
        println(goods_id)
        
        OCToSwift.sharedManager().requestAddSell(goods_id)
        
        
    }
    @IBAction func sj_click(sender: UIButton) {
        var row:Int = sender.tag
        
        var rowData = tableData[row]
        
        let goods_id:Int = rowData["goods_id"].intValue
        
        let is_sell:Int = rowData["is_sell"].intValue
        if is_sell == 0{
            let  authcode = OCToSwift.sharedManager().userToken()
            let url = "\(HomeURL)\(Spread_Add_Sell)&authcode=\(authcode)&goods_id=\(goods_id)"
            NetworkInterface.shareInstance().requestForGet(url, complete: { (re) -> Void in
                
                SVProgressHUD.alertSuccess("上架成功")
                sender.setTitle("已上架", forState: UIControlState.Normal)
                sender.setBackgroundImage(UIImage(named: "gray_btn"), forState: UIControlState.Normal)
                
            }, error: { (error) -> Void in
                SVProgressHUD.alertError("上架失败")
            })
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
}

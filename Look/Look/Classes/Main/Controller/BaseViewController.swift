//
//  BaseViewController.swift
//  NewbieMaintainCarBySwift
//
//  Created by tengan on 2017/3/7.
//  Copyright © 2017年 tenganByJerry. All rights reserved.
//

import UIKit


class BaseViewController: UIViewController {
    

    
    func AddLeftButtonImage(name:NSString,targets:AnyObject,action:Selector) -> Void {
        
        let button = UIButton(type:.custom)
        button.frame = CGRect(x: -34, y: 10, width: 75, height: 45)
        button.setImage(UIImage(named:name as String),for:.normal)
        button.setImage(UIImage(named:name as String),for:.selected)
        button.setImage(UIImage(named:name as String),for:.highlighted)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: action, for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
        
    }
    
    func AddRightButtonTile(name:NSString,targets:AnyObject,action:Selector) -> Void {
        
        let button = UIButton(type:.custom)
        button.frame = CGRect(x: 0, y: 10, width: 75, height: 45)
        button.setTitle(name as String, for: .normal)
        button.setTitle(name as String,for:.selected)
        button.setTitle(name as String,for:.highlighted)
        button.contentHorizontalAlignment = .right
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: action, for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        
    }
    
   @objc func goBack() -> Void {
        
        _ =  navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.green
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white,NSAttributedStringKey.font:UIFont(name: "Helvetica-Bold", size: 19.0)!]
        if (view == self) {
            // 背景设置为黑色
            navigationController?.navigationBar.tintColor = UIColor.white
            // 透明度设置为0
            navigationController?.navigationBar.alpha = 0.000;
            // 设置为半透明
            navigationController?.navigationBar.isTranslucent = true;
        } else { navigationController?.navigationBar.alpha = 1;
            // 背景颜色设置为系统默认颜色
            self.navigationController?.navigationBar.tintColor = nil;
            self.navigationController?.navigationBar.isTranslucent = false;
        }
        
        view.backgroundColor = UIColor.groupTableViewBackground

        automaticallyAdjustsScrollViewInsets = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
extension UIColor {
    //返回随机颜色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

//
//  MyTabBarVC.swift
//  News
//
//  Created by 王峰 on 2018/7/28.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

class MyTabBarVC: UITabBarController {

    


    override func viewDidLoad() {
        super.viewDidLoad()

//        UITabBar.appearance().tintColor = UIColor.red
//        addChildViewControllers()
        
        // 设置全局的文字图片的选中颜色
//        tabBar.tintColor = UIColor (hexString: "#00C15C")
        
        
     
        WFTool.sharedInstance.getStartTime()
        
        tabBar.tintColor = UIColor.red
        
        let tabbarArray = [["title":"首页", "imageName":"home_tabbar_32x32_", "selectImage":"home_tabbar_press_32x32_"],
                           ["title":"发现", "imageName":"video_tabbar_32x32_", "selectImage":"video_tabbar_press_32x32_"],
                           ["title":"关注", "imageName":"huoshan_tabbar_32x32_", "selectImage":"huoshan_tabbar_press_32x32_"],
                           ["title":"我的", "imageName":"mine_tabbar_32x32_", "selectImage":"mine_tabbar_press_32x32_"]]
        

        var i = 0
        
        for item in tabBar.items ?? [] {
            
            item.title = tabbarArray[i]["title"]
            item.image = UIImage(named: tabbarArray[i]["imageName"]!)
            item.selectedImage = UIImage(named: tabbarArray[i]["selectImage"]!)
            i += 1
        }
    }
    
//    ///添加子控制器
//    func addChildViewControllers()  {
//        setChildViewController(HomeVC(), title: "首页", imageName: "home_tabbar_32x32_", selectImage: "home_tabbar_press_32x32_")
//        setChildViewController(VideoVC(), title: "视频", imageName: "video_tabbar_32x32_", selectImage: "video_tabbar_press_32x32_")
//        setChildViewController(HuoshanVC(), title: "小视频", imageName: "huoshan_tabbar_32x32_", selectImage: "huoshan_tabbar_press_32x32_")
//        setChildViewController(MineVC(), title: "我的", imageName: "mine_tabbar_32x32_", selectImage: "mine_tabbar_press_32x32_")
//    }
//
//    /// 初始化子控制器
//    func setChildViewController(_ childController: UIViewController, title: String, imageName: String, selectImage: String) {
//        childController.tabBarItem.image = UIImage(named: imageName)
//        childController.tabBarItem.selectedImage = UIImage(named: selectImage)
//        childController.tabBarItem.title = title
//        
//        //添加导航控制器为 UITabBarController 的字控制器
//        let navVC = MyNavigationVC(rootViewController: childController)
//        
//        addChildViewController(navVC)
//        
//    }

}

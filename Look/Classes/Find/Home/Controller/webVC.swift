//
//  webVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/24.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit

class webVC: BaseViewController ,NSURLConnectionDelegate{

    @IBOutlet weak var webView: UIWebView!
    
    var jumpUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 连接加载
//        webView.loadRequest(URLRequest.init(url: URL.init(string: "https://www.baidu.com")!))

        webView.loadRequest(URLRequest.init(url: URL(string: jumpUrl)!))
    }

}

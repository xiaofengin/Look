//
//  HomeVC.swift
//  News
//
//  Created by 王峰 on 2018/7/28.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftyJSON
class HomeVC: BaseViewController, UIScrollViewDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var scrollV: UIScrollView!
    
    
    var current:CGFloat = 0.0
    var isScroll = true
    
    let hotNews:HotNewsVC = HotNewsVC()
    let smallVideo:SmallVideoVC = SmallVideoVC()
    let recommend:RecommendVC = RecommendVC()
    let titlevc:TitleVC = TitleVC()
    
    var titleArray = [TitleModel]()
    
    let disposeBag = DisposeBag()
    /// 懒加载 头部
    private lazy var segmentV = segmentView.loadViewFromNib()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        setStatusBarBackgroundColor(color: UIColor.white)
         
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"

        

        segmentV.frame = CGRect(x: 0, y: 0, width: topView.width, height: 44)
        segmentV.titleWidth = Double((Kwidth-110)/3)
        segmentV.defaultTag = 2;
        segmentV.titleArray = ["热点","推荐","小视频"];
        segmentV.segmentSelect = { [weak self] (tag)->() in
            
            printCtm(tag)
            if tag == 1 {
                self?.hotNews.hotNewsRequset()
            }else if tag == 3 {
                self?.smallVideo.smallVideoRequset()
            }else{
                self?.recommend.recommendRequset()
            }
            self?.isScroll = false;
            self?.scrollV.setContentOffset(CGPoint(x: Kwidth*CGFloat((tag-1)), y: 0), animated: true)
        }
        self.topView.addSubview(segmentV);
        
//        hotNews = HotNewsVC()
        hotNews.view.frame = CGRect(x: 0, y: 0, width: scrollV.width, height: scrollView.height)
        self.addChildViewController(hotNews)
        scrollV.addSubview(hotNews.view)
        
//        let recommend = RecommendVC()
        recommend.view.frame = CGRect(x: Kwidth, y: 0, width: scrollV.width, height: scrollView.height)
        self.addChildViewController(recommend)
        scrollV.addSubview(recommend.view)
        
//        let smallVideo = SmallVideoVC()
        smallVideo.view.frame = CGRect(x: Kwidth*2, y: 0, width: scrollV.width, height: scrollView.height)
        self.addChildViewController(smallVideo)
        scrollV.addSubview(smallVideo.view)

        
        titlevc.view.frame = self.view.bounds
        titlevc.view.x = -Kwidth;
        titlevc.titleSelect = {[weak self] (cellIndex, data) in
            
            let vc = MoreVC()
            vc.titleArray = data
            vc.selectCell = cellIndex
            vc.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
        let window = UIApplication.shared.keyWindow
        window?.addSubview(titlevc.view)
        
        _ = recommend.rx.observe(CGRect.self, "view.frame").subscribe { (f) in
//                        printCtm(f)
            //            print(f)
        }
        
//        //拖动手势
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(viewPan(sender:)))
//        
//        self.scrollV.addGestureRecognizer(gesture)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
           
            self.isScroll = false;
            self.scrollV.setContentOffset(CGPoint(x: Kwidth, y: 0), animated: false)
        }
    }
    
//    /**平移事件*/
//    @objc func viewPan(sender: UIPanGestureRecognizer) {
//        let _transX = sender.translation(in: scrollV).x
//        let _transY = sender.translation(in: scrollV).y
//        scrollV.transform = CGAffineTransform(translationX: _transX, y: _transY)
//    }


    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        current = scrollView.contentOffset.x/Kwidth
        
        isScroll = true
    }

    // 在开发中如果需要监听scrollView滚动是否停止可以这样写
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
         printCtm("结束le\(offsetX)")
        segmentV.titleSlect(sender: segmentV.buttonsMuArray[Int(offsetX/Kwidth)])

    }
   

    //滑动过程中
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x

        if offsetX < 0 {
            UIView.animate(withDuration: 0.3) {
//                self.titlevc.view.x = 0;
                UIApplication.shared.keyWindow?.rootViewController?.view.x = -offsetX;
//                scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
//                self.scrollV.x = offsetX
            }
        }
        
        if offsetX>0 && offsetX<Kwidth*2 && isScroll{

            let offsetWidth = (offsetX.truncatingRemainder(dividingBy: Kwidth))
             printCtm(offsetX)
            
            ///仿闪屏
            if offsetWidth<10{
                return;
            }
            if current*Kwidth < offsetX{
                
                if offsetWidth < Kwidth/2{
                    ///下划线变化
                    segmentV.sublineView.width = 10 + offsetWidth/(Kwidth/2)*CGFloat(segmentV.titleWidth-5)
                    segmentV.sublineView.x = ((segmentV.lastBut?.x)! + CGFloat(segmentV.titleWidth/2-5.0));
                    
                    ///标题颜色变化
                    let but1Color:UIColor = UIColor(red: 1-offsetWidth/Kwidth, green: 0, blue: 0, alpha: 1)
                    let but2Color:UIColor = UIColor(red: offsetWidth/Kwidth, green: 64/255, blue: 64/255, alpha: 1)
                    let nextBut:UIButton = segmentV.buttonsMuArray[(segmentV.lastBut?.tag)!]
                    
                    changeTitleColor(title1But: segmentV.lastBut!, title1Color: but1Color, title2But: nextBut, title2Color: but2Color)
                }else{

                    ///下划线变化
                    segmentV.sublineView.x = ((segmentV.lastBut?.x)! + CGFloat(segmentV.titleWidth/2-5.0))+5 + (offsetWidth/(Kwidth/2)-1)*CGFloat(segmentV.titleWidth-5);
                    segmentV.sublineView.width = CGFloat(segmentV.titleWidth+5) - (offsetWidth/(Kwidth/2)-1)*CGFloat(segmentV.titleWidth-5)

                    
                    ///标题颜色变化
                    let but1Color:UIColor = UIColor(red: 1-offsetWidth/Kwidth, green: 64/255, blue: 64/255, alpha: 1)
                    let but2Color:UIColor = UIColor(red: offsetWidth/Kwidth, green: 0, blue: 0, alpha: 1)
                    let nextBut:UIButton = segmentV.buttonsMuArray[(segmentV.lastBut?.tag)!]
                    
                    changeTitleColor(title1But: segmentV.lastBut!, title1Color: but1Color, title2But: nextBut, title2Color: but2Color)
                }
                
            }else{
                
                if offsetWidth < Kwidth/2{
                    ///下划线变化
                    segmentV.sublineView.width = 10 + offsetWidth/(Kwidth/2)*CGFloat(segmentV.titleWidth-5)
                    segmentV.sublineView.x = (((segmentV.lastBut?.x)!-CGFloat(segmentV.titleWidth)) + CGFloat(segmentV.titleWidth/2-5.0));
                    
                    ///标题颜色变化
                    let but1Color:UIColor = UIColor(red: offsetWidth/Kwidth, green: 64/255, blue: 64/255, alpha: 1)
                    let but2Color:UIColor = UIColor(red: 1-offsetWidth/Kwidth, green: 0, blue: 0, alpha: 1)
                    let nextBut:UIButton = segmentV.buttonsMuArray[(segmentV.lastBut?.tag)!-2]
                    
                    changeTitleColor(title1But: segmentV.lastBut!, title1Color: but1Color, title2But: nextBut, title2Color: but2Color)
                    
                }else{
                    ///下划线变化
                    segmentV.sublineView.x = (((segmentV.lastBut?.x)!-CGFloat(segmentV.titleWidth)) + CGFloat(segmentV.titleWidth/2-5.0))+5 + (offsetWidth/(Kwidth/2)-1)*CGFloat(segmentV.titleWidth-5);
                    segmentV.sublineView.width = CGFloat(segmentV.titleWidth+5) - (offsetWidth/(Kwidth/2)-1)*CGFloat(segmentV.titleWidth-5)
                    
                    ///标题颜色变化
                    let but1Color:UIColor = UIColor(red: offsetWidth/Kwidth, green: 0, blue: 0, alpha: 1)
                    let but2Color:UIColor = UIColor(red: 1-offsetWidth/Kwidth, green: 64/255, blue: 64/255, alpha: 1)
                    let nextBut:UIButton = segmentV.buttonsMuArray[(segmentV.lastBut?.tag)!-2]
                    
                    changeTitleColor(title1But: segmentV.lastBut!, title1Color: but1Color, title2But: nextBut, title2Color: but2Color)
                }
            }
        }
        
    }
    func changeTitleColor(title1But:UIButton, title1Color:UIColor, title2But:UIButton, title2Color:UIColor ) {
        
        title1But.setTitleColor(title1Color, for: .normal)
        title2But.setTitleColor(title2Color, for: .normal)
        
    }
    @IBAction func OnMenuClick() {
        

        UIView.animate(withDuration: 0.3) {
            self.titlevc.view.x = 0;
        }

    }
    
    @IBAction func OnSearchClick() {
        
        
    }

    

}









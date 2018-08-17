//
//  MoreVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/14.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit

class MoreVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scrollV: UIScrollView!
    var isScroll = true
    var current:CGFloat = 0.0
    var titleArray = [TitleModel]()
    var selectCell = 0
    var vcsArray = [MoreSubVC]()
    
    
    /// 懒加载 头部
    private lazy var segmentV = segmentView.loadViewFromNib()
    
//    override func viewWillLayoutSubviews() {
//        isScroll = false;
//        scrollV.setContentOffset(CGPoint(x: Kwidth*CGFloat(cellIndex), y: 0), animated: false)
//        
//    }
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

        segmentV.frame = CGRect(x: 0, y: 0, width: topView.width, height: 44)
        segmentV.titleWidth = 60
        segmentV.defaultTag = selectCell+1;
        var titleMuArray = [String]()
        for mdole in titleArray {
            titleMuArray.append(mdole.name)
        }
        
        segmentV.titleArray = titleMuArray;
        segmentV.segmentSelect = { [weak self] (tag)->() in
            
            printCtm(tag)
 
            self?.isScroll = false;
            self?.scrollV.setContentOffset(CGPoint(x: Kwidth*CGFloat((tag-1)), y: 0), animated: true)
            
            let vc = self?.vcsArray[tag-1];
            vc?.channelId = (self?.titleArray[tag-1].id)!
            vc?.MoreSubRequset()
            
            
        }
        self.topView.addSubview(segmentV);
        
        for (i,_) in titleMuArray.enumerated() {
            let vc = MoreSubVC()
            vc.view.frame = CGRect(x: CGFloat(i)*Kwidth, y: 0, width: scrollV.width, height: scrollV.height)
            self.addChildViewController(vc)
            scrollV.addSubview(vc.view)
            vcsArray.append(vc);
        }
    }

    @IBAction func OnBlackClick() {
        navigationController?.popViewController(animated: true)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
        current = scrollView.contentOffset.x/Kwidth
        printCtm(current)
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
//                UIApplication.shared.keyWindow?.rootViewController?.view.x = -offsetX;
                //                scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
                //                self.scrollV.x = offsetX
            }
        }
        
        if offsetX>0 && offsetX<Kwidth*11 && isScroll{
            
            let offsetWidth = (offsetX.truncatingRemainder(dividingBy: Kwidth))
//            printCtm(offsetX)
            
            let currentBut = segmentV.buttonsMuArray[Int(current)]
            ///仿闪屏
            if offsetWidth<10{
                return;
            }
            if current*Kwidth < offsetX{
                
                if offsetWidth < Kwidth/2{
                    ///下划线变化
                    segmentV.sublineView.width = 10 + offsetWidth/(Kwidth/2)*CGFloat(segmentV.titleWidth-5)
                    segmentV.sublineView.x = ((currentBut.x) + CGFloat(segmentV.titleWidth/2-5.0));
                    
                    ///标题颜色变化
                    let but1Color:UIColor = UIColor(red: 1-offsetWidth/Kwidth, green: 0, blue: 0, alpha: 1)
                    let but2Color:UIColor = UIColor(red: offsetWidth/Kwidth, green: 64/255, blue: 64/255, alpha: 1)
                    let nextBut:UIButton = segmentV.buttonsMuArray[(currentBut.tag)]
                    
                    changeTitleColor(title1But: currentBut, title1Color: but1Color, title2But: nextBut, title2Color: but2Color)
                }else{
                    
                    ///下划线变化
                    segmentV.sublineView.x = ((currentBut.x) + CGFloat(segmentV.titleWidth/2-5.0))+5 + (offsetWidth/(Kwidth/2)-1)*CGFloat(segmentV.titleWidth-5);
                    segmentV.sublineView.width = CGFloat(segmentV.titleWidth+5) - (offsetWidth/(Kwidth/2)-1)*CGFloat(segmentV.titleWidth-5)
                    
                    
                    ///标题颜色变化
                    let but1Color:UIColor = UIColor(red: 1-offsetWidth/Kwidth, green: 64/255, blue: 64/255, alpha: 1)
                    let but2Color:UIColor = UIColor(red: offsetWidth/Kwidth, green: 0, blue: 0, alpha: 1)
                    let nextBut:UIButton = segmentV.buttonsMuArray[(currentBut.tag)]
                    
                    changeTitleColor(title1But: currentBut, title1Color: but1Color, title2But: nextBut, title2Color: but2Color)
                }
                
            }else{
                
                if offsetWidth < Kwidth/2{
                    ///下划线变化
                    segmentV.sublineView.width = 10 + offsetWidth/(Kwidth/2)*CGFloat(segmentV.titleWidth-5)
                    segmentV.sublineView.x = (((currentBut.x)-CGFloat(segmentV.titleWidth)) + CGFloat(segmentV.titleWidth/2-5.0));
                    
                    ///标题颜色变化
                    let but1Color:UIColor = UIColor(red: offsetWidth/Kwidth, green: 64/255, blue: 64/255, alpha: 1)
                    let but2Color:UIColor = UIColor(red: 1-offsetWidth/Kwidth, green: 0, blue: 0, alpha: 1)
                    let nextBut:UIButton = segmentV.buttonsMuArray[(currentBut.tag)-2]
                    
                    changeTitleColor(title1But: currentBut, title1Color: but1Color, title2But: nextBut, title2Color: but2Color)
                    
                }else{
                    ///下划线变化
                    segmentV.sublineView.x = (((currentBut.x)-CGFloat(segmentV.titleWidth)) + CGFloat(segmentV.titleWidth/2-5.0))+5 + (offsetWidth/(Kwidth/2)-1)*CGFloat(segmentV.titleWidth-5);
                    segmentV.sublineView.width = CGFloat(segmentV.titleWidth+5) - (offsetWidth/(Kwidth/2)-1)*CGFloat(segmentV.titleWidth-5)
                    
                    ///标题颜色变化
                    let but1Color:UIColor = UIColor(red: offsetWidth/Kwidth, green: 0, blue: 0, alpha: 1)
                    let but2Color:UIColor = UIColor(red: 1-offsetWidth/Kwidth, green: 64/255, blue: 64/255, alpha: 1)
                    let nextBut:UIButton = segmentV.buttonsMuArray[(currentBut.tag)-2]
                    
                    changeTitleColor(title1But: currentBut, title1Color: but1Color, title2But: nextBut, title2Color: but2Color)
                }
            }
        }
        
    }
    func changeTitleColor(title1But:UIButton, title1Color:UIColor, title2But:UIButton, title2Color:UIColor ) {
        
        title1But.setTitleColor(title1Color, for: .normal)
        title2But.setTitleColor(title2Color, for: .normal)
        
    }
}




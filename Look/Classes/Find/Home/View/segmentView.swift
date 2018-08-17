//
//  segmentView.swift
//  Look
//
//  Created by 王峰 on 2018/8/9.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit

class segmentView: UIView, NibLoadable, UIScrollViewDelegate {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var sublineView: UIView!
    @IBOutlet weak var scrollV: UIScrollView!
    @IBOutlet weak var scrollWidth: NSLayoutConstraint!
    @IBOutlet weak var subLineX: NSLayoutConstraint!
    
    var segmentSelect:((_ butTag:Int)->())?
    
    var titleWidth = 0.0
    var lastBut:UIButton?
    
    var defaultTag = 1

    
    var buttonsMuArray = [UIButton]()
    
    var titleArray = [String](){
        didSet{
            
            sublineView.layer.masksToBounds = true
            sublineView.layer.cornerRadius = 1.5
            scrollWidth.constant = CGFloat(titleWidth * Double(titleArray.count))
            for (i, titleStr) in titleArray.enumerated() {
               
                let titleBut = UIButton(frame: CGRect(x: Double(i)*titleWidth, y: 0.0, width: titleWidth, height: 44.0))
                titleBut.setTitle(titleStr, for: .normal)
                titleBut.setTitleColor(UIColor.black, for: .normal)
                titleBut.tag = i+1;
                titleBut.addTarget(self, action:#selector(titleSlect(sender:)), for: .touchUpInside)
                titleView.addSubview(titleBut)
                buttonsMuArray.append(titleBut)
                if i == defaultTag-1{
                    subLineX.constant = CGFloat(Double(titleBut.x) + titleWidth/2-5.0)
                    titleBut.setTitleColor(UIColor.red, for: .normal)
                    self.setNeedsLayout()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        self.self.segmentSelect?(titleBut.tag)
                    }
                   
//                    lastBut = titleBut
                }
            }
            
            titleSlect(sender: self.viewWithTag(defaultTag) as! UIButton)
        }
    }
    
    @objc func titleSlect(sender: UIButton) {
        if lastBut != sender {
            printCtm(sender.tag)
            for but in buttonsMuArray{
                if but != sender{
                    but.setTitleColor(UIColor.black, for: .normal)
                }
            }
           
            sender.setTitleColor(UIColor.red, for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.sublineView.x = CGFloat(Double(sender.x) + self.titleWidth/2-5.0)
            }
            
            lastBut = sender
            
            segmentSelect?(sender.tag)
            var offsetX = (lastBut?.x)!-scrollV.width/2+20+CGFloat(titleWidth/2)
            if offsetX<0{
                offsetX = 0.0
            }else if offsetX > CGFloat(titleWidth * Double(titleArray.count))-scrollV.width{
                offsetX = CGFloat(titleWidth * Double(titleArray.count))-scrollV.width
            }
            scrollV.setContentOffset(CGPoint(x: offsetX, y: 0.0), animated: true)
        }
        
    }
    
}

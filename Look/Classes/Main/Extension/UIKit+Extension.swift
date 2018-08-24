//
//  UIKit+Extension.swift
//  News
//
//  Created by 王峰 on 2018/7/30.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit


protocol StoryboardLoadable {}

extension StoryboardLoadable where Self: UIViewController {
    /// 提供 加载方法
    static func loadStoryboard() -> Self {
        return UIStoryboard(name: "\(self)", bundle: nil).instantiateViewController(withIdentifier: "\(self)") as! Self
    }
}

protocol NibLoadable {}

extension NibLoadable {
    static func loadViewFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
    }
}
extension UIView{

    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// x
    var x: CGFloat {
        get { return frame.origin.x }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.x    = newValue
            frame                 = tempFrame
        }
    }
    
    /// y
    var y: CGFloat{
        get { return frame.origin.y }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.origin.y    = newValue
            frame                 = tempFrame
        }
    }
    
    /// height
    var height:CGFloat {
        get { return frame.size.height}
        set(newValue){
            var tempFrame: CGRect = frame
            tempFrame.size.height = newValue
            frame                 = tempFrame
            
        }
    }
    
    /// width
    var width: CGFloat {
        get { return frame.size.width }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size.width  = newValue
            frame = tempFrame
        }
    }
    
    /// size
    var size: CGSize {
        get { return frame.size }
        set(newValue) {
            var tempFrame: CGRect = frame
            tempFrame.size        = newValue
            frame                 = tempFrame
        }
    }
    
    /// centerX
    var centerX: CGFloat {
        get { return center.x }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.x            = newValue
            center                  = tempCenter
        }
    }
    
    /// centerY
    var centerY: CGFloat {
        get { return center.y }
        set(newValue) {
            var tempCenter: CGPoint = center
            tempCenter.y            = newValue
            center                  = tempCenter;
        }
    }
}


protocol RegisterCellFromNib{}

extension RegisterCellFromNib{
    static var identifier:String {  return "\(self)" }
    
    static var nib:UINib? {return UINib(nibName: identifier, bundle: nil)}
}

extension UITableView{
    
    /// 注册 cell 的方法
    func wf_registerCell<T: UITableViewCell>(cell: T.Type) where T: RegisterCellFromNib {
        if let nib = T.nib { register(nib, forCellReuseIdentifier: T.identifier) }
        else { register(cell, forCellReuseIdentifier: T.identifier) }
    }
    
    
     /// 从缓存池池出队已经存在的 cell
    func wf_dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T
        where T:RegisterCellFromNib{
            
            return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
        
    }
}

extension UICollectionView {
    /// 注册 cell 的方法
    func wf_registerCell<T: UICollectionViewCell>(cell: T.Type) where T: RegisterCellFromNib {
        if let nib = T.nib { register(nib, forCellWithReuseIdentifier: T.identifier) }
        else { register(cell, forCellWithReuseIdentifier: T.identifier) }
    }
    
    /// 从缓存池池出队已经存在的 cell
    func wf_dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
    
    /// 注册头部
    func wf_registerSupplementaryHeaderView<T: UICollectionReusableView>(reusableView: T.Type) where T: RegisterCellFromNib {
        // T 遵守了 RegisterCellOrNib 协议，所以通过 T 就能取出 identifier 这个属性
        if let nib = T.nib {
            register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.identifier)
        } else {
            register(reusableView, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.identifier)
        }
    }
    
    /// 获取可重用的头部
    func wf_dequeueReusableSupplementaryHeaderView<T: UICollectionReusableView>(indexPath: IndexPath) -> T where T: RegisterCellFromNib {
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.identifier, for: indexPath) as! T
    }
}

extension UIColor {
    

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(r: r / 255.0, g: g / 255.0, b: b / 255.0, alpha: alpha)
//        self.init(displayP3Red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 背景灰色 f8f9f7
    class func globalBackgroundColor() -> UIColor {
        return UIColor(r: 248, g: 249, b: 247)
    }
    
    /// 背景红色
    class func globalRedColor() -> UIColor {
        return UIColor(r: 196, g: 73, b: 67)
    }
    
    /// 字体蓝色
    class func blueFontColor() -> UIColor {
        return UIColor(r: 72, g: 100, b: 149)
    }
    
    /// 背景灰色 132
    class func grayColor132() -> UIColor {
        return UIColor(r: 132, g: 132, b: 132)
    }
    
    /// 背景灰色 232
    class func grayColor232() -> UIColor {
        return UIColor(r: 232, g: 232, b: 232)
    }
    
    /// 夜间字体背景灰色 113
    class func grayColor113() -> UIColor {
        return UIColor(r: 113, g: 113, b: 113)
    }
    
    /// 夜间背景灰色 37
    class func grayColor37() -> UIColor {
        return UIColor(r: 37, g: 37, b: 37)
    }
    
    /// 灰色 210
    class func grayColor210() -> UIColor {
        return UIColor(r: 210, g: 210, b: 210)
    }
    
}






//
//  SmallVideoInfoVC.swift
//  Look
//
//  Created by 王峰 on 2018/8/24.
//  Copyright © 2018年 王峰. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import BMPlayer
class SmallVideoInfoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    //        let pageNo = 1
    var smallVideoArray = [HotNewsModel]()
    /// 播放器
    private lazy var player = BMPlayer(customControlView: SmallVideoPlayerCustomView())
    /// 评论
    private lazy var commentView = SmallVideoCommentView.loadViewFromNib()
    private let disposeBag = DisposeBag()
    
    /// 原始 索引
    var originalIndex = 0
    /// 当前索引
    var currentIndex = 0
    @IBOutlet weak var collectionV: UICollectionView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        //        UIApplication.shared.statusBarStyle = .lightContent;
        setStatusBarBackgroundColor(color: UIColor.clear)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        //        UIApplication.shared.statusBarStyle = .default;
        setStatusBarBackgroundColor(color: UIColor.white)
    }
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

//        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
        
        collectionV.wf_registerCell(cell: SmallVideoInfoCell.self)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: Kwidth, height: Kheight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        collectionV.collectionViewLayout = layout
    
        commentView.frame = CGRect(x: 0, y: Kheight, width: Kwidth, height: Kheight)
        commentView.loadView()
        let window = UIApplication.shared.keyWindow
        window?.addSubview(commentView)
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
            
            self.collectionV.setContentOffset(CGPoint(x: 0, y: Kheight*CGFloat(self.originalIndex)), animated: false)
            // 设置播放器
            self.setupPlayer(currentIndex: self.originalIndex)
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return smallVideoArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionV.wf_dequeueReusableCell(indexPath: indexPath) as SmallVideoInfoCell
        cell.mySmallVideoData = smallVideoArray[indexPath.row]
        cell.commentBut.rx.tap.subscribe(onNext: {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.commentView.y = 0
            })
            self.commentView.videoId = cell.mySmallVideoData.video.videoId
            self.commentView.NetworkRequest(page: 1)
            self.commentView.commentNumber = cell.mySmallVideoData.video.cn.convertString()
        }).disposed(by: disposeBag)
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.y / scrollView.height + 0.5)
        // 根据当前索引设置播放器
        setupPlayer(currentIndex: currentIndex)
    }
    /// 设置播放器
    private func setupPlayer(currentIndex: Int) {
        // 当前的视频
        let smallVide = smallVideoArray[currentIndex]
        let videoURLString = smallVide.video.streams[0].url
        if  videoURLString.count > 0{
            // https://aweme.snssdk.com/aweme/v1/play/?video_id=887cc4819fd543e68125b471142de2ee&line=0&app_id=13
            // http://v9-dy.ixigua.com/f0c5b6992b84ec8581be670a9f0e6db6/5a5f3713/video/m/220dcaa08afe2814fe982a551581d7051c311518ee4000028f420dbd167/
            let dataTask = URLSession.shared.dataTask(with: URL(string: videoURLString)!, completionHandler: { (data, response, error) in
                // 货到主线程添加播放器
                DispatchQueue.main.async {
                    // 获取当前的 cell
                    let cell = self.collectionV.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as! SmallVideoInfoCell
                    if self.player.isPlaying { self.player.pause() }
                    // 先把 bgImageView 的子视图移除，再添加
                    for subview in cell.mainImageV.subviews { subview.removeFromSuperview() }
                    cell.mainImageV.addSubview(self.player)
                    self.player.snp.makeConstraints({ $0.edges.equalTo(cell.mainImageV) })
                    let asset = BMPlayerResource(url: URL(string: response!.url!.absoluteString)!)
                    self.player.setVideo(resource: asset)
                }
            })
            dataTask.resume()
        }
        
    }
    
    @IBAction func OnBlackClick() {
        
        navigationController?.popViewController(animated: true)
    }


}


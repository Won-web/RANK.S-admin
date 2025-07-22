//
//  ImageSlidingVC.swift
//  MrZzz
//
//  Created by eTech on 24/09/19.
//  Copyright © 2019 eTech. All rights reserved.
//

import UIKit
import TYCyclePagerView
import AVFoundation
import AVKit

class ImageSlidingVC: UIViewController {

    @IBOutlet weak var pagerView: TYCyclePagerView!
    var arrImageAndVideoList:[ImageAndVideoList] = []
    
    @IBOutlet weak var imgClose: UIImageView!
    @IBOutlet weak var lblCurrentPage: UILabel!
    var totalPriviewImage = 0
    var setCurrentPageIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
//        Util.statusBarColor(color: Constant.Color.NAVIGATION_BAR_BG_BLACK_COLOR)
        Util.statusBarColor(color: UIColor.clear)
   
        pagerView.layout.itemSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
     //   AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
//        UIScreen.main.brightness =  Util.getUserDefaultSysBrightness() as! CGFloat
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.pagerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    
    //MARK: Custom Method
    func setUpUI()
    {
       
        self.view.backgroundColor = Constant.Color.VIEW_BG_IMG_PRIVIEW_COLOR
        self.pagerView.backgroundColor = Constant.Color.VIEW_BG_IMG_PRIVIEW_COLOR
        
        imgClose.setImageFit(imageName: Constant.Image.close_white)
        
        let imgCloseTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.imgCloseTabbed))
        imgClose.isUserInteractionEnabled = true
        imgClose.addGestureRecognizer(imgCloseTabbed)
        
        
        // Load Page Viewer file
        pagerView.dataSource = self
        pagerView.delegate = self
       // pagerView.collectionView?.scrollToItem(at:IndexPath(item: setCurrentPageIndex, section: 0), at: .right, animated: false)
       
        lblCurrentPage.setLoginNormalUIStyleWhite(value: "\(self.pagerView.curIndex + 1)/\(totalPriviewImage)")
        pagerView.register(UINib(nibName: Constant.CellIdentifier.PAGE_VIEW_CELL, bundle: nil), forCellWithReuseIdentifier: Constant.CellIdentifier.PAGE_VIEW_CELL)
        pagerView.layout.itemSize = CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        pagerView.setNeedUpdateLayout();
        pagerView.reloadData()
        
    }
    
    //MARK:-  Tapped Methods clicked
       @objc func imgCloseTabbed(_ sender: CustomTabGestur){
        self.navigationController?.popViewController(animated: false)
           
       }
    @objc func imgPlayTabbed(_ sender: CustomTabGestur){
       // printDebug("imgPlayTabbed \(sender.intIndex)")
        let url = URL(string: arrImageAndVideoList[sender.intIndex].objMyVideo.strUrl!)
             if(url != nil)
             {
                 let player = AVPlayer(url: url!)
                 let vc = AVPlayerViewController()
                 vc.player = player

                 self.present(vc, animated: true) {
                     vc.player?.play()
                 }
             }else
             {
                 printDebug("video not found")
             }
    }
    
   
}


//MARK: TYCyclePagerViewDelegate, TYCyclePagerViewDataSource
extension ImageSlidingVC: TYCyclePagerViewDelegate, TYCyclePagerViewDataSource {
    
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        totalPriviewImage = arrImageAndVideoList.count
        return arrImageAndVideoList.count
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: Constant.CellIdentifier.PAGE_VIEW_CELL, for: index) as! PagerViewCell
        
        cell.imgPageView.backgroundColor = Constant.Color.VIEW_BG_IMG_PRIVIEW_COLOR
//        cell.imgPageView.getImageFromURL(url: "")
        
        if(arrImageAndVideoList[index].isImage)
        {
            cell.imgPlay.isHidden = true
            if(arrImageAndVideoList[index].objMyImage.isUrl)
            {
                cell.imgPageView.getImageFromURL(url: arrImageAndVideoList[index].objMyImage.strUrl)
            }else
            {
                cell.imgPageView.image = arrImageAndVideoList[index].objMyImage.uiImage
                cell.imgPageView.setFitImageInImageView()
            }
        }else
        {
            
            if(arrImageAndVideoList[index].objMyVideo.isFromServerUrl)
            {
                cell.imgPageView.getImageFromURL(url: arrImageAndVideoList[index].objMyVideo.strUrl)
            }else
            {
                let url = URL(string: arrImageAndVideoList[index].objMyVideo.strUrl)!
                if let thumbnailImage = cell.imgPageView.getImageFromLocalPath(forUrl: url) {
                    cell.imgPageView.image = thumbnailImage
                }
            }
            
            cell.imgPlay.isHidden = false
            cell.imgPlay.setImageFit(imageName: Constant.Image.play)
            
            let imgPlayTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.imgPlayTabbed))
            imgPlayTabbed.intIndex = index
            cell.imgPlay.isUserInteractionEnabled = true
            cell.imgPlay.addGestureRecognizer(imgPlayTabbed)
        }
        
        //if is video else hide
        
        return cell
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: pagerView.frame.width, height: self.pagerView.frame.height)
       // self.pagerView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 200)
//        layout.itemSpacing = CGFloat(15*0.35)
        layout.maximumAngle = 1
        layout.minimumScale = 1
        layout.itemSpacing = CGFloat(0)
        //layout.itemHorizontalCenter = true
       // layout.itemVerticalCenter = true
        return layout
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        printDebug(toIndex)
        self.lblCurrentPage.setLoginNormalUIStyleWhite(value: "\(toIndex + 1)/\(totalPriviewImage)")
    }
}


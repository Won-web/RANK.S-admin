//
//  PagerViewCell.swift
//  VideoLecture
//
//  Created by etech-9 on 31/08/19.
//  Copyright © 2019 etech-dev. All rights reserved.
//

import UIKit
import TYCyclePagerView

class MainContentBannerCell: UICollectionViewCell {
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgPageView: UIImageView!
    @IBOutlet var lblTotalPageViewPage: UILabel!
    @IBOutlet var lblSymbol: UILabel!
    @IBOutlet var lblPageViewContentName: UILabel!
    @IBOutlet weak var imgPause: UIImageView!
//    @IBOutlet var lblPageViewNextContent: UILabel!
//    @IBOutlet var imgNexPageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpUI()
    {
//        self.setCardStyleView()
//        imgFav.image = UIImage(named: Constant.Image.Heart_Blue)
//        lblFav.setCountUI(value: "1,000")
//        viewCount.setCountViewStyle(viewColor: Constant.Color.VIEW_BACKGROUND)
    }

}

//
//  PagerViewCell.swift
//  VideoLecture
//
//  Created by etech-9 on 31/08/19.
//  Copyright © 2019 etech-dev. All rights reserved.
//

import UIKit
import TYCyclePagerView

class EditProfileImageVideoCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVUser: UIImageView!
    @IBOutlet weak var imgVClose: UIImageView!
    @IBOutlet weak var imgVPlayPlush: UIImageView!
    @IBOutlet var lblAddImg: UILabel!
    

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

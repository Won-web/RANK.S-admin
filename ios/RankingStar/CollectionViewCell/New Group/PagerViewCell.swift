//
//  PagerViewCell.swift
//  VideoLecture
//
//  Created by etech-9 on 31/08/19.
//  Copyright © 2019 etech-dev. All rights reserved.
//

import UIKit
import TYCyclePagerView

class PagerViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var imgPageView: UIImageView!
    @IBOutlet weak var imgPlay: UIImageView!

    var imageView: UIImageView!
    var scrollImg: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpUI() {
    }
    
}

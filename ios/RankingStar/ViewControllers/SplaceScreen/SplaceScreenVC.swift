//
//  SplaceScreenVC.swift
//  VideoLecture
//
//  Created by eTech on 11/09/19.
//  Copyright © 2019 etech-dev. All rights reserved.
//

import UIKit
import SwiftyGif

class SplaceScreenVC: BaseVC {
    
    @IBOutlet var imgSplace: UIImageView!
    @IBOutlet weak var imgBottom: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // imgBottom.image = UIImage(named: Constant.Image.BOTTOM_BANNER)

        try! imgSplace.setGifImage(UIImage(gifName: "IMG_SPLACE_SCREEN".localizedLanguage()), manager: SwiftyGifManager(memoryLimit: 0), loopCount: -1)
        imgSplace.startAnimatingGif()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.1) {
            Util.appDelegate.createMenuView()
        }
    }
}

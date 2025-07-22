//
//  UpdateAppVC.swift
//  RankingStar
//
//  Created by Hitarthi on 03/03/22.
//  Copyright © 2022 Etech. All rights reserved.
//

import UIKit

class UpdateAppVC: BaseVC {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnUpdate: UIButton!
    @IBOutlet var btnSkip: UIButton!
    
    var dicData = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideProgress()
        
        navBar.setUI(navBarText: "NAVIGATION_BAR_LOGIN")
        
        imgLogo.setImageFit(imageName: Constant.Image.logo_kor)
        lblTitle.setFgtPwdHeaderVeryBigUIStylePink(value: dicData["MessageType"] as! String)
        btnUpdate.setTitle(txtValue: dicData["update_button_title"] as! String)
        btnUpdate.setBtnLoginWithEmailUI()
        
        if let isForceUpdate : Bool = Util.getDefaultValue(key: Constant.UserDefaultKey.KEY_FORCE_UPDATE_APP) as? Bool {
            if isForceUpdate {
                btnSkip.isHidden = true
            }else {
                btnSkip.isHidden = false
                btnSkip.setTitle(txtValue: dicData["skip_button_title"] as! String)
                btnSkip.setBtnContestStatusGrayUI(false)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Util.objUpdateAppVC = nil
    }

    @IBAction func onClickedUpdate(_ sender: Any) {
        
//        let urlSting = dicData["URL"] as! String
        let urlSting = dicData["URL"] as! String
        
        Util.setDefaultValue(data: false, key: Constant.UserDefaultKey.KEY_FORCE_UPDATE_SKIP_TAPPED)
        
//        UIApplication.shared.openURL(NSURL(string: urlSting)! as URL)
        
        if let url = URL(string: urlSting) {
            UIApplication.shared.open(url)
        }

    }
    
    @IBAction func onClickedSkip(_ sender: Any) {
        
        Util.setDefaultValue(data: true, key: Constant.UserDefaultKey.KEY_FORCE_UPDATE_SKIP_TAPPED)
        navigationController?.popViewController(animated: true)
        
    }
}

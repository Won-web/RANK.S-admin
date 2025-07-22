//
//  LoginVC.swift
//  RankingStar
//
//  Created by Jinesh on 13/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit
import Material
import AnyFormatKit

class AttendanceCheckVC: BaseVC {
    
    var objAttendenceCheckViewModel : AttendenceCheckViewModel!
    
    @IBOutlet var viewContMainPopup: UIView!
    @IBOutlet var viewContHeader: UIView!
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAtendanceCheck: UILabel!
    @IBOutlet var imgBtnClose: UIImageView!
    
    @IBOutlet var imgSideMenuStar: UIImageView!
    @IBOutlet var lblMyStar: UILabel!
    @IBOutlet var lblTotalCoin: UILabel!
    @IBOutlet var lblTitlePiece: UILabel!
    
    @IBOutlet var lblInfoMaxStarUse: UILabel!
    
    @IBOutlet var btnSend: UIButton!
    var totalUserStar:Int!
    var myNavigationController:UINavigationController? = nil
    
    var objContestant = ContestantDetailModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objAttendenceCheckViewModel = AttendenceCheckViewModel(vc: self)
        setUIColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissAlertInfoPresenter()
    }
    
    //MARK: custom method
    func setUIColor()
    {
        //        Util.statusBarColor(color: Constant.Color.NAVIGATION_BAR_BG_COLOR)
        self.view.backgroundColor = Constant.Color.VIEW_TRANSPERENT_BG_POPUP_COLOR
        
        viewContMainPopup.layer.cornerRadius = 20
        viewContMainPopup.clipsToBounds = true
        viewContHeader.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        //btnClose.setBackgroundImage(UIImage(named: Constant.Image.close_white), for: .normal)
        imgBtnClose.setImageFit(imageName: Constant.Image.close_white)
        
        
        lblTitle.setHeaderUIStyleWhite(value: "LBL_TITLE_ATTRENDANCE_CHECK")
        lblAtendanceCheck.setLoginHeaderVeryBigUIStylePink(value: "LBL_ATTRENDANCE_CHECK_COMP")
        
        imgSideMenuStar.setImageFit(imageName: Constant.Image.history_star)
        
        lblMyStar.setLoginNormalUIStyle(value: "LBL_MY_STAR")
        lblTitlePiece.setLoginNormalUIStyle(value: "LBL_VOTE_PIECE")
        lblTotalCoin.setLoginHeaderBigUIStylePink(value: "50")

        lblInfoMaxStarUse.setSmallTitleSemiBlack(value : "LBL_STAR_HAS_BEEN_EARNED")

        btnSend.setTitle(txtValue: "LBL_ATTENDENCE_CHECK")
        btnSend.setBtnSendVoteUI()
        
    }
    
    //MARK:- Button clicked
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSendClicked(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
//        let objAttendanceCheckConfirmVC = AttendanceCheckConfirmVC()
//        objAttendanceCheckConfirmVC.myNavigationController = self.navigationController
//        
//        objAttendanceCheckConfirmVC.modalTransitionStyle = .crossDissolve
//        objAttendanceCheckConfirmVC.modalPresentationStyle = .overCurrentContext
//        self.myNavigationController?.present(objAttendanceCheckConfirmVC, animated: true, completion: nil)
        //        self.present(objAttendanceCheckConfirmVC, animated: true, completion: nil)
    }
}





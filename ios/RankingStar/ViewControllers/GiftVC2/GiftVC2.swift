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

protocol onSendStarCompleteAction {
    func setRefreshData()
}

class GiftVC2: BaseVC {
    
    var objGiftviewModel : GiftviewModel!
    
    @IBOutlet var viewContMainPopup: UIView!
    @IBOutlet var viewContHeader: UIView!
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgBtnClose: UIImageView!
    
    @IBOutlet var imgSideMenuStar: UIImageView!
    @IBOutlet var lblMyStar: UILabel!
    @IBOutlet var lblTotalCoin: UILabel!
    @IBOutlet var lblTitlePiece: UILabel!
    
    @IBOutlet var btnUserAllStar: UIButton!
    
    @IBOutlet var lblInfoMaxStarUse: UILabel!
    
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var viewContStarInput: UIView!
    @IBOutlet var viewPhoneInput: UIView!
    
    @IBOutlet var txtFStarInput: UITextField!
    @IBOutlet var txtFPhoneNumber: UITextField!
    @IBOutlet weak var imgUserPhoto: UIImageView!
//    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var viewStar: UIView!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var lblPresentedStar: UILabel!
    
    @IBOutlet weak var lblAlertPresentedStars: UILabel!
    
    var totalUserStar:Int!
    var myNavigationController:UINavigationController? = nil
    
    var objContestant = ContestantDetailModel()
    var isBackButtonShow = false
    var isMobileApiSuccess = false
    var userMobile = ""
    
    var delegate : onSendStarCompleteAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objGiftviewModel = GiftviewModel(vc: self)
        setUIColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        dismissAlertInfoPresenter()
    }
    
    //MARK: custom method
    func setUIColor()
    {
        
//        navBar.setUI(navBarText: "LBL_VOTING_HISTORY")
//
//        if(isBackButtonShow) {
//            self.leftBarButton(navBar : navBar , imgName : Constant.Image.back)
//        }else {
//            self.leftBarButton(navBar : navBar , imgName : Constant.Image.menu)
//        }
//        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station)
        
        
        //        Util.statusBarColor(color: Constant.Color.NAVIGATION_BAR_BG_COLOR)
        self.view.backgroundColor = Constant.Color.VIEW_TRANSPERENT_BG_POPUP_COLOR
        
        viewContMainPopup.layer.cornerRadius = 20
        viewContMainPopup.clipsToBounds = true
        viewContHeader.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        //btnClose.setBackgroundImage(UIImage(named: Constant.Image.close_white), for: .normal)
        imgBtnClose.setImageFit(imageName: Constant.Image.close_white)
        lblTitle.setHeaderUIStyleWhite(value: "LBL_GIFT_POPUP_VIEW")
        
        imgSideMenuStar.setImageFit(imageName: Constant.Image.history_star)
        
        lblMyStar.setLoginNormalUIStyle(value: "LBL_MY_STAR")
        lblTitlePiece.setLoginNormalUIStyle(value: "LBL_VOTE_PIECE")
        
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            let myStar : Int = Int(objUserProfile.strRemainingStar)!
            lblTotalCoin.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
            totalUserStar = Int(objUserProfile.strRemainingStar)!
        }
        
        //        lblTitleInfo.setLoginNormalUIStyle(value: "LBL_VOTE_POPUP_TITLE_INFO")
        //        lblStarQuantity.setLoginHeaderBigUIStylePink(value: "100")
        //
        //        imgStar.setImageFit(imageName: Constant.Image.rating_star)
        //        img1Star.setImageFit(imageName: Constant.Image.vote_star1)
        //        imgAllStar.setImageFit(imageName: Constant.Image.vote_star_all)
        //        img10Star.setImageFit(imageName: Constant.Image.vote_star10)
        
        viewContStarInput.rundViewWithBorderColorPink()
        viewPhoneInput.rundViewWithBorderColorPink()
        
        txtFPhoneNumber.setUIWithPlaceholderTxtBlackBig(placeHolder: "TXT_PLACEHOLDER_INPUT_GIFT_PHONE")
        txtFPhoneNumber.keyboardType = .numberPad
//        txtFPhoneNumber.delegate = self
        txtFPhoneNumber.addTarget(self, action: #selector(textFieldDidChangePhoneNumber), for: UIControl.Event.editingChanged)
        
        txtFStarInput.setUIWithPlaceholderTxtBlackBig(placeHolder: "TXT_PLACEHOLDER_INPUT_GIFT_STAR")
        txtFStarInput.keyboardType = .numberPad
        txtFStarInput.addTarget(self, action: #selector(textFieldDidChangeStar), for: UIControl.Event.editingChanged)
        
        imgUserPhoto.setImageFitRoundBorderEditProfile(imageName: Constant.Image.user_default_gift)
        imgUserPhoto.borderColor = Constant.Color.VIEW_SEMI_GRAY_BORDER_COLOR
        viewStar.layer.cornerRadius = viewStar.frame.height/2
        viewStar.borderColor = Constant.Color.VIEW_SEMI_GRAY_BORDER_COLOR
        viewStar.layer.borderWidth = 1
        imgStar.setImageFitRoundBorderEditProfile(imageName: Constant.Image.history_star)
        imgStar.borderColor = UIColor.clear
//        lblUserName.isHidden = true
////        lblUserName.setNormalEditProfileSecondTitleBalck(value: "User Name")
////        lblUserName.textColor = Constant.Color.CONTEST_LIST_CELL_ONE_COLOR
        lblPresentedStar.setNormalSecondTitlePink(value: "")
        lblAlertPresentedStars.setSmallTitleGray(value: "ALERT_PRESENTED_STARS")
        
        
        btnUserAllStar.setTitle(txtValue: "BTN_USE_ALL")
        btnUserAllStar.setBtnContestStatusGrayUI()
        btnUserAllStar.layer.borderWidth = 0
        
        lblInfoMaxStarUse.setSmallTitleGray(value : "LBL_NUMBER_OF_STARS_PRESENT")
        
        btnSend.setTitle(txtValue: "BTN_GIFT_STAR")
        btnSend.setBtnSendVoteUI()
        
        
        //        let img1StarTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.img1StarTabbed))
        //        img1Star.isUserInteractionEnabled = true
        //        img1Star.addGestureRecognizer(img1StarTabbed)
        //
        //        let imgAllStarTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.imgAllStarTabbed))
        //        imgAllStar.isUserInteractionEnabled = true
        //        imgAllStar.addGestureRecognizer(imgAllStarTabbed)
        //
        //        let img10StarTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.img10StarTabbed))
        //        img10Star.isUserInteractionEnabled = true
        //        img10Star.addGestureRecognizer(img10StarTabbed)
    }
    
    func validationTxtField() -> Bool {
        if (txtFPhoneNumber.text?.isEmpty)! {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_PHONE_NUMBER")
            return false
        }else if (txtFPhoneNumber.text?.count != 11) {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_VALID_PHONE_NUMBER")
            return false
        }else if(txtFStarInput.text?.isEmpty)!
        {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_STAR")
            return false
        }
        return true
    }
    
    func getUserDetailByPhoneAPI() {
        if(Util.isNetworkReachable()) {
            self.showProgress()
            objGiftviewModel.getDetailsByPhoneAPI()
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func getGiftAPI() {
        if(Util.isNetworkReachable()) {
            self.showProgress()
            
            let objuserDetail = objGiftviewModel.objUserDetail
            
            let objGift = Gift()
            objGift.strReceiverID = objuserDetail.user_id
            
            let dictData1:[String: Any]? = Util.getUserProfileDict()
            if(dictData1 != nil) {
                let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
                objGift.strSenderID = objUserProfile.strUserId
                objGift.strSenderName = objUserProfile.strUserName
            }
                
            objGift.strStar = txtFStarInput.text
            objGiftviewModel.getGiftAPI(objGift: objGift)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    //MARK:- Button clicked
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnUserAllStar(_ sender: UIButton) {
        txtFStarInput.text = "\(totalUserStar!)"
    }
    
    @IBAction func btnSendClicked(_ sender: UIButton) {
        print("btnSendClicked")
        
        if(Util.isNetworkReachable()) {
            if self.validationTxtField() {
                if(Int(self.txtFStarInput.text!)! <= self.totalUserStar) {
                    if self.isMobileApiSuccess {
                        if (Int(self.txtFStarInput.text!)! != 0) {
                            print("Api call")
                            self.getGiftAPI()
                        }else {
                            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_STAR_CAN_NOT_0")
                        }
                    }else {
                        AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_VALID_PHONE_NUMBER1")
                    }
                }else {
//                    btnSend.setBtnContestStatusGrayUI()
//
//                    AlertPresenter.alertWithYesNo(fromVC: self, message: "ALERT_NOT_HAVE_ENOUGN_STAR", positiveBlock: {
//                        let objWebViewWithTabVC = WebViewWithTabVC()
//                        objWebViewWithTabVC.isBackButtonShow = true
//                        self.dismiss(animated: true, completion: nil)
//
//                        if(self.myNavigationController != nil) {
//                            self.myNavigationController?.pushViewController(objWebViewWithTabVC, animated: true)
//                        }
//                    }) {
//                    }
                }
            }
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
        
//        if(validationTxtField())
//        {
//            if(Int(txtFStarInput.text!)! <= totalUserStar) {
//                if(Int(txtFStarInput.text!)! <= 0 && isMobileApiSuccess == false)
//                {
//                    txtFStarInput.text = ""
//                }else
//                {
//                    print("Api call")
//                    //                        getGiftAPI()
//                }
//            }else {
//                AlertPresenter.alertWithYesNo(fromVC: self, message: "ALERT_NOT_HAVE_ENOUGN_STAR", positiveBlock: {
//                    let objWebViewWithTabVC = WebViewWithTabVC()
//                    objWebViewWithTabVC.isBackButtonShow = true
//                    self.dismiss(animated: true, completion: nil)
//                    if(self.myNavigationController != nil)
//                    {
//                        self.myNavigationController?.pushViewController(objWebViewWithTabVC, animated: true)
//                    }
//
//                }) {
//
//                }
//
//                // self.navigationController?.pushViewController(navMainVC, animated: true)
//            }
//        }
    }
    
    //MARK: Button Tabbed
//    @objc override func leftBarButtonClick() {
//       if(isBackButtonShow)
//       {
//           self.navigationController?.popViewController(animated: true)
//       }else
//       {
//           self.toggleLeft()
//       }
//
//    }
//
//    @objc override func rightBtnClickedWithImg() {
//       let objWebViewWithTabVC = WebViewWithTabVC()
//       objWebViewWithTabVC.isBackButtonShow = true
//       self.navigationController?.pushViewController(objWebViewWithTabVC, animated: true)
//    }
    
    @objc func textFieldDidChangePhoneNumber(_ textField: UITextField) {
         
        var string:String = txtFPhoneNumber.text!
        string = string.replacingOccurrences(of: "-", with: "")
        //        let phoneFormatter = DefaultTextFormatter(textPattern: "###-####-####")
        let phoneFormatter = DefaultTextFormatter(textPattern: "###########")
        txtFPhoneNumber.text = phoneFormatter.format(string)
        
        if txtFPhoneNumber.text!.count == 11 {
            
            let dictData1:[String: Any]? = Util.getUserProfileDict()
            if(dictData1 != nil) {
                let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
                userMobile = objUserProfile.strMobile
            }
            
            if txtFPhoneNumber.text == userMobile {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_CANNOT_GIFT_YOURSELF")
                btnSend.isEnabled = false
                btnSend.backgroundColor = Constant.Color.BTN_GREDIENT_GRAY_LEFT
            }else {
                btnSend.isEnabled = true
                btnSend.setBtnSendVoteUI()
                getUserDetailByPhoneAPI()
                
                if (!txtFStarInput.text!.isEmpty) {
                    if(Int(txtFStarInput.text!)! <= totalUserStar) {
                        btnSend.isEnabled = true
                        btnSend.setBtnSendVoteUI()
                    }else {
                        btnSend.isEnabled = false
                        btnSend.backgroundColor = Constant.Color.BTN_GREDIENT_GRAY_LEFT
                    }
                }
            }
            
        }else if txtFPhoneNumber.text!.count < 11 || txtFPhoneNumber.text == "" {
            if (!txtFStarInput.text!.isEmpty) {
                lblPresentedStar.setNormalSecondTitlePink(value: "LBL_PRESENTED_STAR_NOT_CANCEL")
            }else {
                lblPresentedStar.setNormalSecondTitlePink(value: "")
            }
            lblInfoMaxStarUse.setSmallTitleGray(value : "LBL_NUMBER_OF_STARS_PRESENT")
            viewStar.borderColor = Constant.Color.VIEW_SEMI_GRAY_BORDER_COLOR
            imgUserPhoto.setImageFitRoundBorderEditProfile(imageName: Constant.Image.user_default_gift)
            imgUserPhoto.borderColor = Constant.Color.VIEW_SEMI_GRAY_BORDER_COLOR
            
        }
    }
    
    @objc func textFieldDidChangeStar(_ textField: UITextField) {
        var string:String = txtFStarInput.text!
        string = string.replacingOccurrences(of: "-", with: "")
        let starFormatter = DefaultTextFormatter(textPattern: "######")
        txtFStarInput.text = starFormatter.format(string)
        
        if (!txtFStarInput.text!.isEmpty) {
            lblPresentedStar.setNormalSecondTitlePink(value: "LBL_PRESENTED_STAR_NOT_CANCEL")
            
            if(Int(txtFStarInput.text!)! <= totalUserStar) {
                if txtFPhoneNumber.text!.count == 11 && txtFPhoneNumber.text != userMobile {
                    btnSend.isEnabled = true
                    btnSend.setBtnSendVoteUI()
                }else {
                    btnSend.isEnabled = false
                    btnSend.backgroundColor = Constant.Color.BTN_GREDIENT_GRAY_LEFT
                }
            }else {
                btnSend.isEnabled = false
                btnSend.backgroundColor = Constant.Color.BTN_GREDIENT_GRAY_LEFT
            }
        }else {
            lblInfoMaxStarUse.setSmallTitleGray(value : "LBL_NUMBER_OF_STARS_PRESENT")
            lblPresentedStar.setNormalSecondTitlePink(value: "")
        }
        
        if (isMobileApiSuccess == true && !txtFStarInput.text!.isEmpty) {
            lblInfoMaxStarUse.text = "\(objGiftviewModel.objUserDetail.name!) \("LBL_GIFT_TO".localizedLanguage()) \(txtFStarInput.text!) \("LBL_WOULD_LIKE_TO_GIVE".localizedLanguage())?"
            //            lblInfoMaxStarUse.text = "\("LBL_WOULD_LIKE_TO_GIVE".localizedLanguage()) \(txtFStarInput.text!) \("LBL_GIFT_TO".localizedLanguage()) \(objGiftviewModel.objUserDetail.name!)?"
            
        }else {
            lblInfoMaxStarUse.setSmallTitleGray(value : "LBL_NUMBER_OF_STARS_PRESENT")
        }
        
//        if (!txtFStarInput.text!.isEmpty && isMobileApiSuccess == true)
//        {
//           lblInfoMaxStarUse.text = "\("LBL_WOULD_LIKE_TO_GIVE".localizedLanguage()) \(txtFStarInput.text!) \("LBL_GIFT_TO".localizedLanguage()) \(objGiftviewModel.objUserDetail.name!)?"
//            lblPresentedStar.setNormalSecondTitlePink(value: "LBL_PRESENTED_STAR_NOT_CANCEL")
//        }else
//        {
//            lblInfoMaxStarUse.setSmallTitleGray(value : "LBL_NUMBER_OF_STARS_PRESENT")
//        }
    }
    
//    @objc func img1StarTabbed(sender:CustomTabGestur)
//    {
//        print("img1StarTabbed")
//        if(txtFStarInput.text != "")
//        {
//            txtFStarInput.text = "\(Int(txtFStarInput.text!)! + 1)"
//        }else
//        {
//            txtFStarInput.text = "1"
//        }
//    }
//
//    @objc func imgAllStarTabbed(sender:CustomTabGestur)
//    {
//        print("imgAllStarTabbed")
//        txtFStarInput.text = "\(totalUserStar)"
//    }
//
//    @objc func img10StarTabbed(sender:CustomTabGestur)
//    {
//        print("img10StarTabbed")
//        if(txtFStarInput.text != "")
//        {
//            txtFStarInput.text = "\(Int(txtFStarInput.text!)! + 10)"
//        }else
//        {
//            txtFStarInput.text = "10"
//        }
//
//    }
    
    
    //MARK:- View Model Methods
    
    func onApiSuccessHideProgress() {
        self.hideProgress()
    }
    
    func onSuccessApiResponce() {
        isMobileApiSuccess = true
        imgUserPhoto.getImageFromURL(url: objGiftviewModel.objUserDetail.main_image)
        viewStar.borderColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        imgUserPhoto.borderColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
       
//        lblPresentedStar.setNormalSecondTitlePink(value: "LBL_PRESENTED_STAR_NOT_CANCEL")
//        lblUserName.setNormalEditProfileSecondTitleBalck(value: objGiftviewModel.objUserDetail.name)
//        lblUserName.textColor = Constant.Color.CONTEST_LIST_CELL_ONE_COLOR
        if (!txtFStarInput.text!.isEmpty) {
           lblInfoMaxStarUse.text = "\("LBL_WOULD_LIKE_TO_GIVE".localizedLanguage()) \(txtFStarInput.text!) \("LBL_GIFT_TO".localizedLanguage()) \(objGiftviewModel.objUserDetail.name!)?"
            lblPresentedStar.setNormalSecondTitlePink(value: "LBL_PRESENTED_STAR_NOT_CANCEL")
        }
    }
    
    func onSuccessGiftApi() {
        
        let userName = objGiftviewModel.objUserDetail.name
        
        let successAlert = "\(userName!) \("SUCCESSFULLY_PRESENTED".localizedLanguage()) \(txtFStarInput.text!) \("STARS_TO".localizedLanguage())"
        
        AlertPresenter.alertInformation(fromVC: self, message: successAlert, positiveBlock: {
            self.dismiss(animated: true, completion: nil)
        })
        
        let availableStar = objGiftviewModel.objGift.avilableStar
        var dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            dictData1!["remaining_star"] = availableStar
        }
        Util.setUserProfileDict(strValue: dictData1!)
        
        if delegate != nil {
            delegate?.setRefreshData()
        }
    }
    
    func showMessage(message: String) {
        isMobileApiSuccess = false
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    func showMessageGift(message: String) {
//        self.dismiss(animated: true, completion: nil)
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    
    func onFailGiftApi(message: String) {
//        self.dismiss(animated: true, completion: nil)
        
//        let availableStar = objGiftviewModel.objGift.avilableStar
//        var dictData1:[String: Any]? = Util.getUserProfileDict()
//        if(dictData1 != nil) {
//            dictData1!["remaining_star"] = availableStar
//        }
//        Util.setUserProfileDict(strValue: dictData1!)
//        let myStar : Int = Int(availableStar!)!
//        lblTotalCoin.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
        txtFStarInput.text = ""
        
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }

}





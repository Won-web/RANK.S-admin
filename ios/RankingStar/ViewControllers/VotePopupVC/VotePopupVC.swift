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

class VotePopupVC: BaseVC {
    
    var objVotePopUpViewModel : VotePopUpViewModel!
    
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
    @IBOutlet var txtFStarInput: UITextField!
    
    @IBOutlet weak var imgUserPhoto: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    var totalUserStar:Int!
    var myNavigationController:UINavigationController? = nil
    var objContestant = ContestantDetailModel()
    
    var objContestantProfileDelegate : ContestantProfileVCDelegate!
    var objContestantListVCDelegate : ContestantListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objVotePopUpViewModel = VotePopUpViewModel(vc: self)
        
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
//        lblTitle.setHeaderUIStyleWhite(value: "LBL_VOTING_POPUP_VIEW")
        lblTitle.setHeaderUIStyleWhite(value: "\("VOTE_TO_CONTESTANT_FRONT".localizedLanguage()) \(objContestant.strName!) \("VOTE_TO_CONTESTANT_BACK".localizedLanguage())")
        
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
        
//        txtFStarInput.setUIWithPlaceholderTxtBlackBig(placeHolder: "TXT_PLACEHOLDER_INPUT_STAR")
        txtFStarInput.setUIWithPlaceholderTxtBlackBig(placeHolder: "")
        txtFStarInput.keyboardType = .numberPad
        txtFStarInput.addTarget(self, action: #selector(textFieldDidChangeStar), for: UIControl.Event.editingChanged)
        
        btnUserAllStar.setTitle(txtValue: "BTN_USE_ALL")
        btnUserAllStar.setBtnContestStatusGrayUI()
        btnUserAllStar.layer.borderWidth = 0
        
        lblInfoMaxStarUse.setSmallTitleGray(value : "LBL_USER_MAX_STARS")

        btnSend.setTitle(txtValue: "LBL_SEND_STAR")
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
    
    func getVoteApi() {
        if Util.isNetworkReachable() {
            
            self.showProgress()
            let objVote = VotePopUp()
            objVote.strContestID = objContestant.strContestId
            objVote.strContestantID = objContestant.strId
            objVote.strVote = txtFStarInput.text
            
            let dictData1:[String: Any]? = Util.getUserProfileDict()
            if(dictData1 != nil) {
                let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
                objVote.strVoterID = objUserProfile.strUserId
                objVote.strVoterName = objUserProfile.strUserName
//                objVote.strVoterID = "1"
//                objVote.strVoterName = "Test"
            }
            objVotePopUpViewModel.getVotePopUpAPI(objVote: objVote)
            
        }else {
            self.hideProgress()
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
        if(txtFStarInput.text != "") {
            
            if(Int(txtFStarInput.text!)! <= totalUserStar) {
                if(Int(txtFStarInput.text!)! > 0)
                {
                   getVoteApi()
                }else
                {
                    txtFStarInput.text = ""
//                    AlertPresenter.alertInformation(fromVC: self, message: "ALERT_STAR_CAN_NOT_0")
                }
            }else {
                AlertPresenter.alertWithYesNo(fromVC: self, message: "ALERT_NOT_HAVE_ENOUGN_STAR", positiveBlock: {
                    let objWebViewWithTabVC = WebViewWithTabVC()
                    objWebViewWithTabVC.isBackButtonShow = true
                    self.dismiss(animated: true, completion: nil)
                    if(self.myNavigationController != nil)
                    {
                        self.myNavigationController?.pushViewController(objWebViewWithTabVC, animated: true)
                    }
                    
                }) {
                    
                }
                
                // self.navigationController?.pushViewController(navMainVC, animated: true)
            }
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_VOTE")
        }
        
    }
    
    //MARK: Button Tabbed
    @objc func textFieldDidChangeStar(_ textField: UITextField) {
        var string:String = txtFStarInput.text!
        string = string.replacingOccurrences(of: "-", with: "")
        let starFormatter = DefaultTextFormatter(textPattern: "######")
        txtFStarInput.text = starFormatter.format(string)
        
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
    
    func onSuccessApiResponce(message: String) {
        
//        let successAlert = "\(txtFStarInput.text!) \("ALERT_STAR_RECIPIENT".localizedLanguage()) \(objContestant.strName!) \("ALERT_VOTE_SUCCESS".localizedLanguage())"
        
        let successAlert = " \("ALERT_VOTED_FOR".localizedLanguage()) \(objContestant.strName!)  \("ALERT_PARTICIPANT_WITH".localizedLanguage()) \(txtFStarInput.text!) \("ALERT_STARS".localizedLanguage())"
        
        AlertPresenter.alertInformation(fromVC: self, message: successAlert, positiveBlock: {
            self.dismiss(animated: true, completion: nil)
        })
        var dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            dictData1!["remaining_star"] = objVotePopUpViewModel.objVotePopUp.remainingStar
        }
        Util.setUserProfileDict(strValue: dictData1!)
        
        if self.objContestantProfileDelegate != nil {
            objContestantProfileDelegate.reloadOnlyProfileData()
        }
        
        if self.objContestantListVCDelegate != nil {
            objContestantListVCDelegate.reloadContestantProfileApi()
        }
    }
    
    func showMessage(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    func onFailVoteApi(message: String) {

        let availableStar = objVotePopUpViewModel.objVotePopUp.remainingStar
        var dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            dictData1!["remaining_star"] = availableStar
        }
        Util.setUserProfileDict(strValue: dictData1!)
        let myStar : Int = Int(availableStar!)!
        lblTotalCoin.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
        txtFStarInput.text = ""
        
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }

}





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

class EditUserProfileVC: BaseVC {
    
    var objEditUserProfileViewModel:EditUserProfileViewModel!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var btnSignUp: UIButton!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
    @IBOutlet var txtFName: UITextField!
    @IBOutlet var viewContName: UIView!
    
    @IBOutlet var txtFEmail: UITextField!
    @IBOutlet var viewContEmail: UIView!
    
    @IBOutlet var txtFCurrentPassword: UITextField!
    @IBOutlet var viewContCurrentPassword: UIView!
    
    @IBOutlet var txtFPassword: UITextField!
    @IBOutlet var viewContPassword: UIView!
    
    @IBOutlet var txtFConfPassword: UITextField!
    @IBOutlet var viewContConfPassword: UIView!
    
    @IBOutlet var txtFPhoneNumber: UITextField!
    @IBOutlet var viewContPhoneNumber: UIView!
    
    @IBOutlet var txtFNikName: UITextField!
    @IBOutlet var viewContNikName: UIView!
    
    @IBOutlet var imgUserCurrentLogin: UIImageView!
    @IBOutlet var lblUserCurrentLogin: UILabel!
    
    @IBOutlet var lblPassword: UILabel!
    @IBOutlet var lblPhoneNumber: UILabel!
    @IBOutlet var lblNikName: UILabel!
    
    @IBOutlet weak var cnsPwdViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cnsEmailViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnDeleteAccount: UIButton!
    var isSocialMediaLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objEditUserProfileViewModel = EditUserProfileViewModel(vc: self)
        //self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.view.setRightToLeftPinkGradientViewUI()
    
        setUIColor()
    }

    override func viewWillAppear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        dismissAlertInfoPresenter()
    }
    
    //MARK: custom method
    func setUIColor()
    {
//        Util.statusBarColor(color: Constant.Color.NAVIGATION_BAR_BG_COLOR)
        navBar.setUI(navBarText: "NAVIGATION_BAR_EDIT_PROFILE")
        self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station_black)
        //self.leftBarButton2(navBar: navBar, imgName1: Constant.Image.back, imgName2: Constant.Image.home)
//        self.rightBarSingleBtnWithImage2(navBar: navBar, imgName1: Constant.Image.menu, imgName2: Constant.Image.search)
        
        lblName.setLoginNormalUIStyleFullBack(value: "LBL_NAME")
        lblEmail.setLoginNormalUIStyleFullBack(value: "LBL_EMAIL")
        
        lblPassword.setLoginNormalUIStyleFullBack(value: "LBL_PASSWORD")
        lblPhoneNumber.setLoginNormalUIStyleFullBack(value: "LBL_PHONE_NU")
        lblNikName.setLoginNormalUIStyleFullBack(value: "LBL_NIK_NAME")
        
        viewContName.rectViewWithBorderColor()
        viewContName.backgroundColor = Constant.Color.TXTF_BG_COLOR
        txtFName.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_NAME")
        
        viewContEmail.rectViewWithBorderColor()
        viewContEmail.backgroundColor = Constant.Color.TXTF_BG_COLOR
        txtFEmail.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_ENTER_EMAIL")
        txtFEmail.keyboardType = .emailAddress
        
        viewContCurrentPassword.rectViewWithBorderColor()
        txtFCurrentPassword.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_ENTER_CURRENT_PASSWORD")
        txtFCurrentPassword.textContentType = .password
        txtFCurrentPassword.isSecureTextEntry = true
        
        viewContPassword.rectViewWithBorderColor()
        txtFPassword.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_ENTER_NEW_PASSWORD")
        txtFPassword.textContentType = .password
        txtFPassword.isSecureTextEntry = true
        viewContConfPassword.rectViewWithBorderColor()
        txtFConfPassword.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_CONF_PASSWORD")
        txtFConfPassword.textContentType = .password
        txtFConfPassword.isSecureTextEntry = true
        
        viewContPhoneNumber.rectViewWithBorderColor()
        txtFPhoneNumber.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_PHONE_NU")
        txtFPhoneNumber.keyboardType = .numberPad
        txtFPhoneNumber.addTarget(self, action: #selector(textFieldDidChangePhoneNumber), for: UIControl.Event.editingChanged)
        
        viewContNikName.rectViewWithBorderColor()
        txtFNikName.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_NIK_NAME")
        txtFNikName.textContentType = .none
        
        btnSignUp.setTitle(txtValue: "BTN_SAVE")
        btnSignUp.setBtnSignUpUI()
        
        btnDeleteAccount.setbtnNormalUIStyleFullBack(value: "BTN_DELETE_ACCOUNT")
        
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil)
        {
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            
            if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_APPLE)
            {
                setUserCurrentLoginUI(loginWith:5)
            }else if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_GMAIL)
            {
                setUserCurrentLoginUI(loginWith:2)
            }else if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_FACEBOOK)
            {
                setUserCurrentLoginUI(loginWith:1)
            }else if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_KAKAO)
            {
                setUserCurrentLoginUI(loginWith:3)
            }else if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_NAVER)
            {
                setUserCurrentLoginUI(loginWith:4)
            }else
            {
                setUserCurrentLoginUI(loginWith:0)
            }
            txtFName.text = objUserProfile.strUserName
            txtFEmail.text = objUserProfile.strEmail
            txtFNikName.text = objUserProfile.strUserNikName
            txtFPhoneNumber.text = objUserProfile.strMobile
        }
        
        txtFEmail.isUserInteractionEnabled = false
        txtFName.isUserInteractionEnabled = false
        if isSocialMediaLogin {
            cnsPwdViewHeight.constant = 0
//            cnsEmailViewHeight.constant = 0
        }else {
            cnsPwdViewHeight.constant = 210
//            cnsEmailViewHeight.constant = 90
        }
    }
    
    func setUserCurrentLoginUI(loginWith:Int)
    {
        imgUserCurrentLogin.isHidden = false
        lblUserCurrentLogin.isHidden = false
        
        if(loginWith == 0)
        {
            imgUserCurrentLogin.isHidden = true
            lblUserCurrentLogin.isHidden = true
            
        }else if(loginWith == 1)
        {
            //facebook
            
            imgUserCurrentLogin.setImageFit(imageName: Constant.Image.facebook)
            lblUserCurrentLogin.setSmallUIStyleBlue(value: "LBL_CURRENT_FACEBOOK_LOGIN")
//            "LBL_CURRENT_FACEBOOK_LOGIN" = "You are logged in with a Facebook account.";
        }else if(loginWith == 2)
        {
            //gmail
            imgUserCurrentLogin.setImageFit(imageName: Constant.Image.google)
            lblUserCurrentLogin.setSmallUIStyleRed(value: "LBL_CURRENT_GOOGLE_LOGIN")
//            "LBL_CURRENT_GOOGLE_LOGIN" = "You are signed in with your Google Account.";
        }else if(loginWith == 3)
        {
            // kakao
            imgUserCurrentLogin.setImageFit(imageName: Constant.Image.kakao)
            lblUserCurrentLogin.setSmallUIStyleBlack(value: "LBL_CURRENT_KAKAO_LOGIN")
//            "LBL_CURRENT_KAKAO_LOGIN" = "You are logged in with your Kakao account.";
        }else if(loginWith == 4)
        {
            // naver
            imgUserCurrentLogin.setImageFit(imageName: Constant.Image.naver_green)
            lblUserCurrentLogin.setSmallUIStyleBlack(value: "LBL_CURRENT_NAVER_LOGIN")
    //          "LBL_CURRENT_NAVER_LOGIN" = "You are logged in with your Kakao account.";
        }else if(loginWith == 5)
        {
            // apple
            imgUserCurrentLogin.setImageFit(imageName: Constant.Image.apple)
            lblUserCurrentLogin.setSmallUIStyleBlack(value: "LBL_CURRENT_APPLE_LOGIN")
            //          "LBL_CURRENT_APPLE_LOGIN" = "You are logged in with your Apple account.";
        }
    }
    
    func validationTxtField() -> Bool {
        if (txtFName.text?.isEmpty)! {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_NAME")
            return false
        }
        else if (txtFNikName.text?.isEmpty)! {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_NIK_NAME")
            return false
        }
        else if (txtFPhoneNumber.text?.isEmpty)! {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_PHONE_NUMBER")
            return false
        }else if (txtFPhoneNumber.text?.count != 11) {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_VALID_PHONE_NUMBER")
            return false
        }
        else if isSocialMediaLogin == false {
            if (txtFEmail.text?.isEmpty)! {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_EMAIL")
                return false
            }
            else if (!(txtFEmail.text?.isValidEmail())!) {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_VALID_EMAIL")
                return false
            }
//            else if (txtFCurrentPassword.text?.isEmpty)! {
//                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_CURRENT_PASSWORD")
//                return false
//            }
            else if !(txtFCurrentPassword.text?.isEmpty)! {
                if (txtFCurrentPassword.text!.count < 8) {
                    AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_PASSWORD_8_DIGIT")
                    return false
                }
                if (txtFPassword.text?.isEmpty)! {
                    AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_NEW_PASSWORD")
                    return false
                }
                else if (txtFPassword.text!.count < 8) {
                    AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_PASSWORD_8_DIGIT")
                    return false
                }
                else if (txtFConfPassword.text?.isEmpty)! {
                    AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_CONF_PASSWORD")
                    return false
                }
                else if (txtFPassword.text != txtFConfPassword.text) {
                    AlertPresenter.alertInformation(fromVC: self, message: "ALERT_PASSWORD_NOT_MATCH")
                    return false
                }
                else if (txtFPassword.text == txtFCurrentPassword.text) {
                    AlertPresenter.alertInformation(fromVC: self, message: "ALERT_PASSWORD_IS_SAME")
                    return false
                }
            }
        }
        return true
    }
    
    func setEditProfileAPI() {
        
        if(Util.isNetworkReachable()) {
            self.showProgress()
            
            let dictData1:[String: Any]? = Util.getUserProfileDict()
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            
            let objUserProfileModel = UserProfileModel()
            
            objUserProfileModel.strUserId = objUserProfile.strUserId
            objUserProfileModel.strUserType = objUserProfile.strUserType
            objUserProfileModel.strMobile = txtFPhoneNumber.text
            objUserProfileModel.strUserName = txtFName.text
            objUserProfileModel.strUserNikName = txtFNikName.text
            
            if isSocialMediaLogin {
                objUserProfileModel.strEmail = ""
                objUserProfileModel.strOldPwd = ""
                objUserProfileModel.strPwd = ""
            }else {
                objUserProfileModel.strEmail = txtFEmail.text
                objUserProfileModel.strOldPwd = txtFCurrentPassword.text
                objUserProfileModel.strPwd = txtFPassword.text
            }
            
            objEditUserProfileViewModel.editProfileAPI(objUser: objUserProfileModel)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func setDeleteAccountAPI() {
        
        if(Util.isNetworkReachable()) {
            self.showProgress()
            
            let dictData1:[String: Any]? = Util.getUserProfileDict()
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            
            let objUserProfileModel = UserProfileModel()
            
            objUserProfileModel.strUserId = objUserProfile.strUserId
            
            objEditUserProfileViewModel.deleteAccountAPI(objUser: objUserProfileModel)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
        
    func onApiSuccessHideProgress() {
        self.hideProgress()
    }
    
    func editProfileSuccessApi(message: String) {
        
        var dictData1:[String: Any]? = Util.getUserProfileDict()
        
        dictData1!["name"] = txtFName.text
        dictData1!["nick_name"] = txtFNikName.text
        dictData1!["mobile"] = txtFPhoneNumber.text
        
        Util.setUserProfileDict(strValue: dictData1!)
        self.navigationController?.popViewController(animated: true)
        
//        AlertPresenter.alertInformation(fromVC: self, message: message, positiveBlock: {
//            self.navigationController?.popViewController(animated: true)
//        })
    }
    
    func deleteAccountSuccessApi(message: String) {
        // User Logout
        Util.isDeleteAccBtnTapped = false
        Util.removeAllDataOnLogout()
        
        let objLoginVC = LoginVC()
        
        let objMainVc = MainVC()
        Util.objMainVC = objMainVc
        let navMainVC  : UINavigationController = UINavigationController(rootViewController: objMainVc)
        navMainVC.navigationController?.isNavigationBarHidden = true
        navMainVC.isNavigationBarHidden = true
        Util.currentNavigationController = navMainVC
        Util.slideMenuController.changeMainViewController(navMainVC, close: true)

        Util.currentNavigationController.pushViewController(objLoginVC, animated: true)
    }
    
    func showMessage(message: String) {
        Util.isDeleteAccBtnTapped = false
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    //MARK: Button click events
    @IBAction func btnSignUpClicked(_ sender: UIButton) {
        
        if validationTxtField() {
            setEditProfileAPI()
//            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_SAVE_SUCCESS_FULLY") {
//                Util.setIsUserLogin(strValue: "1")
//                self.navigationController?.popViewController(animated: true)
//            }
        }
        
//        if(txtFPassword.text != txtFConfPassword.text)
//        {
//            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_PASSWORD_NOT_MATCH")
//        }else
//        {
//            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_SAVE_SUCCESS_FULLY") {
//                Util.setIsUserLogin(strValue: "1")
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
        
        
    }
    
    @IBAction func onClickedDeleteAccount(_ sender: Any) {
        
        Util.isDeleteAccBtnTapped = true
        let alertMessage = "\("ALERT_DELETE_ACCOUNT_DESC1".localizedLanguage()) \n\n \("ALERT_DELETE_ACCOUNT_DESC2".localizedLanguage())"
        
        AlertPresenter.alertConfirmation(fromVC: self, title: "ALERT_DELETE_ACCOUNT_TITLE", message: alertMessage, btnPossitiveText: "ALERT_DELETE_ACC_OK", btnNegativeText: "ALERT_DELETE_ACC_CANCEL") {
            
            // DO LOGOUT AND CALL API FOR DELETE ACCOUNT
            
            self.setDeleteAccountAPI()
            
        } negativeBlock: {
            //DISSMIS ALERT DIALOG
            Util.isDeleteAccBtnTapped = false
//            self.dismiss(animated: true)
        }

    }
    
    
    //MARK: Button Tabbed
    
    @objc override func leftBarButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @objc override func leftBarButtonClick2() {
//        let mainVC = MainVC()
//        let navMainVC  : UINavigationController = UINavigationController(rootViewController: mainVC)
//        navMainVC.navigationController?.isNavigationBarHidden = true
//        navMainVC.isNavigationBarHidden = true
//
//        self.slideMenuController()?.changeMainViewController(navMainVC, close: true)
//    }
    
    @objc func textFieldDidChangePhoneNumber(_ textField: UITextField) {
        var string:String = txtFPhoneNumber.text!
        string = string.replacingOccurrences(of: "-", with: "")
        let phoneFormatter = DefaultTextFormatter(textPattern: "###########")
        txtFPhoneNumber.text = phoneFormatter.format(string)
        
    }
    
    @objc override func rightBtnClickedWithImg() {
        
        if(Util.getIsUserLogin() == "0") {
            AlertPresenter.alertInformation(fromVC: Util.currentNavigationController.topViewController!, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
        }else {
            let objWebViewWithTabVC = WebViewWithTabVC()
            objWebViewWithTabVC.isBackButtonShow = true
            self.navigationController?.pushViewController(objWebViewWithTabVC, animated: true)
        }
    }

}

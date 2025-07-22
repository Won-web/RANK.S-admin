//
//  LoginVC.swift
//  RankingStar
//
//  Created by Jinesh on 13/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit
import Material
import SlideMenuControllerSwift
import AnyFormatKit

class SignUpVC: BaseVC {
    
    var objSignUpViewModel:SignUpViewModel!
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var btnSignUp: UIButton!
    
    @IBOutlet var txtFEmail: UITextField!
    @IBOutlet var viewContEmail: UIView!
    
    @IBOutlet var txtFPassword: UITextField!
    @IBOutlet var viewContPassword: UIView!
    
    @IBOutlet var txtFConfPassword: UITextField!
    @IBOutlet var viewContConfPassword: UIView!
    
    @IBOutlet var txtFPhoneNumber: UITextField!
    @IBOutlet var viewContPhoneNumber: UIView!
    
    @IBOutlet var txtFNikName: UITextField!
    @IBOutlet var viewContNikName: UIView!
    
    @IBOutlet weak var txtfName: UITextField!
    @IBOutlet weak var viewContName: UIView!
    
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblPassword: UILabel!
    @IBOutlet var lblPhoneNumber: UILabel!
    @IBOutlet var lblNikName: UILabel!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var imgPrivacyPolicy: UIImageView!
    @IBOutlet var imgTermAndCondition: UIImageView!
    @IBOutlet var imgNewsLetter: UIImageView!
    
    @IBOutlet var lblTitleAggriments: UILabel!
    @IBOutlet var lblPrivacyPolicy: UILabel!
    @IBOutlet var lblTermAndCondition: UILabel!
    @IBOutlet var lblNewsLetter: UILabel!
    
    @IBOutlet var viewContPrivacyPolicy: UIView!
    @IBOutlet var viewContermAndCondition: UIView!
    @IBOutlet var viewContNewsLetter: UIView!
    
    @IBOutlet var btnDoubleCheck: UIButton!
    @IBOutlet var lblAvailableEmail: UILabel!
    
    @IBOutlet var imgUserCurrentLogin: UIImageView!
    @IBOutlet var lblUserCurrentLogin: UILabel!
    
    @IBOutlet weak var cnsEmailPwdViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cnsCurrentLoginViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cnsNewsLetterViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var btnTermCondition: UIButton!
    
    var isCheckPrivacyPolicy : Bool! = false
    var isCheckTermCondition : Bool! = false
    var isCheckSubscription : Bool! = false
    
    var isSocialMediaLogin = false
    var isAutologin = false
    var isEmailValid : Bool!
    var objUserSocialLoginDetails = UserProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objSignUpViewModel = SignUpViewModel(vc: self)
        //  self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.view.setRightToLeftPinkGradientViewUI()
        
        txtFPhoneNumber.delegate = self
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
        navBar.setUI(navBarText: "NAVIGATION_BAR_SIGN_UP")
        self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        //self.leftBarButton2(navBar: navBar, imgName1: Constant.Image.back, imgName2: Constant.Image.home)
        //self.rightBarSingleBtnWithImage2(navBar: navBar, imgName1: Constant.Image.menu, imgName2: Constant.Image.search)
        
        lblEmail.setLoginNormalUIStyleFullBack(value: "LBL_EMAIL")
        lblPassword.setLoginNormalUIStyleFullBack(value: "LBL_PASSWORD")
        lblPhoneNumber.setLoginNormalUIStyleFullBack(value: "LBL_PHONE_NU")
        lblNikName.setLoginNormalUIStyleFullBack(value: "LBL_NIK_NAME")
        lblName.setLoginNormalUIStyleFullBack(value: "LBL_NAME")
        
        viewContEmail.rectViewWithBorderColor()
        txtFEmail.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_ENTER_EMAIL")
        txtFEmail.keyboardType = .emailAddress
        
        viewContPassword.rectViewWithBorderColor()
        txtFPassword.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_ENTER_PASSWORD")
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
        
        viewContName.rectViewWithBorderColor()
        txtfName.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_NAME")
        txtfName.textContentType = .none
        
        lblTitleAggriments.setLoginNormalUIStyleFullBack(value: "LBL_AGREEMENT")
        lblPrivacyPolicy.setLoginNormalUIStyleFullBack(value: "LBL_PRIVACY_POLICY")
        lblTermAndCondition.setLoginNormalUIStyleFullBack(value: "LBL_TERMS_CONDITION")
        lblNewsLetter.setLoginNormalUIStyleFullBack(value: "LBL_NEWSLETTER")
        
        imgPrivacyPolicy.setImageFit(imageName: Constant.Image.check_box_empt)
        imgTermAndCondition.setImageFit(imageName: Constant.Image.check_box_empt)
        imgNewsLetter.setImageFit(imageName: Constant.Image.check_box_empt)
        
        
        let viewContPrivacyPolicyTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContPrivacyPolicyTabbed))
        viewContPrivacyPolicy.isUserInteractionEnabled = true
        viewContPrivacyPolicy.addGestureRecognizer(viewContPrivacyPolicyTabbed)
        
        let viewContermAndConditionTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContermAndConditionTabbed))
        viewContermAndCondition.isUserInteractionEnabled = true
        viewContermAndCondition.addGestureRecognizer(viewContermAndConditionTabbed)
        
//        let viewContNewsLetterTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContNewsLetterTabbed))
//        viewContNewsLetter.isUserInteractionEnabled = true
//        viewContNewsLetter.addGestureRecognizer(viewContNewsLetterTabbed)
        
        cnsNewsLetterViewHeight.constant = 0
        
        btnPrivacyPolicy.setbtnNormalUIStyleFullBack(value: "BTN_EG")
//        btnPrivacyPolicy.setTitle(txtValue: "BTN_EG")
        
        btnTermCondition.setbtnNormalUIStyleFullBack(value: "BTN_EG")
//        btnTermCondition.setTitle(txtValue: "BTN_EG")
        
        btnSignUp.setTitle(txtValue: "BTN_REGISTERED")
        btnSignUp.setBtnSignUpUI()
        
        btnDoubleCheck.setTitle(txtValue: "BTN_DOUBLE_CHECK")
        btnDoubleCheck.setBtnSignUpDoubleCheckUI()
        lblAvailableEmail.setSmallUIStyleBlue(value: "") //LBL_AVAILABLE_ID
        lblAvailableEmail.isHidden = true
     
        imgUserCurrentLogin.setImageFit(imageName: "")
        lblUserCurrentLogin.text = ""
        
        if isSocialMediaLogin {
            cnsEmailPwdViewHeight.constant = 0
            cnsCurrentLoginViewHeight.constant = 25
            getUserSocialMediaDetail()
            
            if (self.objUserSocialLoginDetails.strUserName != nil && self.objUserSocialLoginDetails.strUserName != "") {
                txtfName.text = self.objUserSocialLoginDetails.strUserName
                txtfName.isUserInteractionEnabled = false
                viewContName.backgroundColor = Constant.Color.TXTF_BG_COLOR
            }else {
                txtfName.isUserInteractionEnabled = true
            }
            
            if (self.objUserSocialLoginDetails.strUserNikName != nil && self.objUserSocialLoginDetails.strUserNikName != "") {
                txtFNikName.text = self.objUserSocialLoginDetails.strUserNikName
            }
            
            if (self.objUserSocialLoginDetails.strEmail != nil && self.objUserSocialLoginDetails.strEmail != "") {
                txtFEmail.text = self.objUserSocialLoginDetails.strEmail
                txtFEmail.isUserInteractionEnabled = false
                viewContEmail.backgroundColor = Constant.Color.TXTF_BG_COLOR
            }else {
                txtFEmail.isUserInteractionEnabled = true
            }
            
        }else {
            cnsEmailPwdViewHeight.constant = 175
            cnsCurrentLoginViewHeight.constant = 0
        }
        
    }
    
    func getUserSocialMediaDetail() {
//        let dictData1:[String: Any]? = Util.getUserProfileDict()
//        if(dictData1 != nil) {
        let objUserProfile = self.objUserSocialLoginDetails
            if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_APPLE) {
                
                //apple
                imgUserCurrentLogin.setImageFit(imageName: Constant.Image.apple)
                lblUserCurrentLogin.setSmallUIStyleBlack(value: "LBL_CURRENT_APPLE_LOGIN")
                
            } else if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_GMAIL) {
                
                //gmail
                imgUserCurrentLogin.setImageFit(imageName: Constant.Image.google)
                lblUserCurrentLogin.setSmallUIStyleRed(value: "LBL_CURRENT_GOOGLE_LOGIN")
                
            }else if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_FACEBOOK) {
                
                //facebook
                imgUserCurrentLogin.setImageFit(imageName: Constant.Image.facebook)
                lblUserCurrentLogin.setSmallUIStyleBlue(value: "LBL_CURRENT_FACEBOOK_LOGIN")
                
            }else if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_KAKAO) {
                
                // kakao
                imgUserCurrentLogin.setImageFit(imageName: Constant.Image.kakao)
                lblUserCurrentLogin.setSmallUIStyleBlack(value: "LBL_CURRENT_KAKAO_LOGIN")
                
            }else if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_NAVER) {
                
                // naver
                imgUserCurrentLogin.setImageFit(imageName: Constant.Image.naver_green)
                lblUserCurrentLogin.setSmallUIStyleBlack(value: "LBL_CURRENT_NAVER_LOGIN")
                
            }else {
                imgUserCurrentLogin.setImageFit(imageName: "")
                lblUserCurrentLogin.text = ""
            }
        //}
    }
    
    func validationTxtField() -> Bool {
        if isSocialMediaLogin {
            if (txtFEmail.text?.isEmpty)! {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_EMAIL")
                return false
            }
            else if (!(txtFEmail.text?.isValidEmail())!) {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_VALID_EMAIL")
                return false
            }
            else if (txtfName.text?.isEmpty)! {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_NAME")
                return false
            }
            else if (txtFPhoneNumber.text?.isEmpty)! {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_PHONE_NUMBER")
                return false
            }else if (txtFPhoneNumber.text?.count != 11) {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_VALID_PHONE_NUMBER")
                return false
            }
            else if (txtFNikName.text?.isEmpty)! {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_NIK_NAME")
                return false
            }
            else if !isCheckPrivacyPolicy {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_CHECK_PRIVACY_POLICY")
                return false
            }
            else if !isCheckTermCondition {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_CHECK_TERMS_UF_USE")
                return false
            }
        }else {
            if (txtFEmail.text?.isEmpty)! {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_EMAIL")
                return false
            }else if (!(txtFEmail.text?.isValidEmail())!) {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_VALID_EMAIL")
                return false
            }
            else if (txtFPassword.text?.isEmpty)! {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_PASSWORD")
                return false
            }
            else if (txtFPassword.text!.count < 8) {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_PASSWORD_8_DIGIT")
                return false
            }
            else if (txtFConfPassword.text?.isEmpty)! {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_CONF_PASSWORD")
                return false
            }else if (txtFPassword.text != txtFConfPassword.text) {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_PASSWORD_NOT_MATCH")
                return false
            }else if (txtfName.text?.isEmpty)! {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_NAME")
                return false
            }
            else if (txtFPhoneNumber.text?.isEmpty)! {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_PHONE_NUMBER")
                return false
            }else if (txtFPhoneNumber.text?.count != 11) {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_VALID_PHONE_NUMBER")
                return false
            }
            else if (txtFNikName.text?.isEmpty)! {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_NIK_NAME")
                return false
            }
            else if !isCheckPrivacyPolicy {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_CHECK_PRIVACY_POLICY")
                return false
            }
            else if !isCheckTermCondition {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_CHECK_TERMS_UF_USE")
                return false
            }
        }
        
        return true
    }
    
    func getDeviceRegisterApi() {
        if (Util.isNetworkReachable()) {
            self.showProgress()
            objSignUpViewModel.getDeviceRegisterAPI()
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func getSignWithEmailAPI() {
        
        if(Util.isNetworkReachable()) {
            self.showProgress()
            
            let objUserProfileModel = UserProfileModel()
            objUserProfileModel.strEmail = txtFEmail.text
            objUserProfileModel.strPwd = txtFPassword.text
            objUserProfileModel.strMobile = txtFPhoneNumber.text
            objUserProfileModel.strUserName = txtfName.text
            objUserProfileModel.strUserNikName = txtFNikName.text
            objUserProfileModel.isTermAndCondition = "1"
            objUserProfileModel.isPrivacyPolicy = "1"
            objUserProfileModel.isNewsLatter = "0"
            
            if isCheckSubscription {
                objUserProfileModel.isNewsLatter = "1"
            }
            
            objSignUpViewModel.signUpAPI(objUser: objUserProfileModel)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func getSocialAPI() {
        
        self.objUserSocialLoginDetails.strUserName = txtfName.text!
        self.objUserSocialLoginDetails.strUserNikName = txtFNikName.text!
        self.objUserSocialLoginDetails.strMobile = txtFPhoneNumber.text!
        self.objUserSocialLoginDetails.strEmail = txtFEmail.text!
        
//        if self.objUserSocialLoginDetails.strLoginType == Constant.ResponseParam.LOGIN_TYPE_APPLE {
//            self.objUserSocialLoginDetails.strUserId = self.objUserSocialLoginDetails.strUserSocialId
//        }
        
        if(Util.isNetworkReachable()) {
            self.showProgress()
            
            objSignUpViewModel.socialLoginAPI(objUser: self.objUserSocialLoginDetails)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func getVerifySocialAPI(objUser:UserProfileModel) {
        
        if(Util.isNetworkReachable()) {
            self.showProgress()
            
            objSignUpViewModel.verifySocialLoginAPI(objUser: objUser)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func checkAvailableEmailAPI() {
        
        if(Util.isNetworkReachable()) {
            self.showProgress()
            
            let objUserProfileModel = UserProfileModel()
            objUserProfileModel.strEmail = txtFEmail.text
            
            objSignUpViewModel.checkAvailableEmailAPI(objUser: objUserProfileModel)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    
    func loginSuccessWithSignUp(objOTP : OTP, message : String) {
//        getDeviceRegisterApi()
        Util.setIsUserLogin(strValue: "1")
        Util.setIsUserAutoLogin(strValue: "0")
        Util.setIsUserLoginType(strValue: Constant.ResponseParam.LOGIN_TYPE_AUTH)
//        self.navigationController?.popViewController(animated: true)
        
        AlertPresenter.alertInformation(fromVC: self, message: message) {
            let objOTPVerificationVC = OTPVerificationVC()
            objOTPVerificationVC.enteredEmail = self.txtFEmail.text!
            objOTPVerificationVC.otp = objOTP.otp
            objOTPVerificationVC.fromSignUP = true
            self.navigationController?.pushViewController(objOTPVerificationVC, animated: true)
        }
        
    }
    
    func availableEmailSuccessApi(isSuccess:Bool, message:String) {
        lblAvailableEmail.text = message
        if(isSuccess)
        {
            lblAvailableEmail.isHidden = false
            lblAvailableEmail.textColor = Constant.Color.LBL_TXT_CURRENT_LOGIN
            isEmailValid = true
        }else
        {
            lblAvailableEmail.isHidden = false
            lblAvailableEmail.textColor = Constant.Color.LBL_TXT_EMAIL_NOT_AVAILABLE
            isEmailValid = false
        }
       // AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    func onApiSuccessHideProgress() {
        self.hideProgress()
    }
    
    func onDeviceRegisterSuccessApi() {
    }
    
    func SignUpSuccessWithSocialAccount() {
//        getDeviceRegisterApi()
        if(isAutologin)
        {
            Util.setIsUserAutoLogin(strValue: "1")
        }else
        {
            Util.setIsUserAutoLogin(strValue: "0")
        }
        Util.setIsUserLogin(strValue: "1")
        
        getVerifySocialAPI(objUser: objUserSocialLoginDetails)
        
    }
    
    func onSuccessVerifyLoginSocialAccount() {
        getDeviceRegisterApi()
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func onFailVerifyUserSocialLogin(message: String) {
        
        AlertPresenter.alertInformation(fromVC: self, message: message) {
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
    }
    
    func showMessage(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    
    //MARK: Button click events
    @IBAction func onClickedDoubleCheck(_ sender: Any) {
        if (txtFEmail.text?.isEmpty)! {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_EMAIL")
            
        }
        else if (!(txtFEmail.text?.isValidEmail())!) {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_VALID_EMAIL")
        }else
        {
            checkAvailableEmailAPI()
        }        
    }
    
    @IBAction func onClickPrivacyPolicy(_ sender: Any) {
        let objWebView = WebViewChargingStationFreeVC()
        objWebView.strWebURL = "api/\(Constant.API.PRIVACY_POLICY_WEBVIEW)"
        self.navigationController?.pushViewController(objWebView, animated: true)
    }
    
    @IBAction func onClickTermCondition(_ sender: Any) {
        let objWebView = WebViewChargingStationFreeVC()
        objWebView.strWebURL = "api/\(Constant.API.TERM_CONDITION_WEBVIEW)"
        self.navigationController?.pushViewController(objWebView, animated: true)
    }
    
    
    @IBAction func btnSignUpClicked(_ sender: UIButton) {
        
        if validationTxtField() {
            if isSocialMediaLogin {
                getSocialAPI()
            }else {
                getSignWithEmailAPI()
            }
        }
        
        //        if(txtFEmail.text == "" || txtFEmail.text?.isValidEmail() == false)
        //        {
        //            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_INVALID_EMAIL")
        //        }else if(txtFPassword.text == "" || txtFConfPassword.text == "")
        //        {
        //            AlertPresenter.alertInformation(fromVC: self, message: "TXTF_ERROR_PASSWORD")
        //        }else if(txtFPassword.text != txtFConfPassword.text)
        //        {
        //            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_PASSWORD_NOT_MATCH")
        //        }
        //
        //        else
        //        {
        //            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_SIGN_UP_SUCCESS_FULLY") {
        //                Util.setIsUserLogin(strValue: "1")
        //                self.navigationController?.popViewController(animated: true)
        //            }
        //        }
    }
    
    //MARK: Button Tabbed
    @objc override func leftBarButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc override func leftBarButtonClick2() {
        let mainVC = MainVC()
        let navMainVC  : UINavigationController = UINavigationController(rootViewController: mainVC)
        navMainVC.navigationController?.isNavigationBarHidden = true
        navMainVC.isNavigationBarHidden = true
        
        self.slideMenuController()?.changeMainViewController(navMainVC, close: true)
    }
    
    @objc func viewContPrivacyPolicyTabbed(sender:CustomTabGestur)
    {
        if(imgPrivacyPolicy.image == UIImage(named: Constant.Image.check_box_empt))
        {
            isCheckPrivacyPolicy = true
            imgPrivacyPolicy.setImageFit(imageName: Constant.Image.check_box_check)
            
        }else
        {
            isCheckPrivacyPolicy = false
            imgPrivacyPolicy.setImageFit(imageName: Constant.Image.check_box_empt)
        }
    }
    
    @objc func viewContermAndConditionTabbed(sender:CustomTabGestur)
    {
        if(imgTermAndCondition.image == UIImage(named: Constant.Image.check_box_empt))
        {
            isCheckTermCondition = true
            imgTermAndCondition.setImageFit(imageName: Constant.Image.check_box_check)
            
        }else
        {
            isCheckTermCondition = false
            imgTermAndCondition.setImageFit(imageName: Constant.Image.check_box_empt)
        }
    }
    
    @objc func viewContNewsLetterTabbed(sender:CustomTabGestur)
    {
        if(imgNewsLetter.image == UIImage(named: Constant.Image.check_box_empt))
        {
            isCheckSubscription = true
            imgNewsLetter.setImageFit(imageName: Constant.Image.check_box_check)
            
        }else
        {
            isCheckSubscription = false
            imgNewsLetter.setImageFit(imageName: Constant.Image.check_box_empt)
        }
    }
    
    @objc func textFieldDidChangePhoneNumber(_ textField: UITextField) {
        var string:String = txtFPhoneNumber.text!
        string = string.replacingOccurrences(of: "-", with: "")
        let phoneFormatter = DefaultTextFormatter(textPattern: "###########")
        txtFPhoneNumber.text = phoneFormatter.format(string)
        
    }
    
    //    @objc override func rightBtnClickedWithImg() {
    //        print("rightBtnClickedWithImg")
    //        self.toggleLeft()
    //    }
    //
    //    @objc override func rightBtnClickedWithImg2() {
    //        print("rightBtnClickedWithImg2")
    //    }
    
}

extension SignUpVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}

extension SignUpVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        // print("SlideMenuControllerDelegate: leftWillOpen")
    }
}


//
//  OTPVerificationVC.swift
//  RankingStar
//
//  Created by Hitarthi on 28/02/22.
//  Copyright © 2022 Etech. All rights reserved.
//

import UIKit

class OTPVerificationVC: BaseVC {
    
    var objOTPVerificationViewModel : OTPVerificationViewModel!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var lblEmailVerification: UILabel!
    @IBOutlet var lblEnterOTP: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var viewOTP: UIView!
    @IBOutlet var txtFOTP: UITextField!
    @IBOutlet var btnVerify: UIButton!
    @IBOutlet var lblReSendOTP: UILabel!
    
    var enteredEmail = ""
    var otp = 0
    var fromSignUP = false
    var fromSignUPWithSocialLogin = false
    
    //Timer
    var count = 60  // 60sec if you want
    var resendTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        #if DEBUG
//        txtFOTP.text = "\(otp)"
//        #endif
        
        setOTPToTextField(otp: otp)
        
        objOTPVerificationViewModel = OTPVerificationViewModel(vc: self)
        
        navBar.setUI(navBarText: "NAVIGATION_BAR_OTP")
        self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        setUIColor()
        
        startTimer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissAlertInfoPresenter()
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        self.hideProgress()
    }

    @IBAction func verifyClicked(_ sender: Any) {
        
        if (txtFOTP.text?.isEmpty)! {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_OTP")
        }
//        else if count == 0  {
//            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_VALID_OTP")
//        }
        else {
            getOTPAPI()
        }
    }
    
    //MARK: Custom method
    
    func startTimer() {
        resendTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        if(count > 0) {
            count = count - 1
//            print(count)
            if count >= 10 {
                lblReSendOTP.text = "\("BTN_RESEND_OTP".localizedLanguage()) \("LBL_IN".localizedLanguage()) 00:00:\(count)"
            }else {
                lblReSendOTP.text = "\("BTN_RESEND_OTP".localizedLanguage()) \("LBL_IN".localizedLanguage()) 00:00:0\(count)"
            }
            
            lblReSendOTP.textColor = Constant.Color.LIGHT_GREY1
            lblReSendOTP.isUserInteractionEnabled = false
        }
        else {
            lblReSendOTP.text = "\("BTN_RESEND_OTP".localizedLanguage())"
            lblReSendOTP.textColor = Constant.Color.LBL_CELL_PINK_COLOR
            lblReSendOTP.isUserInteractionEnabled = true
            txtFOTP.text = ""
            resendTimer.invalidate()
            print("call your api")
            // if you want to reset the time make count = 60 and resendTime.fire()
        }
    }
    
    func setUIColor() {
        
        lblEmailVerification.setFgtPwdHeaderVeryBigUIStylePink(value: "LBL_EMAIL_VERIFICATION")
        lblEnterOTP.setLoginNormalUIStyleFullBack(value: "LBL_ENTER_OTP_SENT_TO")
        lblEmail.setLoginNormalUIStyleFullBack(value: enteredEmail)
        lblEmail.font = Constant.Font.FONT_NAVIGATION_HEADER
        
//        lblReSendOTP.setLoginSmallBGColorUITxtPinkCell(value: "\("BTN_RESEND_OTP".localizedLanguage()) \(timer)")
        lblReSendOTP.setLoginNormalUIStylePinkCell(value: "\("BTN_RESEND_OTP".localizedLanguage()) \("LBL_IN".localizedLanguage())")
        let lblOTPTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.lblOTPTabbed))
        lblReSendOTP.isUserInteractionEnabled = true
        lblReSendOTP.addGestureRecognizer(lblOTPTabbed)
        
        viewOTP.rundViewWithBorderColor()
        txtFOTP.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_OTP")
        txtFOTP.textAlignment = .center
        txtFOTP.keyboardType = .numberPad
        
        btnVerify.setTitle(txtValue: "BTN_VERIFY")
        btnVerify.setBtnLoginWithEmailUI()
        
    }
    
    func getOTPAPI() {
        
        if Util.isNetworkReachable() {
            self.showProgress()
            
            let objOTP = OTP()
            objOTP.otp = Int(txtFOTP.text!)
            objOTP.email = enteredEmail
            objOTP.otpFor = Constant.ResponseParam.OTP_FOR_FRGT_PWD
            
            if fromSignUP {
                objOTP.otpFor = Constant.ResponseParam.OTP_FOR_REGISTER
            }
            
            self.objOTPVerificationViewModel.getOTPVerificationAPI(objOTP: objOTP)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func getResendOTPAPI() {
        
        if Util.isNetworkReachable() {
            self.showProgress()
            
            let objOTP = OTP()
            objOTP.email = enteredEmail
            objOTP.otpFor = Constant.ResponseParam.OTP_FOR_FRGT_PWD
            
            if fromSignUP {
                objOTP.otpFor = Constant.ResponseParam.OTP_FOR_REGISTER
            }
            
            self.objOTPVerificationViewModel.getOTPResendAPI(objOTP: objOTP)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func setOTPToTextField(otp : Int) {
        
        if Constant.API.BASEURL == Constant.ServerBaseURL.ETECH_DEMO_V2 {
            txtFOTP.text = "\(otp)"
        }
    }
    
    //MARK: Button Tabbed
    
    @objc override func leftBarButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func lblOTPTabbed() {
        print("Resend OTP")
        getResendOTPAPI()
        count = 60
        startTimer()
    }
    
    //MARK: View Model Methods
    
    func onOTPVerificationApiComplete() {
        self.hideProgress()
    }
    
    func onOTPVerificationApiSuccess() {
        
        var userID = ""
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            userID = objUserProfile.strUserId
        }
        
        if fromSignUP {
            
            let objLoginVC = LoginVC()
//            navigationController?.pushViewController(objLoginVC, animated: true)
            
            let objMainVc = MainVC()
            Util.objMainVC = objMainVc
            let navMainVC  : UINavigationController = UINavigationController(rootViewController: objMainVc)
            navMainVC.navigationController?.isNavigationBarHidden = true
            navMainVC.isNavigationBarHidden = true
            Util.currentNavigationController = navMainVC
            Util.slideMenuController.changeMainViewController(navMainVC, close: true)

            Util.currentNavigationController.pushViewController(objLoginVC, animated: true)
            
        }else {
            //GO TO CREATE NEW PASSWORD SCREEN
            let objCreateNewPwdVC = CreateNewPwdVC()
            objCreateNewPwdVC.userID = userID
            navigationController?.pushViewController(objCreateNewPwdVC, animated: true)
            
        }
    }
    
    func onSuccessOfLoginApi() {
        let objMainVC = MainVC()
        navigationController?.pushViewController(objMainVC, animated: true)
    }
    
    func onOTPResendVerificationSuccess(objOTP : OTP) {
        setOTPToTextField(otp: objOTP.otp)
    }
    
    func showMessage(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }

}

//
//  ForgotPasswordVC.swift
//  RankingStar
//
//  Created by Hitarthi on 28/02/22.
//  Copyright © 2022 Etech. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseVC {

    var objForgotPasswordViewModel : ForgotPasswordViewModel!
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var viewEmail: UIView!
    @IBOutlet var lblForgotPwd: UILabel!
    @IBOutlet var imgEmail: UIImageView!
    @IBOutlet var txtFEmail: UITextField!
    @IBOutlet var btnForgotPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        txtFEmail.text = "demo@gmail.com"
        #endif
        
        objForgotPasswordViewModel = ForgotPasswordViewModel(vc: self)
        setUIColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissAlertInfoPresenter()
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        self.hideProgress()
    }
    
    //MARK: custom method
    
    func setUIColor() {
        
        navBar.setUI(navBarText: "NAVIGATION_BAR_FORGOT_PASSWORD")
        
        self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        
        lblForgotPwd.setFgtPwdHeaderVeryBigUIStylePink(value: "LBL_FORGOT_PWD")
        
        viewEmail.rundViewWithBorderColor()
        imgEmail.setImageFit(imageName: Constant.Image.user_email)
        txtFEmail.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_EMAIL")
        txtFEmail.keyboardType = .emailAddress
        
        btnForgotPassword.setTitle(txtValue: "BTN_VERIFY")
        btnForgotPassword.setBtnLoginWithEmailUI()
        
    }
    
    func validationTxtField() -> Bool {
        if (txtFEmail.text?.isEmpty)! {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_EMAIL")
            return false
        }
        else if (!(txtFEmail.text?.isValidEmail())!) {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_VALID_EMAIL")
            return false
        }
        return true
    }
    
    func getForgotPwdAPI() {
        
        if Util.isNetworkReachable() {
            self.showProgress()
            self.objForgotPasswordViewModel.getForgotPwdAPI(email: txtFEmail.text!)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    
    //MARK: Button click events
    @IBAction func VerifyClicked(_ sender: Any) {
        
        if validationTxtField() {
            getForgotPwdAPI()
        }
        
    }
    
    
    //MARK: View Model Methods
    
    func onForgotPwdApiComplete() {
        self.hideProgress()
    }
    
    func onForgotPwdApiSuccess(objOTP : OTP, message : String) {
        
        //GO TO OTP Verification Screen
        AlertPresenter.alertInformation(fromVC: self, message: message) {
            let objOTPVerificationVC = OTPVerificationVC()
            objOTPVerificationVC.enteredEmail = self.txtFEmail.text!
            objOTPVerificationVC.otp = objOTP.otp
            self.navigationController?.pushViewController(objOTPVerificationVC, animated: true)
        }
        
    }
    
    func showMessage(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    //MARK: Button Tabbed
    
    @objc override func leftBarButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
}

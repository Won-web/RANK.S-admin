//
//  LoginVC.swift
//  RankingStar
//
//  Created by Jinesh on 13/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit
import Material
import GoogleSignIn
import FBSDKLoginKit
import FBSDKShareKit
import Social
import KakaoOpenSDK
import KakaoLink
import KakaoMessageTemplate
import NaverThirdPartyLogin
import SwiftyXMLParser
import AuthenticationServices

// Auto Login View height - 30, Image height - 20

class LoginVC: BaseVC {
    
    var objLoginViewModel:LoginViewModel!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var txtFEmail: UITextField!
    @IBOutlet var viewContEmail: UIView!
    @IBOutlet var imgUserEmail: UIImageView!
    @IBOutlet var imgAppLogo: UIImageView!
    
    @IBOutlet var txtFPassword: UITextField!
    @IBOutlet var viewContPassword: UIView!
    @IBOutlet var imgUserPassword: UIImageView!
    
    @IBOutlet var viewContApple: UIView!
    @IBOutlet var viewContGoogle: UIView!
    @IBOutlet var viewContFaceBook: UIView!
    @IBOutlet var viewContKakao: UIView!
    @IBOutlet var viewContNaver: UIView!
    @IBOutlet var cnsAppleViewHeight: NSLayoutConstraint!
    
    @IBOutlet var imgApple: UIImageView!
    @IBOutlet var imgGoogle: UIImageView!
    @IBOutlet var imgFaceBook: UIImageView!
    @IBOutlet var imgKakao: UIImageView!
    @IBOutlet var imgNaver: UIImageView!
    
    @IBOutlet var lblTitleApple: UILabel!
    @IBOutlet var lblTitleGoogle: UILabel!
    @IBOutlet var lblTitleFaceBook: UILabel!
    @IBOutlet var lblTitleKakao: UILabel!
    @IBOutlet var lblTitleNaver: UILabel!
    
    @IBOutlet var lblUserAutologin: UILabel!
    @IBOutlet var imgUserAutologin: UIImageView!
    @IBOutlet var viewContAutoLogin: UIView!
    
    @IBOutlet var lblOr: UILabel!
    @IBOutlet var lblForgotPwd: UILabel!
    
    //    @IBOutlet var btnGoogle: UIButton!
    //    @IBOutlet var btnFacebook: UIButton!
    //    @IBOutlet var btnKakao: UIButton!
    //    @IBOutlet var btnNaver: UIButton!
    
    
    let btnFBSDKShareButton : FBShareButton = FBShareButton()
    var shareDialog: ShareDialog!
    
    var objUserProfileDetail = UserProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objLoginViewModel  = LoginViewModel(vc: self)
        //        self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.view.setRightToLeftPinkGradientViewUI()
        
        shareDialog = ShareDialog()
        
        setUIColor()
        
        #if DEBUG
//            txtFEmail.text = "mac@mail.com"
//            txtFPassword.text = "12345678"
//        txtFEmail.text = "abc@gmail.com"
//        txtFPassword.text = "12345678"
//        txtFEmail.text = "giunssen@gmail.com"
//        txtFPassword.text = "61818468"
//        txtFEmail.text = "demo@gmail.com" //Phone num : 14082736161
//        txtFPassword.text = "12345678"
        txtFEmail.text = "hit@gmail.com"
        txtFPassword.text = "12345678"
          //Yuvrajsinhr                     //Phone num : 08523697412
//        txtFEmail.text = "minyeh1@naver.
        
        #endif
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
    
    @available(iOS 13.0, *)
    func loginWithAppleAC() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
        //        performExistingAccountSetupFlows()
        
    }
    
    func loginWithGoogleAC()
    {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }

    func setUIColor()
    {
        //Util.statusBarColor(color: Constant.Color.NAVIGATION_BAR_BG_COLOR)
        navBar.setUI(navBarText: "NAVIGATION_BAR_LOGIN")
        self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        // self.leftBarButton2(navBar: navBar, imgName1: Constant.Image.back, imgName2: Constant.Image.home)
        
        imgAppLogo.setImageFit(imageName: Constant.Image.logo_kor)
        imgUserEmail.setImageFit(imageName: Constant.Image.user_email)
        imgUserPassword.setImageFit(imageName: Constant.Image.user_lock)
        
//        imgUserAutologin.setImageFit(imageName: Constant.Image.check_box_empt)
        imgUserAutologin.setImageFit(imageName: Constant.Image.check_box_check)
        
        viewContEmail.rundViewWithBorderColor()
        viewContPassword.rundViewWithBorderColor()
        viewContApple.rundViewWithBorderColor()
        viewContApple.borderColor = UIColor.black
        viewContGoogle.rundViewWithBorderColor()
        viewContFaceBook.rundViewForBtnFacebook()
        viewContKakao.rundViewForBtnFacebook()
//        viewContNaver.rundViewForBtnFacebook()
        
        viewContFaceBook.backgroundColor = Constant.Color.VIEW_BG_FACEBOOK_COLOR
        viewContKakao.backgroundColor = Constant.Color.BTN_LOGIN_WITH_KAKAO_COLOR
//        viewContNaver.backgroundColor = Constant.Color.BTN_LOGIN_WITH_NAVER_COLOR
        
//        imgApple.setImageFit(imageName: Constant.Image.apple)
        imgGoogle.setImageFit(imageName: Constant.Image.google)
        imgFaceBook.setImageFit(imageName: Constant.Image.facebook_white)
        imgKakao.setImageFit(imageName: Constant.Image.kakao_btn)
//        imgNaver.setImageFit(imageName: Constant.Image.naver)
        
//        lblTitleApple.setLoginNormalUIStyleFullBack(value: "BTN_APPLE_LOGIN")
        lblTitleGoogle.setLoginNormalUIStyleFullBack(value: "BTN_GOOGLE_LOGIN")
        lblTitleGoogle.font = Constant.Font.LBL_NORMAL_TEXT1
        lblTitleFaceBook.setLoginNormalUIStyleWhite(value: "BTN_FACEBOOK_LOGIN")
        lblTitleFaceBook.font = Constant.Font.LBL_NORMAL_TEXT1
        lblTitleKakao.setLoginNormalUIStyleWhite(value: "BTN_KAKAO_LOGIN")
        lblTitleKakao.font = Constant.Font.LBL_NORMAL_TEXT1
//        lblTitleNaver.setLoginNormalUIStyleWhite(value: "BTN_NAVER_LOGIN")
//        lblTitleNaver.font = Constant.Font.LBL_NORMAL_TEXT1
        
        txtFEmail.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_EMAIL")
        txtFEmail.keyboardType = .emailAddress
        txtFPassword.setUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_PASSWORD")
        txtFPassword.textContentType = .password
        txtFPassword.isSecureTextEntry = true
        
        lblUserAutologin.setLoginNormalUIStyle(value: "LBL_AUTO_LOGIN")
        lblOr.setLoginNormalUIStyle(value: "LBL_OR")
        lblForgotPwd.setForgotPwdUIStyle(value: "LBL_FORGOT_PWD")
        
        let lblForgotPwdTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.lblForgotPwdTabbed))
        lblForgotPwd.isUserInteractionEnabled = true
        lblForgotPwd.addGestureRecognizer(lblForgotPwdTabbed)
        
        btnLogin.setTitle(txtValue: "BTN_LOGIN")
        btnLogin.setBtnLoginWithEmailUI()
        
        //        btnGoogle.setTitle(txtValue: "BTN_GOOGLE_LOGIN")
        //        btnGoogle.setBtnLoginWithGoogleUI()
        //
        //        btnFacebook.setTitle(txtValue: "BTN_FACEBOOK_LOGIN")
        //        btnFacebook.setBtnLoginWithFacebookUI()
        //        btnKakao.setTitle(txtValue: "BTN_KAKAO_LOGIN")
        //        btnKakao.setBtnLoginWithKakaoUI()
        //        btnNaver.setTitle(txtValue: "BTN_NAVER_LOGIN")
        //        btnNaver.setBtnLoginWithNaverUI()
        
        
        let viewContAutoLoginTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContAutoLoginTabbed))
        viewContAutoLogin.isUserInteractionEnabled = true
        viewContAutoLogin.addGestureRecognizer(viewContAutoLoginTabbed)
        
//        let viewContAppleTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContAppleTabbed))
//        viewContApple.isUserInteractionEnabled = true
//        viewContApple.addGestureRecognizer(viewContAppleTabbed)
        
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
            let size = self.viewContApple.frame.size
            authorizationButton.addTarget(self, action: #selector(self.viewContAppleTabbed), for: .touchUpInside)
            self.viewContApple.addSubview(authorizationButton)
            
            authorizationButton.translatesAutoresizingMaskIntoConstraints = false
            authorizationButton.leadingAnchor.constraint(equalTo: self.viewContApple.leadingAnchor).isActive = true
            authorizationButton.trailingAnchor.constraint(equalTo: self.viewContApple.trailingAnchor).isActive = true
            authorizationButton.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            authorizationButton.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
//        appleCustomLoginButton()
        
        if #available(iOS 13.0, *) {
            cnsAppleViewHeight.constant = 44
        } else {
            cnsAppleViewHeight.constant = 0
        }
        
        let viewContGoogleTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContGoogleTabbed))
        viewContGoogle.isUserInteractionEnabled = true
        viewContGoogle.addGestureRecognizer(viewContGoogleTabbed)
        let viewContFaceBookTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContFaceBookTabbed))
        viewContFaceBook.isUserInteractionEnabled = true
        viewContFaceBook.addGestureRecognizer(viewContFaceBookTabbed)
        let viewContKakaoTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContKakaoTabbed))
        viewContKakao.isUserInteractionEnabled = true
        viewContKakao.addGestureRecognizer(viewContKakaoTabbed)
//        let lblTitleNaverTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.lblTitleNaverTabbed))
//        lblTitleNaver.isUserInteractionEnabled = true
//        lblTitleNaver.addGestureRecognizer(lblTitleNaverTabbed)
        
        print(Util.getIsUserLoginWithFacebook())
    }
    
//    @available(iOS 13.0, *)
//    func setupProviderLoginView() {
//        let authorizationButton = ASAuthorizationAppleIDButton()
//        authorizationButton.addTarget(self, action: #selector(self.viewContAppleTabbed), for: .touchUpInside)
//        self.viewContApple.addSubview(authorizationButton)
//    }
    
 /*   func appleCustomLoginButton() {
        if #available(iOS 13.0, *) {
            
            let customAppleLoginBtn = UIButton()
            customAppleLoginBtn.layer.cornerRadius = 20.0
            customAppleLoginBtn.layer.borderWidth = 2.0
            customAppleLoginBtn.backgroundColor = UIColor.black
            customAppleLoginBtn.layer.borderColor = UIColor.black.cgColor
            customAppleLoginBtn.setTitle("BTN_APPLE_LOGIN".localizedLanguage(), for: .normal)
            customAppleLoginBtn.setTitleColor(UIColor.white, for: .normal)
            customAppleLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
            customAppleLoginBtn.setImage(UIImage(named: Constant.Image.apple_white), for: .normal)
            customAppleLoginBtn.contentHorizontalAlignment = .left
            customAppleLoginBtn.addTarget(self, action: #selector(self.viewContAppleTabbed), for: .touchUpInside)
            customAppleLoginBtn.frame = CGRect(x: 0, y: 0, width: self.viewContApple.frame.width, height: self.viewContApple.frame.height)
            self.viewContApple.addSubview(customAppleLoginBtn)
            
            // Setup Layout Constraints to be in the center of the screen
            guard let imageViewWidth = customAppleLoginBtn.imageView?.frame.width else{return}
            guard let titleLabelWidth = customAppleLoginBtn.titleLabel?.intrinsicContentSize.width else{return}
            customAppleLoginBtn.contentHorizontalAlignment = .left
            customAppleLoginBtn.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 30 - imageViewWidth / 2, bottom: 0.0, right: 0.0)
            customAppleLoginBtn.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: (customAppleLoginBtn.bounds.width - titleLabelWidth) / 2 - imageViewWidth, bottom: 0.0, right: 0.0)
        }
    } */
    
    let loginManager = LoginManager()
    // facebook login and get user Details
    func customFacebookLoginButton()
    {
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.hideProgress()
        }
        
        loginManager.logOut()
        //        loginManager.logOut()
        //        AccessToken.current = nil
        //        Profile.current = nil
        self.showProgress()
        loginManager.logIn(permissions: ["public_profile"], from: self) { (result, error) in
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self.hideProgress()
            }
            if error != nil{
                DispatchQueue.main.async {
                    print("error \(String(describing: error))")
                    AlertPresenter.alertInformation(fromVC: self, message: "Connection_with_facebook_not_success_fully")
                    return
                }
            }
            if(result != nil)
            {
                if(result?.isCancelled)! {
                    DispatchQueue.main.async {
                        AlertPresenter.alertInformation(fromVC: self, message: "Connection_with_facebook_not_success_fully")
                    }
                }
                else
                {

                    DispatchQueue.main.async {
                        //                        print("login success")
                        self.showUserEmailDetail()
                    }
                }
            }
        }
    }
    
    //MARK:- Facebook Login
    func showUserEmailDetail()
    {
        GraphRequest(graphPath: "me", parameters: ["fields":"email, id,name,first_name,gender"]).start { (connection, result, error) in
            DispatchQueue.main.async {
                if error != nil
                {
                    
                    AlertPresenter.alertInformation(fromVC: self, message: "Connection_with_facebook_not_success_fully")
                    return
                }
                print("result : \(result as! NSDictionary)")
                if let resultDict = result as? NSDictionary
                {
                    let objUserProfileModel = UserProfileModel()
                    //                if let objFirstName = resultDict["first_name"] as? String
                    //                {
                    //                    objUserProfileModel.strUserName = objFirstName
                    //                }else
                    //                {
                    //                    objUserProfileModel.strUserName = ""
                    //                }
                    
                    if let objId = resultDict["id"] as? String
                    {
                        objUserProfileModel.strUserId = objId
                    }else
                    {
                        objUserProfileModel.strUserId = ""
                    }
                    
                    if let objName = resultDict["name"] as? String
                    {
                        objUserProfileModel.strUserName = objName
                    }else
                    {
                        objUserProfileModel.strUserName = ""
                    }
                    
                    objUserProfileModel.strUserNikName = ""
                    
                    objUserProfileModel.strEmail = ""
                    if let objEmail = resultDict["email"] as? String {
                        objUserProfileModel.strEmail = objEmail
                    }
                    objUserProfileModel.strLoginType = Constant.ResponseParam.LOGIN_TYPE_FACEBOOK
                    
                    self.objUserProfileDetail = objUserProfileModel
                    self.getVerifySocialAPI(objUser: objUserProfileModel)
                    //                self.getSocialAPI(objUser: objUserProfileModel)
                }else
                {
                    AlertPresenter.alertInformation(fromVC: self, message: "Connection_with_facebook_not_success_fully")
                }
            }
            
            
            
            //            Util.setIsUserLogin(strValue: "1")
            //            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    // share application detail on facebook
    func shareApplicationOnfaceBook()
    {
        let facebookComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookComposer?.setInitialText("Enjoy the devotional hymns of Hanuman Chalisa on your iPhone and worship Lord Hanuman to fulfil your life.")
        facebookComposer?.add(URL(string: "http://itunes.apple.com/in/app/hanuman-chalisha-free/id327904895?mt=8"))
        facebookComposer?.add(UIImage(named: "hanuman"))
        
        self.present(facebookComposer!, animated: true, completion: {
            AlertPresenter.alertInformation(fromVC: self, message: "Click_on_Post_to_share_app")
            
        })
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
        else if (txtFPassword.text?.isEmpty)! {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_PASSWORD")
            return false
        }
        else if (txtFPassword.text!.count < 8) {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ENTER_PASSWORD_8_DIGIT")
            return false
        }
        return true
    }
    
    // facebook share link content
    func btnFBSDKShareLinkContent()
    {
        let content : ShareLinkContent = ShareLinkContent()
        
        //        content.contentURL = URL(string: "http://itunes.apple.com/in/app/hanuman-chalisha-free/id327904895?mt=8")!
        content.contentURL = URL(string: "https://newsroom.fb.com/")!
        //        content.contentTitle = "HanumanChalisa"
        //        content.contentDescription = "Enjoy the devotional hymns of Hanuman Chalisa on your iPhone and worship Lord Hanuman to fulfil your life."
        //        content.imageURL = URL(string: "http://www.etechmavens.com/hanumachalisa/lord-hanuman.jpg")
        
        btnFBSDKShareButton.shareContent = content
        
        btnFBSDKShareButton.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        self.view.addSubview(btnFBSDKShareButton)
        
        
        shareDialog.shareContent = content
        shareDialog.delegate = self
        shareDialog.fromViewController = self
        
        shareDialog.mode = .web
        if(shareDialog.show() == false)
        {
            shareDialog.show()
        }
        self.hideProgress()
        
    }
    
    func sharePostOnKakaoTalk()
    {
        let url = "http://k.kakaocdn.net/dn/jTUdq/btqgeR1hshG/tXkLY8RuDwFN8ziujgupB0/kakaolink40_original.png"
        let template = KMTFeedTemplate {(feedTemplateBuilder) in
            
            feedTemplateBuilder.content = KMTContentObject (builderBlock: {(contentBuilder) in
                contentBuilder.title = Util.applicationName
                contentBuilder.desc = "ALT_SHARE_IF_APP_NOT_INSTALL".localizedLanguage()
                contentBuilder.imageURL = URL (string: "http://k.kakaocdn.net/dn/jTUdq/btqgeR1hshG/tXkLY8RuDwFN8ziujgupB0/kakaolink40_original.png" )!
                contentBuilder.link = KMTLinkObject (builderBlock: {(linkBuilder) in
                    //                    linkBuilder.mobileWebURL = URL (string: "https://apps.apple.com/us/app/kakaotalk/id362057947")!
                })
            })
            
            feedTemplateBuilder.addButton ( KMTButtonObject (builderBlock: {(buttonBuilder) in
                buttonBuilder.title = "BTN_TITLE_SHOW_SHARE_POST".localizedLanguage()
                buttonBuilder.link = KMTLinkObject (builderBlock: {(linkBuilder) in
                    //                    linkBuilder.webURL = URL (string: "https://apps.apple.com/us/app/kakaotalk/id362057947")!
                    //                    linkBuilder.mobileWebURL = URL (string: "https://apps.apple.com/us/app/kakaotalk/id362057947")!
                })
            }))
            
            //            feedTemplateBuilder.addButton ( KMTButtonObject (builderBlock: {(buttonBuilder) in
            //                buttonBuilder.title = "Run the app"
            //                buttonBuilder.link = KMTLinkObject (builderBlock: {(linkBuilder) in
            //                    linkBuilder.iosExecutionParams = "https://itunes.apple.com/in/app/your-appName/id123456?mt=8"
            //                    linkBuilder.androidExecutionParams = url
            //                })
            //            }))
        }
        
        KLKTalkLinkCenter.shared().sendDefault (with: template, success: {(warningMsg, argumentMsg) in
            print ( "warning message: \(String (describing: warningMsg))" )
            print ( "argument message: \(String (describing: argumentMsg))" )
        }, failure: {(error) in
            AlertPresenter.alertInformation(fromVC: self, message: "INTERNAL_SERVER_ERROR")
            //            AlertPresenter.alertInformation(fromVC: self, message: "\(error.localizedDescription)")
        })
    }
    
    //MARK:- Kakao Login
    func loginOnKakaoTalk()
    {
        let session: KOSession = KOSession.shared()!
        if session.isOpen() {
            session.logoutAndClose { (isLogout, error) in
            }
            session.close()
        }
        if session.isOpen() {
            session.logoutAndClose { (isLogout, error) in
            }
            session.close()
        }
        session.presentingViewController = self
        //self.showProgress()
        session.open(completionHandler: { (error) -> Void in
            // self.hideProgress()
            if error != nil{
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_KAKAO_PERMISION_DENY")
            }else if session.isOpen() == true{
                KOSessionTask.userMeTask { [weak self] (error, me) in
                    if let error = error as NSError? {
                        AlertPresenter.alertInformation(fromVC: self!, message: "ALERT_KAKAO_PERMISION_DENY")
                    } else if let me = me as KOUserMe? {
                        //                        print(me.id)
                        //                        print(me.nickname)
                        //
                        //
                        //                        let account = me.account
                        //
                        //                        print(account?.description)
                        //                        print(account?.legalName as Any)
                        
                        //                        var objEmail = String()
                        //
                        //                        if let kakaoAccData = me as? [String:Any] {
                        //
                        //                            if let kakaoDic = kakaoAccData["kakao_account"] as? [String:Any] {
                        //                                if let email = kakaoAccData["email"] as? String {
                        //                                    objEmail = email
                        //                                }
                        //                            }
                        //                        }
                        
                        print("Result : \(me)")
                        
                        let objUserProfileModel = UserProfileModel()
                        objUserProfileModel.strUserId = me.id
                        objUserProfileModel.strUserName = ""
                        objUserProfileModel.strUserNikName = me.nickname!
                        objUserProfileModel.strEmail = ""
                        if me.account?.email! != "" {
                            objUserProfileModel.strEmail = me.account?.email!
                        }
                        objUserProfileModel.strLoginType = Constant.ResponseParam.LOGIN_TYPE_KAKAO
                        self!.objUserProfileDetail = objUserProfileModel
                        self!.getVerifySocialAPI(objUser: objUserProfileModel)
                        //                        self!.getSocialAPI(objUser: objUserProfileModel)
                    }
                    
                }
                
            }else{
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_KAKAO_PERMISION_DENY")
            }
        })
    }
    
    //MARK:- Auth Login
    func getLoginWithEmailAPI() {
        
        if(Util.isNetworkReachable()) {
            self.showProgress()
            
            let objUserProfileModel = UserProfileModel()
            objUserProfileModel.strEmail = txtFEmail.text
            objUserProfileModel.strPwd = txtFPassword.text
            
            if(imgUserAutologin.image == UIImage(named: Constant.Image.check_box_empt))
            {
                objUserProfileModel.isAutoLogin = false
            }else
            {
                objUserProfileModel.isAutoLogin = true
            }
            
            //            if(Util.getIsUserAutoLogin() == "0")
            //            {
            //                objUserProfileModel.isAutoLogin = false
            //            }else
            //            {
            //                objUserProfileModel.isAutoLogin = true
            //            }
            objUserProfileModel.strLoginType = Constant.ResponseParam.LOGIN_TYPE_AUTH
            
            objLoginViewModel.loginWithEmailAPI(objUser: objUserProfileModel)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func getVerifySocialAPI(objUser:UserProfileModel) {
        
        if(Util.isNetworkReachable()) {
            self.showProgress()
            
            objLoginViewModel.verifySocialLoginAPI(objUser: objUser)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func getSocialAPI(objUser : UserProfileModel) {
        
        if(Util.isNetworkReachable()) {
            self.showProgress()
            
            objLoginViewModel.socialLoginAPI(objUser: objUser)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func getDeviceRegisterApi() {
        if (Util.isNetworkReachable()) {
            self.showProgress()
            objLoginViewModel.getDeviceRegisterAPI()
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func loginSuccessWithAuth() {
        getDeviceRegisterApi()
        Util.setIsUserLogin(strValue: "1")
        if(imgUserAutologin.image == UIImage(named: Constant.Image.check_box_empt))
        {
            Util.setIsUserAutoLogin(strValue: "0")
        }else
        {
            Util.setIsUserAutoLogin(strValue: "1")
        }
        Util.setIsUserLoginType(strValue: Constant.ResponseParam.LOGIN_TYPE_AUTH)
//        self.navigationController?.popViewController(animated: true)
        let objMainVC = MainVC()
        navigationController?.pushViewController(objMainVC, animated: true)
    }
    
    func loginSuccessWithSocialAccount(isVerified : Bool, isMobValid : Bool) {
//        getDeviceRegisterApi()
        
        if isVerified  == false {
            
//            if self.objUserProfileDetail.strLoginType == Constant.ResponseParam.LOGIN_TYPE_APPLE {
//                getSocialAPI(objUser: objUserProfileDetail)
//            }
//            else {
                let objSignUp = SignUpVC()
                
                if(imgUserAutologin.image == UIImage(named: Constant.Image.check_box_empt))
                {
                    objSignUp.isAutologin = false
                }else
                {
                    objSignUp.isAutologin = true
                }
                objSignUp.isSocialMediaLogin = true
                objSignUp.objUserSocialLoginDetails = self.objUserProfileDetail
                self.navigationController?.pushViewController(objSignUp, animated: true)
//            }
            
        }else {
            
            if isMobValid == false {
                let objSignUp = SignUpVC()
                
                if(imgUserAutologin.image == UIImage(named: Constant.Image.check_box_empt))
                {
                    objSignUp.isAutologin = false
                }else
                {
                    objSignUp.isAutologin = true
                }
                objSignUp.isSocialMediaLogin = true
                objSignUp.objUserSocialLoginDetails = objLoginViewModel.objUserSocialLoginDetails
                self.navigationController?.pushViewController(objSignUp, animated: true)
            }else {
                Util.setIsUserLogin(strValue: "1")
                // Util.setIsUserAutoLogin(strValue: "0")
                if(imgUserAutologin.image == UIImage(named: Constant.Image.check_box_empt))
                {
                    Util.setIsUserAutoLogin(strValue: "0")
                }else
                {
                    Util.setIsUserAutoLogin(strValue: "1")
                }
                self.navigationController?.popViewController(animated: true)
                getDeviceRegisterApi()
                //        Util.setIsUserLoginType(strValue: Constant.ResponseParam.LOGIN_TYPE_AUTH)
                //        self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func onApiSuccessHideProgress() {
        self.hideProgress()
    }
    
    func onDeviceRegisterSuccessApi() {
        
    }
    
    func SignUpSuccessWithSocialAccount(isMobValid : Bool) {
        
        if isMobValid == false {
            let objSignUpVC = SignUpVC()
            if(imgUserAutologin.image == UIImage(named: Constant.Image.check_box_empt))
            {
                objSignUpVC.isAutologin = false
            }else
            {
                objSignUpVC.isAutologin = true
            }
            objSignUpVC.isSocialMediaLogin = true
            objSignUpVC.objUserSocialLoginDetails = objLoginViewModel.objUserSocialLoginDetails
            self.navigationController?.pushViewController(objSignUpVC, animated: true)
            
        }else {
            Util.setIsUserLogin(strValue: "1")
            getDeviceRegisterApi()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showMessage(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    //MARK: Button click events
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        
        if validationTxtField() {
            getLoginWithEmailAPI()
        }
    }
    
    //MARK: Button Tabbed
    
    @objc func lblForgotPwdTabbed(sender:CustomTabGestur)
    {
        print("Forgot Password Tabbed!!!")
        let objForgotPasswordVC = ForgotPasswordVC()
        navigationController?.pushViewController(objForgotPasswordVC, animated: true)
    }
    
    @objc func viewContAutoLoginTabbed(sender:CustomTabGestur)
    {
        if(imgUserAutologin.image == UIImage(named: Constant.Image.check_box_empt))
        {
            imgUserAutologin.setImageFit(imageName: Constant.Image.check_box_check)
        }else
        {
            imgUserAutologin.setImageFit(imageName: Constant.Image.check_box_empt)
        }
    }
    
    @objc func viewContAppleTabbed(sender:CustomTabGestur)
    {
        if #available(iOS 13.0, *) {
            loginWithAppleAC()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func viewContGoogleTabbed(sender:CustomTabGestur)
    {
        
        loginWithGoogleAC()
    }
    
    @objc func viewContFaceBookTabbed(sender:CustomTabGestur)
    {
        DispatchQueue.main.async {
            self.customFacebookLoginButton()
        }
    }
    
    @objc func viewContKakaoTabbed(sender:CustomTabGestur)
    {
        /* AlertPresenter.alertInformation(fromVC: self, message: "ALERT_LOGIN_SUCCESS") {
         Util.setIsUserLogin(strValue: "1")
         self.navigationController?.popViewController(animated: true)
         }
         */
        loginOnKakaoTalk()
        //        sharePostOnKakaoTalk()
    }
    
    
    
    @objc func lblTitleNaverTabbed(sender:CustomTabGestur)
    {
        NaverThirdPartyLoginConnection.getSharedInstance()?.resetToken()
        //        print("Naver old Accesstocken : \(NaverThirdPartyLoginConnection.getSharedInstance()?.accessToken)" )
        NaverThirdPartyLoginConnection.getSharedInstance()?.delegate = self
        NaverThirdPartyLoginConnection.getSharedInstance()?.requestThirdPartyLogin()
        
    }
    
    @objc override func leftBarButtonClick() {
        self.navigationController?.popViewController(animated: true)
        //        WriteCommentViewPresenter.writeCommentPopup(fromVC: self, title: "wright", placeHolder: "please wright", positiveBlock: { (isClicked, strMsg) in
        //            print("ok")
        //        }) {
        //            print("cancel")
        //        }
    }
    
    @objc override func leftBarButtonClick2() {
        //  self.navigationController?.popViewController(animated: false)
        let mainVC = MainVC()
        let navMainVC  : UINavigationController = UINavigationController(rootViewController: mainVC)
        navMainVC.navigationController?.isNavigationBarHidden = true
        navMainVC.isNavigationBarHidden = true
        self.slideMenuController()?.changeMainViewController(navMainVC, close: true)
    }
    
}

//MARK:- Gmail Login
extension LoginVC : GIDSignInDelegate
{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_GOOGLE_LOGIN_ERROR")
                print("The user has not signed in before or they have since signed out.")
            } else {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_GOOGLE_LOGIN_ERROR")
                print("ERROR : \(error.localizedDescription)")
            }
            return
        }
        //        print("email : \(user?.profile.email)")
        //        print("name : \(user?.profile.name)")
        //        print("givenName : \(user?.profile.givenName)")
        //        print("familyName : \(user?.profile.familyName)")
        //        print("userID : \(user?.userID)")
        
        print("Result : \(user)")
        let objUserProfileModel = UserProfileModel()
        objUserProfileModel.strUserId = user?.userID
        objUserProfileModel.strUserName = user?.profile.name
        objUserProfileModel.strUserNikName = user?.profile.givenName
        objUserProfileModel.strEmail = user?.profile.email
        objUserProfileModel.strLoginType = Constant.ResponseParam.LOGIN_TYPE_GMAIL
        //        self.getSocialAPI(objUser: objUserProfileModel)
        self.objUserProfileDetail = objUserProfileModel
        self.getVerifySocialAPI(objUser: objUserProfileModel)
        
        
        //        Util.setIsUserLogin(strValue: "1")
        //        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        AlertPresenter.alertInformation(fromVC: self, message: "ALERT_GOOGLE_LOGIN_ERROR")
        print("google cancel event clicked")
        //   getHomeDataApi(strGmail:"")
    }
}


extension LoginVC: SharingDelegate
{
    
    // FBSDKSharingDelegate delegate
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        AlertPresenter.alertInformation(fromVC: self, message: "Post_share_successfully")
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        AlertPresenter.alertInformation(fromVC: self, message: "Post_not_share_successfully")
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        AlertPresenter.alertInformation(fromVC: self, message: "Post_not_share_successfully")
    }
    
    //    func sharer(_ sharer: Sharing, didFailWithError error: Error!) {
    //        print("sharer NSError")
    //        print(error)
    //    }
    
    //    func sharer(_ sharer: Sharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
    //      AlertPresenter.alertInformation(fromVC: self, message: "Post_share_successfully")
    //
    //
    //    }
    
    //    func sharerDidCancel(_ sharer: Sharing!) {
    //        AlertPresenter.alertInformation(fromVC: self, message: "Post_not_share_successfully")
    //    }
    // end FBSDKSharingDelegate
    
    func setAletr(title: String, message: String)
    {
        AlertPresenter.alertInformation(fromVC: self, message: message)
        //        let alert1 = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("Ok", comment: "Ok"))
        //        alert1.show()
    }
}

//MARK:- Naver Login
extension LoginVC : NaverThirdPartyLoginConnectionDelegate
{
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        printDebug("oauth20ConnectionDidFinishRequestACTokenWithAuthCode")
        //etech //AAAASxDh1iNkxH7teSx/okfsDL5U7c0ul/iHBbfyuU7MfrfcavhpYnYvXGdxQwpkoGQASNxQuQGCq6sEWFHMdZPPNWf4obY/fn8gVe4j+7vUv7sy
        //alpesh //AAAAQe0QctQRoI35hlwiRCcGQorUCyEqleUOHmk6l6nJh5XMsFQW_3yT006hghw-SWKZQy2aVb_xLentSF6nH6PsKnKNvoWeB5svD4XGSYcjeNjZ
        print("success : \(NaverThirdPartyLoginConnection.getSharedInstance()?.accessToken)")
        //        NaverThirdPartyLoginConnection.getSharedInstance()?.isValidAccessTokenExpireTimeNow()
        //        NaverThirdPartyLoginConnection.getSharedInstance()?.requestDeleteToken()
        
        let urlString = "https://apis.naver.com/nidlogin/nid/getUserProfile.xml" // User profile call API URL
        //        var urlRequest: NSMutableURLRequest? = nil
        //        if let url = URL(string: urlString) {
        //            urlRequest = NSMutableURLRequest(url: url)
        //        }
        var authValue: String? = nil
        if let accessToken = NaverThirdPartyLoginConnection.getSharedInstance()?.accessToken {
            authValue = "Bearer \(accessToken)"
        }
        
        let headers = [ "Content-Type": "application/json" ]
        
        var url : String = urlString
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.setValue(authValue, forHTTPHeaderField: "Authorization")
        request.url = NSURL(string: url) as URL?
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringCacheData
        request.allHTTPHeaderFields = headers
        
        self.showProgress()
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler: { (response:URLResponse!, data: Data!, error: Error!) -> Void in
            self.hideProgress()
            // var error: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
            //  let jsonResult: NSDictionary! = JSONSerialization.JSONObjectWithData(data, options:JSONSerialization.ReadingOptions.MutableContainers, error: error) as? NSDictionary
            if(error == nil)
            {
                var strId = ""
                var strName = ""
                var strNickName = ""
                var strGender = ""
                var strAgeRange = ""
                var strEmail = ""
                
                let xml = try! XML.parse(String(data: data!, encoding: .utf8) ?? "")
                if let data = xml["data"]["response"]["id"].text
                {
                    strId = data
                }
                if let data = xml["data"]["response"]["name"].text
                {
                    strName = data
                }
                if let data = xml["data"]["response"]["nickname"].text
                {
                    strNickName = data
                }
                if let data = xml["data"]["response"]["age"].text
                {
                    strAgeRange = data
                }
                if let data = xml["data"]["response"]["email"].text
                {
                    strEmail = data
                }
                if let data = xml["data"]["response"]["gender"].text
                {
                    strGender = data
                }
                
                if(strId == "")
                {
                    AlertPresenter.alertInformation(fromVC: self, message: "ALERT_NAVER_PERMISION_DENY")
                }else
                {
                    let objUserProfileModel = UserProfileModel()
                    objUserProfileModel.strUserId = strId
                    objUserProfileModel.strUserName = strName
                    objUserProfileModel.strUserNikName = strNickName
                    objUserProfileModel.strEmail = strEmail
                    objUserProfileModel.strLoginType = Constant.ResponseParam.LOGIN_TYPE_NAVER
                    //                    self.getSocialAPI(objUser: objUserProfileModel)
                    self.objUserProfileDetail = objUserProfileModel
                    self.getVerifySocialAPI(objUser: objUserProfileModel)
                }
            }else
            {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_NAVER_PERMISION_DENY")
            }
        })
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        printDebug("oauth20ConnectionDidFinishRequestACTokenWithRefreshToken")
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        printDebug("oauth20ConnectionDidFinishDeleteToken")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        printDebug("oauth20Connection didFailWithError")
        AlertPresenter.alertInformation(fromVC: self, message: "ALERT_NAVER_PERMISION_DENY")
    }
    
}

//MARK:- Apple Login
@available(iOS 13.0, *)
extension LoginVC : ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            let objUserProfileModel = UserProfileModel()
            objUserProfileModel.strUserId = userIdentifier
            objUserProfileModel.strEmail = ""
            objUserProfileModel.strUserName = ""
            objUserProfileModel.strUserNikName = ""
            objUserProfileModel.strMobile = "00000000000"
            
            if email != nil {
                objUserProfileModel.strEmail = email
            }
            
            if fullName?.givenName != nil && fullName?.familyName != nil {
                objUserProfileModel.strUserName = "\(fullName!.givenName!) \(fullName!.familyName!)"
                objUserProfileModel.strUserNikName = fullName!.givenName!
            }
            
            objUserProfileModel.strLoginType = Constant.ResponseParam.LOGIN_TYPE_APPLE
            
            self.objUserProfileDetail = objUserProfileModel
//            getSocialAPI(objUser: objUserProfileDetail)
            self.getVerifySocialAPI(objUser: objUserProfileModel)
            
//            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName!)) \n Email id is \(String(describing: email!))")
        }
        else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            //Navigate to other view controller
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

@available(iOS 13.0, *)
extension LoginVC : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

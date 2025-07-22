//
//  LoginVC.swift
//  RankingStar
//
//  Created by Jinesh on 13/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit
import Material

class SideMenuVC: BaseVC {
    
    
    // var objChargingStarHistoryModel : ChargingStarHistoryModel!
    
    @IBOutlet var viewHeaderBG: UIView!
    @IBOutlet var imgAppIcon: UIImageView!
    //@IBOutlet var imgUserProfile: UIImageView!
    @IBOutlet var viewUserLogin: UIView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet weak var imgSocialMediaIcon: UIImageView!
    @IBOutlet var lblUserEmail: UILabel!
    @IBOutlet var btnEditProfile: UIButton!
    @IBOutlet var btnLogOut: UIButton!
    @IBOutlet var viewUserLogout: UIView!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var btnBotton: UIButton!
    @IBOutlet var viewContTotalCoin: UIView!
    @IBOutlet var imgSideMenuStar: UIImageView!
    @IBOutlet var lblMyStar: UILabel!
    @IBOutlet var lblTotalCoin: UILabel!
    @IBOutlet var lblTitlePiece: UILabel!
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    @IBOutlet var btnClose: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
//    var objMainVC:MainVC!
    var arrSideMenuImages:[String]!
    var arrSideMenuNames:[String]!
    
//    var chargingHistoryVC : UIViewController!
//    var webViewWithTabVC : UIViewController!
//    var webViewVC : UIViewController!
//    var noticeVC : UIViewController!
//    var pushNotificationVC : UIViewController!
//    var appSettingVC : UIViewController!
//    var giftVC2 : UIViewController!
    
    var signUpVC:UIViewController!
    var loginVC : UIViewController!
    var editProfile : UIViewController!
    
    
    //    var currentNavigationController:UINavigationController!
    var isSocialMediaLogin = false
    
    //    var selectedVCCell:Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // objChargingStarHistoryModel = ChargingStarHistoryModel(vc: self)
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = .none
        tblView.register(UINib(nibName: Constant.CellIdentifier.SIDE_MENU_CELL, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier.SIDE_MENU_CELL)
        tblView.isScrollEnabled = false
        
        arrSideMenuImages = [Constant.Image.charge_station_black, Constant.Image.gift_black, Constant.Image.history,  Constant.Image.question,  Constant.Image.ic_note, Constant.Image.notification, Constant.Image.setting]
        arrSideMenuNames = ["TAB_FREE_CHARGEING","TAB_SEND_A_STAR", "TAB_CHARGING_HISTORY", "TAB_RANKING_STAR_GUIDE","TAB_NOTICE", "TAB_NOTIFICATION", "TAB_APP_SETTING"]
        tblViewHeightConst.constant = CGFloat(arrSideMenuNames.count * 53) //table view cell size
        
        //        mainVC = MainVC()
//        chargingHistoryVC = ChargingStarHistoryVC()
//        webViewWithTabVC = WebViewWithTabVC()
//        webViewVC = WebViewVC()
//        pushNotificationVC = PushNotificationListVC()
//        appSettingVC = SettingVC()
//        noticeVC = NoticeVC()
//        giftVC2 = GiftVC2()
        setUIColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Util.appDelegate.objRefreshUserDetailsDelegate = self
        
        Util.statusBarColor(color: UIColor.clear)
        if(Util.getIsUserLogin() == "0")
        {
            viewUserLogout.isHidden = false
            viewUserLogin.isHidden = true
        }else
        {
            let dictData1:[String: Any]? = Util.getUserProfileDict()
            if(dictData1 != nil)
            {
                let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
                let myStar : Int = Int(objUserProfile.strRemainingStar)!
                lblTotalCoin.text = myStar.stringWithSepator(amount: myStar)
                lblUserName.text = objUserProfile.strUserName
                lblUserEmail.text = objUserProfile.strEmail
            }else
            {
                lblTotalCoin.text = "0"
                lblUserName.text = ""
                lblUserEmail.text = ""
            }
            
            viewUserLogout.isHidden = true
            viewUserLogin.isHidden = false
        }
        getUserSocialMediaDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Util.appDelegate.objRefreshUserDetailsDelegate = nil
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        //dismissAlertInfoPresenter()
    }
    
    //MARK: custom method
    func setUIColor()
    {
        //        Util.statusBarColor(color: Constant.Color.NAVIGATION_BAR_BG_COLOR)
        
        //        viewHeaderBG.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        //        viewHeaderBG.setGradientBackground()
        viewHeaderBG.setRightToLeftPinkGradientViewUI(isClearColor: false, isColorPink: true)
        //        scrollView.backgroundColor = UIColor.white
        
        imgAppIcon.setImageFit(imageName: Constant.Image.logo_white_side_menu_kor)
        imgSideMenuStar.setImageFit(imageName: Constant.Image.history_star)
        
        //btnClose.setBackgroundImage(UIImage(named: Constant.Image.close_white), for: .normal)
        btnClose.setImage(UIImage(named: Constant.Image.close_white_thin_side_menu), for: .normal)
        btnClose.setImage(UIImage(named: Constant.Image.close_white_thin_side_menu), for: .highlighted)
        btnClose.tintColor = UIColor.white
        viewContTotalCoin.rundViewWithBorderColorSemiGray()
        lblMyStar.setLoginNormalUIStyle(value: "LBL_MY_STAR")
        lblTotalCoin.setLoginHeaderBigUIStylePink(value: "0")
        lblTitlePiece.setLoginNormalUIStyle(value: "LBL_VOTE_PIECE")
        
        //        imgUserProfile.backgroundColor = UIColor.white
        //        imgUserProfile.layer.cornerRadius = imgUserProfile.frame.size.height/2
        //        imgUserProfile.clipsToBounds = true
        
        //        viewUserLogin.isHidden = true
        //        if(Util.getIsUserLogin() == "0")
        //        {
        //            viewUserLogout.isHidden = false
        //            viewUserLogin.isHidden = true
        //        }else
        //        {
        //            viewUserLogout.isHidden = true
        //            viewUserLogin.isHidden = false
        //        }
        
        
        
        lblUserName.setHeaderUIStyleWhite(value: "UserName")
        lblUserEmail.setSmallUIStyleWhite(value: "user1@gmail.com")
        btnLogOut.setTitle(txtValue: "BTN_LOGOUT")
        btnLogOut.setBtnLoginUI()
        btnLogin.setTitle(txtValue: "BTN_LOGIN")
        btnLogin.setBtnLoginUI()
        btnSignUp.setTitle(txtValue: "BTN_SIGN_UP")
        btnSignUp.setBtnLoginUI()
        btnEditProfile.setTitle(txtValue: "BTN_EDIT_PROFILE")
        btnEditProfile.setBtnLoginUI()
        btnBotton.setTitle(txtValue: "BTN_BOTTOM")
        btnBotton.setBtnSemiBlackBorderAndTextUI()
        imgSocialMediaIcon.setImageFit(imageName: "")
        //        let viewContEarningTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContEarningTabbed))
        //        viewContEarning.isUserInteractionEnabled = true
        //        viewContEarning.addGestureRecognizer(viewContEarningTabbed)
        
    }
    
    func getUserSocialMediaDetail() {
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            
            if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_APPLE) {
                
                //apple
//                imgSocialMediaIcon.setImageFit(imageName: Constant.Image.apple)
                lblUserEmail.text = "LBL_CURRENT_APPLE_LOGIN".localizedLanguage()
                isSocialMediaLogin = true
                
            } else if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_GMAIL) {
                
                //gmail
                //                imgSocialMediaIcon.setImageFit(imageName: Constant.Image.google)
                lblUserEmail.text = "LBL_CURRENT_GOOGLE_LOGIN".localizedLanguage()
                isSocialMediaLogin = true
                
            }else if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_FACEBOOK) {
                
                //facebook
                //                imgSocialMediaIcon.setImageFit(imageName: Constant.Image.facebook)
                lblUserEmail.text = "LBL_CURRENT_FACEBOOK_LOGIN".localizedLanguage()
                isSocialMediaLogin = true
                
            }else if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_KAKAO) {
                
                // kakao
                //                imgSocialMediaIcon.setImageFit(imageName: Constant.Image.kakao)
                lblUserEmail.text = "LBL_CURRENT_KAKAO_LOGIN".localizedLanguage()
                isSocialMediaLogin = true
                
            }else if(objUserProfile.strLoginType == Constant.ResponseParam.LOGIN_TYPE_NAVER) {
                
                // naver
                //                imgSocialMediaIcon.setImageFit(imageName: Constant.Image.naver_green)
                lblUserEmail.text = "LBL_CURRENT_NAVER_LOGIN".localizedLanguage()
                isSocialMediaLogin = true
                
            }else {
                imgSocialMediaIcon.setImageFit(imageName: "")
                isSocialMediaLogin = false
            }
        }
    }
    
    func getChargingHistoryAPI() {
        if(Util.isNetworkReachable()) {
            self.showProgress()
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                self.hideProgress()
            }
            // let objChargingHistoryModel = ChargingHistoryModel()
            // objChargingStarHistoryModel.chargingHistoryAPI(objChargingHistoryModel : objChargingHistoryModel)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            //            refreshControl.endRefreshing()
        }
    }
    
    func changeNavigationBar(index : Int)
    {
        
        Util.objMainVC.pushViewControllerFromSideMenu(index: index)
//        var vc : UIViewController? = nil
//
//        if(index == 0) {
//            //  (self.webViewWithTabVC as! WebViewWithTabVC).strNavBarTitle = "NAV_TITLE_STAR_CHARING_STATION"
//            // vc = self.webViewWithTabVC
//            objMainVC.pushViewControllerFromSideMenu(index: index)
//        }
//        else if(index == 1) {
//            self.toggleLeft()
//            let objGiftVC2 = GiftVC2()
//            objGiftVC2.modalTransitionStyle = .crossDissolve
//            objGiftVC2.modalPresentationStyle = .overCurrentContext
//            objGiftVC2.myNavigationController = Util.currentNavigationController
//            Util.currentNavigationController.present(objGiftVC2, animated: true, completion: nil)
//        }else if(index == 2) {
//            //            vc = self.chargingHistoryVC
//
//        }else if(index == 3) {
//            //            vc = self.webViewVC
//        }else if(index == 4) {
//            //            vc =  self.noticeVC
//        }else if(index == 5) {
//            //            vc = self.pushNotificationVC
//        }else if(index == 6) {
//            //            vc = self.appSettingVC
//        }
//
//        if(vc != nil)
//        {
//            let navMainVC  : UINavigationController = UINavigationController(rootViewController: vc!)
//            navMainVC.navigationController?.isNavigationBarHidden = true
//            navMainVC.isNavigationBarHidden = true
//            Util.currentNavigationController = navMainVC
//            self.slideMenuController()?.changeMainViewController(navMainVC, close: true)
//
//            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
//                //                if(index == 0) {
//                ////                    (vc as! MainVC).updateAPIFromSideMenu()
//                //                }
//                if(index == 0) {
//                    //                    (vc as! WebViewWithTabVC).updateAPIFromSideMenu()
//                }
//                else if(index == 1) {
//                }else if(index == 2) {
//                    (vc as! ChargingStarHistoryVC).updateAPIFromSideMenu()
//                }else if(index == 3) {
//                    (vc as! WebViewVC).updateAPIFromSideMenu()
//                }else if(index == 4) {
//                    (vc as! NoticeVC).updateAPIFromSideMenu()
//                }else if(index == 5) {
//                    (vc as! PushNotificationListVC).updateAPIFromSideMenu()
//                }else if(index == 6) {
//                    (vc as! SettingVC).updateAPIFromSideMenu()
//                }
//            }
//        }
    }
    
    //MARK:- Button Clicked
    @IBAction func btnEditProfileClicked(_ sender: UIButton) {
        self.toggleLeft()
        let objEditUserProfileVC = EditUserProfileVC()
        objEditUserProfileVC.isSocialMediaLogin = self.isSocialMediaLogin
        Util.currentNavigationController.pushViewController(objEditUserProfileVC, animated: true)
    }
    
    @IBAction func btnLogOutClicked(_ sender: UIButton) {
        self.toggleLeft()
        AlertPresenter.alertWithYesNoLogOut(fromVC: Util.currentNavigationController.topViewController!, message: "ALERT_LOGOUT", positiveBlock: {
            Util.removeAllDataOnLogout()
            self.viewUserLogout.isHidden = false
            self.viewUserLogin.isHidden = true
            
            let objMainVc = MainVC()
            Util.objMainVC = objMainVc
            let navMainVC  : UINavigationController = UINavigationController(rootViewController: objMainVc)
            navMainVC.navigationController?.isNavigationBarHidden = true
            navMainVC.isNavigationBarHidden = true
            Util.currentNavigationController = navMainVC
            Util.slideMenuController.changeMainViewController(navMainVC, close: true)
            
        }) {}
    }
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        self.toggleLeft()
        let objLoginVC = LoginVC()
        Util.currentNavigationController.pushViewController(objLoginVC, animated: true)
    }
    
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        self.toggleLeft()
        
    }
    
    @IBAction func btnSignUpClicked(_ sender: UIButton) {
        self.toggleLeft()
        let objSignUpVC = SignUpVC()
        
        Util.currentNavigationController.pushViewController(objSignUpVC, animated: true)
        //        Util.sideMenuNavVC.pushViewController(objSignUpVC, animated: true)
    }
    
    @IBAction func btnBottonClicked(_ sender: UIButton) {
        self.toggleLeft()
        let objTearmAndConditionVC = TearmAndConditionVC()
        objTearmAndConditionVC.strNavBarTitle = "NAVIGATION_BAR_TEARM_CONDITION".localizedLanguage()
        Util.currentNavigationController.pushViewController(objTearmAndConditionVC, animated: true)
    }
    
    //MARK:- View model methods
    func onLeadDashboardCompleted() {
        
    }
    
    
    func onApiSuccessHideProgress() {
        self.hideProgress()
    }
    
    func showMessage(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print(textField.text)
    }
    
}

extension SideMenuVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSideMenuNames.count
        //        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.SIDE_MENU_CELL) as! SideMenuCell
        
        cell.selectionStyle = .none
        cell.lblName.setLoginNormalUIStyleFullBack(value: arrSideMenuNames[indexPath.row])
        //cell.lblCounter.setLoginNormalUIStyleNavColorForCell(value: "\(indexPath.row)A")
        cell.imgNext.setImageFit(imageName: Constant.Image.next)
        cell.imgTabIcon.setImageFit(imageName: arrSideMenuImages[indexPath.row])
        //cell.viewSeprator.backgroundColor = Constant.Color.VIEW_BORDER_COLOR
        cell.viewSeprator.layer.borderWidth = 0.3
        cell.viewSeprator.borderColor =  Constant.Color.VIEW_BORDER_SEME_LIGHT_COLOR
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let index = indexPath.row
//        if(index == 0 || index == 1 || index == 2 || index == 5 || index == 6)
//        {
//            if(Util.getIsUserLogin() == "0")
//            {
//                self.toggleLeft()
//                AlertPresenter.alertInformation(fromVC: Util.currentNavigationController.topViewController!, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
//            }else
//            {
//                changeNavigationBar(index : index)
//            }
//
//        }else
//        {
//            changeNavigationBar(index : index)
//        }
        
        changeNavigationBar(index : indexPath.row)
    }
}

extension SideMenuVC : RefreshUserDetailsDelegate {
    func getUserStar() {
       let dictData1:[String: Any]? = Util.getUserProfileDict()
       if(dictData1 != nil) {
           let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
           let myStar : Int = Int(objUserProfile.strRemainingStar)!
           lblTotalCoin.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
        
       }
    }
}


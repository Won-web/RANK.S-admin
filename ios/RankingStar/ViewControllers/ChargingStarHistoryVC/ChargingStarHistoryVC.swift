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
import Parchment

class ChargingStarHistoryVC: BaseVC {
    
    var objChargingStarHistoryModel : ChargingStarHistoryViewModel!
    
    @IBOutlet var navBar: UINavigationBar!
    
    @IBOutlet var lblTitleTotal: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var imgVRatingStar: UIImageView!
    @IBOutlet var viewContTotalQuantity: UIView!
    @IBOutlet weak var lblPiece: UILabel!
    @IBOutlet var viewTabbarButtomSepretor: UIView!
    
    var searchedText : String = ""
    @IBOutlet  var txtSearch: UITextField!
    @IBOutlet var viewContSearch: UIView!
    @IBOutlet var btnSearchClose: UIButton!
    
    var isBackButonShow = false
    
    @IBOutlet var viewContainerOfPageVC: UIView!
    var navControllerArray:[UINavigationController] = []
    var objChargingStarHistoryDetailVC : ChargingStarHistoryDetailVC!
    var objChargingStarHistoryDetailVC1 : ChargingStarHistoryDetailVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        
        self.view.setRightToLeftPinkGradientViewUI()
        objChargingStarHistoryModel = ChargingStarHistoryViewModel(vc: self)
        
//        txtSearch.delegate = self
        
        setUIColor()
        setSubTabbarPageController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Util.appDelegate.objRefreshUserDetailsDelegate = self
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
    }

    override func viewWillDisappear(_ animated: Bool) {
        Util.appDelegate.objRefreshUserDetailsDelegate = nil
        dismissAlertInfoPresenter()
    }
    
    //MARK: custom method
    func setUIColor()
    {
//        Util.statusBarColor(color: Constant.Color.NAVIGATION_BAR_BG_COLOR)
        navBar.setUI(navBarText: "NAVIGATION_BAR_STAR_HISTORY")
        
        if(isBackButonShow)
        {
            self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        }else
        {
            self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
//            self.leftBarButton(navBar: navBar, imgName: Constant.Image.menu)
        }
        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station_black)
        
        txtSearch.setSearchUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_SEARCH_TITLE")
        btnSearchClose.setBackgroundImage(UIImage(named: Constant.Image.close), for: .normal)
        viewContSearch.rectViewWithBorderColor()
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        viewContSearch.isHidden = true
        
        imgVRatingStar.setImageFit(imageName: Constant.Image.history_star)
        lblTitleTotal.setLoginNormalUIStyleFullBack(value: "LBL_TOTAL_STAR_QUANTITY")
        lblPiece.setLoginNormalUIStyleFullBack(value: "LBL_VOTE_PIECE")
        viewContTotalQuantity.backgroundColor = Constant.Color.VIEW_BG_TOTAL_QUANTITY_COLOR
        viewTabbarButtomSepretor.backgroundColor = Constant.Color.VIEW_SEPRETOR_COLOR
    }
    
    func getStarHistoryListApi() {
        isNetworkAvailable { (isSuccess) in
            if Util.isNetworkReachable() {
                self.showProgress()
                self.objChargingStarHistoryModel.getStarHistoryAPI()
            }else {
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
    }
    
//    @objc func refreshView(_ sender: UIRefreshControl) {
//        getStarHistoryListApi()
//    }
    
    func setSubTabbarPageController() {
        //self.navigationController?.isNavigationBarHidden = false
        setUpControlerForPagginationView()
        let when = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when) {
            let pagingViewController = FixedPagingViewController(viewControllers: self.navControllerArray)
            //pagingViewController.setFixedPageVCUI()
            pagingViewController.setFixedPageVCUI(txtColor: Constant.Color.LBL_LOGIN_DARK_BLACK_COLOR, selectedTxtColor: Constant.Color.LBL_WHITE, tabBarColor: Constant.Color.VIEW_BG_TAB_BAR_COLOR, indicatorColor: UIColor.white)
           // self.viewContainerOfPageVC.addSubview(pagingViewController.view)
            self.view.addSubview(pagingViewController.view)
            pagingViewController.view.frame = self.viewContainerOfPageVC.bounds
            self.viewContainerOfPageVC.addSubview(pagingViewController.view)
            self.viewContainerOfPageVC.autoresizingMask = [.flexibleWidth , .flexibleHeight]
            
            self.addChild(pagingViewController)
            
            pagingViewController.didMove(toParent: self)
            pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                pagingViewController.view.leadingAnchor.constraint(equalTo: self.viewContainerOfPageVC.leadingAnchor),
                pagingViewController.view.trailingAnchor.constraint(equalTo: self.viewContainerOfPageVC .trailingAnchor),
                pagingViewController.view.bottomAnchor.constraint(equalTo: self.viewContainerOfPageVC.bottomAnchor),
                pagingViewController.view.topAnchor.constraint(equalTo: self.viewContainerOfPageVC.topAnchor)
            ])
        }
        getStarHistoryListApi()
    }
    
    func setUpControlerForPagginationView() {
        objChargingStarHistoryDetailVC = ChargingStarHistoryDetailVC()
        objChargingStarHistoryDetailVC.objStarHistory = objChargingStarHistoryModel.objChargingHistoryModel
        objChargingStarHistoryDetailVC.title = "LBL_TOTAL_CHARGING_HISTORY".localizedLanguage()
        objChargingStarHistoryDetailVC.isEarning = true
        objChargingStarHistoryDetailVC.delegate = self
        addNavigationcontrollerInVC(viewControllers: objChargingStarHistoryDetailVC)

        objChargingStarHistoryDetailVC1 = ChargingStarHistoryDetailVC()
        objChargingStarHistoryDetailVC1.objStarHistory = objChargingStarHistoryModel.objChargingHistoryModel
        objChargingStarHistoryDetailVC1.title = "LBL_TOTAL_USING_HOSTORY".localizedLanguage()
        objChargingStarHistoryDetailVC1.isEarning = false
        objChargingStarHistoryDetailVC1.delegate = self
        addNavigationcontrollerInVC(viewControllers: objChargingStarHistoryDetailVC1)
    }
    
    func addNavigationcontrollerInVC(viewControllers: UIViewController) {
        let navVC = UINavigationController(rootViewController: viewControllers)
        navVC.isNavigationBarHidden = true
        navControllerArray.append(navVC)
    }
    
    func updateAPIFromSideMenu() {
        getStarHistoryListApi()
    }
    
    //MARK:- Button clicked
    
    @IBAction func btnSearchClicked(_ sender: UIButton) {
        viewContSearch.isHidden = true
    }
    
   //MARK:- View model methods
    
    func onApiSuccessHideProgress() {
        self.hideProgress()
        refreshControl.endRefreshing()
    }
    
    func onApiResponseSuccess() {
        
        let myStar = Int(objChargingStarHistoryModel.objChargingHistoryModel.remaningStar)!
        lblTotal.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
        
        objChargingStarHistoryDetailVC.getData(objStarHistory: objChargingStarHistoryModel.objChargingHistoryModel)
        objChargingStarHistoryDetailVC1.getData(objStarHistory: objChargingStarHistoryModel.objChargingHistoryModel)
        
    }
    
    func showMessage(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    @objc override func leftBarButtonClick() {
        if(isBackButonShow)
        {
            self.navigationController?.popViewController(animated: true)
        }else
        {
            let objMainVC = MainVC()
            Util.objMainVC = objMainVC
            let navPushVC  : UINavigationController = UINavigationController(rootViewController: objMainVC)
            navPushVC.navigationController?.isNavigationBarHidden = true
            navPushVC.isNavigationBarHidden = true
            Util.currentNavigationController = navPushVC
            Util.slideMenuController.changeMainViewController(navPushVC, close: true)
//            self.toggleLeft()
        }
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
//
//    @objc override func rightBtnClickedWithImg2() {
//        print("rightBtnClickedWithImg2")
//        viewContSearch.isHidden = false
//    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print(textField.text)
    }
    
}

extension ChargingStarHistoryVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField == txtSearch) {
            self.searchedText = txtSearch.text!
            
            if searchedText.isEmpty {
//                objChargingStarHistoryModel.arrChargingHistoryModel = []
//                self.tblView.reloadData()
                
            }else {
//                getChargingHistoryAPI()
               // print(txtSearch.text)
                // nothing
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtSearch) {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension ChargingStarHistoryVC : getApiOnRefresh {
    func getApi() {
        getStarHistoryListApi()
    }
}

extension ChargingStarHistoryVC : RefreshUserDetailsDelegate {
    func getUserStar() {
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            
            let myStar : Int = Int(objUserProfile.strRemainingStar)!
            lblTotal.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
       }
    }
}

extension ChargingStarHistoryVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        // print("SlideMenuControllerDelegate: leftWillOpen")
    }
}


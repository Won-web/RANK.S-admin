//
//  AboutUsVC.swift
//  Jibudo
//
//  Created by kETAN on 13/06/18.
//  Copyright © 2018 kETAN. All rights reserved.
//

import UIKit
import Material
import WebKit
import SlideMenuControllerSwift
import Parchment

protocol RefreshUserDetailsDelegate {
    func getUserStar()
}

class WebViewWithTabVC: BaseVC {
    
    var objChargingStationViewModel : ChargingStationViewModel!
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet weak var scrollview: UIScrollView!
    
    var strNavBarTitle:String! = "NAV_TITLE_STAR_CHARING_STATION"
    var isBackButtonShow = false
    
 //   @IBOutlet var objWKWebView: WKWebView!
    
    @IBOutlet var viewContTotalQuantity: UIView!
    @IBOutlet var lblTitleTotal: UILabel!
    @IBOutlet var imgVRatingStar: UIImageView!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet weak var lblPiece: UILabel!
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lblDot1: UILabel!
    @IBOutlet weak var lblDot2: UILabel!
    @IBOutlet weak var lblDot3: UILabel!
    @IBOutlet weak var lblDetail1: UILabel!
    @IBOutlet weak var lblDetail2: UILabel!
    @IBOutlet weak var lblDetail3: UILabel!
    
    @IBOutlet weak var collectionViewCategory: UICollectionView!
    @IBOutlet weak var cnsCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet var viewContainerOfPageVC: UIView!
    @IBOutlet var viewWKWebViewCont: UIView!
    
    var objWKWebView1:WKWebView!
//    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objChargingStationViewModel = ChargingStationViewModel(vc: self)
        
        //  self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.view.setRightToLeftPinkGradientViewUI()
        setNavigationAndUI()
        
        // setWebView()
        
        collectionViewCategory.register(UINib(nibName: Constant.CellIdentifier.CHARGING_STATION_CATEGORY_CELL, bundle: nil), forCellWithReuseIdentifier: Constant.CellIdentifier.CHARGING_STATION_CATEGORY_CELL)
        collectionViewCategory.dataSource = self
        collectionViewCategory.delegate = self
        collectionViewCategory.isScrollEnabled = false
        manageSizeOfCollectionViewCell()
        setCollectionViewSize()
        
        loadWebview()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        Util.appDelegate.objRefreshUserDetailsDelegate = self
        
        getUserProfileApi()
        
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            let myStar : Int = Int(objUserProfile.strRemainingStar)!
            lblTotal.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
//            userID = objUserProfile.strUserId
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.hideProgress()
        Util.appDelegate.objRefreshUserDetailsDelegate = nil
        dismissAlertInfoPresenter()
    }
    
    func getUserProfileApi() {
        if (Util.isNetworkReachable()) {
            self.showProgress()
            
            let objUserProfileModel = UserProfileModel()
            
            let dictData1:[String: Any]? = Util.getUserProfileDict()
            if(dictData1 != nil) {
                let objUser = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
                objUserProfileModel.strUserId = objUser.strUserId
                objUserProfileModel.strUserType = objUser.strUserType
            }else {
                objUserProfileModel.strUserId = ""
                objUserProfileModel.strUserType = ""
            }
            
            objChargingStationViewModel.getUserProfileAPI(objUser: objUserProfileModel)
        }
    }
    
    func onUserProfileSuccess() {
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            let myStar : Int = Int(objUserProfile.strRemainingStar)!
            lblTotal.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
            //            userID = objUserProfile.strUserId
        }
    }
    
    func onUserProfileFail(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    func loadWebview() {
        let contentController = WKUserContentController();
        contentController.add(self, name: "callbackHandler")
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler:{ })
        
        objWKWebView1 = WKWebView(frame: viewWKWebViewCont.frame, configuration: config)
//        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
        objWKWebView1.navigationDelegate = self
        self.objWKWebView1.frame = self.viewWKWebViewCont.bounds
        self.objWKWebView1.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        
//        objWKWebView1.scrollView.addSubview(refreshControl)
        objWKWebView1.scrollView.bounces = true
        
        viewWKWebViewCont.addSubview(objWKWebView1)
        
        loadUrlWithClickHandler()
    }
    
    func loadUrlWithClickHandler() {
        
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            let myStar : Int = Int(objUserProfile.strRemainingStar)!
            lblTotal.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
        }
        
        isNetworkAvailable { (isSuccess) in
            let strWebURL:String! = "\(Constant.API.BASEURL)\(Constant.API.CHARGING_STATION_WEBVIEW)"
            let url = URL(string: strWebURL)
//            let webURL : URLRequest = URLRequest(url: url!)
            let webURL:URLRequest! = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
            self.objWKWebView1.configuration.preferences.javaScriptEnabled = true
            self.objWKWebView1.load(webURL)
        }
    }
    
    func updateAPIFromSideMenu() {
        loadUrlWithClickHandler()
    }
    
//    @objc func refreshWebView(_ sender: UIRefreshControl) {
//       // setWebView()
//        loadUrlWithClickHandler()
//    }
    
    func setWebView() {
        
        isNetworkAvailable { (isSuccess) in
            if(Util.isNetworkReachable()) {
                let strWebURL:String! = "\(Constant.API.WEB_VIEW_BASEURL)\(Constant.API.CHARGING_STATION_WEBVIEW)"
                let strTrimmedUrl = strWebURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: strTrimmedUrl!)
                let webURL:URLRequest! = URLRequest(url: url!)
                self.showProgress()
                //            objWKWebView.navigationDelegate = self
                //            objWKWebView.load(webURL)
            }else {
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
    }
    
    func getAttendanceCheckApi() {
        if Util.isNetworkReachable() {
            self.showProgress()
            
            let dictData1:[String: Any]? = Util.getUserProfileDict()
            if(dictData1 != nil) {
                let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
                let user_id = objUserProfile.strUserId
                objChargingStationViewModel.getAttendenceCheckAPI(userId: user_id!)
            }
            
        }else {
            self.hideProgress()
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }

    // MARK: - set Navigation UI
    func setNavigationAndUI() {
        
        navBar.setUI(navBarText: strNavBarTitle)
        if(isBackButtonShow)
        {
            self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        }else
        {
            self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
//            self.leftBarButton(navBar: navBar, imgName: Constant.Image.menu)
        }
        
        scrollview.isScrollEnabled = false
        
        imgVRatingStar.setImageFit(imageName: Constant.Image.history_star)
        lblTitleTotal.setLoginNormalUIStyleFullBack(value: "LBL_TOTAL_STAR_QUANTITY")
        lblPiece.setLoginNormalUIStyleFullBack(value: "LBL_VOTE_PIECE")
        viewContTotalQuantity.backgroundColor = Constant.Color.VIEW_BG_TOTAL_QUANTITY_COLOR
        
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            let myStar : Int = Int(objUserProfile.strRemainingStar)!
            lblTotal.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
        }
        
        viewBottom.backgroundColor = Constant.Color.VIEW_BACKGROUND
        lblDot1.setLoginNormalUIStyleFullBack(value: ".")
        lblDot2.setLoginNormalUIStyleFullBack(value: ".")
        lblDot3.setLoginNormalUIStyleFullBack(value: ".")
        lblDetail1.setLoginNormalUIStyleFullBack(value: "LBL_CHARGING_STATION1")
        lblDetail2.setLoginNormalUIStyleFullBack(value: "LBL_CHARGING_STATION2")
//        lblDetail3.setLoginNormalUIStyleFullBack(value: "LBL_CHARGING_STATION3")
        
        objChargingStationViewModel.setCategoryData()
        
        //self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station)
//        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.menu)
//        self.rightBarSingleBtnWithImage2(navBar: navBar, imgName1: Constant.Image.menu, imgName2: Constant.Image.search)
    }
    
    func getUserDetails() -> UserProfileModel {
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        var objUserProfile = UserProfileModel()
        
        if(dictData1 != nil) {
            objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            let myStar : Int = Int(objUserProfile.strRemainingStar)!
            lblTotal.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
//            userID = objUserProfile.strUserId
        }
        return objUserProfile
    }
    
    //MARK: Button Tabbed
    
    @objc override func leftBarButtonClick() {
        if(isBackButtonShow) {
            self.navigationController?.popViewController(animated: true)
        }else {
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
    
//    @objc override func rightBtnClickedWithImg() {
//        //
//    }
//
//    @objc override func rightBtnClickedWithImg2() {
//        printDebug("rightBtnClickedWithImg2")
//    }
    
    //MARK:- View Model Methods
    func onApiSuccessHideProgress() {
        self.hideProgress()
//        refreshControl.endRefreshing()
    }
    
    func onSuccessApiResponce() {
        
        let availableStar = objChargingStationViewModel.objAttendenceCheck.available_star
        let myStar : Int = Int(availableStar!)!
        lblTotal.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
        
        var dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            dictData1!["remaining_star"] = availableStar
        }
        Util.setUserProfileDict(strValue: dictData1!)
        
        let objAttendanceCheckVC = AttendanceCheckVC()
        objAttendanceCheckVC.myNavigationController = self.navigationController
        //            let objContestant = objContestantListViewModel.arrContestantDetailModel[sender.tag]
        //            objAttendanceCheckVC.objContestant = objContestant
        objAttendanceCheckVC.modalTransitionStyle = .crossDissolve
        objAttendanceCheckVC.modalPresentationStyle = .overCurrentContext
        self.present(objAttendanceCheckVC, animated: true, completion: nil)
    }
    
    func showMessage(message: String) {
        let objAttendanceCheckConfirmVC = AttendanceCheckConfirmVC()
        objAttendanceCheckConfirmVC.myNavigationController = self.navigationController
        
        objAttendanceCheckConfirmVC.modalTransitionStyle = .crossDissolve
        objAttendanceCheckConfirmVC.modalPresentationStyle = .overCurrentContext
        self.present(objAttendanceCheckConfirmVC, animated: true, completion: nil)
    }
    
}

//MARK:- Collection view
extension WebViewWithTabVC : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objChargingStationViewModel.getNumberOfRecords()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ChargingStationCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellIdentifier.CHARGING_STATION_CATEGORY_CELL, for: indexPath) as! ChargingStationCategoryCell
        
        cell.viewMain.layer.cornerRadius = 20
        cell.imgBackground.image = UIImage(named: Constant.Image.STAR_BACKGROUND)
        cell.viewStar.roundViewColor()
        cell.imgStar.image = UIImage(named: Constant.Image.history_star)
        
        
        let objCategory = objChargingStationViewModel.arrCategoryChargingStation[indexPath.row]
        
        cell.viewMain.backgroundColor = objCategory.viewColor
        cell.lblTitle.setLoginHeaderBigUIStyleWhiteCell(value: objCategory.title)
        cell.lblDetail.setLoginHeaderBigUIStyleWhiteCell1(value: objCategory.detail)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let objWebViewChargingStationPaidVC = WebViewChargingStationPaidVC()
            self.navigationController?.pushViewController(objWebViewChargingStationPaidVC, animated: true)
            
        } else if indexPath.row == 1 {
            let objAttendanceCheckVC = AttendanceCheckVC()
            objAttendanceCheckVC.myNavigationController = self.navigationController
            //            let objContestant = objContestantListViewModel.arrContestantDetailModel[sender.tag]
            //            objAttendanceCheckVC.objContestant = objContestant
            objAttendanceCheckVC.modalTransitionStyle = .crossDissolve
            objAttendanceCheckVC.modalPresentationStyle = .overCurrentContext
            self.present(objAttendanceCheckVC, animated: true, completion: nil)
            
        } else if indexPath.row == 2 {
            
            let objWebViewChargingStationFreeVC = WebViewChargingStationFreeVC()
            objWebViewChargingStationFreeVC.strWebURL = Constant.API.CHARGING_FREE_POINT_WEBVIEW
            self.navigationController?.pushViewController(objWebViewChargingStationFreeVC, animated: true)
        } else if indexPath.row == 3 {
            let objWebViewChargingStationFreeVC = WebViewChargingStationFreeVC()
            objWebViewChargingStationFreeVC.strWebURL = Constant.API.CHARGING_SHOP_WEBVIEW
            self.navigationController?.pushViewController(objWebViewChargingStationFreeVC, animated: true)

        }else if indexPath.row == 4 {
            let objWebViewChargingStationFreeVC = WebViewChargingStationFreeVC()
            objWebViewChargingStationFreeVC.strWebURL = Constant.API.CHARGING_COUPAN_WEBVIEW
            self.navigationController?.pushViewController(objWebViewChargingStationFreeVC, animated: true)
        }else if indexPath.row == 5 {
            let objGiftVC2 = GiftVC2()
            objGiftVC2.isBackButtonShow = true
            objGiftVC2.modalTransitionStyle = .crossDissolve
            objGiftVC2.modalPresentationStyle = .overCurrentContext
            self.present(objGiftVC2, animated: true, completion: nil)
        }
    }
    
    func manageSizeOfCollectionViewCell() {
        let uiCollectionViewFlowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let size:CGFloat = UIScreen.main.bounds.width - 50
        //        let size:CGFloat = objCollectionView.frame.width - 28
        uiCollectionViewFlowLayout.itemSize = CGSize(width: (size/2), height: (size/2))
        collectionViewCategory.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        uiCollectionViewFlowLayout.minimumInteritemSpacing = 10
        uiCollectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewCategory.collectionViewLayout = uiCollectionViewFlowLayout
        collectionViewCategory.setNeedsLayout()
        collectionViewCategory.updateFocusIfNeeded()
    }
    
    func setCollectionViewSize() {
        let size = ((UIScreen.main.bounds.width - 30) / 2) + 10
        let arrCount = objChargingStationViewModel.getNumberOfRecords()
        cnsCollectionViewHeight.constant = (CGFloat(arrCount) / 2) * size
    }
    // collection view end
}

extension WebViewWithTabVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideProgress()
//        refreshControl.endRefreshing()
        
        let contentSize = objWKWebView1.scrollView.contentSize
        let viewSize = objWKWebView1.bounds.size

        let rw = Float(viewSize.width / contentSize.width)

        objWKWebView1.scrollView.minimumZoomScale = CGFloat(rw)
        objWKWebView1.scrollView.maximumZoomScale = CGFloat(rw)
        objWKWebView1.scrollView.zoomScale = CGFloat(rw)
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.hideProgress()
//        refreshControl.endRefreshing()
       
    }
}

extension WebViewWithTabVC : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("messageBody : \(message.body)")
        
        let objUserProfile = self.getUserDetails()
        
        if message.name == "callbackHandler" {
//            print("callbackHandler")
            
            let objBtnTapName : String = "\(message.body)"
            
            if objBtnTapName == "btn-toll" {
                
                let objWebViewChargingStationPaidVC = WebViewChargingStationPaidVC()
                self.navigationController?.pushViewController(objWebViewChargingStationPaidVC, animated: true)
            }
            else if objBtnTapName == "btn-attendance" {
                
                if(Util.getIsUserLogin() == "0") {
                    AlertPresenter.alertInformation(fromVC: Util.currentNavigationController.topViewController!, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
                }else {
                    getAttendanceCheckApi()
                }
            }
            else if objBtnTapName == "btn-free-charging" {
                
                let objChargingStationNewFreeVC = ChargingStationNewFreeVC()
                objChargingStationNewFreeVC.strWebURL = "\(Constant.API.CHARGING_FREE_POINT_WEBVIEW)\(objUserProfile.strUserId!)\(Constant.API.CHARGING_FREE_POINT_WEBVIEW_NAME)\(objUserProfile.strUserName!)\(Constant.API.CHARGING_FREE_POINT_WEBVIEW_PHONE)\(objUserProfile.strMobile!)\(Constant.API.CHARGING_FREE_POINT_WEBVIEW_DEVICE)"
                
                if objUserProfile.strEmail != nil && objUserProfile.strEmail != "" {
                    objChargingStationNewFreeVC.strWebURL = "\(Constant.API.CHARGING_FREE_POINT_WEBVIEW)\(objUserProfile.strUserId!)\(Constant.API.CHARGING_FREE_POINT_WEBVIEW_NAME)\(objUserProfile.strUserName!)\(Constant.API.CHARGING_FREE_POINT_WEBVIEW_EMAIL)\(objUserProfile.strEmail!)\(Constant.API.CHARGING_FREE_POINT_WEBVIEW_PHONE)\(objUserProfile.strMobile!)\(Constant.API.CHARGING_FREE_POINT_WEBVIEW_DEVICE)"
                }
                
//                TnkSession.sharedInstance().setUserName(objUserProfile.strUserId!)
//                TnkSession.sharedInstance().showAdList(asModal: self, title: "랭킹스타 무료충전소")
                
                self.navigationController?.pushViewController(objChargingStationNewFreeVC, animated: true)

            }
            else if objBtnTapName == "btn-shop" {
                
                let objWebViewChargingStationFreeVC = WebViewChargingStationFreeVC()
                objWebViewChargingStationFreeVC.strWebURL = "\(Constant.API.CHARGING_SHOP_WEBVIEW)\(objUserProfile.strUserId!)\(Constant.API.CHARGING_SHOP_WEBVIEW_NAME)\(objUserProfile.strUserName!)\(Constant.API.CHARGING_SHOP_WEBVIEW_PHONE)\(objUserProfile.strMobile!)"
                
                if objUserProfile.strEmail != nil && objUserProfile.strEmail != "" {
                    objWebViewChargingStationFreeVC.strWebURL = "\(Constant.API.CHARGING_SHOP_WEBVIEW)\(objUserProfile.strUserId!)\(Constant.API.CHARGING_SHOP_WEBVIEW_NAME)\(objUserProfile.strUserName!)\(Constant.API.CHARGING_SHOP_WEBVIEW_EMAIL)\(objUserProfile.strEmail!)\(Constant.API.CHARGING_SHOP_WEBVIEW_PHONE)\(objUserProfile.strMobile!)"
                }
                
//                self.navigationController?.pushViewController(objWebViewChargingStationFreeVC, animated: true)
//                objWebViewChargingStationFreeVC.strWebURL
                
                
                let strPram:String! = objWebViewChargingStationFreeVC.strWebURL
                let strShopURL:String! = "\(Constant.API.WEB_VIEW_BASEURL)\(strPram ?? "")"
                let strShopURLTrim = strShopURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                guard let url = URL(string: strShopURLTrim!), UIApplication.shared.canOpenURL(url) else { return }

                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else if objBtnTapName == "btn-coupon" {
                
                let objWebViewChargingStationFreeVC = WebViewChargingStationFreeVC()
                objWebViewChargingStationFreeVC.strWebURL = "\(Constant.API.CHARGING_COUPAN_WEBVIEW)\(objUserProfile.strUserId!)\(Constant.API.CHARGING_COUPAN_WEBVIEW_NAME)\(objUserProfile.strUserName!)\(Constant.API.CHARGING_COUPAN_WEBVIEW_PHONE)\(objUserProfile.strMobile!)"
                
                if objUserProfile.strEmail != nil && objUserProfile.strEmail != "" {
                    objWebViewChargingStationFreeVC.strWebURL = "\(Constant.API.CHARGING_COUPAN_WEBVIEW)\(objUserProfile.strUserId!)\(Constant.API.CHARGING_COUPAN_WEBVIEW_NAME)\(objUserProfile.strUserName!)\(Constant.API.CHARGING_COUPAN_WEBVIEW1_EMAIL)\(objUserProfile.strEmail!)\(Constant.API.CHARGING_COUPAN_WEBVIEW_PHONE)\(objUserProfile.strMobile!)"
                }
                
                self.navigationController?.pushViewController(objWebViewChargingStationFreeVC, animated: true)
            }
            else if objBtnTapName == "btn-gift" {
                
                if(Util.getIsUserLogin() == "0") {
                    AlertPresenter.alertInformation(fromVC: Util.currentNavigationController.topViewController!, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
                }else {
                    let objGiftVC2 = GiftVC2()
                    objGiftVC2.isBackButtonShow = true
                    objGiftVC2.delegate = self
                    objGiftVC2.modalTransitionStyle = .crossDissolve
                    objGiftVC2.modalPresentationStyle = .overCurrentContext
                    self.present(objGiftVC2, animated: true, completion: nil)
                }
            }
        }
    }
}

extension WebViewWithTabVC : onSendStarCompleteAction {
    func setRefreshData() {
        let dictData1:[String: Any]? = Util.getUserProfileDict()
        if(dictData1 != nil) {
            let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
            let myStar : Int = Int(objUserProfile.strRemainingStar)!
            lblTotal.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
        }
    }
}

extension WebViewWithTabVC : RefreshUserDetailsDelegate {
    func getUserStar() {
       let dictData1:[String: Any]? = Util.getUserProfileDict()
       if(dictData1 != nil) {
           let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
           let myStar : Int = Int(objUserProfile.strRemainingStar)!
           lblTotal.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
        
       }
    }
}

//extension WebViewWithTabVC : SlideMenuControllerDelegate {
//
//    func leftWillOpen() {
//        // print("SlideMenuControllerDelegate: leftWillOpen")
//    }
//}



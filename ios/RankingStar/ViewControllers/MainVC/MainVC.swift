//
//  LoginVC.swift
//  RankingStar
//
//  Created by Jinesh on 13/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit
import Material
import TYCyclePagerView
import SlideMenuControllerSwift

class MainVC: BaseVC {
    
    @IBOutlet weak var pagerView: TYCyclePagerView!
    
    var objMainViewModel : MainViewModel!
    
    @IBOutlet var pageViewContstainheight: NSLayoutConstraint!
    @IBOutlet var navBar: UINavigationBar!
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeight: NSLayoutConstraint!
    
    @IBOutlet var tblSearchList: UITableView!
    
    var searchedText : String = ""
    @IBOutlet  var txtSearch: UITextField!
    @IBOutlet var viewContSearch: UIView!
    @IBOutlet weak var viewMainSearch: UIView!
    
    @IBOutlet var btnSearchClose: UIButton!
    @IBOutlet var scrollViewMain: UIScrollView!
    
    let objRefreshControl = UIRefreshControl()
    var objBottomRefreshControl = UIRefreshControl()
    var objBottomRefreshControlForSearch = UIRefreshControl()

    var isBottomRefressControllRemoved:Bool = false
    var isBottomRefressSearchControllRemoved:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.view.setRightToLeftPinkGradientViewUI()
        objMainViewModel = MainViewModel(vc: self)
        txtSearch.delegate = self
        
        tblView.delegate = self
        tblView.dataSource = self
       // tblView.isScrollEnabled = false
        tblView.separatorStyle = .none
        tblView.register(UINib(nibName: Constant.CellIdentifier.CONTEST_LIST, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier.CONTEST_LIST)
        tblView.estimatedRowHeight = 185
        //        tblViewHeight.constant = 200
        
        tblSearchList.delegate = self
        tblSearchList.dataSource = self
        tblSearchList.separatorStyle = .none
        tblSearchList.register(UINib(nibName: Constant.CellIdentifier.SEARCH_LIST_CELL, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier.SEARCH_LIST_CELL)
        
        tblSearchList.bottomRefreshControl = objBottomRefreshControlForSearch
        tblSearchList.bottomRefreshControl?.addTarget(self, action: #selector(handleSearchBottomRefreshControl), for: .valueChanged)
        
        
        //        objMainViewModel.arrSearchUserProfileModel.removeAll()
        //        self.tblSearchList.reloadData()
        //tblView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 15))
        scrollViewMain.refreshControl = objRefreshControl
        scrollViewMain.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        scrollViewMain.bottomRefreshControl = objBottomRefreshControl
        scrollViewMain.bottomRefreshControl?.addTarget(self, action: #selector(handleBottomRefreshControl), for: .valueChanged)
        
//        Util.getDeviceDetails()
        setUIColor()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        
        let refreshToken = Util.getRefreshToken()
        if(Util.getIsUserLogin() != "0" && refreshToken != "") {
            getUserProfileApi()
        }
        //        Util.setStatusBarHide(isHidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        dismissAlertInfoPresenter()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.pagerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: pageViewContstainheight.constant)
     //   pagerView.layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: pageViewContstainheight.constant)
        
    }
    
    //MARK: custom method
    
    func setUIColor()
    {
//        Util.appDelegate.createMenuView()
        navBar.setUI(navBarText: "RANKING_STAR")
        // navBar.setLeftNavUI(navBarText: "RANKING_STAR")
        //self.leftBarButton(navBar : navBar , imgName : Constant.Image.back)
        self.leftBarButton2(navBar: navBar, imgName1: Constant.Image.menu_black, imgName2: Constant.Image.search_black)
        //self.rightBarSingleBtnWithImage2(navBar: navBar, imgName1: Constant.Image.menu, imgName2: Constant.Image.search)
        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station_black)
        
        txtSearch.setSearchUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_SEARCH_TITLE")
       // btnSearchClose.setBackgroundImage(UIImage(named: Constant.Image.back), for: .normal)
        btnSearchClose.tintColor = UIColor.black
        btnSearchClose.setImage(UIImage(named: Constant.Image.back_black), for: .normal)
        btnSearchClose.setImage(UIImage(named: Constant.Image.back_black), for: .highlighted)
//        viewContSearch.rectViewWithBorderColor()
        viewContSearch.setRightToLeftPinkGradientViewUI()
        viewContSearch.setCardStyleWithShadowView()
        //        viewContSearch.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        viewContSearch.isHidden = true
        tblSearchList.isHidden = true
        viewMainSearch.isHidden = true
        setPagerViewUI()
        
        
        /*     lblTotalPageViewPage.setSmallUIStyleWhite(value: "\(startingPage)/\(totalPage)")
         lblSymbol.setSmall2BGColorUITxtWhite(value: "LBL_AT_THE_RET")
         lblPageViewContentName.setLoginSmallBGColorUITxtWhite(value: " \("LBL_VIEW_ALL_BANNER".localizedLanguage()) ")
         
         let lblPageViewContentNameTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.lblPageViewContentNameTabbed))
         lblPageViewContentName.isUserInteractionEnabled = true
         lblPageViewContentName.addGestureRecognizer(lblPageViewContentNameTabbed)
         
         lblPageViewNextContent.setLoginNormalUIStyleWhite(value: "Nextpage")
         imgNexPageView.setImageFit(imageName: Constant.Image.right_arrow)
         imgNexPageView.tintColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
         */
        getContentListAPI()
    }
    
    func updateAPIFromSideMenu() {
        getContentListAPI()
    }
    
    func pushViewControllerFromSideMenu(index:Int) {
        
        if(index == 0 || index == 1 || index == 2 || index == 5 || index == 6)
        {
            if(Util.getIsUserLogin() == "0")
            {
                self.closeLeft()
                AlertPresenter.alertInformation(fromVC: Util.currentNavigationController.topViewController!, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
            }else
            {
                createVCForPush(index:index)
            }
            
        }else
        {
            createVCForPush(index:index)
        }
        
    }
    
    func createVCForPush(index:Int)
    {
        self.closeLeft()
        if(index == 0) {
            let objWebViewWithTabVC = WebViewWithTabVC()
            objWebViewWithTabVC.isBackButtonShow = true
            pushVCForSideMenu(objVC:objWebViewWithTabVC)
            //  (self.webViewWithTabVC as! WebViewWithTabVC).strNavBarTitle = "NAV_TITLE_STAR_CHARING_STATION"
            // vc = self.webViewWithTabVC
        }
        else if(index == 1) {
            
            let objGiftVC2 = GiftVC2()
            objGiftVC2.modalTransitionStyle = .crossDissolve
            objGiftVC2.modalPresentationStyle = .overCurrentContext
            objGiftVC2.myNavigationController = Util.currentNavigationController
            Util.currentNavigationController.present(objGiftVC2, animated: true, completion: nil)
        }else if(index == 2) {
            let objChargingStarHistoryVC = ChargingStarHistoryVC()
            objChargingStarHistoryVC.isBackButonShow = true
            pushVCForSideMenu(objVC:objChargingStarHistoryVC)
            //            vc = self.chargingHistoryVC
            
        }else if(index == 3) {
            let objWebViewVC = WebViewVC()
            objWebViewVC.isBackButtonShow = true
            pushVCForSideMenu(objVC:objWebViewVC)
            //            vc = self.webViewVC
        }else if(index == 4) {
            let objNoticeVC = NoticeVC()
            objNoticeVC.isBackButtonShow = true
            pushVCForSideMenu(objVC:objNoticeVC)
            //            vc =  self.noticeVC
        }else if(index == 5) {
            let objPushNotificationListVC = PushNotificationListVC()
            objPushNotificationListVC.isBackButtonShow = true
            pushVCForSideMenu(objVC:objPushNotificationListVC)
            //            vc = self.pushNotificationVC
        }else if(index == 6) {
            let objSettingVC = SettingVC()
            objSettingVC.isBackButtonShow = true
            pushVCForSideMenu(objVC:objSettingVC)
            //            vc = self.appSettingVC
        }
    }
    
    func pushVCForSideMenu(objVC:UIViewController)
    {
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    func setPagerViewUI()
    {
        self.pagerView.dataSource = self
        self.pagerView.delegate = self
        self.pagerView.register(UINib(nibName: Constant.CellIdentifier.MAIN_CONTENT_BANNER, bundle: nil), forCellWithReuseIdentifier: Constant.CellIdentifier.MAIN_CONTENT_BANNER)
        self.pagerView.setNeedUpdateLayout();

        pagerView.autoScrollInterval = 5.0
    }
    
    func getContentListAPI() {
        isNetworkAvailable { (isSuccess) in
            if(Util.isNetworkReachable()) {
               // self.showProgress()
                let objUserProfileModel = UserProfileModel()
                self.objMainViewModel.getContentListAPI(objUser: objUserProfileModel)
            }else {
                self.objRefreshControl.endRefreshing()
                self.objBottomRefreshControl.endRefreshing()
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
    }
    
    func getSearchListAPI(txtSearch:String) {
        
        if(Util.isNetworkReachable()) {
            self.showProgress()
            
            let objUserProfileModel = UserProfileModel()
            objUserProfileModel.strSearch = txtSearch
            objUserProfileModel.strPage = objMainViewModel.searchPageNo
            objMainViewModel.getSearchListAPI(objUser: objUserProfileModel)
        }
//        else {
//            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
//        }
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
            
            objMainViewModel.getUserProfileAPI(objUser: objUserProfileModel)
        }
    }
    
    func setContestListTableviewHeight()
    {
        if(objMainViewModel.getTableNumberOfSection() == 0)
        {
            tblViewHeight.constant = 200
            showNoDataFoundDialog2(uiView: tblView)
        }else
        {
            tblViewHeight.constant = CGFloat(objMainViewModel.getTableNumberOfSection() * 185)
            hideNoDataFoundDialog2()
        }
    }
    
    //MARK:- Button clicked
    
    @IBAction func btnSearchClicked(_ sender: UIButton) {
        // txtSearch.text = ""
        viewContSearch.isHidden = true
        tblSearchList.isHidden = true
        viewMainSearch.isHidden = true
    }
    
    //MARK:- View model methods
    func onSuccessApiResponce() {
        if(objMainViewModel.arrContestSlider.count == 0) {
            pageViewContstainheight.constant = 0
//            showNoDataFoundDialog(uiView: pagerView)
        }else {
            pageViewContstainheight.constant = 300
//            hideNoDataFoundDialog()
        }
        
        if(objMainViewModel.hasMoreRecored == true)
        {
            if(isBottomRefressControllRemoved == true)
            {
                isBottomRefressControllRemoved = false
                objBottomRefreshControl = UIRefreshControl()
                scrollViewMain.bottomRefreshControl = objBottomRefreshControl
                scrollViewMain.bottomRefreshControl?.addTarget(self, action: #selector(handleBottomRefreshControl), for: .valueChanged)
                
                printDebug("refress is not hidden")
            }
        }else
        {
            isBottomRefressControllRemoved = true
            scrollViewMain.bottomRefreshControl?.removeFromSuperview()
            printDebug("bottom refress is hidden")
        }
        objRefreshControl.endRefreshing()
        objBottomRefreshControl.endRefreshing()
        setContestListTableviewHeight()
        pagerView.reloadData()
        tblView.reloadData()
    }
    
    func onSuccessSearchApiResponce(isSuccess:Bool) {
        if(isSuccess)
        {
            if(objMainViewModel.hasMoreRecoredSearch == true)
            {
                if(isBottomRefressSearchControllRemoved == true)
                {
                    isBottomRefressSearchControllRemoved = false
                    objBottomRefreshControlForSearch = UIRefreshControl()
                    tblSearchList.bottomRefreshControl = objBottomRefreshControlForSearch
                    tblSearchList.bottomRefreshControl?.addTarget(self, action: #selector(handleSearchBottomRefreshControl), for: .valueChanged)
                    printDebug("refress is not hidden")
                }
            }else
            {
                isBottomRefressSearchControllRemoved = true
                tblSearchList.bottomRefreshControl?.removeFromSuperview()
                printDebug("bottom refress is hidden")
            }
            tblSearchList.reloadData()
            objBottomRefreshControlForSearch.endRefreshing()
        }else
        {
            objBottomRefreshControlForSearch.endRefreshing()
        }
        
        if(objMainViewModel.arrSearchUserProfileModel.count <= 0)
        {
            showNoDataFoundDialog3(uiView: tblSearchList)
        }else
        {
            hideNoDataFoundDialog3()
        }
        
    }
    
    func onUserProfileSuccess() {
        
    }
    
    func onApiSuccessHideProgress() {
        self.hideProgress()
    }
    
    func showMessage(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    //MARK: Button Tabbed
    @objc override func leftBarButtonClick(){
        self.toggleLeft()
    }
    
    @objc override func leftBarButtonClick2(){
        txtSearch.text = ""
        // remove table view array
        objMainViewModel.arrSearchUserProfileModel.removeAll()
        self.tblSearchList.reloadData()
        hideNoDataFoundDialog3()
        viewContSearch.isHidden = false
        tblSearchList.isHidden = false
        viewMainSearch.isHidden = false
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
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.searchedText = txtSearch.text!
        if searchedText.isEmpty {
            objMainViewModel.arrSearchUserProfileModel.removeAll()
            self.tblSearchList.reloadData()
            showNoDataFoundDialog3(uiView: tblSearchList)
        }else {
            objMainViewModel.arrSearchUserProfileModel.removeAll()
            objMainViewModel.searchPageNo = 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.getSearchListAPI(txtSearch: self.txtSearch.text!)
            }
            hideNoDataFoundDialog3()
            
        }
    }
    
    //MARK:-  Tapped Methods clicked
    @objc func imgPageViewTappedMethod(_ sender: CustomTabGestur) {
        
        let objContestantListVC = ContestantListVC()
        objContestantListVC.strContestId = objMainViewModel.arrContestSlider[sender.intIndex].strId
        self.navigationController?.pushViewController(objContestantListVC, animated: true)
        
    }
    
    @objc func imgPauseTapGestRec(_ sender: CustomTabGestur) {
        print("imgPauseTapGestRec")
        let cell = sender.objUICollectionViewCell as! MainContentBannerCell
        
        if(pagerView.autoScrollInterval == 0)
        {
            
            pagerView.autoScrollInterval = 5.0
            cell.imgPause.setImageFit(imageName: Constant.Image.slider_pause)
        }else
        {
            pagerView.autoScrollInterval = 0
            cell.imgPause.setImageFit(imageName: Constant.Image.slider_play)
        }
    }
    
    @objc func handleRefreshControl() {
        printDebug("handleRefreshControl")
        objMainViewModel.arrContestSlider.removeAll()
        pagerView.reloadData()
//        if(isBottomRefressControllRemoved == true)
//        {
//            isBottomRefressControllRemoved = false
//            objBottomRefreshControl = UIRefreshControl()
//            scrollViewMain.bottomRefreshControl?.addTarget(self, action: #selector(handleBottomRefreshControl), for: .valueChanged)
//            scrollViewMain.bottomRefreshControl = objBottomRefreshControl
//            printDebug("refress is not hidden")
//        }
        getContentListAPI()
    }
    
    @objc func handleBottomRefreshControl() {
        printDebug("handleBottomRefreshControl")
        
        if(isBottomRefressControllRemoved == false)
        {
            if(objMainViewModel.hasMoreRecored == true)
            {
                let objUserProfileModel = UserProfileModel()
                objMainViewModel.subContestPageNo += 1
                objUserProfileModel.strPage = objMainViewModel.subContestPageNo
                objMainViewModel.getSubContentListAPI(objUser: objUserProfileModel)
            }
        }else
        {
            objBottomRefreshControl.endRefreshing()
        }
        
    }
    
    @objc func handleSearchBottomRefreshControl() {
        printDebug("handleBottomRefreshControl")
        
        if(isBottomRefressSearchControllRemoved == false)
        {
            if(objMainViewModel.hasMoreRecoredSearch == true)
            {
                let objUserProfileModel = UserProfileModel()
                objUserProfileModel.strSearch = txtSearch.text!
                objMainViewModel.searchPageNo += 1
                objUserProfileModel.strPage = objMainViewModel.searchPageNo
                objMainViewModel.getSearchListAPI(objUser: objUserProfileModel)
            }
        }else
        {
            objBottomRefreshControlForSearch.endRefreshing()
        }
        
    }
    
    
    
    //MARK:-  Tapped Methods clicked
    @objc func lblPageViewContentNameTabbed(_ sender: CustomTabGestur){
        printDebug("lblPageViewContentNameTabbed")
    }
}

extension MainVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tblView:
            return objMainViewModel.getTableNumberOfSection()
        //break;
        case tblSearchList:
            return objMainViewModel.arrSearchUserProfileModel.count
        // break;
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case tblView:
            return 175
        //break;
        case tblSearchList:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case tblView:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.CONTEST_LIST) as! ContestListCell
            
            let objContestSlider = objMainViewModel.arrContestList[indexPath.row]
            
            cell.selectionStyle = .none
            cell.btnVote.setTitle(txtValue: " \(String(describing: objContestSlider.strStatusLabel!))")
            cell.btnVote.setBtnContestStatusPinkUICell()
            
            cell.btnVote.isEnabled = false
            cell.lblContestName.setNormalEditProfileSecondTitleBalck(value: objContestSlider.strName)
            
            if(Constant.ResponseParam.CONTEST_STATUS_OPEN == objContestSlider.strStatus)
            {
                cell.btnVote.backgroundColor = Constant.Color.CONTEST_LIST_CELL_ONE_COLOR
                cell.lblContestName.textColor = Constant.Color.CONTEST_LIST_CELL_ONE_COLOR
            }else if(Constant.ResponseParam.CONTEST_STATUS_PREPARING == objContestSlider.strStatus)
            {
                cell.btnVote.backgroundColor = Constant.Color.CONTEST_LIST_CELL_SECOND_COLOR
                cell.lblContestName.textColor = Constant.Color.CONTEST_LIST_CELL_SECOND_COLOR
                cell.viewShade.backgroundColor = Constant.Color.IMAGE_SHADE
            }else
            {
                cell.btnVote.backgroundColor = Constant.Color.CONTEST_LIST_CELL_THIRD_COLOR
                cell.lblContestName.textColor = Constant.Color.CONTEST_LIST_CELL_THIRD_COLOR
                cell.viewShade.backgroundColor = Constant.Color.IMAGE_SHADE
            }
            
            cell.imgBackGround.getImageFromURL(url: objContestSlider.strSubImageUrl, defImage: Constant.Image.Banner_iOS)
            cell.imgBackGround.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
//            cell.imgBackGround.setFitImageInImageView()
            
            return cell
        //break;
        case tblSearchList:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.SEARCH_LIST_CELL) as! SearchListCell
            cell.selectionStyle = .none
            let objUser = objMainViewModel.arrSearchUserProfileModel[indexPath.row]
            cell.lblName.setBoldEditProfileSecondTitleBalck(value: objUser.strUserName)
            
            cell.lblDetails.setNormalDateThirdTitlePlaceHolder(value: objUser.strContestName)
            cell.imgUser.getImageFromURL(url: objUser.strImageUrl)
//            cell.imgUser.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
//            cell.imgUser.setFitImageInImageView()
            cell.viewSepretor.backgroundColor = Constant.Color.VIEW_SEPRETOR_COLOR
            return cell
        // break;
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case tblView:
            let objContestantListVC = ContestantListVC()
            objContestantListVC.strContestId = objMainViewModel.arrContestList[indexPath.row].strId
            self.navigationController?.pushViewController(objContestantListVC, animated: true)
        //break;
        case tblSearchList:
            
            let objContestantProfileVC = ContestantProfileVC()
            
            let objContestant = ContestantDetailModel()
            objContestant.strContestId = objMainViewModel.arrSearchUserProfileModel[indexPath.row].strContestId
            objContestant.strId = objMainViewModel.arrSearchUserProfileModel[indexPath.row].strUserId
            
//            objContestantProfileVC.strContestId = objContestant.strContestId
//            objContestantProfileVC.strContestantId = objMainViewModel.arrSearchUserProfileModel[indexPath.row].strUserId
            objContestantProfileVC.objContestant = objContestant
            
            self.navigationController?.pushViewController(objContestantProfileVC, animated: true)
            
//            let objContestantListVC = ContestantListVC()
//            objContestantListVC.strContestId = objMainViewModel.arrSearchUserProfileModel[indexPath.row].strContestId
//            self.navigationController?.pushViewController(objContestantListVC, animated: true)
        default:
            return
        }
        
    }
    
}

extension MainVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField == txtSearch) {
            //            self.searchedText = txtSearch.text!
            //
            //            if searchedText.isEmpty {
            //              //  objChargingStarHistoryModel.arrChargingHistoryModel = []
            //                self.tblView.reloadData()
            //
            //            }else {
            ////                getChargingHistoryAPI()
            //               // print(txtSearch.text)
            //                // nothing
            //            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtSearch) {
            textField.resignFirstResponder()
        }
        return true
    }
}


//MARK: TYCyclePagerViewDelegate, TYCyclePagerViewDataSource
extension MainVC: TYCyclePagerViewDelegate, TYCyclePagerViewDataSource {
    
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return objMainViewModel.arrContestSlider.count
    }
    
    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: Constant.CellIdentifier.MAIN_CONTENT_BANNER, for: index) as! MainContentBannerCell
        
        //        cell.imgPageView.setImageFill(imageName: arrImage[index])
        let imgurl = (objMainViewModel.arrContestSlider[index].strImageUrl).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        cell.imgPageView.getImageFromURL(url: imgurl!)
        cell.imgPageView.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
        cell.imgPageView.setAspectFillImageInImageView()
        
        cell.lblTotalPageViewPage.setSmallUIStyleSemiblack(value: "\(index + 1)/\(objMainViewModel.arrContestSlider.count)")
        //cell.lblTotalPageViewPage.setSmallUIStyleSemiblack(value: "\(index + 1)/\(10)")
        cell.lblTotalPageViewPage.setAttributedTextPagingLbl(text: cell.lblTotalPageViewPage.text!, subString: "\(index + 1)")
        //cell.lblSymbol.setSmall2BGColorUITxtWhite(value: "LBL_AT_THE_RET")
        if(pagerView.autoScrollInterval == 0)
        {
            cell.imgPause.setImageFit(imageName: Constant.Image.slider_play)
        }else
        {
            cell.imgPause.setImageFit(imageName: Constant.Image.slider_pause)
        }
        
        let imgPauseTapGestRec = CustomTabGestur(target: self, action: #selector(self.imgPauseTapGestRec))
        imgPauseTapGestRec.objUICollectionViewCell = cell
        cell.imgPause.isUserInteractionEnabled = true
        cell.imgPause.addGestureRecognizer(imgPauseTapGestRec)
        
        let imgPageViewTapGestRec = CustomTabGestur(target: self, action: #selector(self.imgPageViewTappedMethod))
        imgPageViewTapGestRec.intIndex = index
        cell.imgPageView.isUserInteractionEnabled = true
        cell.imgPageView.addGestureRecognizer(imgPageViewTapGestRec)
        return cell
    }
    
    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: self.pagerView.frame.height)
        //layout.itemSize = CGSize(width: self.pagerView.frame.height, height: pagerView.frame.width)
        // self.pagerView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 200)
        //        layout.itemSpacing = CGFloat(15*0.35)
        layout.maximumAngle = 1
        layout.minimumScale = 1
        layout.itemSpacing = CGFloat(0)
        layout.itemHorizontalCenter = true
        // layout.itemVerticalCenter = true
        return layout
    }
    
    func pagerView(_ pageView: TYCyclePagerView, didScrollFrom fromIndex: Int, to toIndex: Int) {
        
        // lblTotalPageViewPage.text = "\(toIndex+1)/\(totalPage)"
    }
}

extension MainVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        // print("SlideMenuControllerDelegate: leftWillOpen")
    }
}

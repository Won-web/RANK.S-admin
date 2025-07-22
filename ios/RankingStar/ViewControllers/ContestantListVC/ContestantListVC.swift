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

protocol ContestantListVCDelegate {
   func reloadContestantProfileApi()
}

class ContestantListVC: BaseVC {
    
    var objContestantListViewModel : ContestantListViewModel!
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var imgBanner: UIImageView!
    @IBOutlet weak var viewCategoryAndList: UIView!
    
//    @IBOutlet var imgBannerBG: UIImageView!
//    @IBOutlet var lblBannerYear: UILabel!
//    @IBOutlet var lblBannerSecondTitle: UILabel!
//    @IBOutlet var lblBannerThirdTitle: UILabel!
//    @IBOutlet var lblBannerFullDate: UILabel!
//
//    @IBOutlet var viewContBannerDetails: UIView!
  
    var searchedText : String = ""
    @IBOutlet  var txtSearch: UITextField!
    @IBOutlet var viewContSearch: UIView!
    @IBOutlet var btnSearchClose: UIButton!
    
    @IBOutlet var viewContCategorys: UIView!
   
    @IBOutlet var scrollViewFilter: UIScrollView!
    @IBOutlet var cnsFilterCatViewHeight: NSLayoutConstraint!
    
    var objUIRefreshControl = UIRefreshControl()
    
    var strContestId:String!
    var objContestant = ContestantDetailModel()
    
    var selectedCategory : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.view.setRightToLeftPinkGradientViewUI()

        objContestantListViewModel = ContestantListViewModel(vc: self)
        objContestantListViewModel.setDefaulstData()
        txtSearch.delegate = self
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.separatorStyle = .none
        
        tblView.register(UINib(nibName: Constant.CellIdentifier.CONTESTANT_LIST2, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier.CONTESTANT_LIST2)
        tblView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5))
        tblView.tableHeaderView?.backgroundColor = UIColor.white
        tblView.backgroundColor = Constant.Color.TABLE_VIEW_BG_COLOR
        
        tblView.refreshControl = objUIRefreshControl
        objUIRefreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        scrollViewFilter.indicatorStyle = .white
        setUIColor()
        getContestantListAPI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            AlertPresenter.alertInformation(fromVC: self, message: "aa")
//        }
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
    }

    override func viewWillDisappear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        dismissAlertInfoPresenter()
    }
    //MARK: custom method
    func setUIColor()
    {
        navBar.setUI(navBarText: "NAVIGATION_BAR_CONTESTANT_LIST")
        self.leftBarButton(navBar : navBar , imgName : Constant.Image.back_black)
        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station_black)
        
        txtSearch.setSearchUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_SEARCH_TITLE")
        btnSearchClose.setBackgroundImage(UIImage(named: Constant.Image.close), for: .normal)
        viewContSearch.rectViewWithBorderColor()
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        viewContSearch.isHidden = true
        
        let imgBannerTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.imgBannerTabbed))
        imgBanner.isUserInteractionEnabled = true
        imgBanner.addGestureRecognizer(imgBannerTabbed)
        
    }
    
    func setCategoryListUI()
    {
        var lblPrevious:UILabel!
        viewContCategorys.subviews.forEach({ $0.removeFromSuperview() })
        var index = 1
        let totalArraCount = objContestantListViewModel.arrMyFilterModel.count
        if(totalArraCount == 0)
        {
            cnsFilterCatViewHeight.constant = 0
        }else
        {
            cnsFilterCatViewHeight.constant = 45
            
            for myFilterModel in objContestantListViewModel.arrMyFilterModel
            {
                let lblTitleFilter:UILabel = UILabel()
                lblTitleFilter.translatesAutoresizingMaskIntoConstraints = false
               // lblTitleFilter.backgroundColor = UIColor.red
                viewContCategorys.addSubview(lblTitleFilter)
                
                lblTitleFilter.setCategoryList(value: "   \(myFilterModel.strCategoryName!)   ",lblHeight: 35)
                
                if(myFilterModel.isSelected == false)
                {
                    lblTitleFilter.backgroundColor = UIColor.white
                    lblTitleFilter.textColor = Constant.Color.LBL_TXT_PINK_COLOR
                }else
                {
                    lblTitleFilter.backgroundColor = Constant.Color.LBL_CELL_BG_PINK_TEXT
                    lblTitleFilter.textColor = Constant.Color.LBL_WHITE
                }
                
                if(index == 1)
                {
                    lblTitleFilter.leftAnchor.constraint(equalTo: viewContCategorys.leftAnchor, constant: 15).isActive = true
                }else
                {
                    lblTitleFilter.leftAnchor.constraint(equalTo: lblPrevious.rightAnchor, constant: 10).isActive = true
                }
                if(index == totalArraCount)
                {
                    lblTitleFilter.trailingAnchor.constraint(equalTo: viewContCategorys.trailingAnchor, constant: -15).isActive = true
                }
                
                lblTitleFilter.widthAnchor.constraint(equalToConstant: Util.getLblWidth(label: lblTitleFilter)).isActive = true
                lblTitleFilter.heightAnchor.constraint(equalToConstant: 35).isActive = true
                lblTitleFilter.topAnchor.constraint(equalTo: viewContCategorys.topAnchor, constant: 7).isActive = true
                lblPrevious = lblTitleFilter
                
                let lblTitleFilterTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.lblTitleFilterTabbed))
                lblTitleFilterTabbed.objLabel = lblTitleFilter
                lblTitleFilterTabbed.intIndex = index
                lblTitleFilter.isUserInteractionEnabled = true
                lblTitleFilter.addGestureRecognizer(lblTitleFilterTabbed)
                
                index += 1
            }
        }
    }
    
    func getFirstCategory() {
        if objContestantListViewModel.arrMyFilterModel.count != 0 {
            let objMyFilterModel = objContestantListViewModel.arrMyFilterModel[0]
            if objMyFilterModel.isSelected == true {
                objMyFilterModel.isSelected = false
                objContestantListViewModel.arrContestantDetailModel.removeAll()
                for objContestantDetailModel in objContestantListViewModel.arrOriginalContestantDetailModel
                {
                    if(objContestantDetailModel.strContestCategoryId == objMyFilterModel.strCategoryId)
                    {
                        objContestantListViewModel.arrContestantDetailModel.append(objContestantDetailModel)
                    }
                }
                tblView.reloadData()
                
                for myFilterModel in objContestantListViewModel.arrMyFilterModel {
                    if(objMyFilterModel.strCategoryName != myFilterModel.strCategoryName) {
                        myFilterModel.isSelected = false
                    }
                }
            }
        }
    }
    
    @objc func lblTitleFilterTabbed(_ sender: CustomTabGestur){
        
        let objMyFilterModel = objContestantListViewModel.arrMyFilterModel[sender.intIndex - 1]
        
        if(objMyFilterModel.isSelected == true)
        {
            objMyFilterModel.isSelected = false
            objContestantListViewModel.arrContestantDetailModel.removeAll()
            
            if selectedCategory == Int(objMyFilterModel.strCategoryId) {
                objContestantListViewModel.arrContestantDetailModel = objContestantListViewModel.arrOriginalContestantDetailModel
            }else {
                for objContestantDetailModel in objContestantListViewModel.arrOriginalContestantDetailModel
                {
                    if(objContestantDetailModel.strContestCategoryId == objMyFilterModel.strCategoryId)
                    {
                        objContestantListViewModel.arrContestantDetailModel.append(objContestantDetailModel)
                    }
                }
            }
            tblView.reloadData()
        }else
        {
            objMyFilterModel.isSelected = true
            objContestantListViewModel.arrContestantDetailModel.removeAll()
            for objContestantDetailModel in objContestantListViewModel.arrOriginalContestantDetailModel
            {
                if(objContestantDetailModel.strContestCategoryId == objMyFilterModel.strCategoryId)
                {
                    objContestantListViewModel.arrContestantDetailModel.append(objContestantDetailModel)
                }
            }
            tblView.reloadData()
        }
        
        for myFilterModel in objContestantListViewModel.arrMyFilterModel
        {
            if(objMyFilterModel.strCategoryName != myFilterModel.strCategoryName)
            {
                myFilterModel.isSelected = false
            }
            
        }
        selectedCategory = Int(objMyFilterModel.strCategoryId)
        setCategoryListUI()
    }
    
    func getContestantListAPI(isProcessShow:Bool = true) {
        isNetworkAvailable { (isSuccess) in
            if(Util.isNetworkReachable()) {
                if(isProcessShow)
                {
                    self.showProgress()
                }
                let objUserProfileModel = UserProfileModel()
                objUserProfileModel.strContestId = self.strContestId
                self.objContestantListViewModel.getContestantListAPI(objUser : objUserProfileModel)
            }else {
                self.objUIRefreshControl.endRefreshing()
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
    }
    
    func tableviewCellUI(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.CONTESTANT_LIST2) as! ContestantListCell2
                
        cell.selectionStyle = .none
        let objContestant = objContestantListViewModel.arrContestantDetailModel[indexPath.row]
        cell.viewContRenk.backgroundColor = Constant.Color.CONTESTANT_LIST_CELL_ONE_COLOR
        
        //        if(indexPath.row == 0 || indexPath.row == 1 ||  indexPath.row == 2)
        //        {
        cell.viewContRenk.backgroundColor = Constant.Color.CONTESTANT_LIST_CELL_ONE_COLOR
        cell.lblRenk.setLoginHeaderBigUIStyleWhiteCell(value: objContestant.strRank)
            
        if Int(objContestant.strRank) == 1 {
            cell.lblRenk.setLoginHeaderBigUIStyleWhiteCell(value: "\(objContestant.strRank!)\("LBL_ST".localizedLanguage())")
        }else if Int(objContestant.strRank) == 2 {
            cell.lblRenk.setLoginHeaderBigUIStyleWhiteCell(value: "\(objContestant.strRank!)\("LBL_ND".localizedLanguage())")
        } else if Int(objContestant.strRank) == 3 {
            cell.lblRenk.setLoginHeaderBigUIStyleWhiteCell(value: "\(objContestant.strRank!)\("LBL_RD".localizedLanguage())")
        }else {
//            cell.viewContRenk.backgroundColor = Constant.Color.CONTESTANT_LIST_CELL_THIRD_COLOR
        }
            
//        }else
//        {
//            cell.viewContRenk.backgroundColor = Constant.Color.CONTESTANT_LIST_CELL_THIRD_COLOR
//            cell.lblRenk.setLoginHeaderBigUIStyleWhiteCell(value: objContestant.strRank)
//        }
//        cell.imgUserProfile.getImageFromURL(url: objContestant.strUserProfileImgUrl)
        cell.imgUserProfile.getImageFromURL(url: objContestant.strThumbImgUrl)
        cell.imgUserProfile.setAspectFillImageInImageView()
        cell.imgUserProfile.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
        
        cell.lblUserName.setLoginHeaderUIStyleBlackCell(value: objContestant.strName)
        cell.lblUserVotes.setLoginHeaderBigUIStylePink(value: Util.intToNumberFormat(intValue:objContestant.strVoteCoin))
        
        cell.imgStar.setImageFit(imageName: Constant.Image.history_star)
        cell.btnVote.setTitle(txtValue: "BTN_CONTESTANT_LIST_VOTE")
        cell.updateFocusIfNeeded()
       // cell.btnVote.setBtnContestStatusPinkUICell()
        cell.btnVote.setBtnContestStatusPinkUI()
        //cell.btnVote.backgroundColor = Constant.Color.BTN_BACKGROUND_PINK
        cell.btnVote.addTarget(self, action: #selector(btnVoteClicked(sender:)), for: .touchUpInside)
        cell.btnVote.tag = indexPath.row
        // let viewContInfoPageTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContInfoPageTabbed))
       
        return cell
    }
    
    
    @objc func handleRefreshControl() {
        printDebug("handleRefreshControl")
        getContestantListAPI(isProcessShow: false)
    }
    
    //MARK:- Button clicked
    
    @IBAction func btnSearchClicked(_ sender: UIButton) {
        viewContSearch.isHidden = true
    }
    
   //MARK:- View model methods
    func onContestantListSuccess() {
        
        if(objContestantListViewModel.arrMyFilterModel.count != 0) {
            let objFirstCat = objContestantListViewModel.arrMyFilterModel[0]
            objFirstCat.isSelected = true
        }
        
        setCategoryListUI()
        getFirstCategory()
        
        if(objContestantListViewModel.getTableNumberOfSection() == 0)
        {
            showNoDataFoundDialog(uiView: viewCategoryAndList)
        }else
        {
            hideNoDataFoundDialog()
        }
        imgBanner.getImageFromURL(url: objContestantListViewModel.objContestDetail.strSubImageUrl, defImage: Constant.Image.Banner_iOS)
        imgBanner.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
        tblView.reloadData()
        objUIRefreshControl.endRefreshing()
    }
       
    func onApiSuccessHideProgress() {
        self.hideProgress()
        self.objUIRefreshControl.endRefreshing()
    }
    
    func showMessage(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    
    //MARK: Button Tabbed
    @objc override func leftBarButtonClick() {
        self.navigationController?.popViewController(animated: true)
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
    
    @objc func btnVoteClicked(sender: UIButton){
        print("btnVoteClicked : \(sender.tag)")
        if(Util.getIsUserLogin() == "0")
        {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
        }else
        {
            let startDate = Util.ConvertStringToDate(dateString: objContestantListViewModel.objContestDetail.strVoteStartDate, dateFormat: Constant.DateFormat.DateFormatYYYY_MM_DD_HH_MM_SS)
            
            let endDate = Util.ConvertStringToDate(dateString: objContestantListViewModel.objContestDetail.strVoteEndDate, dateFormat: Constant.DateFormat.DateFormatYYYY_MM_DD_HH_MM_SS)
            
//            if objContestantListViewModel.objContestDetail.strId == "47" {
//                startDate = Util.ConvertStringToDate(dateString: "2022-07-14 23:55:00", dateFormat: Constant.DateFormat.DateFormatYYYY_MM_DD_HH_MM_SS)
//
//                endDate = Util.ConvertStringToDate(dateString: "2022-08-14 23:55:00", dateFormat: Constant.DateFormat.DateFormatYYYY_MM_DD_HH_MM_SS)
//            }
            
            let todayDateValid = Date().isBetween(date: startDate, andDate: endDate)
            print("Open Date : \(startDate), End Date : \(endDate),  Is Today Date Valid? : \(todayDateValid)")
            
            
//            if objContestantListViewModel.objContestDetail.strStatus == Constant.ResponseParam.CONTEST_STATUS_OPEN {
            if todayDateValid {
                let objVotePopupVC = VotePopupVC()
                objVotePopupVC.myNavigationController = self.navigationController
                
                let objContestant = objContestantListViewModel.arrContestantDetailModel[sender.tag]
                objVotePopupVC.objContestant = objContestant
                objVotePopupVC.objContestantListVCDelegate = self
                
                objVotePopupVC.modalTransitionStyle = .crossDissolve
                objVotePopupVC.modalPresentationStyle = .overCurrentContext
                self.present(objVotePopupVC, animated: true, completion: nil)
            }else {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_IT_IS_NOT_VOTING_PERIOD")
            }
        }
    }
    
//    @objc override func rightBtnClickedWithImg2() {
//        print("rightBtnClickedWithImg2")
//        viewContSearch.isHidden = false
//
//    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print(textField.text ?? "")
    }
    
    //MARK:-  Tapped Methods clicked
//    @objc func viewContBannerDetailsTabbed(_ sender: CustomTabGestur){
//        print("viewContBannerDetailsTabbed")
//        let objWebViewWithBtnVC = WebViewWithBtnVC()
//        self.navigationController?.pushViewController(objWebViewWithBtnVC, animated: true)
//    }
    
    @objc func imgBannerTabbed(_ sender: CustomTabGestur){
        
        if objContestantListViewModel.objContestDetail.strWebViewUrl != "" {
            let objWebViewWithBtnVC = WebViewWithBtnVC()
            objWebViewWithBtnVC.strWebURL = objContestantListViewModel.objContestDetail.strWebViewUrl
            objWebViewWithBtnVC.strHomeUrl = objContestantListViewModel.objContestDetail.strHomePage
            self.navigationController?.pushViewController(objWebViewWithBtnVC, animated: true)
        }
    }
    
    @objc func viewContInfoPageTabbed(_ sender: CustomTabGestur){
        let objWebViewVC = WebViewVC()
        objWebViewVC.strNavBarTitle = "NAV_VOTING_GUIDE".localizedLanguage()
        self.navigationController?.pushViewController(objWebViewVC, animated: true)
        
    }

    @objc func viewContShareTabbed(_ sender: CustomTabGestur){
        let objWebViewVC = WebViewVC()
        objWebViewVC.strNavBarTitle = "NAV_ANNOUNCE_COMPETITION".localizedLanguage()
        self.navigationController?.pushViewController(objWebViewVC, animated: true)

    }
    
    @objc func viewContVotesButtonTabbed(_ sender: CustomTabGestur){
        if(Util.getIsUserLogin() == "0")
        {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
        }else
        {
            if objContestantListViewModel.objContestDetail.strStatus == Constant.ResponseParam.CONTEST_STATUS_OPEN {
                let objVotePopupVC = VotePopupVC()
                objVotePopupVC.myNavigationController = self.navigationController
                objVotePopupVC.modalTransitionStyle = .crossDissolve
                objVotePopupVC.modalPresentationStyle = .overCurrentContext
                self.present(objVotePopupVC, animated: true, completion: nil)
            }else {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_IT_IS_NOT_VOTING_PERIOD")
            }
        }
    }
}

extension ContestantListVC : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if(section == 0)
//        {
//            return UIView()
//        }else
//        {
//            let subviewArray = Bundle.main.loadNibNamed(Constant.CellIdentifier.CONTESTANT_LIST_HEADER_VIEW, owner: self, options: nil)
//
//            let viewHeader = subviewArray?[0] as? ContestantListHeaderView
//
//            viewHeader?.viewContVoteCount.backgroundColor = Constant.Color.VIEW_BG_TOTAL_QUANTITY_COLOR
//            viewHeader?.viewContInfoPage.backgroundColor = Constant.Color.VIEW_BG_FACEBOOK_COLOR
//            viewHeader?.viewContShare.backgroundColor = Constant.Color.VIEW_BG_TAB_BAR_COLOR
//
//            viewHeader?.lblVoteTitle.setLoginSmallUIStylePlaceHolderBlack(value: "Votes")
//             let voteCount:Int = 3556853
//            viewHeader?.lblVoteCount.setNormalUIStylePink(value: Util.intToNumberFormat(intValue:voteCount))
//
//            viewHeader?.lblInfoPage.setLoginNormalUIStyleWhite(value: "LBL_INFORMATION")
//            viewHeader?.lblShare.setLoginNormalUIStyleWhite(value: "LBL_SHARE")
//
//            viewHeader?.lblContestantListTitle.setLoginNormalUIStyleFullBack(value: "LBL_CONTESTANT")
//            viewHeader?.lblContestantListTime.setLoginSmallUIStylePlaceHolderBlack(value: "Time: 12.6 at 23:59")
//
//
//            let viewContInfoPageTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContInfoPageTabbed))
//            viewHeader?.viewContInfoPage.isUserInteractionEnabled = true
//            viewHeader?.viewContInfoPage.addGestureRecognizer(viewContInfoPageTabbed)
//
//            let viewContShareTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContShareTabbed))
//            viewHeader?.viewContShare.isUserInteractionEnabled = true
//            viewHeader?.viewContShare.addGestureRecognizer(viewContShareTabbed)
//
//            // self.viewHeader = viewHeader
//                    return viewHeader
//        }
//
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if(section == 0)
//        {
//            return 0.0
//        }else
//        {
//            return 90.0
//        }
//
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objContestantListViewModel.getTableNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return tableviewCellUI(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objContestantProfileVC = ContestantProfileVC()
        
        let objContestant = objContestantListViewModel.arrContestantDetailModel[indexPath.row]
        objContestantProfileVC.objContestant = objContestant
        
        objContestantProfileVC.objContestantListVCDelegate = self
        self.navigationController?.pushViewController(objContestantProfileVC, animated: true)
    }
}

extension ContestantListVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
//        if(textField == txtSearch) {
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
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if(textField == txtSearch) {
//            textField.resignFirstResponder()
//        }
        return true
    }
}

extension ContestantListVC: ContestantListVCDelegate {

    func reloadContestantProfileApi() {
        getContestantListAPI()
    }
}

extension ContestantListVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        // print("SlideMenuControllerDelegate: leftWillOpen")
    }
}

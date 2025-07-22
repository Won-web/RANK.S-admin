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

class VotingHistoryVC2: BaseVC {
    
    var objVotingHistoryViewModel : VotingHistoryViewModel!
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var imgBanner: UIImageView!
  
//    var searchedText : String = ""
//    @IBOutlet  var txtSearch: UITextField!
//    @IBOutlet var viewContSearch: UIView!
//    @IBOutlet var btnSearchClose: UIButton!
    
    @IBOutlet var lblRenking: UILabel!
    @IBOutlet var lblProfileNikName: UILabel!
    @IBOutlet var lblVote: UILabel!
    @IBOutlet var viewContVoteHistory: UIView!
    
    var strContestId:String!
    var strContestant:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objVotingHistoryViewModel = VotingHistoryViewModel(vc: self)
        
      //  self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        self.view.setRightToLeftPinkGradientViewUI()
      //  objContestantListViewModel.setDefaulstData()
        tblView.delegate = self
        tblView.dataSource = self
        
        tblView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshView(_:)), for: UIControl.Event.valueChanged)
        tblView.register(UINib(nibName: Constant.CellIdentifier.VOTING_HISTORY_CELL, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier.VOTING_HISTORY_CELL)
        
        tblView.tableFooterView = UIView()
        
        setUIColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissAlertInfoPresenter()
    }

    //MARK: custom method
    func setUIColor()
    {
        navBar.setUI(navBarText: "LBL_VOTING_HISTORY")
        self.leftBarButton(navBar : navBar , imgName : Constant.Image.back_black)
        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station_black)
        imgBanner.setImageFit(imageName: Constant.Image.Banner_iOS)
        imgBanner.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
        
        viewContVoteHistory.backgroundColor = Constant.Color.APP_VIEW_BG_HISTORY_TITLE
        
        lblRenking.setLoginNormalUIStyleWhite(value: "LBL_VOTE_HISTORY_RANKING")
        lblProfileNikName.setLoginNormalUIStyleWhite(value: "LBL_VOTE_HISTORY_PROFILE_NIK_NAME")
        lblVote.setLoginNormalUIStyleWhite(value: "LBL_VOTE_HISTORY_VOTES")
        
        let imgBannerTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.imgBannerTabbed))
        imgBanner.isUserInteractionEnabled = true
        imgBanner.addGestureRecognizer(imgBannerTabbed)
        getVotingListAPI()
    }
    
    func getVotingListAPI() {
        isNetworkAvailable { (isSuccess) in
            if(Util.isNetworkReachable()) {
                self.showProgress()
                
                let objVoteHistory = VoteHistory()
                objVoteHistory.strContestID = self.strContestId
                objVoteHistory.strContestantID = self.strContestant
                
                self.objVotingHistoryViewModel.getVotingHistoryListAPI(objVoteHistory: objVoteHistory)
            }else {
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
    }
    
    @objc func refreshView(_ sender: UIRefreshControl) {
        getVotingListAPI()
    }
    
    
    //MARK:- Button clicked
//    @IBAction func btnSearchClicked(_ sender: UIButton) {
//        viewContSearch.isHidden = true
//    }
    
    //MARK:- View model methods
    
    func onApiSuccessHideProgress() {
        self.hideProgress()
        refreshControl.endRefreshing()
    }
    
    func onSuccessApiResponce() {
        if(objVotingHistoryViewModel.strBannerImgUrl != "")
        {
            imgBanner.getImageFromURL(url: objVotingHistoryViewModel.strBannerImgUrl,defImage: Constant.Image.Banner_iOS)
        }
        if objVotingHistoryViewModel.arrVoteHistory.count == 0 {
            self.showNoDataFoundDialog(uiView: self.tblView)
        }else {
            self.hideNoDataFoundDialog()
            tblView.reloadData()
        }
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
       printDebug("btnVoteClicked : \(sender.tag)")
    }
    
//    @objc override func rightBtnClickedWithImg2() {
//        printDebug("rightBtnClickedWithImg2")
//        viewContSearch.isHidden = false
//
//    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        printDebug(textField.text ?? "")
    }
    
    //MARK:-  Tapped Methods clicked
    @objc func imgBannerTabbed(_ sender: CustomTabGestur){
//        let objWebViewWithBtnVC = WebViewWithBtnVC()
//        self.navigationController?.pushViewController(objWebViewWithBtnVC, animated: true)
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
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
        let objVotePopupVC = VotePopupVC()
        objVotePopupVC.myNavigationController = self.navigationController
        objVotePopupVC.modalTransitionStyle = .crossDissolve
        objVotePopupVC.modalPresentationStyle = .overCurrentContext
        self.present(objVotePopupVC, animated: true, completion: nil)
    }
}

extension VotingHistoryVC2 : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        objVotingHistoryViewModel.getNumberOfRecords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.VOTING_HISTORY_CELL) as! VotingHistoryCell
        
        cell.selectionStyle = .none
        cell.viewSeprator.backgroundColor = Constant.Color.VIEW_SEPRETOR_COLOR
        cell.imgStar.setImageFit(imageName: Constant.Image.history_star)
        
        let objVoteHistory = objVotingHistoryViewModel.arrVoteHistory[indexPath.row]
        
        cell.lblIndex.setBoldEditProfileThirdTitleBalck(value: objVoteHistory.ranking)
//        cell.lblName.setLoginNormalUIStyleBackForCell(value: objVoteHistory.name)
        cell.lblName.setLoginNormalUIStyleBackForCell(value: objVoteHistory.nick_name)
        
        let myVote : Int = Int(objVoteHistory.vote)!
        cell.lblCounter.setBoldEditProfileThirdTitleBalck(value: myVote.stringWithSepator(amount: myVote))
        
        return cell
    }
}

extension VotingHistoryVC2 : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        // printDebug("SlideMenuControllerDelegate: leftWillOpen")
    }
}

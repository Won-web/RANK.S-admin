//
//  WebViewChargingStationPaidVC.swift
//  RankingStar
//
//  Created by Hitarthi on 04/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit
import WebKit
import StoreKit


class WebViewChargingStationPaidVC: BaseVC {

    var objChargingStationPurchaseViewModel : ChargingStationPurchaseViewModel!
    
    @IBOutlet var navBar: UINavigationBar!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lblDot1: UILabel!
    @IBOutlet weak var lblDot2: UILabel!
//    @IBOutlet weak var lblDot3: UILabel!
    
    @IBOutlet weak var lblDetail1: UILabel!
    @IBOutlet weak var lblDetail2: UILabel!
//    @IBOutlet weak var lblDetail3: UILabel!
    
    @IBOutlet var viewContTotalQuantity: UIView!
    @IBOutlet var lblTitleTotal: UILabel!
    @IBOutlet var imgVRatingStar: UIImageView!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet weak var lblPiece: UILabel!
    
    var objIAPService:IAPServiceModel!

    var serverTransactionId:String = ""
    var purchasePlanListIdx:Int = -1
    
    var strNavBarTitle:String! = "NAV_TITLE_STAR_CHARING_STATION"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objChargingStationPurchaseViewModel = ChargingStationPurchaseViewModel(vc: self)
        
        self.view.setRightToLeftPinkGradientViewUI()
        navBar.setUI(navBarText: strNavBarTitle)
        self.leftBarButton(navBar: navBar, imgName: Constant.Image.back_black)
        
        tblView.delegate = self
        tblView.dataSource = self
        
        tblView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshView(_:)), for: UIControl.Event.valueChanged)
        tblView.register(UINib(nibName: Constant.CellIdentifier.CHARGING_POINT_PURCHASE_CELL, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier.CHARGING_POINT_PURCHASE_CELL)
        tblView.tableFooterView = UIView()
        refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: UIControl.Event.valueChanged)
        setUpUI()
        
        objIAPService = IAPServiceModel.shared
        objIAPService.getProducts()
        objIAPService.objIAPServiceModelDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        Util.appDelegate.objRefreshUserDetailsDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissAlertInfoPresenter()
        Util.appDelegate.objRefreshUserDetailsDelegate = nil
    }
    
    func setUpUI() {
        getPurchaseStarApi()
        
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
        //lblDot3.setLoginNormalUIStyleFullBack(value: ".")
        lblDetail1.setLoginNormalUIStyleFullBack(value: "LBL_PAID_CHARGING_STATION1")
        lblDetail1.font = Constant.Font.LBL_NORMAL_THIRD_TEXT
        lblDetail2.setLoginNormalUIStyleFullBack(value: "LBL_PAID_CHARGING_STATION2")
        lblDetail2.font = Constant.Font.LBL_NORMAL_THIRD_TEXT
//        lblDetail3.setLoginNormalUIStyleFullBack(value: "LBL_PAID_CHARGING_STATION3")
//        lblDetail3.font = Constant.Font.LBL_NORMAL_THIRD_TEXT
    }

    func getPurchaseStarApi() {
        isNetworkAvailable { (isSuccess) in
            if (Util.isNetworkReachable()) {
                self.showProgress()
                self.objChargingStationPurchaseViewModel.getChargingStarPurchaseAPI()
            }else {
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
    }
    
    func startPurchasePlan(_ plan:StarPurchasePlan, arrIdx idx:Int) {
        if(Util.getIsUserLogin() == "1") {
            if (Util.isNetworkReachable()) {
                self.showFullscreenProgressDialog()
                self.showProgress()
                
                purchasePlanListIdx = idx
                
                objChargingStationPurchaseViewModel.createTransation(ForPlan: plan, index: idx)
            }
            else {
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
    }
    
    func endPurchasePlan(state: TransactionStatus, paymentTransId: String!, desc: String, otherDetails: [String: String]!) {
        
        if (Util.isNetworkReachable()) {
            self.showFullscreenProgressDialog()
            self.showProgress()
            if(self.serverTransactionId != "") {
                self.objChargingStationPurchaseViewModel.completeTransaction(status: state, transactionId: self.serverTransactionId, paymentTransId: paymentTransId, desc: desc, otherDetails: otherDetails, index: purchasePlanListIdx)
            }
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    @objc func refreshWebView(_ sender: UIRefreshControl) {
        sender.endRefreshing()
    }
    
    @objc override func leftBarButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshView(_ sender: UIRefreshControl) {
        getPurchaseStarApi()
    }
    
    @objc func btnPriceTabbed(sender:CustomTabGestur)
    {
        printDebug("index = \(sender.intIndex)")
     
        if IAPServiceModel.shared.canMakePayments() {
            if (Util.isNetworkReachable()) {
                let objStarPurchasePlan = self.objChargingStationPurchaseViewModel.arrStarPurchasePlan[sender.intIndex]
                self.startPurchasePlan(objStarPurchasePlan, arrIdx: sender.intIndex)
            }
            else {
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
        else {
            AlertPresenter.alertInformation(fromVC: self, message: "In_App_NOT_SUPPORTED")
        }
    }
    
    //MARK:- View model methods
    func onApiSuccessHideProgress() {
        self.hideProgress()
        refreshControl.endRefreshing()
    }
    
    func onApiSuccessHideFullProgress() {
        self.hideProgress()
        self.hideFullscreenDialog()
    }
    
    func onCreateTransationComplete(status: Bool, message: String, transactionId: String, arrIdx: Int) {
        if status && transactionId.count > 0 {
            isNetworkAvailable { (isSuccess) in
                self.purchasePlanListIdx = arrIdx
                self.serverTransactionId = transactionId
                
                let objPurchasePlan = self.objChargingStationPurchaseViewModel.arrStarPurchasePlan[arrIdx]
                
                //IAPServiceModel.shared.
                if (Int(objPurchasePlan.star) == 120) {
                    IAPServiceModel.shared.purchase(product: .consumableW120, transactionId: transactionId)
                }else if (Int(objPurchasePlan.star) == 390) {
                    IAPServiceModel.shared.purchase(product: .consumableW390, transactionId: transactionId)
                }else  if (Int(objPurchasePlan.star) == 590) {
                    IAPServiceModel.shared.purchase(product: .consumableW590, transactionId: transactionId)
                }else  if (Int(objPurchasePlan.star) == 1100) {
                    IAPServiceModel.shared.purchase(product: .consumableW1100, transactionId: transactionId)
                }else  if (Int(objPurchasePlan.star) == 2000) {
                    IAPServiceModel.shared.purchase(product: .consumableW2000, transactionId: transactionId)
                }else {
                    AlertPresenter.alertInformation(fromVC: self, message: "ALERT_ITEM_UNAVAILABLE")
                }
            }
        }
        else {
            purchasePlanListIdx = -1
            serverTransactionId = ""
            AlertPresenter.alertInformation(fromVC: self, message: message)
        }
    }
    
    func onCompleteTransactionComplete(status: Bool, remainingStar: String, message: String, arrIdx: Int) {
        if(status) {
          AlertPresenter.alertInformation(fromVC: self, message: "ALT_TRANJACTION_SUCCESS")
            
            var dictData1:[String: Any]? = Util.getUserProfileDict()
            if(dictData1 != nil) {
                dictData1!["remaining_star"] = remainingStar
                Util.setUserProfileDict(strValue: dictData1!)
            }
            
            let myStar : Int = Int(remainingStar)!
            lblTotal.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
        }
        else {
            AlertPresenter.alertInformation(fromVC: self, message: message)
        }
        
    }
    
    func onSuccessApiResponce() {
        if objChargingStationPurchaseViewModel.arrStarPurchasePlan.count == 0 {
            self.showNoDataFoundDialog(uiView: self.tblView)
        }else {
            self.hideNoDataFoundDialog()
            tblView.reloadData()
        }
    }
    
    func showMessage(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
}

extension WebViewChargingStationPaidVC : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objChargingStationPurchaseViewModel.getNumberOfRecords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.CHARGING_POINT_PURCHASE_CELL) as! ChargingPurchasePointCell
        
        cell.selectionStyle = .none
        
        let objStarPurchasePlan = objChargingStationPurchaseViewModel.arrStarPurchasePlan[indexPath.row]
        cell.lblStaticText.setBoldEditProfileUIStylePink(value: "\("LBL_PAID_CHARGING_RANKING_STAR".localizedLanguage())")
        
        let star : Int = Int(objStarPurchasePlan.star)!
        cell.lblTitle.setBoldEditProfileUIStylePink(value: "\(star.stringWithSepator(amount: star))개")
        cell.lblTitle.textAlignment = .right
        cell.lblTitle.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
//        cell.lblSubTitle.setSmallUIStyleBlack(value: "보너스 \(objStarPurchasePlan.extra_star!)개")
        cell.lblSubTitle.setSmallUIStyleBlack(value: "")
        
        let price : Int = Int(objStarPurchasePlan.price)!
        cell.btnPrice.setTitle(txtValue: "₩\(price.stringWithSepator(amount: price))")
        cell.btnPrice.setBtnContestStatusPinkUI1()
        
        let btnPriceTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.btnPriceTabbed))
        btnPriceTabbed.intIndex = indexPath.row
        cell.btnPrice.isUserInteractionEnabled = true
        
        cell.btnPrice.addGestureRecognizer(btnPriceTabbed)
        
//        cell.lblTitle.setBoldEditProfileUIStylePink(value: "랭킹스타 100개")
//        cell.lblSubTitle.setSmallUIStyleBlack(value: "보너스 10개")
//        cell.btnPrice.setTitle(txtValue: "₩11,000")
//        cell.btnPrice.setBtnContestStatusPinkUI1()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension WebViewChargingStationPaidVC : IAPServiceModelDelegate {
    
    func purchseSuccess(updatedTransaction: SKPaymentTransaction) {
        print("purchseSuccess \(updatedTransaction.payment.productIdentifier)")
        
        handleTransaction(state: .success, transaction: updatedTransaction)
    }
    
    func purchseFail(updatedTransaction: SKPaymentTransaction) {
        print("purchseFail \(updatedTransaction.payment.productIdentifier)")
        
        handleTransaction(state: .fail, transaction: updatedTransaction)
    }
    
    private func handleTransaction(state: TransactionStatus, transaction: SKPaymentTransaction) {
        
        var otherDetails = [String:String]()
        if let dt = transaction.transactionDate {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            otherDetails["transactionDate"] = df.string(from: dt)
        }
        
        otherDetails["transaction.payment.productIdentifier"] = transaction.payment.productIdentifier
        
        var msg = "Purchase Completed"
        
        if state == .success {
            msg = "Purchase Successfully Completed"
        }
        else {
            if let err = transaction.error {
                msg = "Error: \(err.localizedDescription)"
            }
        }
        
        endPurchasePlan(state: state, paymentTransId: transaction.transactionIdentifier, desc: msg, otherDetails: otherDetails)
    }
    
    func tranjactionState(objSKPaymentTransactionState:SKPaymentTransactionState)
    {
        print("tranjactionState \(objSKPaymentTransactionState.status())")
        self.showProgress()
        if objSKPaymentTransactionState.status() != "purchasing" {
            self.hideProgress()
        }
    }
}

extension WebViewChargingStationPaidVC : RefreshUserDetailsDelegate {
    func getUserStar() {
       let dictData1:[String: Any]? = Util.getUserProfileDict()
       if(dictData1 != nil) {
           let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
           let myStar : Int = Int(objUserProfile.strRemainingStar)!
           lblTotal.setLoginHeaderBigUIStylePink(value: myStar.stringWithSepator(amount: myStar))
        
       }
    }
}

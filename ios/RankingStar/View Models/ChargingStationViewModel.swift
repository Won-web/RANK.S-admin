//
//  ChargingStationViewModel.swift
//  RankingStar
//
//  Created by Hitarthi on 12/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class ChargingStationViewModel: NSObject {
    
    private var vcRef : WebViewWithTabVC!
    var arrCategoryChargingStation = [CategoryChargingStation]()
    var objAttendenceCheck = AttendenceCheck()
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : WebViewWithTabVC!) {
        super.init()
        vcRef = vc
    }
    
    func getNumberOfRecords() -> Int {
        return arrCategoryChargingStation.count
    }
    
    func getUserProfileAPI(objUser : UserProfileModel) {
       
        let requestHelper = RequestHelper()
        
        requestHelper.getUserProfileAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                self.vcRef.onUserProfileSuccess()
            }else {
                self.vcRef.onUserProfileFail(message: resMessage)
            }
        })
    }
    
    func setCategoryData() {
        for i in 0..<6 {
            let objCategoryChargingStation = CategoryChargingStation()
            
            if i == 0 {
                objCategoryChargingStation.viewColor = Constant.Color.COLLECTION_CATE_1
                objCategoryChargingStation.title = "TOLL_STATION"
                objCategoryChargingStation.detail = "TOLL_STATION_DETAILS"
                arrCategoryChargingStation.append(objCategoryChargingStation)
            }else if i == 1 {
                objCategoryChargingStation.viewColor = Constant.Color.COLLECTION_CATE_2
                objCategoryChargingStation.title = "ATTENDANCE_CHECK"
                objCategoryChargingStation.detail = "ATTENDANCE_CHECK_DETAILS"
                arrCategoryChargingStation.append(objCategoryChargingStation)
            }else if i == 2 {
                objCategoryChargingStation.viewColor = Constant.Color.COLLECTION_CATE_2
                objCategoryChargingStation.title = "FREE_STATION"
                objCategoryChargingStation.detail = "FREE_STATION_DETAILS"
                arrCategoryChargingStation.append(objCategoryChargingStation)
            }else if i == 3 {
                objCategoryChargingStation.viewColor = Constant.Color.COLLECTION_CATE_1
                objCategoryChargingStation.title = "STAR_SHOP"
                objCategoryChargingStation.detail = "STAR_SHOP_DETAILS"
                arrCategoryChargingStation.append(objCategoryChargingStation)
            }else if i == 4 {
                objCategoryChargingStation.viewColor = Constant.Color.COLLECTION_CATE_1
                objCategoryChargingStation.title = "COUPAN_STATION"
                objCategoryChargingStation.detail = "COUPAN_STATION_DETAILS"
                arrCategoryChargingStation.append(objCategoryChargingStation)
            }else if i == 5 {
                objCategoryChargingStation.viewColor = Constant.Color.COLLECTION_CATE_2
                objCategoryChargingStation.title = "GIFT"
                objCategoryChargingStation.detail = "GIFT_DETAILS"
                arrCategoryChargingStation.append(objCategoryChargingStation)
            }
        }
    }
    
    func getAttendenceCheckAPI(userId : String) {
        let requestHelper = RequestHelper()
        
        requestHelper.getAttendenceCheckAPI(userID: userId, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                self.objAttendenceCheck = resObj as! AttendenceCheck
                
                self.vcRef.onSuccessApiResponce()
            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
    
}

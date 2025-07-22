//
//  LeadViewModel.swift
//  HafoosCRM
//
//  Created by etech-9 on 26/11/19.
//  Copyright © 2019 Tushar S. All rights reserved.
//

import UIKit

class MainViewModel: NSObject {

    private var vcRef : MainVC!
    
    var arrContestSlider:[ContestDetail] = []
    var arrSearchUserProfileModel:[UserProfileModel] = []
    var arrContestList:[ContestDetail] = []
    var hasMoreRecored = false
    var subContestPageNo = 1
    var hasMoreRecoredSearch = false
    var searchPageNo = 1
    
    var arrOpen = [ContestDetail]()
    var arrPreparing = [ContestDetail]()
    var arrClose = [ContestDetail]()
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : MainVC!) {
        super.init()
        vcRef = vc
    }
    

    func getTableNumberOfSection() -> Int {
        return arrContestList.count
    }
    
    func getContentListAPI(objUser : UserProfileModel) {
        subContestPageNo = 1
        arrContestList.removeAll()
        let requestHelper = RequestHelper()
        
        requestHelper.contentListAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in

            //self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                let objContestDetail = resObj as! ContestDetail
                
                //self.setDefaulstData()
                self.arrContestSlider = objContestDetail.arrContestDetail
                
              // self.vcRef.onSuccessApiResponce()
            }
            else{
               // self.vcRef.showMessage(message: resMessage)
            }
            
            let objUserProfileModel = UserProfileModel()
            objUserProfileModel.strPage = self.subContestPageNo
            //self.vcRef.showProgress()
            self.getSubContentListAPI(objUser: objUserProfileModel)
        })
    }
    
    func getSubContentListAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()
        
        requestHelper.subContentListAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            // self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                let objContestDetail = resObj as! ContestDetail
                self.hasMoreRecored = objContestDetail.hasMoreRecored
                self.arrContestList += objContestDetail.arrContestDetail
                
                self.arrOpen.removeAll()
                self.arrPreparing.removeAll()
                self.arrClose.removeAll()
                
                for i in 0..<self.arrContestList.count {
                    
                    let objContestSlider = self.arrContestList[i]
                    
                    if(Constant.ResponseParam.CONTEST_STATUS_OPEN == objContestSlider.strStatus) {
                        self.arrOpen.append(objContestSlider)
                    }else if(Constant.ResponseParam.CONTEST_STATUS_PREPARING == objContestSlider.strStatus) {
                        self.arrPreparing.append(objContestSlider)
                    }else {
                        self.arrClose.append(objContestSlider)
                    }
                }
                self.appendAllDataNumberVise()
                
            }
            else{
                self.vcRef.onSuccessApiResponce()
            }
        })
    }
    
    func getSearchListAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()
        requestHelper.getSearchListAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in

            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                let objUserProfileModel = resObj as! UserProfileModel
                self.arrSearchUserProfileModel.removeAll()
                self.arrSearchUserProfileModel = objUserProfileModel.arrUserProfileModel
                self.hasMoreRecoredSearch = objUserProfileModel.hasMoreRecored
//
//                self.hasMoreRecored = objContestDetail.hasMoreRecored
//                self.arrContestList += objContestDetail.arrContestDetail
                self.vcRef.onSuccessSearchApiResponce(isSuccess: true)
            }else
            {
                self.hasMoreRecoredSearch = false
                self.vcRef.onSuccessSearchApiResponce(isSuccess: false)
            }
            
        })
    }
    
    func getUserProfileAPI(objUser : UserProfileModel) {
       
        let requestHelper = RequestHelper()
        
        requestHelper.getUserProfileAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                self.vcRef.onUserProfileSuccess()
            }
        })
    }
    
    func appendAllDataNumberVise() {
        
        self.arrContestList.removeAll()
        self.arrContestList += arrOpen
        self.arrContestList += arrPreparing
        self.arrContestList += arrClose
        
        self.arrOpen.removeAll()
        self.arrPreparing.removeAll()
        self.arrClose.removeAll()
        
        self.vcRef.onSuccessApiResponce()
    }
    
//    func setDefaulstData()
//    {
//        arrContestSlider.removeAll()
//        arrContestList.removeAll()
//        let objContestDetail1 = ContestDetail()
//        objContestDetail1.strName = "2020 Miss Korea Contest"
//        objContestDetail1.strImageUrl = "contest4"
//        objContestDetail1.strStatus = "Voting"
//        
//        let objContestDetail2 = ContestDetail()
//        objContestDetail2.strName = "Spring Girl Crush Contest"
//        objContestDetail2.strImageUrl = "contest4"
//        objContestDetail2.strStatus = "Preparing"
//        
//        let objContestDetail3 = ContestDetail()
//        objContestDetail3.strName = "Spring Girl Crush Contest"
//        objContestDetail3.strImageUrl = "contest4"
//        objContestDetail3.strStatus = "Voting ends"
//        
//        let objContestDetail4 = ContestDetail()
//        objContestDetail4.strName = "Spring Girl Crush Contest"
//        objContestDetail4.strImageUrl = "contest5"
//        objContestDetail4.strStatus = "Voting ends"
//        
//        arrContestList.append(objContestDetail1)
//        arrContestList.append(objContestDetail2)
//        arrContestList.append(objContestDetail3)
//        arrContestList.append(objContestDetail3)
//        arrContestList.append(objContestDetail3)
//        arrContestList.append(objContestDetail3)
//        arrContestList.append(objContestDetail3)
//        arrContestList.append(objContestDetail3)
//        arrContestList.append(objContestDetail3)
//
//        
//        arrContestSlider.append(objContestDetail4)
//        arrContestSlider.append(objContestDetail4)
//        arrContestSlider.append(objContestDetail4)
//        arrContestSlider.append(objContestDetail4)
//        arrContestSlider.append(objContestDetail4)
//        arrContestSlider.append(objContestDetail4)
//        
//        
////        arrSearchUserProfileModel.removeAll()
////        let objUserProfileModel = UserProfileModel()
////        objUserProfileModel.strUserId = "1"
////        objUserProfileModel.strUserName = "Hong Gil Dong"
////        objUserProfileModel.strDetail = "Anatainer Korea Competition"
////
////        let objUserProfileModel2 = UserProfileModel()
////        objUserProfileModel2.strUserId = "1"
////        objUserProfileModel2.strUserName = "Gil Dong Kim"
////        objUserProfileModel2.strDetail = "Anatainer Korea Competition"
////
////        let objUserProfileModel3 = UserProfileModel()
////        objUserProfileModel3.strUserId = "1"
////        objUserProfileModel3.strUserName = "Hong Gil Dong"
////        objUserProfileModel3.strDetail = "Anatainer Korea Competition"
////
////
////        arrSearchUserProfileModel.append(objUserProfileModel)
////        arrSearchUserProfileModel.append(objUserProfileModel2)
////        arrSearchUserProfileModel.append(objUserProfileModel3)
//        
//        self.vcRef.onSuccessApiResponce()
//        
//    }
    
}

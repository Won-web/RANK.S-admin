//
//  LeadViewModel.swift
//  HafoosCRM
//
//  Created by etech-9 on 26/11/19.
//  Copyright © 2019 Tushar S. All rights reserved.
//

import UIKit

class ContestantListViewModel: NSObject {

    private var vcRef : ContestantListVC!
    
    var objContestDetail:ContestDetail!
    var arrContestantDetailModel:[ContestantDetailModel] = []
    var arrOriginalContestantDetailModel:[ContestantDetailModel] = []
    var arrMyFilterModel:[MyFilterModel] = []
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : ContestantListVC!) {
        super.init()
        vcRef = vc
    }
    

    func getTableNumberOfSection() -> Int {
        return arrContestantDetailModel.count
    }
    
    func getContestantListAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()
        
        requestHelper.getContestantListAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                let objContestantDetailModel = resObj as! ContestantDetailModel
                self.objContestDetail = objContestantDetailModel.objContestDetail
                self.arrContestantDetailModel = objContestantDetailModel.arrContestantDetailModel
                self.arrOriginalContestantDetailModel = objContestantDetailModel.arrContestantDetailModel
                self.arrMyFilterModel = objContestantDetailModel.arrMyFilterModel
                self.vcRef.onContestantListSuccess()
            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
    
    func setDefaulstData()
    {
//        arrContestantDetailModel.removeAll()
//        let objContestantDetailModel = ContestantDetailModel()
//        objContestantDetailModel.strName = "Seyeon Kim"
//        objContestantDetailModel.strUserProfileImgUrl = "people1"
//        objContestantDetailModel.strVoteCoin = 15200
//      //  objContestantDetailModel.strStatus = "Voting"
//
//        arrContestantDetailModel.append(objContestantDetailModel)
//        arrContestantDetailModel.append(objContestantDetailModel)
//        arrContestantDetailModel.append(objContestantDetailModel)
//        arrContestantDetailModel.append(objContestantDetailModel)
//        arrContestantDetailModel.append(objContestantDetailModel)
//        arrContestantDetailModel.append(objContestantDetailModel)
//        arrContestantDetailModel.append(objContestantDetailModel)
//        arrContestantDetailModel.append(objContestantDetailModel)
//        arrContestantDetailModel.append(objContestantDetailModel)
//        arrContestantDetailModel.append(objContestantDetailModel)
//        arrContestantDetailModel.append(objContestantDetailModel)
//        arrContestantDetailModel.append(objContestantDetailModel)
//        arrContestantDetailModel.append(objContestantDetailModel)
//        arrContestantDetailModel.append(objContestantDetailModel)
        
        arrMyFilterModel.removeAll()
        let objMyFilterModel = MyFilterModel()
        objMyFilterModel.strCategoryName = "Woman"
        objMyFilterModel.isSelected = false
        
        let objMyFilterModel1 = MyFilterModel()
        objMyFilterModel1.strCategoryName = "Man"
        objMyFilterModel1.isSelected = false
        
        let objMyFilterModel2 = MyFilterModel()
        objMyFilterModel2.strCategoryName = "Junior"
        objMyFilterModel2.isSelected = false
        
        let objMyFilterModel3 = MyFilterModel()
        objMyFilterModel3.strCategoryName = "Senior"
        objMyFilterModel3.isSelected = false
        
        let objMyFilterModel4 = MyFilterModel()
        objMyFilterModel4.strCategoryName = "Team"
        objMyFilterModel4.isSelected = false
        
//        let objMyFilterModel5 = MyFilterModel()
//        objMyFilterModel5.strCategoryName = "Category6"
//        objMyFilterModel5.isSelected = false
//
//        let objMyFilterModel6 = MyFilterModel()
//        objMyFilterModel6.strCategoryName = "Category7"
//        objMyFilterModel6.isSelected = false
        
        arrMyFilterModel.append(objMyFilterModel)
        arrMyFilterModel.append(objMyFilterModel1)
        arrMyFilterModel.append(objMyFilterModel2)
        arrMyFilterModel.append(objMyFilterModel3)
        arrMyFilterModel.append(objMyFilterModel4)
//        arrMyFilterModel.append(objMyFilterModel5)
//        arrMyFilterModel.append(objMyFilterModel6)
        
    }
    
    
    

    
    
}

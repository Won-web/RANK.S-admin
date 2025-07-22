//
//  NoticeListViewModel.swift
//  RankingStar
//
//  Created by Hitarthi on 05/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class NoticeListViewModel: NSObject {
    
    private var vcRef : NoticeVC!
    var arrNoticeList : [Notice] = []
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : NoticeVC!) {
        super.init()
        vcRef = vc
    }
    
    func getNumberOfRecords() -> Int {
        return arrNoticeList.count
    }
    
    func getNoticeListAPI() {
        let requestHelper = RequestHelper()
        
        requestHelper.getNoticeListAPI(resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in
            
             self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                
                let objNotice = resObj as! Notice
                self.arrNoticeList = objNotice.arrNotice
                
                self.vcRef.onSuccessApiResponce()
            }
            else{
                self.vcRef.onFailApiResponce(message: resMessage)
            }
        })
    }
}

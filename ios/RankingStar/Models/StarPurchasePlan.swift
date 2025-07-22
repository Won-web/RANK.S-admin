//
//  StarPurchasePlan.swift
//  RankingStar
//
//  Created by Hitarthi on 15/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class StarPurchasePlan: NSObject {
    
    var plan_id : String!
    var plan_name : String!
    var desc : String!
    var star : String!
    var price : String!
    var extra_star : String!
    var status : String!
    var product_id : String!
    var created_date : String!
    var updated_date : String!
    var arrPlanList = [StarPurchasePlan]()
    
    static func dictToUserObjectConvertionContest(dictData : [String:Any]) -> [StarPurchasePlan] {
        
        var arrStarPurchase = [StarPurchasePlan]()
        
        if let arrData = dictData["plan_list"] as? [[String:Any]] {
            
            arrData.forEach { (starPlanDic) in
                let objPlanList = StarPurchasePlan()
                
                if let data = starPlanDic["plan_id"] as? String {
                    objPlanList.plan_id = data
                }
                if let data = starPlanDic["plan_name"] as? String {
                    objPlanList.plan_name = data
                }
                if let data = starPlanDic["description"] as? String {
                    objPlanList.desc = data
                }
                if let data = starPlanDic["star"] as? String {
                    objPlanList.star = data
                }
                if let data = starPlanDic["price"] as? String {
                    objPlanList.price = data
                }
                if let data = starPlanDic["product_id"] as? String {
                    objPlanList.product_id = data
                }
                if let data = starPlanDic["extra_star"] as? String {
                    objPlanList.extra_star = data
                }
                if let data = starPlanDic["status"] as? String {
                    objPlanList.status = data
                }
                if let data = starPlanDic["created_date"] as? String {
                    objPlanList.created_date = data
                }
                if let data = starPlanDic["updated_date"] as? String {
                    objPlanList.updated_date = data
                }
                
                arrStarPurchase.append(objPlanList)
            }
        }
        
        return arrStarPurchase
    }
}

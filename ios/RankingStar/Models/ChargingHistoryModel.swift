//
//  ChargingHistoryModel.swift
//  RankingStar
//
//  Created by Jinesh on 17/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit

class ChargingHistoryModel: NSObject {
    
    var vote_id : String!
    var contest_id : String!
    var contestant_id : String!
    var voter_id : String!
//    var vote : String!
    var desc : String!
    var date : String!
    var name : String!
    var contest_name : String!
    var type : String!
    var receiver_name : String!
    
    var purchase_id : String!
    var user_id : String!
//    var contest_id : String!
    var star : String!
    var amount : String!
    var refund : String!
//    var desc : String!
    var usage_type : String!
    var purchase_date : String!
    var created_date : String!
    var updated_date : String!
//    var contest_name : String!
    var Sender_name : String!
    
    var remaningStar : String!
    var arrEarning = [ChargingHistoryModel]()
    var arrUsage = [ChargingHistoryModel]()
    
    static func dictToUserObjectConvertion(dictData : [String:Any]) -> ChargingHistoryModel {
             
        let objStarHistory = ChargingHistoryModel()
        
        if let data = dictData["remaining_star"] as? String {
            objStarHistory.remaningStar = data
        }
        
        if let arrUsageData = dictData["usage_history"] as? [[String:Any]] {
            
            arrUsageData.forEach { (objUsage) in
                let objUsageData = getUsageData(usageData: objUsage)
                objStarHistory.arrUsage.append(objUsageData)
            }
        }
        
        if let arrEarningData = dictData["purchase_history"] as? [[String:Any]] {
            
            arrEarningData.forEach { (objEarning) in
                let objEarningData = getEarningData(earningData: objEarning)
                objStarHistory.arrEarning.append(objEarningData)
            }
        }
        return objStarHistory
    }
    
    static func getEarningData(earningData : [String:Any]) -> ChargingHistoryModel {
        let objEarning = ChargingHistoryModel()
        
        if let data = earningData["purchase_id"] as? String {
            objEarning.purchase_id = data
        }
        if let data = earningData["user_id"] as? String {
            objEarning.user_id = data
        }
        if let data = earningData["contest_id"] as? String {
            objEarning.contest_id = data
        }
        if let data = earningData["star"] as? String {
            objEarning.star = data
        }
        if let data = earningData["amount"] as? String {
            objEarning.amount = data
        }
        if let data = earningData["refund"] as? String {
            objEarning.refund = data
        }
        if let data = earningData["description"] as? String {
            objEarning.desc = data
        }
        if let data = earningData["type"] as? String {
            objEarning.type = data
        }
        if let data = earningData["purchase_date"] as? String {
            objEarning.purchase_date = data
        }
        if let data = earningData["created_date"] as? String {
            objEarning.created_date = data
        }
        if let data = earningData["updated_date"] as? String {
            objEarning.updated_date = data
        }
        if let data = earningData["contest_name"] as? String {
            objEarning.contest_name = data
        }
        if let data = earningData["Sender_name"] as? String {
            objEarning.Sender_name = data
        }
        
        return objEarning
    }
    
    static func getUsageData(usageData : [String:Any]) -> ChargingHistoryModel {
        let objUsage = ChargingHistoryModel()
        
        if let data = usageData["vote_id"] as? String {
            objUsage.vote_id = data
        }
        if let data = usageData["contest_id"] as? String {
            objUsage.contest_id = data
        }
        if let data = usageData["contestant_id"] as? String {
            objUsage.contestant_id = data
        }
        if let data = usageData["voter_id"] as? String {
            objUsage.voter_id = data
        }
        if let data = usageData["star"] as? String {
            objUsage.star = data
        }
        if let data = usageData["description"] as? String {
            objUsage.desc = data
        }
        if let data = usageData["date"] as? String {
            objUsage.date = data
        }
        if let data = usageData["name"] as? String {
            objUsage.name = data
        }
        if let data = usageData["contest_name"] as? String {
            objUsage.contest_name = data
        }
        if let data = usageData["type"] as? String {
            objUsage.usage_type = data
        }
        if let data = usageData["receiver_name"] as? String {
            objUsage.receiver_name = data
        }
        
        return objUsage
    }
}

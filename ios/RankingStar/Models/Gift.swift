//
//  Gift.swift
//  RankingStar
//
//  Created by Hitarthi on 19/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class Gift: NSObject {

    var strReceiverID : String!
    var strSenderID : String!
    var strSenderName : String!
    var strStar : String!
    
    var avilableStar : String!
    
    static func dictToUserObjectConvertionContest(dictData : [String:Any]) -> Gift {
        let objGift = Gift()
        
        if let objData = dictData["star_details"] as? [String:Any] {
            
            if let data = objData["available_star"] as? String {
                objGift.avilableStar = data
            }
        }
        
        return objGift
    }
}

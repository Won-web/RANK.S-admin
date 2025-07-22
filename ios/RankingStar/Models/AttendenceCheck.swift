//
//  AttendenceCheck.swift
//  RankingStar
//
//  Created by Hitarthi on 19/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class AttendenceCheck: NSObject {

    var available_star : String!
    
    static func dictToUserObjectConvertionContest(dictData : [String:Any]) -> AttendenceCheck {
        let objAttendenceCheck = AttendenceCheck()
        
        if let objData = dictData["star_details"] as? [String:Any] {
            
            if let data = objData["available_star"] as? String {
                objAttendenceCheck.available_star = data
            }
        }
        
        return objAttendenceCheck
    }
}

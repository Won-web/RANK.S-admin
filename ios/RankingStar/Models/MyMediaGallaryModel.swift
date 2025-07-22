//
//  MyMediaGallaryModel.swift
//  RankingStar
//
//  Created by Jinesh on 06/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

class MyMediaGallaryModel: NSObject {
    
    var srtMediaId:String!
    var srtContestantId:String!
    var srtMediaName:String!
    var srtMediaPath:String!
    var srtThumbPath:String!
    var srtMediaType:String!
    var srtStatus:String!
    var srtCreatedDate:String!
    var srtUpdatedDate:String!
    
    var arrMyMediaGallaryModel = [MyMediaGallaryModel]()

    static func dictToUserObjectConvertionMediaGallary(dictData : NSDictionary) -> MyMediaGallaryModel {
        
        let arrData = dictData["media_details"] as! NSArray
        let objMyMediaGallaryModel = MyMediaGallaryModel()
        objMyMediaGallaryModel.arrMyMediaGallaryModel.removeAll()
        for objContest in arrData
        {
            let objRef = MyMediaGallaryModel()
            let objContestDict = objContest as! NSDictionary
            
            if let objRefData = objContestDict["media_id"] as? String {
                objRef.srtMediaId = String(objRefData)
            }
            if let objRefData = objContestDict["contestant_id"] as? String {
                objRef.srtContestantId = String(objRefData)
            }
            if let objRefData = objContestDict["media_name"] as? String {
                objRef.srtMediaName = String(objRefData)
            }
            
            if let objRefData = objContestDict["media_path"] as? String {
                objRef.srtMediaPath = String(objRefData)
            }
            if let objRefData = objContestDict["thumb_path"] as? String {
                objRef.srtThumbPath = String(objRefData)
            }
            
            if let objRefData = objContestDict["media_type"] as? String {
                objRef.srtMediaType = String(objRefData)
            }
            if let objRefData = objContestDict["status"] as? String {
                objRef.srtStatus = String(objRefData)
            }
            if let objRefData = objContestDict["created_date"] as? String {
                objRef.srtCreatedDate = String(objRefData)
            }
            
            if let objRefData = objContestDict["updated_date"] as? String {
                objRef.srtUpdatedDate = String(objRefData)
            }
            objMyMediaGallaryModel.arrMyMediaGallaryModel.append(objRef)
        }
        return objMyMediaGallaryModel
    }
}

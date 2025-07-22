//
//  LeadViewModel.swift
//  HafoosCRM
//
//  Created by etech-9 on 26/11/19.
//  Copyright © 2019 Tushar S. All rights reserved.
//

import UIKit

class ContestantProfileViewModel: NSObject {

    private var vcRef : ContestantProfileVC!
    
//    var arrChargingHistoryModel = [ChargingHistoryModel]()
    var objUserProfileModel = UserProfileModel()
    var arrMyMediaGallaryModel = [MyMediaGallaryModel]()
    var arrMyMediaGallaryModelImage = [MyMediaGallaryModel]()
    var arrMyMediaGallaryModelVideo = [MyMediaGallaryModel]()
    var arrMyMediaGallaryModelYouTubeVideo = [MyMediaGallaryModel]()
    //var arrUserMessageInfo:[UserMessageInfo] = []
   
    
    private convenience override init() {
        self.init(vc:nil)
    }
    
    init(vc : ContestantProfileVC!) {
        super.init()
        vcRef = vc
    }
    

    func getTableNumberOfSection() -> Int {
        return arrMyMediaGallaryModelImage.count
    }
    
    func getNumberOfTableRow(_ forSection : Int) -> Int {
        return 0
    }
    
    func getnumberOfVideos() -> Int {
        return arrMyMediaGallaryModelVideo.count
    }
    
    func getNumberOfYouTubeVideos() -> Int {
        return arrMyMediaGallaryModelYouTubeVideo.count
    }
    
    func getContestantDetailsAPI(objUser : UserProfileModel) {
        let requestHelper = RequestHelper()

        requestHelper.getContestantDetailsAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in

            self.vcRef.onApiSuccessHideProgress()
            if resCode == Constant.ResponseStatus.SUCCESS {
                self.objUserProfileModel = resObj as! UserProfileModel
                self.vcRef.contestantDetailSuccessResponse()
//                arrChargingHistoryModel = resObj as! arrChargingHistoryModel

            }
            else{
                self.vcRef.showMessage(message: resMessage)
            }
        })
    }
    
    func getMediaGallaryAPI(objUser : UserProfileModel) {
            let requestHelper = RequestHelper()

            requestHelper.getMediaGallaryAPI(objUser: objUser, resBlock: { (_ resObj : NSObject ,_ resCode : Int,_ resMessage : String) -> Void in

                self.vcRef.onApiSuccessHideProgress()
                self.arrMyMediaGallaryModelYouTubeVideo.removeAll()
                if resCode == Constant.ResponseStatus.SUCCESS {
                    self.arrMyMediaGallaryModelImage.removeAll()
                    self.arrMyMediaGallaryModelVideo.removeAll()
                    self.arrMyMediaGallaryModelYouTubeVideo.removeAll()
                    self.arrMyMediaGallaryModel.removeAll()
                    let objMyMediaGallaryModel = resObj as! MyMediaGallaryModel
                    self.arrMyMediaGallaryModel = objMyMediaGallaryModel.arrMyMediaGallaryModel
                    for imgaeMedia in objMyMediaGallaryModel.arrMyMediaGallaryModel
                    {
                        if(imgaeMedia.srtMediaType == Constant.ResponseParam.MEDIA_TYPE_IMAGE)
                        {
                          self.arrMyMediaGallaryModelImage.append(imgaeMedia)
                        }else if(imgaeMedia.srtMediaType == Constant.ResponseParam.MEDIA_TYPE_VIDEO)
                        {
                            self.arrMyMediaGallaryModelVideo.append(imgaeMedia)
                        }else if(imgaeMedia.srtMediaType == Constant.ResponseParam.MEDIA_TYPE_YOUTUBE_VIDEO)
                        {
                            self.arrMyMediaGallaryModelYouTubeVideo.append(imgaeMedia)
                        }
                    }
                    self.vcRef.mediaGallarySuccessResponse()
                }
                else{
                    self.arrMyMediaGallaryModel.removeAll()
                    self.arrMyMediaGallaryModelImage.removeAll()
                    self.vcRef.showMessageForMediaGallery(message: resMessage)
                }
            })
        }
    
    func setDefaulstData()
    {
        let  objUserHobbiesModel1 = UserHobbiesModel()
        objUserHobbiesModel1.strHobbiesName = "Age"
        objUserHobbiesModel1.strHobbiesDetail = "25years old"
        
        let  objUserHobbiesModel2 = UserHobbiesModel()
        objUserHobbiesModel2.strHobbiesName = "Height"
        objUserHobbiesModel2.strHobbiesDetail = "172cm"
        
        let  objUserHobbiesModel3 = UserHobbiesModel()
        objUserHobbiesModel3.strHobbiesName = "Weight"
        objUserHobbiesModel3.strHobbiesDetail = "51kg"
        
        let  objUserHobbiesModel4 = UserHobbiesModel()
        objUserHobbiesModel4.strHobbiesName = "Other"
        objUserHobbiesModel4.strHobbiesDetail = "Participated in"
        
        objUserProfileModel.objUserHobbiesModel1.append(objUserHobbiesModel1)
        objUserProfileModel.objUserHobbiesModel1.append(objUserHobbiesModel2)
        objUserProfileModel.objUserHobbiesModel1.append(objUserHobbiesModel3)
        objUserProfileModel.objUserHobbiesModel1.append(objUserHobbiesModel4)
        
        
        let  objUserHobbies2Model1 = UserHobbiesModel()
        objUserHobbies2Model1.strHobbiesName = "Education"
        objUserHobbies2Model1.strHobbiesDetail = "Damkang University, Taiwan"
        
        let  objUserHobbies2Model2 = UserHobbiesModel()
        objUserHobbies2Model2.strHobbiesName = "Major"
        objUserHobbies2Model2.strHobbiesDetail = "Diplomatic and International Relations"
        
        let  objUserHobbies2Model3 = UserHobbiesModel()
        objUserHobbies2Model3.strHobbiesName = "Plans"
        objUserHobbies2Model3.strHobbiesDetail = "Damkang University, Taiwan"
        
        let  objUserHobbies2Model4 = UserHobbiesModel()
        objUserHobbies2Model4.strHobbiesName = "hobby"
        objUserHobbies2Model4.strHobbiesDetail = "Traveling, Reading, Gundam Model, Bowling"
        
        let  objUserHobbies2Model5 = UserHobbiesModel()
        objUserHobbies2Model5.strHobbiesName = "specialty"
        objUserHobbies2Model5.strHobbiesDetail = "Foreign Language, Exercise, Makeup, Playing with Cats"
        
       
        objUserProfileModel.objUserHobbiesModel2.append(objUserHobbies2Model1)
        objUserProfileModel.objUserHobbiesModel2.append(objUserHobbies2Model2)
        objUserProfileModel.objUserHobbiesModel2.append(objUserHobbies2Model3)
        objUserProfileModel.objUserHobbiesModel2.append(objUserHobbies2Model4)
        objUserProfileModel.objUserHobbiesModel2.append(objUserHobbies2Model5)
        
        
    }
    
    

    
    
}

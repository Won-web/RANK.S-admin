//
//  LoginVC.swift
//  RankingStar
//
//  Created by Jinesh on 13/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit
import Material
import Photos
import AssetsPickerViewController
import ActionSheetPicker_3_0
import AVKit
import SlideMenuControllerSwift
import MobileCoreServices
import Alamofire
import GTProgressBar


class EditprofileContestantSelfVC: BaseVC {
    
    var objEditprofileContestantSelfModel : EditprofileContestantSelfViewModel!
    @IBOutlet var navBar: UINavigationBar!
    
    @IBOutlet var lblCollectionText: UILabel!
    @IBOutlet var objCollectionView: UICollectionView!
    
    @IBOutlet var imgUserImage: UIImageView!
    
    var searchedText : String = ""
    @IBOutlet  var txtSearch: UITextField!
    @IBOutlet var viewContSearch: UIView!
    @IBOutlet var viewContSepretor: UIView!
    @IBOutlet var viewContSepretor2: UIView!
    @IBOutlet var btnSearchClose: UIButton!
    
    @IBOutlet var imgUserProfile: UIImageView!
    @IBOutlet var btnEditUserProfile: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var lblTitleUserInfo: UILabel!
    @IBOutlet var txtVUserInfo: UITextView!
    @IBOutlet var imgDeleteUserInfo: UIImageView!
    
    @IBOutlet var cnsCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cnsIntroViewHeight: NSLayoutConstraint!
    
    @IBOutlet var viewProfileDetailBottom: UIView!
    @IBOutlet var lblProfileTitle: UILabel!
    @IBOutlet var lblProfileNameText: UILabel!
    @IBOutlet var lblProfileNameValue: UILabel!
    @IBOutlet var lblProfileMobText: UILabel!
    @IBOutlet var lblProfileMobValue: UILabel!
    @IBOutlet var lblProfileEmailText: UILabel!
    @IBOutlet var lblProfileEmailValue: UILabel!
    @IBOutlet var viewContProgress: UIView!
    
    @IBOutlet weak var lblYouTubeVideoLink: UILabel!
    @IBOutlet weak var txtFYoutubeLink1: UITextField!
    @IBOutlet weak var txtFYoutubeLink2: UITextField!
    @IBOutlet weak var txtFYoutubeLink3: UITextField!
    @IBOutlet weak var viewYouTubeLink1: UIView!
    @IBOutlet weak var viewYouTubeLink2: UIView!
    @IBOutlet weak var viewYouTubeLink3: UIView!
    
    @IBOutlet weak var imgYouTubeLinkClose1: UIImageView!
    @IBOutlet weak var imgYouTubeLinkClose2: UIImageView!
    @IBOutlet weak var imgYouTubeLinkClose3: UIImageView!
    
    var isEditProfileBtnClicked = false
    var selectedImgUserProfile = UIImage()
    
    var isClickedVideoSelection:Bool = false
    
    var intVideoMaxRecoredSecond:Double = 5 * 60
    var objContestantProfileVCDelegate:ContestantProfileVCDelegate!
    var strDeleteMediaGallryItem:Int = -1
    var maximumImgSelectionCount:Int = 10
    var maximumVideoSelectionCount:Int = 3
    var arrStrIndexOfImgs:[Int] = [Int]()
    var arrStrIndexOfImgsNextTry:[Int] = [Int]()
    var imageUploadTryCount:Int = 1
    var imageUploadTryMaxCount:Int = 3
    
    var arrStrIndexOfVideos:[Int] = [Int]()
    var arrStrIndexOfVideosNextTry:[Int] = [Int]()
    var videosUploadTryCount:Int = 1
    var videosUploadTryMaxCount:Int = 3
    
    var arrYouTubeVideoUrl = [MyMediaGallaryModel]()
    var ID1 = ""
    var ID2 = ""
    var ID3 = ""
    
    var url1 = ""
    var url2 = ""
    var url3 = ""
   // var isProfileUpdateSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        viewContProgress.isHidden = true
        self.view.setRightToLeftPinkGradientViewUI()
        
        txtVUserInfo.delegate = self
        
        // objEditprofileContestantSelfModel = EditprofileContestantSelfViewModel(vc: self)
        objCollectionView.register(UINib(nibName: Constant.CellIdentifier.EDIT_PROFILE_IMAGE_VIDEO_CELL, bundle: nil), forCellWithReuseIdentifier: Constant.CellIdentifier.EDIT_PROFILE_IMAGE_VIDEO_CELL)
        objCollectionView.dataSource = self
        objCollectionView.delegate = self
        objCollectionView.isScrollEnabled = false
        manageSizeOfCollectionViewCell()
        setCollectionViewSize()
        setUIColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        dismissAlertInfoPresenter()
        FileManager.default.clearTmpDirectory()
    }
    //MARK: custom method
    func setUIColor()
    {
        //        Util.statusBarColor(color: Constant.Color.NAVIGATION_BAR_BG_COLOR)
        navBar.setUI(navBarText: "NAVIGATION_BAR_EDIT_PROFILE_SELF")
        self.leftBarButton(navBar : navBar , imgName : Constant.Image.back_black)
        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station_black)
        //        self.rightBarSingleBtnWithImage2(navBar: navBar, imgName1: Constant.Image.menu, imgName2: Constant.Image.search)
        
        txtSearch.setSearchUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_SEARCH_TITLE")
        btnSearchClose.setBackgroundImage(UIImage(named: Constant.Image.close), for: .normal)
        viewContSearch.rectViewWithBorderColor()
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        viewContSearch.isHidden = true
        
        viewContSepretor.backgroundColor = Constant.Color.VIEW_SEPRETOR_COLOR
        viewContSepretor2.backgroundColor = Constant.Color.VIEW_SEPRETOR_COLOR
        
        if(objEditprofileContestantSelfModel.objUserProfileModel.strImageUrl != "")
        {
            imgUserProfile.getImageFromURL(url: objEditprofileContestantSelfModel.objUserProfileModel.strImageUrl)
            imgUserProfile.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
            imgUserProfile.setAspectFillImageInImageView()
            //            imgUserProfile.setFillImageInImageView()
        }
        
        btnEditUserProfile.setBtnEditProfileUI()
        btnEditUserProfile.setTitle(txtValue: "BTN_EDIT_PROFILE_IMAGE")
        btnEditUserProfile.setViewshadow()
        //        btnEditUserProfile.setBtnEditUserProfileUI()
        
        //Hide Edit Profile Button
        btnEditUserProfile.isHidden = true
        
        lblTitleUserInfo.setEditProfileHeaderUIStyleFullBack(value: "LBL_PROFILE_MY_WORD")
        txtVUserInfo.setRectViewTxtNormalBlack(value: objEditprofileContestantSelfModel.objUserProfileModel.strMyIntro)
        
        txtVUserInfo.adjustUITextViewHeight()
        let size : CGSize = self.txtVUserInfo.contentSize;
        if size.height >= 70 {
            cnsIntroViewHeight.constant = size.height + 30
        }else {
            cnsIntroViewHeight.constant = 100
        }
        
        imgDeleteUserInfo.image = UIImage(named: Constant.Image.close1)
        btnSave.setTitle(txtValue: "BTN_EDIT_PROFILE_SAVE")
        btnSave.setBtnSignUpUI()
        
        lblCollectionText.setCollectionTitleUIStyle(value: "LBL_PHOTOS_VIDEO")
        
        lblYouTubeVideoLink.setCollectionTitleUIStyle(value: "LBL_YOUTUBE_LINK")
        txtFYoutubeLink1.setUIWithPlaceholderTxtBlackBig(placeHolder: "PLEASE_ENTER_YOUTUBE_LINK")
        txtFYoutubeLink2.setUIWithPlaceholderTxtBlackBig(placeHolder: "PLEASE_ENTER_YOUTUBE_LINK")
        txtFYoutubeLink3.setUIWithPlaceholderTxtBlackBig(placeHolder: "PLEASE_ENTER_YOUTUBE_LINK")
        
        getTextfieldYouTubeUrl()
        
        viewYouTubeLink1.backgroundColor = Constant.Color.TXTF_BG_COLOR
        viewYouTubeLink2.backgroundColor = Constant.Color.TXTF_BG_COLOR
        viewYouTubeLink3.backgroundColor = Constant.Color.TXTF_BG_COLOR
        
        imgYouTubeLinkClose1.image = UIImage(named: Constant.Image.close1)
        imgYouTubeLinkClose2.image = UIImage(named: Constant.Image.close1)
        imgYouTubeLinkClose3.image = UIImage(named: Constant.Image.close1)
        
        viewProfileDetailBottom.backgroundColor = Constant.Color.TXTF_BG_COLOR
        lblProfileTitle.setEditProfileUIStyle(value: "LBL_PROFILE_TEXT")
        lblProfileNameText.setEditProfileUIStyle1(value: "LBL_PROFILE_NAME")
        lblProfileMobText.setEditProfileUIStyle1(value: "LBL_PROFILE_MOB")
        lblProfileEmailText.setEditProfileUIStyle1(value: "LBL_PROFILE_EMAIL")
        
        lblProfileNameValue.setEditProfileUIStyle1(value: "")
        lblProfileMobValue.setEditProfileUIStyle1(value: "")
        lblProfileEmailValue.setEditProfileUIStyle1(value: "rankingstar.2020@gmail.com")
        
        hideBottomView()
    }
    
    func hideBottomView() {
        viewProfileDetailBottom.backgroundColor = UIColor.clear
        lblProfileTitle.setEditProfileUIStyle(value: "")
        lblProfileNameText.setEditProfileUIStyle1(value: "")
        lblProfileMobText.setEditProfileUIStyle1(value: "")
        lblProfileEmailText.setEditProfileUIStyle1(value: "")
        
        lblProfileNameValue.setEditProfileUIStyle1(value: "")
        lblProfileMobValue.setEditProfileUIStyle1(value: "")
        lblProfileEmailValue.setEditProfileUIStyle1(value: "")
    }
    
    func getTextfieldYouTubeUrl() {
        let arrCount = arrYouTubeVideoUrl.count
        
        if arrCount == 1 {
            url1 = arrYouTubeVideoUrl[0].srtMediaName
            ID1 = arrYouTubeVideoUrl[0].srtMediaId
            
            txtFYoutubeLink1.text = url1
            
        }else if arrCount == 2 {
            url1 = arrYouTubeVideoUrl[0].srtMediaName
            ID1 = arrYouTubeVideoUrl[0].srtMediaId
            
            url2 = arrYouTubeVideoUrl[1].srtMediaName
            ID2 = arrYouTubeVideoUrl[1].srtMediaId
            
            txtFYoutubeLink1.text = url1
            
            txtFYoutubeLink2.text = url2
        }else if arrCount == 3 {
            url1 = arrYouTubeVideoUrl[0].srtMediaName
            ID1 = arrYouTubeVideoUrl[0].srtMediaId
            
            url2 = arrYouTubeVideoUrl[1].srtMediaName
            ID2 = arrYouTubeVideoUrl[1].srtMediaId
            
            url3 = arrYouTubeVideoUrl[2].srtMediaName
            ID3 = arrYouTubeVideoUrl[2].srtMediaId
            
            txtFYoutubeLink1.text = url1
            
            txtFYoutubeLink2.text = url2
            
            txtFYoutubeLink3.text = url3
        }
    }
    
    func setUserProfileAPI() {
        if(Util.isNetworkReachable()) {
            self.showFullscreenProgressDialog()
            
            let objUserProfileModel = UserProfileModel()
            objUserProfileModel.strMyIntro = txtVUserInfo.text
            objUserProfileModel.strUserId = objEditprofileContestantSelfModel.objUserProfileModel.strContestantId
            
            objUserProfileModel.strYouTubeID1 = ID1
            objUserProfileModel.strYouTubeID2 = ID2
            objUserProfileModel.strYouTubeID3 = ID3
            
            objUserProfileModel.strYouTubeUrl1 = self.txtFYoutubeLink1.text
            objUserProfileModel.strYouTubeUrl2 = self.txtFYoutubeLink2.text
            objUserProfileModel.strYouTubeUrl3 = self.txtFYoutubeLink3.text
            
            if(self.selectedImgUserProfile == UIImage())
            {
                objUserProfileModel.isUserProfileImageChange = false
            }else
            {
                objUserProfileModel.userProfileImg = self.selectedImgUserProfile
                objUserProfileModel.isUserProfileImageChange = true
            }
            
            objEditprofileContestantSelfModel.setUserProfileAPI(objUser: objUserProfileModel)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func imageArrayUploadApi(imgGallery:UIImage,indexToUpload:Int,totalImageToUpload:Int)
    {
        if(Util.isNetworkReachable()) {
            self.showFullscreenProgressDialog()
            
            let objUserProfileModel = UserProfileModel()
            objUserProfileModel.strUserId = objEditprofileContestantSelfModel.objUserProfileModel.strContestantId
            objUserProfileModel.userProfileImg = imgGallery
//            UIApplication.shared.isIdleTimerDisabled = true
            objEditprofileContestantSelfModel.imageArrayUploadApi(objUser: objUserProfileModel, indexToUpload: indexToUpload, totalImageToUpload: totalImageToUpload)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func getMediaGallaryAPI() {
        if(Util.isNetworkReachable()) {
            self.showFullscreenProgressDialog()
            let objUserProfileModel = UserProfileModel()
            objUserProfileModel.strContestantId = self.objEditprofileContestantSelfModel.objUserProfileModel.strContestantId
            self.objEditprofileContestantSelfModel.getMediaGallaryAPI(objUser: objUserProfileModel)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func setVideoUploadApi(localUrl:URL,indexToUpload:Int,totalVideoToUpload:Int)
    {
        viewContProgress.isHidden = false
        viewContProgress.subviews.forEach({ $0.removeFromSuperview() })
         let objLikeGTProgress:GTProgressBar  = GTProgressBar()
        objLikeGTProgress.progress = 0
        objLikeGTProgress.createProgressbarUI(isLikeView: false, progressView: viewContProgress)
        
        let strUrl = Constant.API.BASEURL + Constant.API.ADD_GALLARY_ITEM
        var parameters = [String:String]()
        parameters = ["language":"english","contestant_id":"\(objEditprofileContestantSelfModel.objUserProfileModel.strContestantId!)","media_type":"video"]
        //http://etechservices.biz/rankingstar/assets/gallary/trim_7AD8425E-408B-47C8-8EB8-5742C39C7A3F.MOV
        self.showFullscreenProgressDialog()
      //  DispatchQueue.global(qos: .background).async {
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in parameters {
                    
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                multipartFormData.append(localUrl, withName: "media_path")
            }, to:strUrl)
            { (result) in
                switch result {
                case .success(let upload, _ , _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        objLikeGTProgress.progress = CGFloat(progress.fractionCompleted)
                        printDebug("uploding progress : \(progress)")
                    })
                    
                    upload.responseJSON { response in
                        self.hideFullscreenDialog()
                        self.viewContProgress.isHidden = true
                        if(response.error != nil)
                        {
                            self.isVideoUpdateApiSuccess(isSuccess: false, indexToUpload: indexToUpload, totalVideoToUpload: totalVideoToUpload)
                        }else
                        {
//                            printDebug("uploding done res Dic : \(String(describing: response.result.value))")
                            self.isVideoUpdateApiSuccess(isSuccess: true, indexToUpload: indexToUpload, totalVideoToUpload: totalVideoToUpload)
                        }
                    }
                    
                case .failure(let encodingError):
                    self.hideFullscreenDialog()
                    self.viewContProgress.isHidden = true
                    printDebug("uploding failed \(encodingError)")
                    
                    self.isVideoUpdateApiSuccess(isSuccess: false, indexToUpload: indexToUpload, totalVideoToUpload: totalVideoToUpload)
                    
                }
            }
//        }
    }
    
    func deleteMediaGalleryItemAPI(mediaId:String) {
        if(Util.isNetworkReachable()) {
            self.showFullscreenProgressDialog()
            
            let objUserProfileModel = UserProfileModel()
            objUserProfileModel.strGalleryMediaId = mediaId
            objEditprofileContestantSelfModel.deleteMediaGalleryItemAPI(objUser: objUserProfileModel)
        }else {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    func setActionSheet()
    {
        let getPhotoActionSheet = UIAlertController(title: "GET_IMAGE_FROM_GALLERY".localizedLanguage(), message: "", preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "TAKE_PHOTO".localizedLanguage(), style: .default){(ACTION) in
            if(self.maximumImgSelectionCount <= self.getTotalVideoCount(isImgCount: true))
            {
                AlertPresenter.alertInformation(fromVC: self, message: "ALT_IMAGE_MAX_LIMIT")
//                self.objCollectionView.reloadData()
            }else
            {
                let image = UIImagePickerController()
                image.delegate = self
                image.sourceType = UIImagePickerController.SourceType.camera
                image.allowsEditing = false
                self.present(image, animated: true, completion: nil)
            }
        }
        
        let recoredVideoAction = UIAlertAction(title: "RECORED_VIDEO".localizedLanguage(), style: .default){(ACTION) in
            //  "RECORED_VIDEO" = "Movie shooting";
//            AlertPresenter.alertInformation(fromVC: self, message: "ALT_FUNC_UNDER_DEVELOPMENT")
            
            if(self.maximumVideoSelectionCount <= self.getTotalVideoCount(isImgCount: false))
            {
                AlertPresenter.alertInformation(fromVC: self, message: "ALT_VIDEO_MAX_LIMIT")
            }else
            {
                self.isClickedVideoSelection = true
                let image = UIImagePickerController()
                image.delegate = self
                image.videoQuality = .typeHigh
                image.mediaTypes = [(kUTTypeMovie as String)]
                image.sourceType = UIImagePickerController.SourceType.camera
                image.allowsEditing = true
                image.videoMaximumDuration = self.intVideoMaxRecoredSecond
                self.present(image, animated: true, completion: nil)

            }
        }
        
        let choosePhotoVieoAction = UIAlertAction(title: "CHOOSE_PHOTO_VIDEO".localizedLanguage(), style: .default)
        {(ACTION) in
            if(self.maximumImgSelectionCount <= self.getTotalVideoCount(isImgCount: true))
            {
                AlertPresenter.alertInformation(fromVC: self, message: "ALT_IMAGE_MAX_LIMIT")
//                self.objCollectionView.reloadData()
            }else
            {
                let picker = AssetsPickerViewController()
                picker.pickerDelegate = self
                picker.pickerConfig.assetsMaximumSelectionCount = self.maximumImgSelectionCount - self.getTotalVideoCount(isImgCount: true)
                self.present(picker, animated: true, completion: nil)
            }
            
        }
        
        let choosePhotoAction = UIAlertAction(title: "CHOOSE_VIDEO".localizedLanguage(), style: .default)
        {(ACTION) in
//            AlertPresenter.alertInformation(fromVC: self, message: "ALT_FUNC_UNDER_DEVELOPMENT")
            
            if(self.maximumVideoSelectionCount <= self.getTotalVideoCount(isImgCount: false))
            {
                AlertPresenter.alertInformation(fromVC: self, message: "ALT_VIDEO_MAX_LIMIT")
            }else
            {
                let image = UIImagePickerController()
                image.delegate = self
                image.videoQuality = .typeHigh
                image.mediaTypes = [(kUTTypeMovie as String)]
                image.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                image.videoMaximumDuration = self.intVideoMaxRecoredSecond
                image.allowsEditing = true
                self.present(image, animated: true, completion: nil)
            }
            
        }
        
        let cancelPhotoAction = UIAlertAction(title: "ALERT_CANCEL".localizedLanguage(), style: .cancel, handler: nil)
        
//        getPhotoActionSheet.addAction(choosePhotoAction)
        getPhotoActionSheet.addAction(takePhotoAction)
//        getPhotoActionSheet.addAction(recoredVideoAction)
        getPhotoActionSheet.addAction(choosePhotoVieoAction)
        
        getPhotoActionSheet.addAction(cancelPhotoAction)
        present(getPhotoActionSheet, animated: true, completion: nil)
    }
    
    
    func setActionSheetForProfileImage()
    {
        let getPhotoActionSheet = UIAlertController(title: "GET_IMAGE_FROM_GALLERY".localizedLanguage(), message: "", preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "TAKE_PHOTO".localizedLanguage(), style: .default){(ACTION) in
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.camera
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
        }
        
        let choosePhotoAction = UIAlertAction(title: "CHOOSE_PHOTO_VIDEO".localizedLanguage(), style: .default)
        {(ACTION) in
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.allowsEditing = false
            self.present(image, animated: true, completion: nil)
        }
        
        
        let cancelPhotoAction = UIAlertAction(title: "ALERT_CANCEL".localizedLanguage(), style: .cancel, handler: nil)
        
        getPhotoActionSheet.addAction(takePhotoAction)
        getPhotoActionSheet.addAction(choosePhotoAction)
        getPhotoActionSheet.addAction(cancelPhotoAction)
        present(getPhotoActionSheet, animated: true, completion: nil)
    }
    
    func getImageFromAsset(asset:PHAsset,imageSize:CGSize, callback:@escaping (_ result:UIImage) -> Void) -> Void{
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.fast
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = true
        PHImageManager.default().requestImage(for: asset, targetSize: imageSize, contentMode: PHImageContentMode.default, options: requestOptions, resultHandler: { (currentImage, info) in
            callback(currentImage!)
        })
    }
    
    func getTotalVideoCount(isImgCount:Bool) -> Int
    {
        var totalVideo = 0
        for objMediaGallery in self.objEditprofileContestantSelfModel.arrImageAndVideoList
        {
            if(objMediaGallery.isImage == isImgCount)
            {
                totalVideo += 1
            }
        }
        return totalVideo
        
    }
    
    func getUrlFromPHAsset(asset: PHAsset, callBack: @escaping (_ url: URL?) -> Void)
    {
        asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions(), completionHandler: { (contentEditingInput, dictInfo) in
            
            if let strURL = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString
            {
                callBack(URL.init(string: strURL))
            }
        })
    }
    
    func getUIImage(asset: PHAsset) -> UIImage {
        
        var img: UIImage = UIImage()
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)!
            }
        }
        return img
    }
    
    func setCollectionViewSize() {
        let size = ((UIScreen.main.bounds.width - 30) / 2) + 10
        let arrCount = objEditprofileContestantSelfModel.getTableNumberOfSection()
        
        if objEditprofileContestantSelfModel.getTableNumberOfSection() == 0 {
            cnsCollectionViewHeight.constant = size
        }else if (objEditprofileContestantSelfModel.getTableNumberOfSection() % 2 == 0) {
            cnsCollectionViewHeight.constant = (CGFloat(arrCount) / 2) * size + size
        }else {
            let imgCountInt = Int(arrCount / 2)
            cnsCollectionViewHeight.constant = (CGFloat(imgCountInt) * size) + size
        }
    }
    
    func fileSize(forURL url: Any) -> Double {
           var fileURL: URL?
           var fileSize: Double = 0.0
           if (url is URL) || (url is String)
           {
               if (url is URL) {
                   fileURL = url as? URL
               }
               else {
                   fileURL = URL(fileURLWithPath: url as! String)
               }
               var fileSizeValue = 0.0
               try? fileSizeValue = (fileURL?.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
               if fileSizeValue > 0.0 {
                   fileSize = (Double(fileSizeValue) / (1024 * 1024))
               }
           }
           return fileSize
       }
       
       @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
           //        let title = (error == nil) ? "Success" : "Error"
           //        let message = (error == nil) ? "Video was saved" : "Video failed to save"
           
           //        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           //        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
           //        present(alert, animated: true, completion: nil)
       }
    
    
    //MARK:- Button clicked
    
    @IBAction func btnSearchClicked(_ sender: UIButton) {
        viewContSearch.isHidden = true
    }
    @IBAction func btnEditClicked(_ sender: UIButton) {
        isEditProfileBtnClicked = true
        setActionSheetForProfileImage()
        
    }
    
    @IBAction func onClickedDeleteProfileText(_ sender: Any) {
        txtVUserInfo.setRectViewTxtNormalBlack(value: "")
    }
    
    @IBAction func onClickedYouTubeLink1(_ sender: Any) {
        txtFYoutubeLink1.text = ""
    }
    
    @IBAction func onClickedYouTubeLink2(_ sender: Any) {
        txtFYoutubeLink2.text = ""
    }
    
    @IBAction func onClickedYouTubeLink3(_ sender: Any) {
        txtFYoutubeLink3.text = ""
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        setUserProfileAPI()
    }
    
    //MARK:-  Tapped Methods clicked
    @objc func imgVCloseTabbed(_ sender: CustomTabGestur){
        if(strDeleteMediaGallryItem == -1)
        {
            strDeleteMediaGallryItem = 100
            let objImageAndVideoList = objEditprofileContestantSelfModel.arrImageAndVideoList[sender.intIndex]
            if(objImageAndVideoList.isImage)
            {
                if(objImageAndVideoList.objMyImage.isUrl == true)
                {
                    strDeleteMediaGallryItem = sender.intIndex
                    //objImageAndVideoList.objMyImage.objMyMediaGallaryModel.srtMediaId
                    deleteMediaGalleryItemAPI(mediaId: objImageAndVideoList.objMyImage.objMyMediaGallaryModel.srtMediaId)
                }else
                {
                    printDebug("Need Api call")
                    objEditprofileContestantSelfModel.arrImageAndVideoList.remove(at: sender.intIndex)
                    setCollectionViewSize()
                    objCollectionView.reloadData()
                    strDeleteMediaGallryItem = -1
                }
            }else
            {
                if(objImageAndVideoList.objMyVideo.isFromServerUrl == true)
                {
                    strDeleteMediaGallryItem = sender.intIndex
                    deleteMediaGalleryItemAPI(mediaId: objImageAndVideoList.objMyVideo.objMyMediaGallaryModel.srtMediaId)
                }else
                {
                    printDebug("Need Api call")
                    objEditprofileContestantSelfModel.arrImageAndVideoList.remove(at: sender.intIndex)
                    setCollectionViewSize()
                    objCollectionView.reloadData()
                    strDeleteMediaGallryItem = -1
                }
            }
        }
        
//        deleteMediaGalleryItemAPI(mediaId: String(sender.intIndex) )
        
    }
    
    @objc func imgVPlayPlushTabbed(_ sender: CustomTabGestur){
        if(objEditprofileContestantSelfModel.getTableNumberOfSection() <= sender.intIndex )
        {
            setActionSheet()
        }else
        {
            if (objEditprofileContestantSelfModel.arrImageAndVideoList[sender.intIndex].objMyVideo.strUrl as? String) != nil {
                
                let url = URL(string: objEditprofileContestantSelfModel.arrImageAndVideoList[sender.intIndex].objMyVideo.strUrl!)
                let player = AVPlayer(url: url!)
                let vc = AVPlayerViewController()
                vc.player = player
                
                self.present(vc, animated: true) {
                    vc.player?.play()
                }
            }
        }
    }
    
    
    
    //MARK:- View model methods
    func onProfileUpdateApiCompleted(isSuccess:Bool, message : String) {
        if(isSuccess == true)
        {
            printDebug("User profile data uploaded successfully")
            
//            if(arrStrIndexOfImgs.count > 0) {
                startImageUploadingLogic()
//            }
            
//            if(arrStrIndexOfVideos.count > 0) {
                startVideoUploadingLogic()
//            }
            
//            getMediaGallaryAPI()
            getTextfieldYouTubeUrl()
            if(objContestantProfileVCDelegate != nil)
            {
                objContestantProfileVCDelegate.reloadContestantProfileApi()
            }
            
            AlertPresenter.alertInformation(fromVC: self, message: "ALT_PROFILE_UPDATE_SUCCESS") {
                self.navigationController?.popViewController(animated: true)
            }
            
        }else
        {
            printDebug("User profile data not uploaded")
            AlertPresenter.alertInformation(fromVC: self, message: message)
        }
    }
    func mediaGallarySuccessResponse() {
        objCollectionView.reloadData()
        //AlertPresenter.alertInformation(fromVC: self, message: "ALT_PROFILE_UPDATE_SUCCESS")
    }
    
    func isImageUpdateApiSuccess(isSuccess:Bool,indexToUpload:Int,totalImageToUpload:Int) {
//        UIApplication.shared.isIdleTimerDisabled = false
        if(isSuccess == true)
        {
//            AlertPresenter.alertInformation(fromVC: self, message: "ALT_PROFILE_UPDATE_SUCCESS")
        }else
        {
            arrStrIndexOfImgsNextTry.append(arrStrIndexOfImgs[indexToUpload])
        }  // 1..10    0..9    10
        if(indexToUpload < arrStrIndexOfImgs.count - 1)
        {
            let uploadImageIndex = arrStrIndexOfImgs[indexToUpload + 1]
            let objImageAndVideoList = objEditprofileContestantSelfModel.arrImageAndVideoList[uploadImageIndex]
            imageArrayUploadApi(imgGallery: objImageAndVideoList.objMyImage.uiImage, indexToUpload: indexToUpload + 1, totalImageToUpload: totalImageToUpload)
            
        }else
        {
            if(arrStrIndexOfImgsNextTry.count > 0 && imageUploadTryCount <= imageUploadTryMaxCount)
            {
                imageUploadTryCount = imageUploadTryCount + 1
                arrStrIndexOfImgs.removeAll()
                arrStrIndexOfImgs = arrStrIndexOfImgsNextTry
                
                if(arrStrIndexOfImgs.count > 0)
                {
                    let uploadIndex:Int = arrStrIndexOfImgs[0]
                    let objImageAndVideoList = self.objEditprofileContestantSelfModel.arrImageAndVideoList[uploadIndex]
                    imageArrayUploadApi(imgGallery: objImageAndVideoList.objMyImage.uiImage, indexToUpload: 0, totalImageToUpload: arrStrIndexOfImgs.count)
                }
                
            }else
            {
                if(arrStrIndexOfImgsNextTry.count > 0)
                {
                  //  print("\(arrStrIndexOfImgsNextTry.count) Image not upload success")
                    AlertPresenter.alertInformation(fromVC: self, message: "ALT_SOME_IMAGE_NOT_UPLOAD")
                }else
                {
//                    print("all Image upload success")
                    
//                    AlertPresenter.alertInformation(fromVC: self, message: "ALT_PROFILE_UPDATE_SUCCESS")
                }
                
//                startVideoUploadingLogic()
                
//                getMediaGallaryAPI()
//                if(objContestantProfileVCDelegate != nil)
//                {
//                    objContestantProfileVCDelegate.reloadContestantProfileApi()
//                }
            }
            
        }
        
        
    }
    
    
    func isVideoUpdateApiSuccess(isSuccess:Bool,indexToUpload:Int,totalVideoToUpload:Int) {
        if(isSuccess == true)
        {
            //            AlertPresenter.alertInformation(fromVC: self, message: "ALT_PROFILE_UPDATE_SUCCESS")
        }else
        {
            arrStrIndexOfVideosNextTry.append(arrStrIndexOfVideos[indexToUpload])
        }  // 1..10    0..9    10
        if(indexToUpload < arrStrIndexOfVideos.count - 1)
//        if(indexToUpload < totalVideoToUpload - 1)
        {
            let uploadImageIndex = arrStrIndexOfVideos[indexToUpload + 1]
            let objImageAndVideoList = objEditprofileContestantSelfModel.arrImageAndVideoList[uploadImageIndex]
            setVideoUploadApi(localUrl: URL(string: objImageAndVideoList.objMyVideo.strThumbUrl)!, indexToUpload: indexToUpload + 1, totalVideoToUpload: totalVideoToUpload)
            //   imageArrayUploadApi(imgGallery: objImageAndVideoList.objMyImage.uiImage, indexToUpload: indexToUpload + 1, totalImageToUpload: totalVideoToUpload)
            
        }else
        {
            if(arrStrIndexOfVideosNextTry.count > 0 && videosUploadTryCount <= videosUploadTryMaxCount)
            {
                videosUploadTryCount = videosUploadTryCount + 1
                arrStrIndexOfVideos.removeAll()
                arrStrIndexOfVideos = arrStrIndexOfVideosNextTry
                
                if(arrStrIndexOfVideos.count > 0)
                {
                    let uploadIndex:Int = arrStrIndexOfVideos[0]
                    let objImageAndVideoList = self.objEditprofileContestantSelfModel.arrImageAndVideoList[uploadIndex]
                    setVideoUploadApi(localUrl: URL(string: objImageAndVideoList.objMyVideo.strThumbUrl)!, indexToUpload: 0, totalVideoToUpload: totalVideoToUpload)
                }
                
            }else
            {
                if(arrStrIndexOfVideosNextTry.count > 0)
                {
                    print("ALT_SOME_VIDEO_NOT_UPLOAD")
                    AlertPresenter.alertInformation(fromVC: self, message: "ALT_SOME_VIDEO_NOT_UPLOAD")
                }else
                {
                    print("all videos upload success")
                    AlertPresenter.alertInformation(fromVC: self, message: "ALT_PROFILE_UPDATE_SUCCESS")
                }
                getMediaGallaryAPI()
                UIApplication.shared.isIdleTimerDisabled = false
                if(objContestantProfileVCDelegate != nil)
                {
                    objContestantProfileVCDelegate.reloadContestantProfileApi()
                }
            }
        }
    }
    
    func startImageUploadingLogic() {
        // call all image upload api
        arrStrIndexOfImgs.removeAll()
        arrStrIndexOfImgsNextTry.removeAll()
        imageUploadTryCount = 1
        var index:Int = 0
        for objMediaGallery in self.objEditprofileContestantSelfModel.arrImageAndVideoList
        {
            if(objMediaGallery.isImage == true)
            {
                if(objMediaGallery.objMyImage.isUrl == false)
                {
                    arrStrIndexOfImgs.append(index)
                }
            }
            index += 1
        }

        if(arrStrIndexOfImgs.count > 0)
        {
            let uploadIndex:Int = arrStrIndexOfImgs[0]
            let objImageAndVideoList = self.objEditprofileContestantSelfModel.arrImageAndVideoList[uploadIndex]
            imageArrayUploadApi(imgGallery: objImageAndVideoList.objMyImage.uiImage, indexToUpload: 0, totalImageToUpload: arrStrIndexOfImgs.count)
        }
    }
    
    func startVideoUploadingLogic()
    {
        arrStrIndexOfVideos.removeAll()
        arrStrIndexOfVideosNextTry.removeAll()
        videosUploadTryCount = 1
        var index:Int = 0
        for objMediaGallery in self.objEditprofileContestantSelfModel.arrImageAndVideoList
        {
            if(objMediaGallery.isImage == false)
            {
                if(objMediaGallery.objMyVideo.isFromServerUrl == false)
                {
                    arrStrIndexOfVideos.append(index)
                }
            }
            index += 1
        }
        
        if(arrStrIndexOfVideos.count > 0)
        {
            let uploadIndex:Int = arrStrIndexOfVideos[0]
            let objImageAndVideoList = self.objEditprofileContestantSelfModel.arrImageAndVideoList[uploadIndex]
            //imageArrayUploadApi(imgGallery: objImageAndVideoList.objMyImage.uiImage, indexToUpload: 0, totalImageToUpload: arrStrIndexOfImgs.count)
            
//            setVideoUploadApi(localUrl: URL(string: objImageAndVideoList.objMyVideo.strUrl)!, indexToUpload: 0, totalVideoToUpload: arrStrIndexOfVideos.count)
            UIApplication.shared.isIdleTimerDisabled = true
            setVideoUploadApi(localUrl: URL(string: objImageAndVideoList.objMyVideo.strThumbUrl)!, indexToUpload: 0, totalVideoToUpload: arrStrIndexOfVideos.count)
        }else
        {
//            getMediaGallaryAPI()
//            getTextfieldYouTubeUrl()
//            if(objContestantProfileVCDelegate != nil)
//            {
//                objContestantProfileVCDelegate.reloadContestantProfileApi()
//            }
            
            UIApplication.shared.isIdleTimerDisabled = false
            
////            AlertPresenter.alertInformation(fromVC: self, message: "ALT_PROFILE_UPDATE_SUCCESS")
//            AlertPresenter.alertInformation(fromVC: self, message: "ALT_PROFILE_UPDATE_SUCCESS") {
//                self.navigationController?.popViewController(animated: true)
//            }
        }
    }
    
    
    func successMediaGalleryItemDelete(isSuccess: Bool) {
        if(isSuccess)
        {
            if(strDeleteMediaGallryItem != -1)
            {
                objEditprofileContestantSelfModel.arrImageAndVideoList.remove(at: strDeleteMediaGallryItem)
                setCollectionViewSize()
                objCollectionView.reloadData()
            }
            strDeleteMediaGallryItem = -1
        }else
        {
            strDeleteMediaGallryItem = -1
        }
        
        if(objContestantProfileVCDelegate != nil)
        {
            objContestantProfileVCDelegate.reloadContestantProfileApi()
        }
        
    }
    
    func onApiSuccessHideProgress() {
        self.hideFullscreenDialog()
    }
    
    func showMessage(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    @objc override func leftBarButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc override func rightBtnClickedWithImg() {
        
        if(Util.getIsUserLogin() == "0") {
            AlertPresenter.alertInformation(fromVC: Util.currentNavigationController.topViewController!, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
        }else {
            let objWebViewWithTabVC = WebViewWithTabVC()
            objWebViewWithTabVC.isBackButtonShow = true
            self.navigationController?.pushViewController(objWebViewWithTabVC, animated: true)
        }
    }
    
    @objc override func rightBtnClickedWithImg2() {
        viewContSearch.isHidden = false
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        printDebug(textField.text)
    }
}

extension EditprofileContestantSelfVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField == txtSearch) {
            self.searchedText = txtSearch.text!
            
            if searchedText.isEmpty {
                //  objChargingStarHistoryModel.arrChargingHistoryModel = []
                //   self.tblView.reloadData()
                
            }else {
                //                getChargingHistoryAPI()
                // print(txtSearch.text)
                // nothing
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == txtSearch) {
            textField.resignFirstResponder()
        }
        return true
    }
}


extension EditprofileContestantSelfVC:UICollectionViewDataSource,UICollectionViewDelegate
{
    // collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if objEditprofileContestantSelfModel.arrImageList.count >= 10 {
//            return objEditprofileContestantSelfModel.getTableNumberOfSection()
//        }else {
            return objEditprofileContestantSelfModel.getTableNumberOfSection() + 1
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:EditProfileImageVideoCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellIdentifier.EDIT_PROFILE_IMAGE_VIDEO_CELL, for: indexPath) as! EditProfileImageVideoCell
        
        let lastIndex = objEditprofileContestantSelfModel.getTableNumberOfSection();
        if(indexPath.row != lastIndex)
        {
            cell.imgVClose.isHidden = false
            cell.lblAddImg.isHidden = true
            cell.imgVUser.isHidden = false
            cell.imgVUser.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
            cell.contentView.layer.borderWidth = 0
            cell.imgVClose.setImageFit(imageName: Constant.Image.close_white)
            cell.imgVClose.backgroundColor = Constant.Color.IMG_BG_VIEW_CLOSE
            cell.imgVClose.isUserInteractionEnabled = true
            
            let objImageAndVideoList = objEditprofileContestantSelfModel.arrImageAndVideoList[indexPath.row]
            
            if(objImageAndVideoList.isImage)
            {
                cell.imgVPlayPlush.isHidden = true
                cell.imgVPlayPlush.isUserInteractionEnabled = false
                if(objImageAndVideoList.objMyImage.isUrl == true)
                {
//                    cell.imgVUser.getImageFromURL(url: objImageAndVideoList.objMyImage.strUrl)
                    if objImageAndVideoList.objMyImage.strThumbUrl != nil {
                        cell.imgVUser.getImageFromURL(url: objImageAndVideoList.objMyImage.strThumbUrl)
                    }else {
                        cell.imgVUser.getImageFromURL(url: objImageAndVideoList.objMyImage.strUrl)
                    }
                }else
                {
                    cell.imgVUser.image = objImageAndVideoList.objMyImage.uiImage
                }
                cell.imgVUser.setFitImageInImageView()
            }else
            {
                cell.imgVPlayPlush.isHidden = false
                cell.imgVPlayPlush.isUserInteractionEnabled = true
                cell.imgVPlayPlush.setImageFit(imageName: Constant.Image.play)
                if(objImageAndVideoList.objMyVideo.isFromServerUrl == true)
                {
//                    cell.imgVUser.getImageFromURL(url: objImageAndVideoList.objMyVideo.strUrl)
                    if objImageAndVideoList.objMyVideo.strThumbUrl != nil {
                        cell.imgVUser.getImageFromURL(url: objImageAndVideoList.objMyVideo.strThumbUrl)
                    }
                }else
                {
//                    cell.imgVUser.image = objImageAndVideoList.objMyVideo.thumbImage
                    
                    let url = URL(string: objImageAndVideoList.objMyVideo.strThumbUrl)!
                    printDebug("file size :  \(fileSize(forURL: url))")
                    // 5 minit height quality video file size : file size :  546.4310493469238
                    // 5 minit medium quality video file size : file size :  10.548881530761719
                    // 5 minit low quality video file size : file size :  1.532257080078125
                    // 1282 by 720 seconds 30: file size : 149.82036972045898
                    // 960 by 540 seconds 30: file size : 109.38795185089111
                    // 640 by 480 seconds 30: file size : 13.2427339553833
                    // 30 seconds height quality video file size : file size : 56.26252841949463
                    if let thumbnailImage = cell.imgVUser.getImageFromLocalPath(forUrl: url) {
                        cell.imgVUser.image = thumbnailImage
                    }
                }
                cell.imgVUser.setFitImageInImageView()
            }
            
            let imgVCloseTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.imgVCloseTabbed))
            imgVCloseTabbed.intIndex = indexPath.row
            cell.imgVClose.isUserInteractionEnabled = true
            cell.imgVClose.addGestureRecognizer(imgVCloseTabbed)
            
        }else
        {
            cell.imgVClose.isHidden = true
            cell.imgVClose.isUserInteractionEnabled = false
            cell.imgVPlayPlush.isHidden = false
            cell.imgVUser.isHidden = true
            cell.imgVPlayPlush.setImageFit(imageName: Constant.Image.add_pink)
            cell.lblAddImg.isHidden = false
            cell.lblAddImg.setNormalUIStylePink(value: "LBL_ADD")
            cell.contentView.layer.borderWidth = 2
            cell.contentView.borderColor = Constant.Color.VIEW_BORDER_PINK_COLOR
        }
        
        let imgVPlayPlushTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.imgVPlayPlushTabbed))
        imgVPlayPlushTabbed.intIndex = indexPath.row
        cell.imgVPlayPlush.isUserInteractionEnabled = true
        cell.imgVPlayPlush.addGestureRecognizer(imgVPlayPlushTabbed)
        return   cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let lastIndex = objEditprofileContestantSelfModel.getTableNumberOfSection();
        if(indexPath.row != lastIndex)
        {
            //            let objImageSlidingVC = ImageSlidingVC()
            //            objImageSlidingVC.setCurrentPageIndex = indexPath.row
            //            objImageSlidingVC.arrImageAndVideoList = objEditprofileContestantSelfModel.arrImageAndVideoList
            //            self.navigationController?.pushViewController(objImageSlidingVC, animated: false)
        }else if(indexPath.row == lastIndex)
        {
            setActionSheet()
        }
    }
    
    func manageSizeOfCollectionViewCell()
    {
        let uiCollectionViewFlowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let size:CGFloat = UIScreen.main.bounds.width - 50
        //        let size:CGFloat = objCollectionView.frame.width - 28
        uiCollectionViewFlowLayout.itemSize = CGSize(width: (size/2), height: (size/2))
        objCollectionView.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        uiCollectionViewFlowLayout.minimumInteritemSpacing = 10
        uiCollectionViewFlowLayout.minimumLineSpacing = 10
        //        uiCollectionViewFlowLayout.scrollDirection = .vertical
        objCollectionView.collectionViewLayout = uiCollectionViewFlowLayout
        objCollectionView.setNeedsLayout()
        objCollectionView.updateFocusIfNeeded()
    }
    // collection view end
}

extension EditprofileContestantSelfVC: AssetsPickerViewControllerDelegate {
    
    func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {}
    func assetsPickerDidCancel(controller: AssetsPickerViewController) {}
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        for assetTmp in assets
        {
            let objImageAndVideoList = ImageAndVideoList()
            
            if(assetTmp.mediaType == PHAssetMediaType.image)
            {
                objImageAndVideoList.isImage = true
                objImageAndVideoList.objMyImage.isUrl = false
                objImageAndVideoList.objMyImage.uiImage = getUIImage(asset: assetTmp)
            }else if(assetTmp.mediaType == PHAssetMediaType.video)
            {
                objImageAndVideoList.isImage = false
                objImageAndVideoList.objMyVideo.isFromServerUrl = false
                objImageAndVideoList.objMyVideo.strUrl = ""
                getUrlFromPHAsset(asset: assetTmp, callBack: { (url) in
                    
                    objImageAndVideoList.objMyVideo.strThumbUrl = url?.absoluteString
                })
                
                //                PHImageManager.default().requestExportSession(forVideo: assetTmp, options: nil, exportPreset: AVAssetExportPresetHighestQuality, resultHandler: { (assetExportSession, info) -> Void in // Here you set values that specifies your video (original, after edit, slow-mo, ...) and that affects resulting size.
                //                    assetExportSession?.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds(assetTmp.duration, preferredTimescale: 30)) // Time interval is default from zero to infinite so it needs to be set prior to file size computations. Time scale is I believe (it is "only" preferred value) not important in this case.
                //                    let HERE_YOU_ARE = assetExportSession?.estimatedOutputFileLength
                //                    printDebug("Video size : \(HERE_YOU_ARE)")
                //                })
                
            }
            
            
            objEditprofileContestantSelfModel.arrImageAndVideoList.append(objImageAndVideoList)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.setCollectionViewSize()
            self.objCollectionView.reloadData()
        }
    }
    
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        if(asset.mediaType == PHAssetMediaType.image)
        {
            return true
        }else if(asset.mediaType == PHAssetMediaType.video)
        {
            return false
            //            if(asset.duration <= intVideoMaxRecoredSecond)
            //            {
            //                return true
            //            }else
            //            {
            //               return false
            //            }
        }
        return false
    }
    func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {}
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
    func assetsPicker(controller: AssetsPickerViewController, didDeselect asset: PHAsset, at indexPath: IndexPath) {}
    
}


extension EditprofileContestantSelfVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let objType:String = info[.mediaType] as! String
        
        if(objType == kUTTypeMovie as String)
        {
            if(self.isClickedVideoSelection == true)
            {
                self.isClickedVideoSelection = false
                guard
                    let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
                    mediaType == (kUTTypeMovie as String),
                    let url1 = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
                    UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url1.path)
                    else {
                        return
                }

                UISaveVideoAtPathToSavedPhotosAlbum(
                    url1.path,
                    self,
                    #selector(video(_:didFinishSavingWithError:contextInfo:)),
                    nil)
            }
            
            if let mediaFileUrl = info[.mediaURL] as? URL
            {
                do {
                    let data =  try Data(contentsOf: mediaFileUrl)   //  "Secret Message".data(using: .utf8)!
                    let tempDir =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    //                    let tempDir = FileManager.default.temporaryDirectory
                    let localURL = tempDir.appendingPathComponent(mediaFileUrl.lastPathComponent)
                    try? data.write(to: localURL)
                    
                    let objImageAndVideoList = ImageAndVideoList()
                    objImageAndVideoList.isImage = false
                    objImageAndVideoList.objMyVideo.isFromServerUrl = false
                    
                    //                    if(isClickedVideoSelection == true)
                    //                    {
                    objImageAndVideoList.objMyVideo.strThumbUrl = localURL.absoluteString
                    //                    }else
                    //                    {
                    //
                    //                        objImageAndVideoList.objMyVideo.strUrl = localURL.absoluteString
                    //                    }
                    
                    objEditprofileContestantSelfModel.arrImageAndVideoList.append(objImageAndVideoList)
                    setCollectionViewSize()
                    objCollectionView.reloadData()
                } catch {
                    print(error)
                }
            }
            self.dismiss(animated: true, completion: nil)
            
        }else if(objType == kUTTypeImage as String)
        {
            // printDebug("Image")
            let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage ?? UIImage()
            if(isEditProfileBtnClicked == true)
            {
                isEditProfileBtnClicked = false
                imgUserProfile.setImageFill(image: selectedImage)
                selectedImgUserProfile = selectedImage
                imgUserProfile.setFitImageInImageView()
                imgUserProfile.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR

            }else
            {
                let objImageAndVideoList = ImageAndVideoList()
                objImageAndVideoList.isImage = true
                objImageAndVideoList.objMyImage.isUrl = false
                objImageAndVideoList.objMyImage.uiImage = selectedImage
                
                objEditprofileContestantSelfModel.arrImageAndVideoList.append(objImageAndVideoList)
                setCollectionViewSize()
                objCollectionView.reloadData()
            }
            //
            self.dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isClickedVideoSelection = false
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditprofileContestantSelfVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        // print("SlideMenuControllerDelegate: leftWillOpen")
    }
}

extension EditprofileContestantSelfVC : UITextViewDelegate {
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        let size : CGSize = self.txtVUserInfo.contentSize;
//        cnsIntroViewHeight.constant = size.height + 30
//        return true
//    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        let size : CGSize = self.txtVUserInfo.contentSize;
//        cnsIntroViewHeight.constant = size.height + 30
//    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size : CGSize = self.txtVUserInfo.contentSize;
        print("Change")
        if size.height >= 70 {
            textView.adjustUITextViewHeight()
            cnsIntroViewHeight.constant = size.height + 30
        }else {
            cnsIntroViewHeight.constant = 100
        }
    }
}

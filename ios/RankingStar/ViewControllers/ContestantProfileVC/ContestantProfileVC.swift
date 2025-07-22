//
//  LoginVC.swift
//  RankingStar
//
//  Created by Jinesh on 13/12/19.
//  Copyright © 2019 Etech. All rights reserved.
//

import UIKit
import Material
import TYCyclePagerView
import SlideMenuControllerSwift
import AVKit
import AVFoundation
import Lightbox
import Kingfisher

protocol ContestantProfileVCDelegate {
    func reloadContestantProfileApi()
    func reloadOnlyProfileData()
}


class ContestantProfileVC: BaseVC {
    
    var objContestantProfileViewModel : ContestantProfileViewModel!
    
    @IBOutlet var navBar: UINavigationBar!
    
    @IBOutlet var imgUserProfile: UIImageView!
    @IBOutlet var imgStarCoin: UIImageView!
    @IBOutlet var lblTotalVote: UILabel!
    @IBOutlet var lblRank: UILabel!
    @IBOutlet var viewContRank: UIView!
    @IBOutlet var viewContRankAndDetails: UIView!
    
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblUserTitleAge: UILabel!
    @IBOutlet var lblUserTitleHeight: UILabel!
    @IBOutlet var lblUserTitleWeight: UILabel!
    
    @IBOutlet var lblUserAge: UILabel!
    @IBOutlet var lblUserHeight: UILabel!
    @IBOutlet var lblUserWeight: UILabel!
    
    @IBOutlet var btnVote: UIButton!
    @IBOutlet var btnShare: UIButton!
    
    @IBOutlet var btnEditProfile: UIButton!
    
    @IBOutlet var viewContButtomTabbar: UIView!
    @IBOutlet var viewContButtomVote: UIView!
    @IBOutlet var viewContButtomStarCharging: UIView!
    @IBOutlet var viewContButtomShare: UIView!
    @IBOutlet var viewContButtomVotingRecord: UIView!
    
    @IBOutlet var imgButtomVote: UIImageView!
    @IBOutlet var imgButtomStarCharging: UIImageView!
    @IBOutlet var imgButtomShare: UIImageView!
    @IBOutlet var imgButtomVotingRecord: UIImageView!
   
    @IBOutlet var lblButtomTabVote: UILabel!
    @IBOutlet var lblButtomTabStarCharging: UILabel!
    @IBOutlet var lblButtomTabShare: UILabel!
    @IBOutlet var lblButtomTabVotingRecord: UILabel!
  
    @IBOutlet var viewContFlexibleHobbies1: UIView!
    @IBOutlet var viewContFlexibleHobbies2: UIView!
    
    @IBOutlet var viewHeightFlexibleHobbies1: NSLayoutConstraint!
    @IBOutlet var viewHeightFlexibleHobbies2: NSLayoutConstraint!
    
    @IBOutlet var viewAgeSepretor: UIView!
    @IBOutlet var viewHeightSepretor: UIView!
    
    @IBOutlet var viewSepretorFirst: UIView!
    @IBOutlet var viewSepretorSecond: UIView!
    @IBOutlet var viewSepretorThird: UIView!
    @IBOutlet var viewSepretorForth: UIView!
    
    @IBOutlet var viewContContestantDetailProfile: UIView!
    @IBOutlet var imgContestantDetailProfile: UIImageView!
    @IBOutlet var lblContestantDetailProfile: UILabel!
    
    @IBOutlet var objCollectionView: UICollectionView!
    
    var searchedText : String = ""
    @IBOutlet  var txtSearch: UITextField!
    @IBOutlet var viewContSearch: UIView!
    @IBOutlet var btnSearchClose: UIButton!
    
    @IBOutlet var viewContPreviewImg: UIView!
    @IBOutlet var constPreviewImgHeight: NSLayoutConstraint!
    @IBOutlet weak var cnsImageViewHeight: NSLayoutConstraint!
    
//    @IBOutlet var imgVideoThumbnail: UIImageView!
//    @IBOutlet var imgVideoPlayBtn: UIImageView!
    @IBOutlet var imgPreview: UIImageView!
    
    @IBOutlet var tblVideoList: UITableView!
    @IBOutlet var cnstblVideoListHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblYouTubeList: UITableView!
    @IBOutlet weak var cnstblYouTubeListHeight: NSLayoutConstraint!
    
    var arrEditProfileMsgCell:[EditProfileMsgCell] = []
    var objLightboxController:LightboxController!
    
    var imageView: UIImageView!
    var scrollImg: UIScrollView!
    var collectionCurrentIndex : Int! = 0
    
//    var strContestId:String! = "1"
//    var strContestantId:String! = "1"
    
    var objContestant = ContestantDetailModel()
    
    var objContestantListVCDelegate : ContestantListVCDelegate!
    var isProfilePhotoUpdated : Bool = false
    
    var arrWidth = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        
        self.view.setRightToLeftPinkGradientViewUI()
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        objContestantProfileViewModel = ContestantProfileViewModel(vc: self)
        txtSearch.delegate = self
        
        objCollectionView.register(UINib(nibName: Constant.CellIdentifier.CONTESTANT_PROFILE_IMAGE_VIDEO_CELL, bundle: nil), forCellWithReuseIdentifier: Constant.CellIdentifier.CONTESTANT_PROFILE_IMAGE_VIDEO_CELL)
        objCollectionView.dataSource = self
        objCollectionView.delegate = self
        objCollectionView.showsHorizontalScrollIndicator = false
        
        tblVideoList.register(UINib(nibName: Constant.CellIdentifier.CONTESTANT_PROFILE_VIDEO_LIST_CELL, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier.CONTESTANT_PROFILE_VIDEO_LIST_CELL)
        tblVideoList.dataSource = self
        tblVideoList.delegate = self
        tblVideoList.separatorStyle = .none
        
        tblYouTubeList.register(UINib(nibName: Constant.CellIdentifier.CONTESTANT_PROFILE_VIDEO_LIST_CELL, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier.CONTESTANT_PROFILE_VIDEO_LIST_CELL)
        tblYouTubeList.dataSource = self
        tblYouTubeList.delegate = self
        tblYouTubeList.separatorStyle = .none
        
//        constPreviewImgHeight.constant = 0
        constPreviewImgHeight.constant = (UIScreen.main.bounds.height - 279)
        
        manageSizeOfCollectionViewCell()
        manageHightOfVideoCell()
        manageHightOfYouTubeVideoCell()
        
//        if let flowLayout = objCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        }
        
//        tblView.delegate = self
//        tblView.dataSource = self
//        tblView.separatorStyle = .none
//
//        tblView.register(UINib(nibName: Constant.CellIdentifier.EDIT_PROFILE_MSG_CELL, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier.EDIT_PROFILE_MSG_CELL)
        setUIColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
//        getContestantDetailsAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        dismissAlertInfoPresenter()
    }
    
    //MARK: custom method
    func setUIColor()
    {
        navBar.setUI(navBarText: "RANKING_STAR") //2020 Analyst Korea
        self.leftBarButton(navBar : navBar , imgName : Constant.Image.back_black)
        self.rightBarSingleBtnWithImage(navBar: navBar, imgName: Constant.Image.charge_station_black)
        //self.rightBarSingleBtnWithImage2(navBar: navBar, imgName1: Constant.Image.menu, imgName2: Constant.Image.search)
        
//        Util.statusBarColor(color: Constant.Color.STATUS_BAR_GREY_COLOR)
        
        lblButtomTabVote.text = ""
        lblButtomTabStarCharging.text = ""
        lblButtomTabShare.text = ""
        lblButtomTabVotingRecord.text = ""
        lblRank.text = ""
        lblTotalVote.text = ""
//        lblUserName.text = ""
//        lblContestantNumber.text = ""
//        lblContestantRankUpDown.text = ""
//        lblTotalLikes.text = ""
//        lblTitleVote.text = ""
        
        lblRank.text = ""
        lblTotalVote.text = ""
        lblUserName.text = ""
        
        lblUserTitleAge.text = ""
        lblUserAge.text = ""
        
        lblUserTitleHeight.text = ""
        lblUserHeight.text = ""
        
        lblUserTitleWeight.text = ""
        lblUserWeight.text = ""
        
        btnVote.setTitle(txtValue: "BTN_VOTE")
        btnVote.setBtnContestStatusPinkUI(true)
        
        btnShare.setTitle(txtValue: "BTN_SHARE")
        btnShare.setBtnContestStatusGrayUI(true)
        
        txtSearch.setSearchUIWithPlaceholder(placeHolder: "TXT_PLACEHOLDER_SEARCH_TITLE")
        btnSearchClose.setBackgroundImage(UIImage(named: Constant.Image.close), for: .normal)
        viewContSearch.rectViewWithBorderColor()
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        viewContSearch.isHidden = true
        
        imgStarCoin.setImageFit(imageName: Constant.Image.history_star)
     //   imgLikes.setImageFit(imageName: Constant.Image.like)
        viewContButtomTabbar.backgroundColor = Constant.Color.VIEW_BG_TAB_BAR_COLOR
        imgButtomVote.setImageFit(imageName: Constant.Image.tab_vote)
        
        imgButtomShare.setImageFit(imageName: Constant.Image.tab_gift)
        imgButtomStarCharging.setImageFit(imageName: Constant.Image.tab_star_charging)
        imgButtomVotingRecord.setImageFit(imageName: Constant.Image.tab_vote_recored)
        
        imgUserProfile.setImageFit(imageName: Constant.Image.Default_iOS)
        imgUserProfile.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
        let imgUserProfileTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.imgUserProfileTabbed)) //imgPreviewTabbed
        imgUserProfile.isUserInteractionEnabled = true
        imgUserProfile.addGestureRecognizer(imgUserProfileTabbed)
        
        lblButtomTabVote.setSmallUIStyleTabbarWhite(value: "LBL_TABBAR_VOTE")
        lblButtomTabStarCharging.setSmallUIStyleTabbarWhite(value: "LBL_TABBAR_STAR_CHARGING")
        lblButtomTabShare.setSmallUIStyleTabbarWhite(value: "LBL_TABBAR_GIFT")
        lblButtomTabVotingRecord.setSmallUIStyleTabbarWhite(value: "LBL_TABBAR_VOTE_LIST")
        
        btnEditProfile.setTitle(txtValue: "BTN_EDIT_PROFILE")
        btnEditProfile.setBtnEditProfileUI()
        btnEditProfile.backgroundColor = UIColor.white
        btnEditProfile.isHidden = true
        
        viewContRank.backgroundColor = Constant.Color.NAVIGATION_BAR_BG_COLOR
        viewContRank.layer.cornerRadius = viewContRank.layer.height/2
        viewContRankAndDetails.backgroundColor = Constant.Color.VIEW_BG_EDIT_PROFILE_DETAIL_COLOR
        
//        imgVideoPlayBtn.setImageFit(imageName: Constant.Image.play)
//        let imgVideoPlayBtnTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.imgVideoPlayBtnTabbed))
//        imgVideoPlayBtn.isUserInteractionEnabled = true
//        imgVideoPlayBtn.addGestureRecognizer(imgVideoPlayBtnTabbed)
        
        
        viewSepretorFirst.backgroundColor = Constant.Color.TXTF_BG_COLOR
        viewSepretorSecond.backgroundColor = Constant.Color.TXTF_BG_COLOR
        viewSepretorThird.backgroundColor = Constant.Color.TXTF_BG_COLOR
        viewSepretorForth.backgroundColor = Constant.Color.TXTF_BG_COLOR
      //  viewSepretorFifth.backgroundColor = Constant.Color.VIEW_SEPRETOR_COLOR
        
        viewAgeSepretor.backgroundColor = Constant.Color.VIEW_SEPRETOR_COLOR
        viewHeightSepretor.backgroundColor = Constant.Color.VIEW_SEPRETOR_COLOR
        
        let viewContButtomVoteTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContButtomVoteTabbed))
        viewContButtomVote.isUserInteractionEnabled = true
        viewContButtomVote.addGestureRecognizer(viewContButtomVoteTabbed)
        
        let viewContButtomStarChargingTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContButtomStarChargingTabbed))
        viewContButtomStarCharging.isUserInteractionEnabled = true
        viewContButtomStarCharging.addGestureRecognizer(viewContButtomStarChargingTabbed)
        
        let viewContButtomShareTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContButtomShareTabbed))
        viewContButtomShare.isUserInteractionEnabled = true
        viewContButtomShare.addGestureRecognizer(viewContButtomShareTabbed)
        
        let viewContButtomVotingRecordTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.viewContButtomVotingRecordTabbed))
        viewContButtomVotingRecord.isUserInteractionEnabled = true
        viewContButtomVotingRecord.addGestureRecognizer(viewContButtomVotingRecordTabbed)
 
      //  tblViewHeight.constant = UIScreen.main.bounds.height - 196
        
//        imgPreview.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
        let imgPreviewTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.imgPreviewTabbed))
        imgPreview.isUserInteractionEnabled = true
        imgPreview.addGestureRecognizer(imgPreviewTabbed)
        
       // setProfiledataHobbies1FromApi()
        getContestantDetailsAPI()
        
    }
    
    func reloadTableViewCustom()
    {
        arrEditProfileMsgCell.removeAll()
       // tblView.reloadData()
    }
    
    func setProfiledataHobbies1FromApi()
    {
//        btnEditProfile.isHidden = false
        if(Util.getIsUserLogin() == "1")
        {
            let dictData1:[String: Any]? = Util.getUserProfileDict()
            if(dictData1 != nil)
            {
                let objUserProfile = UserProfileModel.dictToUserObjUserDefaultUserProfile(dictData: dictData1!)
                if(objUserProfile.strUserId == objContestantProfileViewModel.objUserProfileModel.strUserId)
                {
                    btnEditProfile.isHidden = false
                }else
                {
                    btnEditProfile.isHidden = true
                }
            }
        }
        
        if(objContestantProfileViewModel.objUserProfileModel.strImageUrl != "")
        {
            imgUserProfile.getImageFromURL(url: objContestantProfileViewModel.objUserProfileModel.strImageUrl)
            imgUserProfile.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
//            imgUserProfile.setFitImageInImageView()
            imgUserProfile.setAspectFillImageInImageView()
        }
        
        let strRank : Int = Int(objContestantProfileViewModel.objUserProfileModel.strCurrentRanking)!
        if strRank == 1 {
            lblRank.setLoginHeaderBigUIStyleWhiteCell(value: "\(strRank)\("LBL_ST".localizedLanguage())")
        }else if strRank == 2 {
            lblRank.setLoginHeaderBigUIStyleWhiteCell(value: "\(strRank)\("LBL_ND".localizedLanguage())")
        } else if strRank == 3 {
            lblRank.setLoginHeaderBigUIStyleWhiteCell(value: "\(strRank)\("LBL_RD".localizedLanguage())")
        }else {
            lblRank.setLoginHeaderBigUIStyleWhiteCell(value: "\(strRank)")
        }
        
        let vote = objContestantProfileViewModel.objUserProfileModel.strTotalVote
        if(vote!.count >= 1)
        {
            lblTotalVote.setLoginHeaderBigUIStylePink(value: Util.intToNumberFormat(intValue: Int(vote!) ?? 0))
        }else
        {
            lblTotalVote.setLoginHeaderBigUIStylePink(value: Util.intToNumberFormat(intValue: 0))
        }
        
        lblUserName.setEditProfileHeaderUIStyleFullBack(value: objContestantProfileViewModel.objUserProfileModel.strUserName)
        
        lblUserTitleAge.setNormalEditProfileSecondTitleGray(value: "LBL_AGE")
        lblUserAge.setBoldEditProfileSecondTitleBalck(value: "\(objContestantProfileViewModel.objUserProfileModel.strAge!)\("LBL_AGE_VALUE".localizedLanguage())")
        
        lblUserTitleHeight.setNormalEditProfileSecondTitleGray(value: "LBL_HEIGHT")
        
        if Float(objContestantProfileViewModel.objUserProfileModel.strHeight)! <= 10 {
            lblUserHeight.setBoldEditProfileSecondTitleBalck(value: "\(objContestantProfileViewModel.objUserProfileModel.strHeight!)ft")
        }else {
            lblUserHeight.setBoldEditProfileSecondTitleBalck(value: "\(objContestantProfileViewModel.objUserProfileModel.strHeight!)cm")
        }
        lblUserTitleWeight.setNormalEditProfileSecondTitleGray(value: "LBL_WEIGHT")
        lblUserWeight.setBoldEditProfileSecondTitleBalck(value: "\(objContestantProfileViewModel.objUserProfileModel.strWeight!)kg")

        setProfiledataHobbies2FromApi()
    }
    
    func setProfiledataHobbies2FromApi()
    {
        let sceenWidth = UIScreen.main.bounds.width - 30
        viewContFlexibleHobbies2.subviews.forEach({ $0.removeFromSuperview() })
        
        viewHeightFlexibleHobbies2.constant = 25
        var labelHeight:CGFloat = 0

        let totalRecord = objContestantProfileViewModel.objUserProfileModel.objUserHobbiesModel2.count
        var index = 1
        for objUserHobbies in objContestantProfileViewModel.objUserProfileModel.objUserHobbiesModel2
        {
            let lblTitle:UILabel = UILabel()
            lblTitle.translatesAutoresizingMaskIntoConstraints = false
            viewContFlexibleHobbies2.addSubview(lblTitle)
            lblTitle.setBoldEditProfileThirdTitleGrey(value: objUserHobbies.strHobbiesName)
            
            lblTitle.leftAnchor.constraint(equalTo: viewContFlexibleHobbies2.leftAnchor, constant: 15).isActive = true
            lblTitle.topAnchor.constraint(equalTo: viewContFlexibleHobbies2.topAnchor, constant: labelHeight).isActive = true
            lblTitle.widthAnchor.constraint(equalToConstant: 80).isActive = true
            lblTitle.heightAnchor.constraint(equalToConstant: 35).isActive = true
            
            let lblDetail:UILabel = UILabel()
            lblDetail.translatesAutoresizingMaskIntoConstraints = false
            viewContFlexibleHobbies2.addSubview(lblDetail)
            lblDetail.numberOfLines = 0
            lblDetail.setNormalEditProfileThirdTitleBalck(value: objUserHobbies.strHobbiesDetail)
            
            lblDetail.leftAnchor.constraint(equalTo: viewContFlexibleHobbies2.leftAnchor, constant: 105).isActive = true
            lblDetail.topAnchor.constraint(equalTo: viewContFlexibleHobbies2.topAnchor, constant: labelHeight).isActive = true
            lblDetail.widthAnchor.constraint(equalToConstant: sceenWidth - 95).isActive = true
            var lblDetailHeight = Util.getLblHeight(label: lblDetail,lblWidth: sceenWidth - 95)
            lblDetailHeight += 15
//            if(lblDetailHeight < 35)
//            {
//                lblDetailHeight = 35
//            }
            lblDetail.heightAnchor.constraint(equalToConstant: lblDetailHeight).isActive = true
            
            labelHeight += lblDetailHeight
            
            if(index != totalRecord)
            {
                let viewSepretor:UIView = UIView()
                viewSepretor.translatesAutoresizingMaskIntoConstraints = false
                viewSepretor.backgroundColor = Constant.Color.VIEW_SEPRETOR_COLOR
                viewContFlexibleHobbies2.addSubview(viewSepretor)
                
                viewSepretor.leftAnchor.constraint(equalTo: viewContFlexibleHobbies2.leftAnchor, constant: 15).isActive = true
                viewSepretor.topAnchor.constraint(equalTo: viewContFlexibleHobbies2.topAnchor, constant: labelHeight).isActive = true
                viewSepretor.trailingAnchor.constraint(equalTo: viewContFlexibleHobbies2.trailingAnchor, constant: 0).isActive = true
                viewSepretor.heightAnchor.constraint(equalToConstant: 1).isActive = true
                labelHeight += 1
            }
            index += 1
        }
        viewHeightFlexibleHobbies2.constant = labelHeight
        
        setProfileOtherApiData()
    }
    
    func setProfileOtherApiData()
    {
        viewContContestantDetailProfile.backgroundColor = Constant.Color.VIEW_BG_EDIT_PROFILE_DETAIL_COLOR
        
        imgContestantDetailProfile.getImageFromURL(url: objContestantProfileViewModel.objUserProfileModel.strImageUrl)
        imgContestantDetailProfile.roundViewColor()
        imgContestantDetailProfile.layer.borderWidth = 1
        imgContestantDetailProfile.borderColor = Constant.Color.VIEW_SEMI_GRAY_BORDER_COLOR
//        imgContestantDetailProfile.setFitImageInImageView()
        imgContestantDetailProfile.setAspectFillImageInImageView()
        
        
        if(objContestantProfileViewModel.objUserProfileModel.strMyIntro == "")
        {
            lblContestantDetailProfile.setNormalEditProfileSecondTitleBalck(value: "LBL_NO_INFO_AVAILABLE".localizedLanguage())
        }else
        {
            lblContestantDetailProfile.setNormalEditProfileSecondTitleBalck(value: objContestantProfileViewModel.objUserProfileModel.strMyIntro)
        }
        
        
        
//        imgVideoThumbnail.setImageFill(imageName: "bunny")
//        imgVideoThumbnail.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
//        imgVideoThumbnail.setFitImageInImageView()
    }
    
    func addPreviewImageUI() {

        let vWidth = viewContPreviewImg.frame.width
        let vHeight = viewContPreviewImg.frame.height

        scrollImg = UIScrollView()
        scrollImg.delegate = self
        scrollImg.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
       // scrollImg.backgroundColor = UIColor.systemPink
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()

        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 10.0

        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollImg.addGestureRecognizer(doubleTapGest)

        self.viewContPreviewImg.addSubview(scrollImg)

        imageView = UIImageView(frame: CGRect(x: 0 , y: 0, width: vWidth, height: vHeight))
        imageView.image = UIImage(named: Constant.Image.Default_iOS)
        imageView.center = scrollImg.center
        imageView!.layer.cornerRadius = 11.0
        imageView!.clipsToBounds = false
        scrollImg.addSubview(imageView!)
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = imageView.convert(center, from: scrollImg)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func getContestantDetailsAPI() {
        isNetworkAvailable { (isSuccess) in
            if(Util.isNetworkReachable()) {
                self.showProgress()
                let objUserProfileModel = UserProfileModel()
                objUserProfileModel.strContestId = self.objContestant.strContestId
                objUserProfileModel.strContestantId = self.objContestant.strId
                self.objContestantProfileViewModel.getContestantDetailsAPI(objUser: objUserProfileModel)
            }else {
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
    }
    
    func getMediaGallaryAPI() {
        isNetworkAvailable { (isSuccess) in
            if(Util.isNetworkReachable()) {
                self.showProgress()
                let objUserProfileModel = UserProfileModel()
                objUserProfileModel.strContestantId = self.objContestant.strId
                self.objContestantProfileViewModel.getMediaGallaryAPI(objUser: objUserProfileModel)
            }else {
                AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
            }
        }
    }
    
    func contestantDetailSuccessResponse() {
        setProfiledataHobbies1FromApi()
        getMediaGallaryAPI()
    }
    
    func getImageWithArr() {
        arrWidth.removeAll()
        
        if(objContestantProfileViewModel.arrMyMediaGallaryModelImage.count != 0) {
            for objMyMediaGallaryModelImage in objContestantProfileViewModel.arrMyMediaGallaryModelImage {
                
                let imageView = UIImageView()
                let imageUrl = objMyMediaGallaryModelImage.srtMediaPath
                let height = objCollectionView.frame.height
                
                let width = imageView.getImageFromURLWithWidth(url: imageUrl!, height: height)
                arrWidth.append(Double(width))
            }
        }
    }
    
    func mediaGallarySuccessResponse() {
        
        getImageWithArr()
        self.objCollectionView.reloadData()
        
        objCollectionView.reloadData()
        manageHightOfVideoCell()
        manageHightOfYouTubeVideoCell()
        tblVideoList.reloadData()
        tblYouTubeList.reloadData()
        if(objContestantProfileViewModel.arrMyMediaGallaryModelImage.count == 0)
        {
            cnsImageViewHeight.constant = 0
            constPreviewImgHeight.constant = 0
        }else
        {
            cnsImageViewHeight.constant = 140
            constPreviewImgHeight.constant = (UIScreen.main.bounds.height - 279)
            imgPreview.getImageFromURL(url: objContestantProfileViewModel.arrMyMediaGallaryModelImage[0].srtMediaPath)
            imgPreview.setFitImageInImageView()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.getImageWithArr()
            self.objCollectionView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.getImageWithArr()
            self.objCollectionView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.getImageWithArr()
            self.objCollectionView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.getImageWithArr()
            self.objCollectionView.reloadData()
        }
    }
    
    func onApiSuccessHideProgress() {
        self.hideProgress()
    }
    
    func showMessage(message: String) {
        AlertPresenter.alertInformation(fromVC: self, message: message)
    }
    
    func showMessageForMediaGallery(message: String) {
        if objContestantProfileViewModel.arrMyMediaGallaryModelImage.count == 0 {
            
            cnsImageViewHeight.constant = 0
            constPreviewImgHeight.constant = 0
            
        }else {
            cnsImageViewHeight.constant = 140
            constPreviewImgHeight.constant = 380
        }
        
        if objContestantProfileViewModel.arrMyMediaGallaryModelYouTubeVideo.count == 0 {
            manageHightOfYouTubeVideoCell()
            tblYouTubeList.reloadData()
        }
        
//        getMediaGallaryAPI()
    }
    
    //MARK:- Button clicked
    @IBAction func btnSearchClicked(_ sender: UIButton) {
        viewContSearch.isHidden = true
    }
    
    @IBAction func btnSendMessageClicked(_ sender: UIButton) {
       // txtFSendMessage.text = ""
    }
    
    @IBAction func btnVoteClicked(_ sender: UIButton) {
        if(Util.getIsUserLogin() == "0")
        {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
        }else
        {
            if objContestantProfileViewModel.objUserProfileModel.strContestStatus == Constant.ResponseParam.CONTEST_STATUS_OPEN {
                let objVotePopupVC = VotePopupVC()
                objVotePopupVC.myNavigationController = self.navigationController
                //            objVotePopupVC.objContestant = self.objContestant
                self.objContestant.strName = objContestantProfileViewModel.objUserProfileModel.strUserName
                objVotePopupVC.objContestant = self.objContestant
                objVotePopupVC.objContestantProfileDelegate = self
                objVotePopupVC.modalTransitionStyle = .crossDissolve
                objVotePopupVC.modalPresentationStyle = .overCurrentContext
                self.present(objVotePopupVC, animated: true, completion: nil)
            }else {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_IT_IS_NOT_VOTING_PERIOD")
            }
        }
    }
    
    @IBAction func btnShareClicked(_ sender: UIButton) {
        if(objContestantProfileViewModel.objUserProfileModel.strUserId != nil)
        {
            let objSharePopupVC = SharePopupVC()
            objSharePopupVC.objUserProfileModel = objContestantProfileViewModel.objUserProfileModel
            objSharePopupVC.imgContestantProfile = imgUserProfile.image
            objSharePopupVC.modalTransitionStyle = .crossDissolve
            objSharePopupVC.modalPresentationStyle = .overCurrentContext
            self.present(objSharePopupVC, animated: true, completion: nil)
        }else
        {
            AlertPresenter.alertInformation(fromVC: self, message: "NO_INTERNET_CONNECTION")
        }
    }
    
    @IBAction func btnEditProfileClicked(_ sender: UIButton) {
        let objEditprofileContestantSelfVC = EditprofileContestantSelfVC()
        
        let objEditprofileContestantSelfViewModel = EditprofileContestantSelfViewModel(vc: objEditprofileContestantSelfVC)
        objEditprofileContestantSelfViewModel.objUserProfileModel = objContestantProfileViewModel.objUserProfileModel
        objEditprofileContestantSelfViewModel.setDataInImageVideoArray(arrMyMediaGallaryModel: objContestantProfileViewModel.arrMyMediaGallaryModel)
        
        objEditprofileContestantSelfVC.objContestantProfileVCDelegate = self
        objEditprofileContestantSelfVC.arrYouTubeVideoUrl = objContestantProfileViewModel.arrMyMediaGallaryModelYouTubeVideo
        objEditprofileContestantSelfVC.objEditprofileContestantSelfModel = objEditprofileContestantSelfViewModel
        
        self.navigationController?.pushViewController(objEditprofileContestantSelfVC, animated: true)
    }
    
    
    //MARK: Button Tabbed
    @objc override func leftBarButtonClick() {
        self.navigationController?.popViewController(animated: true)
        
        if isProfilePhotoUpdated {
            if objContestantListVCDelegate != nil {
                objContestantListVCDelegate.reloadContestantProfileApi()
            }
        }
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
    
//    @objc override func rightBtnClickedWithImg2() {
//        viewContSearch.isHidden = false
//    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
      //  print(textField.text ?? "")
    }

    //MARK:-  Tapped Methods clicked
    @objc func viewContButtomVoteTabbed(_ sender: CustomTabGestur){
        if(Util.getIsUserLogin() == "0")
        {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
        }else
        {
            if objContestantProfileViewModel.objUserProfileModel.strContestStatus == Constant.ResponseParam.CONTEST_STATUS_OPEN {
                let objVotePopupVC = VotePopupVC()
                objVotePopupVC.myNavigationController = self.navigationController
                self.objContestant.strName = objContestantProfileViewModel.objUserProfileModel.strUserName
                objVotePopupVC.objContestant = self.objContestant
                objVotePopupVC.objContestantProfileDelegate = self
                objVotePopupVC.modalTransitionStyle = .crossDissolve
                objVotePopupVC.modalPresentationStyle = .overCurrentContext
                self.present(objVotePopupVC, animated: true, completion: nil)
            }else {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_IT_IS_NOT_VOTING_PERIOD")
            }
        }
    }
    

    @objc func imgPreviewTabbed(_ sender: CustomTabGestur){
        var images = [LightboxImage]()
        for objMyMediaGallaryModel in objContestantProfileViewModel.arrMyMediaGallaryModelImage {
            images.append(LightboxImage(imageURL: URL(string: objMyMediaGallaryModel.srtMediaPath)!))
        }
        
//        for objImage in arrImages {
//            images.append(LightboxImage(
//                image: UIImage(named: objImage)!,
//                text: ""
//            ))
//        }
        
        LightboxConfig.CloseButton.image = UIImage(named: Constant.Image.close_white)
        // LightboxConfig.CloseButton.textAttributes = TextAttributes.Lightbox.closeButton
        LightboxConfig.CloseButton.text = ""
        LightboxConfig.PageIndicator.enabled = true
        
        LightboxConfig.handleVideo = { from, videoURL in
            // Custom video handling
            let videoController = AVPlayerViewController()
            videoController.player = AVPlayer(url: videoURL)
            
            from.present(videoController, animated: true) {
                videoController.player?.play()
            }
        }
        
        objLightboxController = LightboxController(images: images)
        objLightboxController.modalPresentationStyle = .fullScreen
        objLightboxController.pageDelegate = self
        
        self.present(objLightboxController, animated: false, completion: nil)
        for i in  0..<collectionCurrentIndex {
            objLightboxController.next()
        }
    }
    
    @objc func imgUserProfileTabbed(_ sender: CustomTabGestur){
        var images = [LightboxImage]()
        images.append(LightboxImage(imageURL: URL(string: objContestantProfileViewModel.objUserProfileModel.strImageUrl)!))
        
        LightboxConfig.CloseButton.image = UIImage(named: Constant.Image.close_white)
        LightboxConfig.CloseButton.text = ""
        LightboxConfig.PageIndicator.enabled = false
        
        let objLightboxController1 = LightboxController(images: images)
        objLightboxController1.modalPresentationStyle = .fullScreen
        
        self.present(objLightboxController1, animated: false, completion: nil)
    }
    
    @objc func viewContButtomStarChargingTabbed(_ sender: CustomTabGestur){
        
        if(Util.getIsUserLogin() == "0") {
            AlertPresenter.alertInformation(fromVC: Util.currentNavigationController.topViewController!, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
        }else {
            let objWebViewWithTabVC = WebViewWithTabVC()
            objWebViewWithTabVC.isBackButtonShow = true
            self.navigationController?.pushViewController(objWebViewWithTabVC, animated: true)
        }
        
        
    }

    @objc func viewContButtomShareTabbed(_ sender: CustomTabGestur){
        if(Util.getIsUserLogin() == "0")
        {
            AlertPresenter.alertInformation(fromVC: self, message: "ALERT_YOU_HAVE_LOGIN_FIRST")
        }else
        {
            
            let objGiftVC2 = GiftVC2()
            objGiftVC2.myNavigationController = self.navigationController
            objGiftVC2.isBackButtonShow = true
            objGiftVC2.modalTransitionStyle = .crossDissolve
            objGiftVC2.modalPresentationStyle = .overCurrentContext
            self.present(objGiftVC2, animated: true, completion: nil)
    //        self.navigationController?.pushViewController(objGiftVC2, animated: true)
        }

    }
    
    @objc func viewContButtomVotingRecordTabbed(_ sender: CustomTabGestur){
        let objVotingHistoryVC2 = VotingHistoryVC2()
        objVotingHistoryVC2.strContestant = self.objContestant.strId
        objVotingHistoryVC2.strContestId = self.objContestant.strContestId
        self.navigationController?.pushViewController(objVotingHistoryVC2, animated: true)
    }
    
    @objc func imgVideoPlayBtnTabbed(_ sender: CustomTabGestur){
        printDebug("play video")
        //http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
        //https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
        //http://etechservices.biz/rankingstar/assets/gallary/trim_6C87C59E-9F4E-49B8-9116-1B0BD900E243.MOV
//        let url = URL(string: "http://rankingstar.cafe24.com/video/SampleVideo_1280x720_30mb.mp4")
        
        let url = URL(string: sender.strUrl)
        
        if sender.isYouTubeVideo {
            if(sender.strUrl != nil)
            {
                let objYoutubePlayerVC = YoutubePlayerVC()
                objYoutubePlayerVC.url_YouTube_Key = sender.strUrl
                self.navigationController?.pushViewController(objYoutubePlayerVC, animated: false)
            }else
            {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_INVALID_YOUTUBE_LINK")
                printDebug("video not found")
            }
            
        }else {
            if(url != nil)
            {
                let player = AVPlayer(url: url!)
                let vc = AVPlayerViewController()
                
                vc.player = player

                vc.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

                self.present(vc, animated: true) {
                    vc.player?.play()
                }
            }else
            {
                AlertPresenter.alertInformation(fromVC: self, message: "ALERT_VIDEO_NOT_FOUND")
                printDebug("video not found")
            }
        }
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollImg.zoomScale == 1 {
            scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollImg.setZoomScale(1, animated: true)
        }
    }
    
    
}

extension ContestantProfileVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField == txtSearch) {
            self.searchedText = txtSearch.text!
            
            if searchedText.isEmpty {
              //  objChargingStarHistoryModel.arrChargingHistoryModel = []
                reloadTableViewCustom()
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


extension ContestantProfileVC : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        // print("SlideMenuControllerDelegate: leftWillOpen")
    }
}

extension ContestantProfileVC : UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    // collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objContestantProfileViewModel.getTableNumberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ContestantProfileImageVideoCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CellIdentifier.CONTESTANT_PROFILE_IMAGE_VIDEO_CELL, for: indexPath) as! ContestantProfileImageVideoCell
        cell.imgVPlayPlush.isHidden = true
        
        cell.imgVUser.getImageFromURLWithWidth(url: objContestantProfileViewModel.arrMyMediaGallaryModelImage[indexPath.row].srtThumbPath, height: objCollectionView.frame.height)

        cell.imgVUser.setFitImageInImageView()
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       // let cell = collectionView.cellForItem(at: indexPath) as! ContestantProfileImageVideoCell
        imgPreview.getImageFromURL(url: objContestantProfileViewModel.arrMyMediaGallaryModelImage[indexPath.row].srtMediaPath)
        imgPreview.setFitImageInImageView()
        self.collectionCurrentIndex = indexPath.row
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = arrWidth[indexPath.row]
        let height = Double(objCollectionView.frame.height)
        return CGSize(width: width, height: height)
    }
    
    func manageSizeOfCollectionViewCell()
    {
        let uiCollectionViewFlowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let size:CGFloat = UIScreen.main.bounds.width - 50
//        let size:CGFloat = objCollectionView.frame.width - 28
        uiCollectionViewFlowLayout.itemSize = CGSize(width: (size/2) - 15, height: objCollectionView.frame.height)
        objCollectionView.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        uiCollectionViewFlowLayout.minimumInteritemSpacing = 10
        uiCollectionViewFlowLayout.minimumLineSpacing = 10
        uiCollectionViewFlowLayout.scrollDirection = .horizontal
        objCollectionView.collectionViewLayout = uiCollectionViewFlowLayout
        objCollectionView.setNeedsLayout()
        objCollectionView.updateFocusIfNeeded()
    }
    // collection view end
}

extension ContestantProfileVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case tblVideoList:
            return 200
        case tblYouTubeList:
            return 200
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tblVideoList:
            return objContestantProfileViewModel.arrMyMediaGallaryModelVideo.count
        case tblYouTubeList:
            return objContestantProfileViewModel.arrMyMediaGallaryModelYouTubeVideo.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case tblVideoList:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.CONTESTANT_PROFILE_VIDEO_LIST_CELL) as! ContestantProfileVideoCell
            
            cell.viewSeparator.backgroundColor = Constant.Color.TXTF_BG_COLOR
            if indexPath.row == objContestantProfileViewModel.arrMyMediaGallaryModelVideo.count - 1 {
                cell.viewSeparator.backgroundColor = UIColor.clear
            }
            
            let objVideo = objContestantProfileViewModel.arrMyMediaGallaryModelVideo[indexPath.row]
            
            //        let url = "http://rankingstar.cafe24.com/video/SampleVideo_1280x720_30mb.mp4"
            
            cell.imgVideoPlayBtn.setImageFit(imageName: Constant.Image.play)
            let imgVideoPlayBtnTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.imgVideoPlayBtnTabbed))
            imgVideoPlayBtnTabbed.strUrl = objVideo.srtMediaPath
            cell.imgVideoPlayBtn.isUserInteractionEnabled = true
            cell.imgVideoPlayBtn.addGestureRecognizer(imgVideoPlayBtnTabbed)
            
            cell.imgVideoThumbnail.getImageFromURL(url: objVideo.srtThumbPath,defImage: Constant.Image.Video_iOS)
            //        cell.imgVideoThumbnail.setImageFill(imageName: objVideo.srtThumbPath)
            cell.imgVideoThumbnail.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
            //cell.imgVideoThumbnail.setFitImageInImageView()
            
            return cell
            
        case tblYouTubeList:

            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.CONTESTANT_PROFILE_VIDEO_LIST_CELL) as! ContestantProfileVideoCell
            
//            cell.viewSeparator.backgroundColor = Constant.Color.TXTF_BG_COLOR
            if indexPath.row == objContestantProfileViewModel.arrMyMediaGallaryModelVideo.count - 1 {
                cell.viewSeparator.backgroundColor = UIColor.clear
            }
            
            let objYouTubeVideo = objContestantProfileViewModel.arrMyMediaGallaryModelYouTubeVideo[indexPath.row]
            
            cell.imgVideoPlayBtn.setImageFit(imageName: Constant.Image.play)
            let imgVideoPlayBtnTabbed:CustomTabGestur = CustomTabGestur(target: self, action: #selector(self.imgVideoPlayBtnTabbed))
            imgVideoPlayBtnTabbed.strUrl = objYouTubeVideo.srtMediaPath
            imgVideoPlayBtnTabbed.isYouTubeVideo = true
            cell.imgVideoPlayBtn.isUserInteractionEnabled = true
            cell.imgVideoPlayBtn.addGestureRecognizer(imgVideoPlayBtnTabbed)
            
            cell.imgVideoThumbnail.getImageFromURL(url: objYouTubeVideo.srtThumbPath,defImage: Constant.Image.Video_iOS)
            //        cell.imgVideoThumbnail.setImageFill(imageName: objVideo.srtThumbPath)
//            cell.imgVideoThumbnail.backgroundColor = Constant.Color.VIEW_IMG_BG_GRAY_COLOR
            //cell.imgVideoThumbnail.setFitImageInImageView()
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func manageHightOfVideoCell() {
        let videoCount = objContestantProfileViewModel.getnumberOfVideos()
        cnstblVideoListHeight.constant = CGFloat(videoCount * 200)
    }
    
    func manageHightOfYouTubeVideoCell() {
        let videoCount = objContestantProfileViewModel.getNumberOfYouTubeVideos()
        cnstblYouTubeListHeight.constant = CGFloat(videoCount * 200)
    }
}


extension ContestantProfileVC: LightboxControllerPageDelegate,LightboxControllerDismissalDelegate {

    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
    }
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
    //    objLightboxController.dismiss(animated: true, completion: nil)
    }
}
extension ContestantProfileVC: ContestantProfileVCDelegate {
    func reloadContestantProfileApi()
    {
        getContestantDetailsAPI()
        getMediaGallaryAPI()
        
        isProfilePhotoUpdated = true
    }
    
    func reloadOnlyProfileData() {
        getContestantDetailsAPI()
        isProfilePhotoUpdated = true
    }
}


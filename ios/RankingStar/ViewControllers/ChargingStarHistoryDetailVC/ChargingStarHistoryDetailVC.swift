//
//  ChargingStarHistoryDetailVC.swift
//  RankingStar
//
//  Created by etech-9 on 03/02/20.
//  Copyright © 2020 Etech. All rights reserved.
//

import UIKit

protocol getApiOnRefresh {
    func getApi()
}

class ChargingStarHistoryDetailVC: BaseVC {

    @IBOutlet var tblView: UITableView!
    var isEarning : Bool! = false
    var objStarHistory : ChargingHistoryModel!
    var isViewWillApear = false
    
    var delegate : getApiOnRefresh!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.delegate = self
        tblView.dataSource = self
        
        tblView.register(UINib(nibName: Constant.CellIdentifier.CELL_CHARGING_HISTORY, bundle: nil), forCellReuseIdentifier: Constant.CellIdentifier.CELL_CHARGING_HISTORY)
        tblView.separatorStyle = .none
        tblView.tableFooterView = UIView()
        tblView.reloadData()
        
        addRefreashControl(tblView: tblView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblView.reloadData()
        isViewWillApear = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isViewWillApear = false
        dismissAlertInfoPresenter()
    }
    
    func getData(objStarHistory : ChargingHistoryModel) {
        self.objStarHistory = objStarHistory
        if isViewWillApear  {
            self.tblView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    override func refresh(sender: AnyObject) {
        if delegate != nil {
            delegate?.getApi()
        }
    }
}


extension ChargingStarHistoryDetailVC : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isEarning {
            return self.objStarHistory.arrEarning.count
        }else {
            return self.objStarHistory.arrUsage.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.CELL_CHARGING_HISTORY) as! ChargingHistoryCell

        cell.selectionStyle = .none
        
        if isEarning {
            let objEarning = objStarHistory.arrEarning[indexPath.row]
            
            
            if objEarning.type != nil && objEarning.type != "" {
                if objEarning.type == "gift" {
                    cell.lblName.setLoginNormalUIStyleFullBack(value: objEarning.desc)
                    if objEarning.Sender_name != nil && objEarning.Sender_name != "" {
                        cell.lblName.setLoginNormalUIStyleFullBack(value: "\(objEarning.desc!) - \(objEarning.Sender_name!)")
                    }
                }else {
                    cell.lblName.setLoginNormalUIStyleFullBack(value: objEarning.desc)
                    if objEarning.Sender_name != nil && objEarning.Sender_name != "" {
                        cell.lblName.setLoginNormalUIStyleFullBack(value: "\(objEarning.Sender_name!) \(objEarning.desc!)")
                    }
                }
            }else {
                cell.lblName.setLoginNormalUIStyleFullBack(value: objEarning.desc)
                if objEarning.Sender_name != nil && objEarning.Sender_name != "" {
                    cell.lblName.setLoginNormalUIStyleFullBack(value: "\(objEarning.Sender_name!) \(objEarning.desc!)")
                }
            }
            
            let myStar : Int = Int(objEarning.star)!
            cell.lblCounter.setLoginNormalUIStyleNavColorForCell(value: "\(myStar.stringWithSepator(amount: myStar)) 개")
            cell.lblDate.setLoginNormalUIStyleFullBack(value: objEarning.purchase_date)
        }else {
            let objUsage = objStarHistory.arrUsage[indexPath.row]
            
            if objUsage.desc == Constant.ResponseParam.STAR_HISTORY_TYPE_GIFT {
                cell.lblName.setLoginNormalUIStyleFullBack(value: "\(objUsage.usage_type!)")
                if objUsage.receiver_name != nil && objUsage.receiver_name != "" {
                    cell.lblName.setLoginNormalUIStyleFullBack(value: "\(objUsage.usage_type!) \(objUsage.receiver_name!) ")
                }
                if objUsage.contest_name != nil && objUsage.contest_name != "" {
                    cell.lblName.setLoginNormalUIStyleFullBack(value: "\(objUsage.contest_name!) - \(objUsage.usage_type!) \(objUsage.receiver_name!) ")
                }
            }else {
                cell.lblName.setLoginNormalUIStyleFullBack(value: "\(objUsage.usage_type!)")
                if objUsage.receiver_name != nil && objUsage.receiver_name != "" {
                    cell.lblName.setLoginNormalUIStyleFullBack(value: "\(objUsage.receiver_name!) \(objUsage.usage_type!)")
                }
                if objUsage.contest_name != nil && objUsage.contest_name != "" {
                    cell.lblName.setLoginNormalUIStyleFullBack(value: "\(objUsage.contest_name!) - \(objUsage.receiver_name!) \(objUsage.usage_type!)")
                }
            }
            
            
            let myStar : Int = Int(objUsage.star)!
            cell.lblCounter.setLoginNormalUIStyleNavColorForCell(value: "-\(myStar.stringWithSepator(amount: myStar)) 개")
            let date = Util.convertDateFormat(date: objUsage.date, dateFormat: Constant.DateFormat.DateFormatYYYY_MM_DD_HH_MM_SS, newDateFormat: Constant.DateFormat.Simple_Date_Format)
            cell.lblDate.setLoginNormalUIStyleFullBack(value: date!)
            //            cell.lblName.setLoginNormalUIStyleFullBack(value: "Name \(indexPath.row)\(indexPath.row)")
            //            cell.lblCounter.setLoginNormalUIStyleNavColorForCell(value: "\(indexPath.row)A")
        }
        cell.viewSeprator.backgroundColor = Constant.Color.VIEW_SEPRETOR_COLOR

        return cell
    }
}

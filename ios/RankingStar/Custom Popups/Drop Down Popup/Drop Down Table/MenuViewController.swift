//
//  MenuViewController.swift
//  ThingsUI
//
//  Created by Ryan Nystrom on 3/8/18.
//  Copyright © 2018 Ryan Nystrom. All rights reserved.
//

import UIKit

@objc protocol MenuViewControllerDelegate: NSObjectProtocol {
    @objc func selectedDropDownListItem(strItem : String, itemIndex:Int)
}
/*
class DropDownItems {
    
    var strMenuItemName : String!
    var strMenuImageName : String!
    
    init(strItemName: String, strImageName: String?) {
        strMenuItemName = strItemName
        strMenuImageName = strImageName
    }
}*/

class MenuViewController: UITableViewController {

    var menuDropdownDeletege : MenuViewControllerDelegate? = nil
    fileprivate var arrMenuItem : [DropDownItems] = [DropDownItems]()
    
    var arrTblData: [DropDownItems] {
        get {
            return arrMenuItem
        }
        set(newValue) {
            arrMenuItem = newValue
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "DropDownCell", bundle: nil), forCellReuseIdentifier: "dropDownCell")
        tableView.reloadData()
        tableView.layoutIfNeeded()
        preferredContentSize = CGSize(width: 100, height: tableView.contentSize.height)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenuItem.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objRefCell = tableView.dequeueReusableCell(withIdentifier: "dropDownCell", for: indexPath) as! DropDownCell
        objRefCell.lblMenuTitle.text = "\(arrMenuItem[indexPath.row].strMenuItemName!)"
        
        objRefCell.selectionStyle = .none
        return objRefCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menuDropdownDeletege != nil {
            if arrMenuItem.count > 0 {
                menuDropdownDeletege?.selectedDropDownListItem(strItem: arrMenuItem[indexPath.row].strMenuItemName, itemIndex:indexPath.row)
            }
        }
    }

}

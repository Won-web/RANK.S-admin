//
//  DropDownMenuListingTBL.swift
//  CommonXibDemo
//
//  Created by kETAN on 10/10/18.
//  Copyright © 2018 kETAN. All rights reserved.
//

import UIKit

@objc protocol DropDownMenuListingTBLDelegate: NSObjectProtocol {
    @objc func selectedDropDownListItem(strItem : String, itemIndex:Int)
}

class DropDownItems {

    var strMenuItemName : String!
    var strMenuImageName : String!
    
    init(strItemName: String, strImageName: String?) {
        strMenuItemName = strItemName
        strMenuImageName = strImageName
    }
    
}

class DropDownMenuListingTBL: UITableViewController {
    
    var menuDropdownDeletege : DropDownMenuListingTBLDelegate? = nil
    fileprivate var arrMenuItem : [DropDownItems] = [DropDownItems]()
    var cGFloatWidthOfCell:CGFloat = 100
    var textAlignment:NSTextAlignment = .center
    
    var arrTblData: [DropDownItems] {
        get {
            return arrMenuItem
        }
        set(newValue) {
            arrMenuItem = newValue
            tableView.reloadData()
            //preferredContentSize = CGSize(width: 100, height: Int(tableView.contentSize.height)*Int(arrMenuItem.count))
            
            if tableView.contentSize.height <= UIScreen.main.bounds.height {
//                preferredContentSize = CGSize(width: 100, height: tableView.contentSize.height)
                preferredContentSize = CGSize(width: cGFloatWidthOfCell, height: tableView.contentSize.height)
            } else {
                preferredContentSize = CGSize(width: 100, height: 150)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: "DropDownCell", bundle: nil), forCellReuseIdentifier: "dropDownCell")
        tableView.tableFooterView = UIView()
        tableView.reloadData()
        //preferredContentSize = CGSize(width: 200, height: 300)
        
        preferredContentSize = CGSize(width: 100, height: tableView.contentSize.height)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        tableView.layoutIfNeeded()
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrMenuItem.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objRefCell = tableView.dequeueReusableCell(withIdentifier: "dropDownCell", for: indexPath) as! DropDownCell
        objRefCell.lblMenuTitle.textAlignment = textAlignment
        objRefCell.lblMenuTitle.text = "\(arrMenuItem[indexPath.row].strMenuItemName!)"
        objRefCell.lblMenuTitle.font = PopupOverDropDown.FONT_LBL_DROP_DOWN_TITLE
        objRefCell.lblMenuTitle.textColor = PopupOverDropDown.LBL_DROP_DOWN_TITLE_COLOR
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

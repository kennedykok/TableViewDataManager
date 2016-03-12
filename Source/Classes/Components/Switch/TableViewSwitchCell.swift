//
//  TableViewSwitchCell.swift
//  TableViewManager
//
//  Created by Roman Efimov on 3/15/15.
//  Copyright (c) 2015 Roman Efimov. All rights reserved.
//

import UIKit

public class TableViewSwitchCell: TableViewFormCell {

    // Public variables
    //
    public override var item: TableViewItem! { get { return switchItem } set { switchItem = newValue as! TableViewSwitchItem } }
    
    // Private variables
    //
    private var switchItem: TableViewSwitchItem!
    
    // Interface builder outlets
    //
    @IBOutlet weak var switchControl: UISwitch!
    
    public override func cellDidLoad() {
        super.cellDidLoad()
    }
    
    public override func cellWillAppear() {
        super.cellWillAppear()
        self.switchControl.on = self.switchItem.value
    }
    
    @IBAction func switchValueChanged(sender: UISwitch!) {
        self.switchItem.value = sender.on
        guard let changeHandler = self.switchItem.changeHandler, let tableView = self.tableViewManager.tableView, let indexPath = self.indexPath else {
            return
        }
        changeHandler(section: self.section, item: self.switchItem, tableView: tableView, indexPath: indexPath)
    }
    
}
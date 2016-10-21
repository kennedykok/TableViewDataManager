//
// TableViewDateCell.swift
// TableViewDataManager
//
// Copyright (c) 2016 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

open class TableViewDateTimeCell: TableViewFormCell {
    
    // MARK: Public variables
    //
    open override var item: TableViewItem! { get { return dateTimeItem } set { dateTimeItem = newValue as! TableViewDateTimeItem } }
    
    // MARK: Private variables
    //
    fileprivate var dateTimeItem: TableViewDateTimeItem!
    
    fileprivate lazy var datePickerItem: TableViewDatePickerItem = TableViewDatePickerItem()
    
    // MARK: View lifecycle
    //
    open override func cellDidLoad() {
        super.cellDidLoad()
        self.item.selectionHandler = { (section: TableViewSection, item: TableViewItem, tableView: UITableView, indexPath: IndexPath) -> (Void) in
            let dateTimeItem = item as! TableViewDateTimeItem
            guard let indexOfItem = section.items.index(of: item) else {
                return
            }
            let newItemIndexPath = IndexPath(row: indexOfItem + 1, section: (indexPath as NSIndexPath).section)
            dateTimeItem.selected = (newItemIndexPath as NSIndexPath).row < section.items.count && section.items[(newItemIndexPath as NSIndexPath).row] is TableViewDatePickerItem
            if dateTimeItem.selected {
                section.items.remove(at: (newItemIndexPath as NSIndexPath).row)
                tableView.deleteRows(at: [newItemIndexPath], with: .top)
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                section.items.insert(self.datePickerItem, at: (newItemIndexPath as NSIndexPath).row)
                tableView.insertRows(at: [IndexPath(row: (newItemIndexPath as NSIndexPath).row, section: (indexPath as NSIndexPath).section)], with: .fade)
            }
        }
    }
    
    open override func cellWillAppear() {
        super.cellWillAppear()
        self.selectionStyle = .default
        self.setSelected(self.dateTimeItem.selected, animated: false)
        self.datePickerItem.dateTimeItem = self.dateTimeItem
        self.datePickerItem.changeHandler = { [unowned self] (section: TableViewSection, item: TableViewDatePickerItem, tableView: UITableView, indexPath: IndexPath) in
            self.updateDetailLabelText()
        }
        updateDetailLabelText()
    }
    
    fileprivate func updateDetailLabelText() {
        guard let detailTextLabel = self.detailTextLabel else {
            return
        }
        
        if let value = self.dateTimeItem.value {
            detailTextLabel.text = self.dateTimeItem.dateFormatter.string(from: value)
        } else {
            detailTextLabel.text = self.dateTimeItem.placeholder
        }
    }
    
}

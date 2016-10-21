//
// TableViewPickerCell.swift
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

open class TableViewPickerCell: TableViewFormCell {
    
    // MARK: Public variables
    //
    open override var item: TableViewItem! { get { return pickerItem } set { pickerItem = newValue as! TableViewPickerItem } }
    
    // MARK: Private variables
    //
    fileprivate var pickerItem: TableViewPickerItem!
    
    fileprivate lazy var pickerViewItem: TableViewPickerViewItem = TableViewPickerViewItem()
    
    // MARK: View lifecycle
    //
    open override func cellDidLoad() {
        super.cellDidLoad()
        self.item.selectionHandler = { (section: TableViewSection, item: TableViewItem, tableView: UITableView, indexPath: IndexPath) -> (Void) in
            let pickerItem = item as! TableViewPickerItem
            guard let indexOfItem = section.items.index(of: item) else {
                return
            }
            let newItemIndexPath = IndexPath(row: indexOfItem + 1, section: (indexPath as NSIndexPath).section)
            pickerItem.selected = (newItemIndexPath as NSIndexPath).row < section.items.count && section.items[(newItemIndexPath as NSIndexPath).row] is TableViewPickerViewItem
            if pickerItem.selected {
                section.items.remove(at: (newItemIndexPath as NSIndexPath).row)
                tableView.deleteRows(at: [newItemIndexPath], with: .top)
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                section.items.insert(self.pickerViewItem, at: (newItemIndexPath as NSIndexPath).row)
                tableView.insertRows(at: [IndexPath(row: (newItemIndexPath as NSIndexPath).row, section: (indexPath as NSIndexPath).section)], with: .fade)
            }
        }
    }
    
    open override func cellWillAppear() {
        super.cellWillAppear()
        self.selectionStyle = .default
        self.setSelected(self.pickerItem.selected, animated: false)
        self.pickerViewItem.pickerItem = self.pickerItem
        self.pickerViewItem.changeHandler = { [unowned self] (section: TableViewSection, item: TableViewPickerViewItem, tableView: UITableView, indexPath: IndexPath) in
            self.updateDetailLabelText()
        }
        updateDetailLabelText()
    }
    
    fileprivate func updateDetailLabelText() {
        guard let detailTextLabel = self.detailTextLabel else {
            return
        }
        
        if let value = self.pickerItem.value {
            detailTextLabel.text = value.joined(separator: ", ")
        } else {
            detailTextLabel.text = self.pickerItem.placeholder
        }
    }
    
}

//
// TableViewPickerViewCell.swift
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

open class TableViewPickerViewCell: TableViewFormCell, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: Public variables
    //
    open override var item: TableViewItem! { get { return pickerViewItem } set { pickerViewItem = newValue as! TableViewPickerViewItem } }
    
    // MARK: Private variables
    //
    fileprivate var pickerViewItem: TableViewPickerViewItem!
    
    // MARK: Interface builder outlets
    //
    @IBOutlet open fileprivate(set) var pickerView: UIPickerView!
    
    // MARK: View Lifecycle
    //
    open override func cellWillAppear() {
        super.cellWillAppear()
        guard let pickerItem = self.pickerViewItem.pickerItem, let value = pickerItem.value, let options = pickerItem.options else {
            return
        }
        for (component, item) in options.enumerated() {
            if let index = item.index(of: value[component]) {
                self.pickerView.selectRow(index, inComponent: component, animated: false)
            }
        }
        
    }
    
    // MARK: <UIPickerViewDelegate> methods
    //
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let pickerItem = self.pickerViewItem.pickerItem, let options = pickerItem.options else {
            return nil
        }
        return options[component][row]
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let pickerItem = self.pickerViewItem.pickerItem, let options = pickerItem.options {
            pickerItem.value = {
                var value : [String] = []
                for (component, item) in options.enumerated() {
                    value.append(item[pickerView.selectedRow(inComponent: component)])
                }
                return value
            }()
        }
        guard let changeHandler = self.pickerViewItem.changeHandler, let tableView = self.tableViewDataManager.tableView, let indexPath = self.indexPath else {
            return
        }
        changeHandler(self.section, self.pickerViewItem, tableView, indexPath)
    }
    
    // MARK: <UIPickerViewDataSource> methods
    //
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let pickerItem = self.pickerViewItem.pickerItem, let options = pickerItem.options else {
            return 0
        }
        return options.count
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let pickerItem = self.pickerViewItem.pickerItem, let options = pickerItem.options else {
            return 0
        }
        return options[component].count
    }
    
}

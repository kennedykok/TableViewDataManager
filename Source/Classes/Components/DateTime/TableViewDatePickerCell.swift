//
// TableViewDatePickerCell.swift
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

open class TableViewDatePickerCell: TableViewFormCell {

    // MARK: Public variables
    //
    open override var item: TableViewItem! { get { return datePickerItem } set { datePickerItem = newValue as! TableViewDatePickerItem } }
    
    // MARK: Private variables
    //
    fileprivate var datePickerItem: TableViewDatePickerItem!
    
    // MARK: Interface builder outlets
    //
    @IBOutlet open fileprivate(set) var datePicker: UIDatePicker!
    
    // MARK: View Lifecycle
    //
    open override func cellWillAppear() {
        super.cellWillAppear()
        guard let dateTimeItem = self.datePickerItem.dateTimeItem, let value = dateTimeItem.value else {
            return
        }
        self.datePicker.date = value as Date
        
        self.datePicker.datePickerMode = dateTimeItem.datePickerMode
        self.datePicker.locale = dateTimeItem.locale as Locale?
        self.datePicker.calendar = dateTimeItem.calendar as Calendar!
        self.datePicker.timeZone = dateTimeItem.timeZone as TimeZone?
        self.datePicker.minimumDate = dateTimeItem.minimumDate as Date?
        self.datePicker.maximumDate = dateTimeItem.maximumDate as Date?
        self.datePicker.minuteInterval = dateTimeItem.minuteInterval        
    }
    
    // MARK: Actions
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker!) {
        if let dateTimeItem = self.datePickerItem.dateTimeItem {
            dateTimeItem.value = sender.date
        }
        guard let changeHandler = self.datePickerItem.changeHandler, let tableView = self.tableViewDataManager.tableView, let indexPath = self.indexPath else {
            return
        }
        changeHandler(self.section, self.datePickerItem, tableView, indexPath)
    }
    
}

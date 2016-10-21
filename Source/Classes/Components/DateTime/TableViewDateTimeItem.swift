//
// TableViewDateItem.swift
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

open class TableViewDateTimeItem: TableViewFormItem {
   
    open var value: Date?
    open var selected: Bool = false
    open var pickerStartDate: Date? // date to be used for the picker when the value is not set; defaults to current date when not specified
    open var placeholder: String?
    open var format: String {
        get {
            return self.dateFormatter.dateFormat
        }
        set {
            self.dateFormatter.dateFormat = newValue
        }
    }
    open var datePickerMode: UIDatePickerMode = .dateAndTime
    
    open var locale: Locale? // default is [NSLocale currentLocale]. setting nil returns to default
    open var calendar: Calendar? // default is [NSCalendar currentCalendar]. setting nil returns to default
    open var timeZone: TimeZone? // default is nil. use current time zone or time zone from calendar
    
    open var minimumDate: Date? // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
    open var maximumDate: Date? // default is nil
    open var minuteInterval: NSInteger = 1 // display minutes wheel with interval. interval must be evenly divided into 60. default is 1. min is 1, max is 30
    
    open lazy var dateFormatter: DateFormatter = DateFormatter()
    
    // MARK: Instance Lifecycle
    //
    public convenience init(text: String?, placeholder: String?, value: Date!, format: String!, datePickerMode: UIDatePickerMode!) {
        self.init(text: text)
        self.value = value
        self.placeholder = placeholder
        self.format = format
        self.datePickerMode = datePickerMode
    }
    
}

//
// TableViewSection.swift
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

public enum TableViewSectionDisplayStatus {
    case willDisplay
    case didEndDisplaying
}

open class TableViewSection {
    
    // MARK: Variables
    //
    open var items: [TableViewItem] = []
    open var headerTitle: String?
    open var footerTitle: String?
    open var headerView: UIView?
    open var footerView: UIView?
    open var style: TableViewCellStyle?
    open var indexTitle: String?
    open var configurationHandler: ((_ tableViewCell: TableViewCell) -> (Void))?
    open var headerDisplayHandler: ((_ section: TableViewSection, _ tableView: UITableView, _ indexPath: IndexPath, _ view: UIView, _ status: TableViewSectionDisplayStatus) -> (Void))?
    open var footerDisplayHandler: ((_ section: TableViewSection, _ tableView: UITableView, _ indexPath: IndexPath, _ view: UIView, _ status: TableViewSectionDisplayStatus) -> (Void))?
    
    // MARK: Lifecycle
    //    
    public init() {
        
    }
    
    public convenience init(headerTitle: String) {
        self.init()
        self.headerTitle = headerTitle
    }
    
    public convenience init(headerTitle: String, footerTitle: String) {
        self.init(headerTitle: headerTitle)
        self.footerTitle = footerTitle
    }
    
    public convenience init(headerView: UIView) {
        self.init()
        self.headerView = headerView
    }
    
    public convenience init(headerView: UIView, footerView: UIView) {
        self.init(headerView: headerView)
        self.footerView = footerView
    }
    
}

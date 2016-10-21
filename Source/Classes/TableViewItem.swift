//
// TableViewItem.swift
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

public typealias TableViewItemEditingStyle = UITableViewCellEditingStyle

public enum TableViewEditingStatus {
    case willBeginEditing
    case didEndEditing
}

public enum TableViewCellDisplayStatus {
    case willDisplay
    case didEndDisplaying
}

public enum TableViewActionBarButton {
    case previous
    case next
    case done
}

public protocol TableViewItemFocusable {
    
}

open class TableViewItem: NSObject, UIAccessibilityIdentification {
    
    // MARK: Variables
    //
    open var text: String?
    open var detailText: String?
    open var section: TableViewSection?
    open var image: UIImage?
    open var highlightedImage: UIImage?
    open var editingStyle: TableViewItemEditingStyle = .none
    open var height: Float = Float(UITableViewAutomaticDimension)
    open var accessibilityIdentifier: String?
    open var indentationLevel: Int = 0
    open var selectable = true
    open var shouldIndentWhileEditing = true
    open var configurationHandler: ((_ tableViewCell: TableViewCell) -> (Void))?
    open var displayHandler: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath, _ tableViewCell: TableViewCell, _ status: TableViewCellDisplayStatus) -> (Void))?
    open var selectionHandler: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void))?
    open var deselectionHandler: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void))?
    open var accessoryButtonTapHandler: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void))?
    open var insertionHandler: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void))?
    open var deletionHandler: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void))?
    open var deletionHandlerWithCompletion: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath, _ completionHandler: ((Void) -> (Void))) -> (Void))?
    open var moveHandler: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> (Bool))?
    open var moveCompletionHandler: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> (Void))?
    open var cutHandler: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void))?
    open var copyHandler: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void))?
    open var pasteHandler: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void))?
    open var editingHandler: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath, _ status: TableViewEditingStatus) -> (Void))?
    open var actionBarButtonTapHandler: ((_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath, _ button: TableViewActionBarButton) -> (Void))?
    
    // MARK: Lifecycle
    //
    public convenience init(text: String?) {
        self.init()
        self.text = text
    }
    
    public convenience init(text: String?, configurationHandler: @escaping (_ tableViewCell: TableViewCell) -> (Void)) {
        self.init(text: text)
        self.configurationHandler = configurationHandler
    }
    
    public convenience init(text: String?, selectionHandler: @escaping (_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void)) {
        self.init(text: text)
        self.selectionHandler = selectionHandler
    }
    
    public convenience init(text: String?, configurationHandler: @escaping (_ tableViewCell: TableViewCell) -> (Void), selectionHandler: @escaping (_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void)) {
        self.init(text: text)
        self.configurationHandler = configurationHandler
        self.selectionHandler = selectionHandler
    }
    
    public convenience init(text: String?, image: UIImage) {
        self.init(text: text)
        self.image = image
    }
    
    public convenience init(text: String?, image: UIImage, configurationHandler: @escaping (_ tableViewCell: TableViewCell) -> (Void)) {
        self.init(text: text)
        self.image = image
        self.configurationHandler = configurationHandler
    }
    
    public convenience init(text: String?, image: UIImage, selectionHandler: @escaping (_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void)) {
        self.init(text: text)
        self.selectionHandler = selectionHandler
        self.image = image
    }
    
    public convenience init(text: String?, image: UIImage, configurationHandler: @escaping (_ tableViewCell: TableViewCell) -> (Void), selectionHandler: @escaping (_ section: TableViewSection, _ item: TableViewItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void)) {
        self.init(text: text)
        self.image = image
        self.configurationHandler = configurationHandler
        self.selectionHandler = selectionHandler
    }
    
}

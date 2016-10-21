//
// TableViewCell.swift
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

let kYTMTableViewCellPadding: Float = 15

open class TableViewCell: UITableViewCell {
    
    // MARK: Public variables
    //
    open var item: TableViewItem!
    open var section: TableViewSection!
    open var indexPath: IndexPath?
    open var cellLoaded = false
    open var style: TableViewCellStyle?
    open var backgroundImageView: UIImageView?
    open var selectedBackgroundImageView: UIImageView?
    open var actionBar: TableViewActionBar?
    open var tableViewDataManager: TableViewDataManager!
    open var type: TableViewCellType {
        guard let indexPath = self.indexPath, let section = self.section else {
            return .any
        }
        switch ((indexPath as NSIndexPath).row, section.items.count) {
        case let (row, count) where row == 0 && count == 1:
            return .single
        case let (row, count) where row == 0 && count > 1:
            return .first
        case let (row, count) where row > 0 && row < count - 1 && count > 2:
            return .middle
        case let (row, count) where row == count - 1 && count > 1:
            return .last
        default:
            return .any
        }
    }

    // MARK: Cell view lifecycle
    //
    open func cellDidLoad() {
        if (self.style?.hasCustomBackgroundImage() != nil || self.style?.hasCustomBackgroundColor() != nil) {
            self.addBackgroundImage()
        }
        
        if (self.style?.hasCustomSelectedBackgroundImage() != nil || self.style?.hasCustomSelectedBackgroundImage() != nil) {
            self.addSelectedBackgroundImage()
        }
        
        self.actionBar = TableViewActionBar(navigationHandler: { [weak self] (index: Int) -> (Void) in
            if let strongSelf = self, let tableView = strongSelf.tableViewDataManager.tableView, let indexPath = strongSelf.indexPath {
                if let indexPath = index == 0 ? strongSelf.indexPathForPreviousResponder() : strongSelf.indexPathForNextResponder() {
                    var cell = tableView.cellForRow(at: indexPath) as? TableViewCell
                    if cell == nil {
                        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                    cell = tableView.cellForRow(at: indexPath) as? TableViewCell
                    if let cell = cell, let responder = cell.responder() {
                        responder.becomeFirstResponder()
                    }
                }
                
                if let actionBarButtonTapHandler = strongSelf.item.actionBarButtonTapHandler {
                    actionBarButtonTapHandler(strongSelf.section, strongSelf.item, tableView, indexPath, index == 0 ? .previous : .next)
                }
            }
        }, doneHandler: { [weak self] in
            if let strongSelf = self, let tableView = strongSelf.tableViewDataManager.tableView, let indexPath = strongSelf.indexPath {
                strongSelf.endEditing(true)
                if let actionBarButtonTapHandler = strongSelf.item.actionBarButtonTapHandler {
                    actionBarButtonTapHandler(strongSelf.section, strongSelf.item, tableView, indexPath, .done)
                }
            }
        })
    }
    
    open func cellWillAppear() {
        updateActionBarNavigationControl()
        self.textLabel?.text = item.text
        self.detailTextLabel?.text = item.detailText
        self.imageView?.image = self.item.image
        self.imageView?.highlightedImage = self.item.highlightedImage
    }
    
    // MARK: Public methods
    //
    open class func heightWithItem(_ item: TableViewItem, tableView: UITableView, indexPath: IndexPath) -> Float {
        return item.height
    }
    
    open class func estimatedHeightWithItem(_ item: TableViewItem, tableView: UITableView, indexPath: IndexPath) -> Float {
        return heightWithItem(item, tableView: tableView, indexPath: indexPath)
    }
    
    open func updateActionBarNavigationControl() {
        if let actionBar = self.actionBar {
            actionBar.navigationControl.setEnabled(self.indexPathForPreviousResponder() != nil, forSegmentAt: 0)
            actionBar.navigationControl.setEnabled(self.indexPathForNextResponder() != nil, forSegmentAt: 1)
        }
    }
    
    open func responder() -> UIResponder? {
        return nil
    }
    
    open func indexPathForPreviousResponder() -> IndexPath? {
        if let indexPath = self.indexPath {
            for itemIndex in (0...(indexPath as NSIndexPath).section).reversed() {
                if let indexPath = self.tableViewDataManager.indexPathForPreviousResponderInSectionIndex(itemIndex, currentSection: self.section, currentItem: self.item) {
                    return indexPath;
                }
            }
        }
        return nil
    }
    
    open func indexPathForNextResponder() -> IndexPath? {
        if let indexPath = self.indexPath, let datasource = self.tableViewDataManager.dataSource {
            for itemIndex in (indexPath as NSIndexPath).section..<datasource.sections.count {
                if let indexPath = self.tableViewDataManager.indexPathForNextResponderInSectionIndex(itemIndex, currentSection: self.section, currentItem: self.item) {
                    return indexPath;
                }
            }
        }
        return nil
    }

    // MARK: Overrides
    //
    open override func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = self.imageView, let _ = imageView.image {
            imageView.frame.origin.x = self.separatorInset.left
            if let textLabel = self.textLabel {
                textLabel.frame.origin.x = imageView.frame.maxX + self.indentationWidth
                textLabel.frame.size.width = self.contentView.frame.width - textLabel.frame.origin.x - CGFloat(kYTMTableViewCellPadding)
            }
        }
        
        guard let style = self.style else {
            return
        }
        
        if style.hasCustomBackgroundColor() || style.hasCustomBackgroundImage() {
            self.backgroundColor = UIColor.clear
            if self.backgroundImageView == nil {
                self.addBackgroundImage()
            }
        }
        
        if style.hasCustomSelectedBackgroundColor() || style.hasCustomSelectedBackgroundImage() {
            if self.selectedBackgroundImageView == nil {
                self.addSelectedBackgroundImage()
            }
        }
        
        if let backgroundImageView = self.backgroundImageView , style.hasCustomBackgroundColor()  {
            backgroundImageView.backgroundColor = style.backgroundColorForCellType(self.type)
        }
        if let backgroundImageView = self.backgroundImageView , style.hasCustomBackgroundImage()  {
            backgroundImageView.image = style.backgroundImageForCellType(self.type)
        }
        if let selectedBackgroundImageView = self.selectedBackgroundImageView , style.hasCustomSelectedBackgroundColor()  {
            selectedBackgroundImageView.backgroundColor = style.selectedBackgroundColorForCellType(self.type)
        }
        if let selectedBackgroundImageView = self.selectedBackgroundImageView , style.hasCustomSelectedBackgroundImage()  {
            selectedBackgroundImageView.image = style.selectedBackgroundImageForCellType(self.type)
        }
    }
    
    // MARK: Private methods
    //
    fileprivate func addBackgroundImage() {
        self.backgroundImageView = {
            let view = UIImageView(frame: CGRect(x: 0, y: 0, width: self.contentView.bounds.size.width, height: self.contentView.bounds.size.height + 1))
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return view
        }();
        self.backgroundView = {
            let view = UIView(frame: self.contentView.bounds)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            if let backgroundImageView = self.backgroundImageView {
                view.addSubview(backgroundImageView)
            }
            return view
        }();
    }
    
    fileprivate func addSelectedBackgroundImage() {
        self.selectedBackgroundImageView = {
            let view = UIImageView(frame: CGRect(x: 0, y: 0, width: self.contentView.bounds.size.width, height: self.contentView.bounds.size.height + 1))
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return view
        }();
        self.selectedBackgroundView = {
            let view = UIView(frame: self.contentView.bounds)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            if let selectedBackgroundImageView = self.selectedBackgroundImageView {
                view.addSubview(selectedBackgroundImageView)
            }
            return view
        }();
    }
}

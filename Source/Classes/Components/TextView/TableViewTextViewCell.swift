//
// TableViewTextViewCell.swift
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

open class TableViewTextViewCell: TableViewFormCell, UITextViewDelegate {

    // MARK: Public variables
    //
    open override var item: TableViewItem! { get { return textViewItem } set { textViewItem = newValue as! TableViewTextViewItem } }
    
    // MARK: Private variables
    //
    fileprivate var textViewItem: TableViewTextViewItem!
    
    // MARK: Interface builder outlets
    //
    @IBOutlet open fileprivate(set) var textView: UITextView!
    
    // MARK: View Lifecycle
    //
    open override func cellDidLoad() {
        super.cellDidLoad()
        self.textView.textContainer.lineFragmentPadding = 0
        self.textView.textContainerInset = UIEdgeInsets.zero
    }
    
    open override func cellWillAppear() {
        super.cellWillAppear()
        self.textView.inputAccessoryView = self.textViewItem.showsActionBar ? self.actionBar : nil
        self.textView.isEditable = textViewItem.editable
        self.textView.text = textViewItem.value
        self.textView.autocapitalizationType = self.textViewItem.autocapitalizationType
        self.textView.autocorrectionType = self.textViewItem.autocorrectionType
        self.textView.spellCheckingType = self.textViewItem.spellCheckingType
        self.textView.keyboardType = self.textViewItem.keyboardType
        self.textView.keyboardAppearance = self.textViewItem.keyboardAppearance
        self.textView.returnKeyType = self.textViewItem.returnKeyType
        self.textView.enablesReturnKeyAutomatically = self.textViewItem.enablesReturnKeyAutomatically
    }
    
    open override func responder() -> UIResponder? {
        return self.textView
    }
    
    // MARK: <UITextViewDelegate> methods
    //
    open func textViewDidBeginEditing(_ textView: UITextView) {
        if let beginEditingHandler = self.textViewItem.beginEditingHandler, let tableView = self.tableViewDataManager.tableView, let indexPath = self.indexPath {
            beginEditingHandler(self.section, self.textViewItem, tableView, indexPath)
        }
        self.updateActionBarNavigationControl()
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        if let endEditingHandler = self.textViewItem.endEditingHandler, let tableView = self.tableViewDataManager.tableView, let indexPath = self.indexPath {
            endEditingHandler(self.section, self.textViewItem, tableView, indexPath)
        }
    }
    
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let returnKeyHandler = self.textViewItem.returnKeyHandler, let tableView = self.tableViewDataManager.tableView, let indexPath = self.indexPath , text == "\n" {
            textView.resignFirstResponder()
            returnKeyHandler(self.section, self.textViewItem, tableView, indexPath)
            return false
        }
        return true
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        self.textViewItem.value = textView.text
        if let changeHandler = self.textViewItem.changeHandler, let tableView = self.tableViewDataManager.tableView, let indexPath = self.indexPath {
            changeHandler(self.section, self.textViewItem, tableView, indexPath)
        }
    }
}

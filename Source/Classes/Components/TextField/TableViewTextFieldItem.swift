//
// TableViewTextItem.swift
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

open class TableViewTextFieldItem: TableViewFormItem, TableViewItemFocusable {
   
    open var value: String?
    open var placeholder: String?
    open var charactersLimit: Int?
    open var secureTextEntry = false
    open var showsActionBar = true
    
    // MARK: Keyboard
    //
    open var autocapitalizationType = UITextAutocapitalizationType.sentences // default is UITextAutocapitalizationTypeSentences
    open var autocorrectionType = UITextAutocorrectionType.default // default is UITextAutocorrectionTypeDefault
    open var spellCheckingType = UITextSpellCheckingType.default // default is UITextSpellCheckingTypeDefault
    open var keyboardType = UIKeyboardType.default // default is UIKeyboardTypeDefault
    open var keyboardAppearance = UIKeyboardAppearance.default // default is UIKeyboardAppearanceDefault
    open var returnKeyType = UIReturnKeyType.default // default is UIReturnKeyDefault (See note under UIReturnKeyType enum)
    open var enablesReturnKeyAutomatically = false // default is NO (when YES, will automatically disable return key when text widget has zero-length contents, and will automatically enable when text widget has non-zero-length contents)

    // MARK: Handlers
    //
    open var changeHandler: ((_ section: TableViewSection, _ item: TableViewTextFieldItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void))?
    open var changeCharacterInRangeHandler: ((_ section: TableViewSection, _ item: TableViewTextFieldItem, _ tableView: UITableView, _ indexPath: IndexPath, _ range: NSRange, _ replacementString: String) -> (Bool))?
    open var returnKeyHandler: ((_ section: TableViewSection, _ item: TableViewTextFieldItem, _ tableView: UITableView, _ indexPath: IndexPath) -> (Void))?

    // MARK: Instance Lifecycle
    //
    public convenience init(text: String?, placeholder: String?, value: String?) {
        self.init(text: text)
        self.placeholder = placeholder
        self.value = value
    }
}

//
// TableViewDataManager.swift
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

open class TableViewDataManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Public variables
    //
    open var dataSource: TableViewDataSource?
    open var style: TableViewCellStyle?
    open var showsIndexList = false
    open var tableView: UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
        }
    }

    // MARK: Instance Lifecycle
    //
    public init(tableView: UITableView, dataSource: TableViewDataSource) {
        super.init();
        self.tableView = tableView
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.dataSource = dataSource
        self.registerCellClass(TableViewCell.self, forItemClass: TableViewItem.self)
        [ "TableViewCell": TableViewItem.self,
          "TableViewTextFieldCell": TableViewTextFieldItem.self,
          "TableViewSwitchCell": TableViewSwitchItem.self,
          "TableViewSliderCell": TableViewSliderItem.self,
          "TableViewDateTimeCell": TableViewDateTimeItem.self,
          "TableViewDatePickerCell": TableViewDatePickerItem.self,
          "TableViewPickerCell": TableViewPickerItem.self,
          "TableViewPickerViewCell": TableViewPickerViewItem.self,
          "TableViewTextViewCell": TableViewTextViewItem.self,
          "TableViewSegmentedControlCell": TableViewSegmentedControlItem.self ].forEach { self.registerNib(UINib(nibName: $0, bundle: Bundle(for: TableViewDataManager.self)), forItemClass: $1) }
    }
    
    deinit {
        self.tableView?.delegate = nil
        self.tableView?.dataSource = nil
    }
    
    public convenience init(tableView: UITableView) {
        self.init(tableView: tableView, dataSource: TableViewDataSource())
    }
    
    // MARK: Public methods
    //
    open func registerCellClass(_ cellClass: AnyClass, forItemClass itemClass: AnyClass) {
        self.tableView?.register(cellClass, forCellReuseIdentifier: NSStringFromClass(itemClass))
    }
    
    open func registerNib(_ nib: UINib, forItemClass: AnyClass) {
        let identifier = NSStringFromClass(forItemClass)
        self.tableView?.register(nib, forCellReuseIdentifier: identifier)
    }
    
    open func indexPathForPreviousResponderInSectionIndex(_ sectionIndex: Int, currentSection: TableViewSection, currentItem: TableViewItem) -> IndexPath? {
        guard let _ = self.dataSource, let section = self.sectionAtIndexPath(IndexPath(row: 0, section: sectionIndex)) else {
            return nil
        }
        let items = section.items as NSArray
        let indexInSection = section === currentSection ? items.index(of: currentItem) : section.items.count
        for itemIndex in (0..<indexInSection).reversed() {
            let item = section.items[itemIndex]
            if item is TableViewItemFocusable {
                return IndexPath(row: itemIndex, section: sectionIndex)
            }
        }
        return nil
    }
    
    open func indexPathForNextResponderInSectionIndex(_ sectionIndex: Int, currentSection: TableViewSection, currentItem: TableViewItem) -> IndexPath? {
        guard let _ = self.dataSource, let section = self.sectionAtIndexPath(IndexPath(row: 0, section: sectionIndex)) else {
            return nil
        }
        let items = section.items as NSArray
        let indexInSection = section === currentSection ? items.index(of: currentItem) : -1
        for itemIndex in (indexInSection+1)..<section.items.count {
            let item = section.items[itemIndex]
            if item is TableViewItemFocusable {
                return IndexPath(row: itemIndex, section: sectionIndex)
            }
        }
        return nil
    }
    
    // MARK: Private methods
    //
    fileprivate func sectionAtIndexPath(_ indexPath: IndexPath) -> TableViewSection? {
        guard let dataSource = self.dataSource , (indexPath as NSIndexPath).section < dataSource.sections.count else {
            return nil
        }
        return dataSource.sections[(indexPath as NSIndexPath).section]
    }
    
    fileprivate func itemAtIndexPath(_ indexPath: IndexPath) -> TableViewItem? {
        guard let section = self.sectionAtIndexPath(indexPath) , (indexPath as NSIndexPath).row < section.items.count else {
            return nil
        }
        return section.items[(indexPath as NSIndexPath).row]
    }
    
    // MARK: <UITableViewDataSource> methods
    //
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = self.dataSource {
            if section < dataSource.sections.count {
                return dataSource.sections[section].items.count
            }
        }
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = self.sectionAtIndexPath(indexPath), let item = self.itemAtIndexPath(indexPath) else {
            return TableViewCell()
        }
        let identifier = NSStringFromClass(type(of: item))
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TableViewCell
        
        cell.style = self.style
        if let sectionStyle = section.style {
            cell.style = sectionStyle
        }
        cell.item = item
        cell.section = section
        cell.indexPath = indexPath
        cell.separatorInset = tableView.separatorInset
        cell.accessibilityIdentifier = item.accessibilityIdentifier
        cell.tableViewDataManager = self
        if !cell.cellLoaded {
            cell.cellDidLoad()
            cell.cellLoaded = true
        }
        cell.cellWillAppear()
        
        if let configurationHandler = section.configurationHandler {
            configurationHandler(cell)
        }
        
        if let configurationHandler = item.configurationHandler {
            configurationHandler(cell)
        }
        
        return cell
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        return dataSource.sections.count
    }
    
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = self.sectionAtIndexPath(IndexPath(row: 0, section: section)) else {
            return nil
        }
        return section.headerTitle
    }
    
    open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let section = self.sectionAtIndexPath(IndexPath(row: 0, section: section)) else {
            return nil
        }
        return section.footerTitle
    }
    
    // Editing
    
    // Individual rows can opt out of having the -editing property set for them.
    //
    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let item = self.itemAtIndexPath(indexPath) else {
            return false
        }
        return item.editingStyle != .none || item.moveHandler != nil
    }
    
    // Moving/reordering
    
    // Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
    //
    open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let item = self.itemAtIndexPath(indexPath) else {
            return false
        }
        return item.moveHandler != nil
    }
    
    // Index
    
    open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if !self.showsIndexList {
            return nil
        }
        var indexTitles: [String] = []
        guard let dataSource = self.dataSource else {
            return indexTitles
        }
        for section in dataSource.sections {
            if let indexTitle = section.indexTitle {
                indexTitles.append(indexTitle)
            } else {
                indexTitles.append("")
            }
        }
        return indexTitles
    }
    
    // Data manipulation - insert and delete support
    
    // After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
    // Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
    //
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let section = self.sectionAtIndexPath(indexPath), let item = self.itemAtIndexPath(indexPath) else {
            return
        }
        if editingStyle == .delete {
            if let deletionHandlerWithCompletion = item.deletionHandlerWithCompletion {
                deletionHandlerWithCompletion(section, item, tableView, indexPath, { (Void) -> (Void) in
                    section.items.remove(at: (indexPath as NSIndexPath).row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                })
            } else {
                if let deletionHandler = item.deletionHandler {
                    deletionHandler(section, item, tableView, indexPath)
                }
                section.items.remove(at: (indexPath as NSIndexPath).row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        if editingStyle == .insert {
            if let insertionHandler = item.insertionHandler {
                insertionHandler(section, item, tableView, indexPath)
            }
        }
    }
    
    // Data manipulation - reorder / moving support
    
    open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let sourceSection = self.sectionAtIndexPath(sourceIndexPath), let item = self.itemAtIndexPath(sourceIndexPath), let destinationSection = self.sectionAtIndexPath(destinationIndexPath) else {
            return
        }
        sourceSection.items.remove(at: (sourceIndexPath as NSIndexPath).row)
        destinationSection.items.insert(item, at: (destinationIndexPath as NSIndexPath).row)
        
        if let moveCompletionHandler = item.moveCompletionHandler {
            moveCompletionHandler(destinationSection, item, tableView, sourceIndexPath, destinationIndexPath)
        }
    }

    // MARK: <UITableViewDelegate> methods
    //
    
    // Display customization
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = self.sectionAtIndexPath(indexPath), let item = self.itemAtIndexPath(indexPath), let displayHandler = item.displayHandler else {
            return
        }
        displayHandler(section, item, tableView, indexPath, cell as! TableViewCell, .willDisplay)
    }
    
    
    open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection index: Int) {
        let indexPath = IndexPath(row: 0, section: index)
        guard let section = self.sectionAtIndexPath(indexPath), let headerDisplayHandler = section.headerDisplayHandler else {
            return
        }
        headerDisplayHandler(section, tableView, indexPath, view, .willDisplay)
    }
    
    open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection index: Int) {
        let indexPath = IndexPath(row: 0, section: index)
        guard let section = self.sectionAtIndexPath(indexPath), let footerDisplayHandler = section.footerDisplayHandler else {
            return
        }
        footerDisplayHandler(section, tableView, indexPath, view, .willDisplay)
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = self.sectionAtIndexPath(indexPath), let item = self.itemAtIndexPath(indexPath), let displayHandler = item.displayHandler else {
            return
        }
        displayHandler(section, item, tableView, indexPath, cell as! TableViewCell, .didEndDisplaying)
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection index: Int) {
        let indexPath = IndexPath(row: 0, section: index)
        guard let section = self.sectionAtIndexPath(indexPath), let footerDisplayHandler = section.footerDisplayHandler else {
            return
        }
        footerDisplayHandler(section, tableView, indexPath, view, .didEndDisplaying)
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection index: Int) {
        let indexPath = IndexPath(row: 0, section: index)
        guard let section = self.sectionAtIndexPath(indexPath), let footerDisplayHandler = section.footerDisplayHandler else {
            return
        }
        footerDisplayHandler(section, tableView, indexPath, view, .didEndDisplaying)
    }
    
    // Variable height support
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = self.itemAtIndexPath(indexPath) else {
            return UITableViewAutomaticDimension
        }
        return CGFloat(TableViewCell.heightWithItem(item, tableView: tableView, indexPath: indexPath))
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection index: Int) -> CGFloat {
        guard let section = self.sectionAtIndexPath(IndexPath(row: 0, section: index)), let headerView = section.headerView else {
            return UITableViewAutomaticDimension
        }
        return headerView.frame.height
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection index: Int) -> CGFloat {
        guard let section = self.sectionAtIndexPath(IndexPath(row: 0, section: index)), let footerView = section.footerView else {
            return UITableViewAutomaticDimension
        }
        return footerView.frame.height
    }
    
    // Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
    // If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
    //
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = self.itemAtIndexPath(indexPath) else {
            return UITableViewAutomaticDimension
        }
        return CGFloat(TableViewCell.estimatedHeightWithItem(item, tableView: tableView, indexPath: indexPath))
    }
    
    // Section header & footer information. Views are preferred over title should you decide to provide both
    //
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionAtIndexPath(IndexPath(row: 0, section: section))?.headerView
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.sectionAtIndexPath(IndexPath(row: 0, section: section))?.footerView
    }
    
    // Accessories (disclosures).
    
    open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let section = self.sectionAtIndexPath(indexPath), let item = self.itemAtIndexPath(indexPath), let accessoryButtonTapHandler = item.accessoryButtonTapHandler else {
           return
        }
        accessoryButtonTapHandler(section, item, tableView, indexPath)
    }
    
    // Selection
    
    // -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
    // Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
    //
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let item = self.itemAtIndexPath(indexPath) else {
            return true
        }
        return item.selectable
    }
    
    // Called after the user changes the selection.
    //
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let section = self.sectionAtIndexPath(indexPath), let item = self.itemAtIndexPath(indexPath), let selectionHandler = item.selectionHandler {
            selectionHandler(section, item, tableView, indexPath)
        }
    }
    
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let section = self.sectionAtIndexPath(indexPath), let item = self.itemAtIndexPath(indexPath), let deselectionHandler = item.deselectionHandler else {
            return
        }
        deselectionHandler(section, item, tableView, indexPath)
    }
    
    // Editing
    
    // Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
    //
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        guard let item = self.itemAtIndexPath(indexPath) else {
            return .none
        }
        return item.editingStyle
    }
    
    /*
    optional func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? // supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
    */
    
    // Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
    //
    open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        guard let item = self.itemAtIndexPath(indexPath) else {
            return true
        }
        return item.shouldIndentWhileEditing
    }
    
    // The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
    //
    open func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        guard let section = self.sectionAtIndexPath(indexPath), let item = self.itemAtIndexPath(indexPath), let editingHandler = item.editingHandler else {
            return
        }
        editingHandler(section, item, tableView, indexPath, .willBeginEditing)
    }
    
    open func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let section = self.sectionAtIndexPath(indexPath!), let item = self.itemAtIndexPath(indexPath!), let editingHandler = item.editingHandler else {
            return
        }
        return editingHandler(section, item, tableView, indexPath!, .didEndEditing)
    }

    // Moving/reordering
    
    // Allows customization of the target row for a particular row as it is being moved/reordered
    //
    open func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        guard let sourceSection = self.sectionAtIndexPath(sourceIndexPath), let item = self.itemAtIndexPath(sourceIndexPath), let moveHandler = item.moveHandler else {
            return proposedDestinationIndexPath
        }
        return moveHandler(sourceSection, item, tableView, sourceIndexPath, proposedDestinationIndexPath) ? proposedDestinationIndexPath : sourceIndexPath
    }
    
    // Indentation

    open func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        guard let item = self.itemAtIndexPath(indexPath) else {
            return 0
        }
        return item.indentationLevel
    }
    
    // Cut / Copy / Paste.  All three methods must be implemented by the delegate.
    
    open func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        guard let item = self.itemAtIndexPath(indexPath) else {
            return false
        }
        return item.copyHandler != nil || item.pasteHandler != nil || item.cutHandler != nil
    }
    
    open func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        guard let item = self.itemAtIndexPath(indexPath) else {
            return false
        }
        return (item.copyHandler != nil && action == #selector(UIResponderStandardEditActions.copy(_:))) || (item.pasteHandler != nil && action == #selector(UIResponderStandardEditActions.paste(_:))) || (item.cutHandler != nil && action == #selector(UIResponderStandardEditActions.cut(_:)))
    }
    
    open func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        guard let item = self.itemAtIndexPath(indexPath), let section = self.sectionAtIndexPath(indexPath) else {
            return
        }
        if let copyHandler = item.copyHandler , action == #selector(UIResponderStandardEditActions.copy(_:)) {
            copyHandler(section, item, tableView, indexPath)
        }
        if let pasteHandler = item.pasteHandler , action == #selector(UIResponderStandardEditActions.paste(_:)) {
            pasteHandler(section, item, tableView, indexPath)
        }
        if let cutHandler = item.cutHandler , action == #selector(UIResponderStandardEditActions.cut(_:)) {
            cutHandler(section, item, tableView, indexPath)
        }
    }
}

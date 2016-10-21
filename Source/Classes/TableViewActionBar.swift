//
// TableViewActionBar.swift
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

open class TableViewActionBar: UIToolbar {

    open var navigationControl: UISegmentedControl!
    open var navigationHandler: ((_ index: Int) -> (Void))?
    open var doneHandler: ((Void) -> (Void))?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    public required init(navigationHandler: @escaping ((_ index: Int) -> (Void)), doneHandler: @escaping ((Void) -> (Void))) {
        super.init(frame: CGRect.null)
        self.navigationHandler = navigationHandler
        self.doneHandler = doneHandler
        self.commonInit()
    }
    
    // MARK: Private methods
    //
    fileprivate func commonInit() {
        self.sizeToFit()
        self.navigationControl = {
            let control = UISegmentedControl(items: ["Previous", "Next"])
            control.isMomentary = true
            control.setDividerImage(UIImage(), forLeftSegmentState: UIControlState(), rightSegmentState: UIControlState(), barMetrics: .default)
            control.addTarget(self, action: #selector(TableViewActionBar.previousNextPressed(_:)), for: .valueChanged)
            control.setWidth(40, forSegmentAt: 0)
            control.setWidth(40, forSegmentAt: 1)
            control.setContentOffset(CGSize(width: -4, height: 0), forSegmentAt: 0)
            control.setImage(UIImage(named: "TableViewDataManager.bundle/UIButtonBarArrowLeft", in: Bundle(for: type(of: self)), compatibleWith: nil), forSegmentAt: 0)
            control.setImage(UIImage(named: "TableViewDataManager.bundle/UIButtonBarArrowRight", in: Bundle(for: type(of: self)), compatibleWith: nil), forSegmentAt: 1)
            control.setBackgroundImage(UIImage(named: "TableViewDataManager.bundle/Transparent", in: Bundle(for: type(of: self)), compatibleWith: nil), for: UIControlState(), barMetrics: .default)
            return control
        }()
        self.items = [
            UIBarButtonItem(customView: self.navigationControl),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(TableViewActionBar.doneButtonPressed(_:)))
        ]
    }
    
    // MARK: Action handlers
    //
    open func previousNextPressed(_ segmentedControl: UISegmentedControl) {
        if let navigationHandler = self.navigationHandler {
            navigationHandler(segmentedControl.selectedSegmentIndex)
        }
    }
    
    open func doneButtonPressed(_ sender: AnyObject) {
        if let doneHandler = self.doneHandler {
            doneHandler()
        }
    }

}

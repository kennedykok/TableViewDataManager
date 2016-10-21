//
// TableViewCellStyle.swift
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

public enum TableViewCellType {
    case first
    case middle
    case last
    case single
    case any
}

open class TableViewCellStyle {
    
    fileprivate var backgroundImages: [TableViewCellType:UIImage] = [:]
    fileprivate var selectedBackgroundImages: [TableViewCellType:UIImage] = [:]
    fileprivate var backgroundColors: [TableViewCellType:UIColor] = [:]
    fileprivate var selectedBackgroundColors: [TableViewCellType:UIColor] = [:]
    
    public init() {
    
    }
    
    open func hasCustomBackgroundImage() -> Bool {
        return self.backgroundImageForCellType(.any) != nil || self.backgroundImageForCellType(.first) != nil || self.backgroundImageForCellType(.middle) != nil || self.backgroundImageForCellType(.last) != nil || self.backgroundImageForCellType(.single) != nil
    }
    
    open func hasCustomBackgroundColor() -> Bool {
        return self.backgroundColorForCellType(.any) != nil || self.backgroundColorForCellType(.first) != nil || self.backgroundColorForCellType(.middle) != nil || self.backgroundColorForCellType(.last) != nil || self.backgroundColorForCellType(.single) != nil
    }
    
    open func backgroundImageForCellType(_ cellType: TableViewCellType) -> UIImage? {
        let image = self.backgroundImages[cellType]
        if image == nil && cellType != .any {
            return self.backgroundImages[.any]
        }
        return image
    }
    
    open func backgroundColorForCellType(_ cellType: TableViewCellType) -> UIColor? {
        let backgroundColor = self.backgroundColors[cellType]
        if backgroundColor == nil && cellType != .any {
            return self.backgroundColors[.any]
        }
        return backgroundColor
    }
    
    open func setBackgroundImage(_ image: UIImage, forCellType cellType: TableViewCellType) {
        self.backgroundImages[cellType] = image
    }
    
    open func setBackgroundColor(_ color: UIColor, forCellType cellType: TableViewCellType) {
        self.backgroundColors[cellType] = color
    }
    
    open func hasCustomSelectedBackgroundImage() -> Bool {
        return self.selectedBackgroundImageForCellType(.any) != nil || self.selectedBackgroundImageForCellType(.first) != nil || self.selectedBackgroundImageForCellType(.middle) != nil || self.selectedBackgroundImageForCellType(.last) != nil || self.selectedBackgroundImageForCellType(.single) != nil
    }
    
    open func hasCustomSelectedBackgroundColor() -> Bool {
        return self.selectedBackgroundColorForCellType(.any) != nil || self.selectedBackgroundColorForCellType(.first) != nil || self.selectedBackgroundColorForCellType(.middle) != nil || self.selectedBackgroundColorForCellType(.last) != nil || self.selectedBackgroundColorForCellType(.single) != nil
    }
    
    open func selectedBackgroundImageForCellType(_ cellType: TableViewCellType) -> UIImage? {
        let image = self.selectedBackgroundImages[cellType]
        if image == nil && cellType != .any {
            return self.selectedBackgroundImages[.any]
        }
        return image
    }
    
    open func selectedBackgroundColorForCellType(_ cellType: TableViewCellType) -> UIColor? {
        let backgroundColor = self.selectedBackgroundColors[cellType]
        if backgroundColor == nil && cellType != .any {
            return self.selectedBackgroundColors[.any]
        }
        return backgroundColor
    }
    
    open func setSelectedBackgroundImage(_ image: UIImage, forCellType cellType: TableViewCellType) {
        self.selectedBackgroundImages[cellType] = image
    }
    
    open func setSelectedBackgroundColor(_ color: UIColor, forCellType cellType: TableViewCellType) {
        self.selectedBackgroundColors[cellType] = color
    }
}

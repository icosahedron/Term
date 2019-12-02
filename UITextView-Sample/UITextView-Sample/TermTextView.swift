//
//  TermTextView.swift
//  UITextView-Sample
//
//  Created by Jay Kint on 11/30/19.
//  Copyright © 2019 werks.co. All rights reserved.
//

import Foundation
import UIKit
import CoreText

/// A monospaced coordinate system view of text suitable for terminal emulation

class TermTextView : UIView {
        
    var _dim : CGSize
    var _scale : CGSize
    var _margins : CGSize
    var _cursor : CGPoint
    var _font : UIFont
//    var _textFramesetter : CTFramesetter
//    var _textFrame : CTFrame
//    var _measure : UILabel
    
    public init(frame: CGRect, font : UIFont) {
        
        self._cursor = CGPoint(x:0, y:0)
        self._dim = CGSize.zero
        self._scale = CGSize.zero
        self._font = font
        self._margins = CGSize.zero
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blue
        self.layer.isGeometryFlipped = true
        self.recalcDimensions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func write(_ text : NSAttributedString) {
        
    }
    
    public func cursorMove(_ to: CGPoint) {
        
    }
    
    public func resize(_ to: CGSize) {
        recalcDimensions(to)
    }
    
    public var size : CGSize {
        return self._dim
    }
    
    public var font : UIFont {
        get {
            return self._font
        }
        set(value) {
            self._font = value
            self.recalcDimensions()
        }
    }
    
    private func recalcDimensions(_ newBounds: CGSize? = nil)
    {
        let bounds = newBounds ?? self.bounds.size
        let fontAttributes = [NSAttributedString.Key.font: self._font]
        self._scale = ("W" as NSString).size(withAttributes: fontAttributes)
        self._dim.width = floor(bounds.width / self._scale.width)
        self._dim.height = floor(bounds.height / self._scale.height)
        let widthDiff = (bounds.width - self._dim.width * self._scale.width) / 2.0
        let heightDiff = (bounds.height - self._dim.height * self._scale.height) / 2.0
        self._margins = CGSize(width: widthDiff, height: heightDiff)
        print("\(self._dim.width) x \(self._dim.height)")
    }
    
    private func drawString(x: Int, y: Int, str: String)
    {
        let string = NSAttributedString(string: str, attributes: [NSAttributedString.Key.font: font])
        let pt_x = CGFloat(x) * self._scale.width + self._margins.width
        let pt_y = CGFloat(y) * self._scale.height + self._margins.height
        string.draw(at: CGPoint(x: pt_x, y: pt_y))
        print("drawString: x: \(x) y: \(y) pt_x: \(pt_x) pt_y: \(pt_y)")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()!
        UIGraphicsPushContext(context)
        
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
//        string.draw(at: CGPoint(x: 0, y: 0))
        drawString(x: 1, y: 1, str: "Hello, world")
        
        UIGraphicsPopContext()
    }
    
}


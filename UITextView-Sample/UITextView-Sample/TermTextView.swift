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

class TermTextView : UIView, UIKeyInput {
    
    private var _dim : CGSize
    private var _scale : CGSize
    private var _margins : CGSize
    private var _cursor : CGPoint
    private var _font : UIFont
    
    public var hasText: Bool = false;
    
    public override var canBecomeFirstResponder : Bool {
        get { print("canBecomeFirstResponder"); return true }
    }
    
    public override var canResignFirstResponder: Bool {
        get { print("canResignFirstResponder"); return true }
    }
    
    public init(frame: CGRect, font : UIFont) {
        
        _cursor = CGPoint(x:0, y:0)
        _dim = CGSize.zero
        _scale = CGSize.zero
        _font = font
        _margins = CGSize.zero
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.blue
//        layer.isGeometryFlipped = true
        recalcDimensions()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
        
        isUserInteractionEnabled = true;
    }
    
    @objc
    public func tap(_ r : UIGestureRecognizer) {
        print("tap")
        let can = becomeFirstResponder()
        print("becomeFirstResponder = \(can)")
        let first = isFirstResponder
        print("isFirstResponder = \(first)")
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
        get {
            return self._dim
        }
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
    
    private func recalcDimensions(_ newBounds: CGSize? = nil) {
        let bounds = newBounds ?? self.bounds.size
        let fontAttributes = [NSAttributedString.Key.font: self._font]
        self._scale = ("W" as NSString).size(withAttributes: fontAttributes)
        self._dim.width = floor(bounds.width / self._scale.width)
        self._dim.height = floor(bounds.height / self._scale.height)
        let widthDiff = (bounds.width - self._dim.width * self._scale.width) / 2.0
        let heightDiff = (bounds.height - self._dim.height * self._scale.height) / 2.0
        self._margins = CGSize(width: widthDiff, height: heightDiff)
        print("\(self._dim.width) x \(self._dim.height)")
        let first = self.isFirstResponder
        print("isFirstResponder = \(first)")
    }
    
    private func drawString(x: Int, y: Int, str: String) {
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
        
//        context.textMatrix = .identity
//        context.translateBy(x: 0, y: bounds.size.height)
//        context.scaleBy(x: 1.0, y: -1.0)
        
//        string.draw(at: CGPoint(x: 0, y: 0))
        drawString(x: 1, y: 1, str: "Hello, world")
        
        UIGraphicsPopContext()
    }
    
    public func insertText(_ text: String) {
        print(text)
        return
    }
    
    public func deleteBackward() {
        print("deleteBackward")
        return
    }
}


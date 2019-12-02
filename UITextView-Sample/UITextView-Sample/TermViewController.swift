//
//  ViewController.swift
//  UITextView-Sample
//
//  Created by Jay Kint on 8/10/19.
//  Copyright © 2019 werks.co. All rights reserved.
//

import UIKit

class TermViewController: UIViewController, UIScrollViewDelegate {

    var scrollView : UIScrollView!
    var termView : TermTextView!
    var firstLayout : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let defaultFont = UIFont(name: "Menlo", size: 14.0)
//        scrollView = UIScrollView(frame: self.view.bounds)
//        scrollView.backgroundColor = UIColor.green
//        scrollView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue) // UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        self.view.addSubview(scrollView)
        
        termView = TermTextView(frame: self.view.bounds, font: defaultFont!)
        termView.backgroundColor = UIColor.lightGray
//        termView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue) // UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        termView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(termView)
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byCharWrapping
//        textView.attributedText = NSAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//                                                     attributes:[NSAttributedString.Key.font : defaultFont!, NSAttributedString.Key.paragraphStyle : style])
        // this sets the text view to be fully within the safe area of the view controller
        // these resources helped a lot
        // https://useyourloaf.com/blog/safe-area-layout-guide/
        // https://developer.apple.com/documentation/uikit/nslayoutanchor
        // https://stackoverflow.com/questions/46317061/use-safe-area-layout-programmatically#46318300
        // Basically this is setting the text view anchors to equal the safe area guides.
        // The thing to remember is that these are equations, not assignments, which is why the guide is
        // equal to the textView in bottom and trailing.  Reversed, these go beyond the bottom and trailing
        // edges.
        let guide = view.safeAreaLayoutGuide
        self.view.keyboardLayoutGuide.usesSafeArea = false

        NSLayoutConstraint.activate([
            self.termView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
            self.termView.leadingAnchor.constraint(equalToSystemSpacingAfter: guide.leadingAnchor, multiplier: 1.0),
            self.view.keyboardLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: self.termView.bottomAnchor, multiplier: 1.0),
            guide.trailingAnchor.constraint(equalToSystemSpacingAfter: self.termView.trailingAnchor, multiplier: 1.0)
            ])
        
        self.termView.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
      // MARK: - keyboard
    internal func textView(_: UITextView, shouldChangeTextIn range: NSRange, replacementText newText: String) -> Bool {
//           let cstr = newText.utf8CString
//           cstr.withUnsafeBytes { ptr in
//               let cstr = UnsafeRawBufferPointer(ptr).bindMemory(to: Int8.self)
//               let len = strlen(cstr.baseAddress!)
//               let utf8 = UnsafeRawBufferPointer(cstr).bindMemory(to: UInt8.self)
//               output!.write(utf8.baseAddress!, maxLength: len)
//           }
//        print(newText)
        return true
    }

    // MARK: - Orientation/Resize calculation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("Will Transition to size \(size) from super view size \(self.view.frame.size)")
        detectOrientation()
        super.view.layoutSubviews()
        termView.setNeedsDisplay()
        termView.resize(size)
    }
    
    func detectOrientation() {
        if(UIDevice.current.orientation.isLandscape) {
            print("Landscape")
        } else {
            print("Portrait")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (firstLayout) {
            firstLayout = false
            detectOrientation()
        }
    }
}


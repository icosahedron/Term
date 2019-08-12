//
//  ViewController.swift
//  UITextView-Sample
//
//  Created by Jay Kint on 8/10/19.
//  Copyright © 2019 werks.co. All rights reserved.
//

import UIKit

class TermViewController: UIViewController, UITextViewDelegate {

    var textView : UITextView!
    var firstLayout : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView = UITextView(frame: self.view.bounds)
        self.textView.delegate = self
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
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
        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
            self.textView.leadingAnchor.constraint(equalToSystemSpacingAfter: guide.leadingAnchor, multiplier: 1.0),
            guide.bottomAnchor.constraint(equalToSystemSpacingBelow: self.textView.bottomAnchor, multiplier: 1.0),
            guide.trailingAnchor.constraint(equalToSystemSpacingAfter: self.textView.trailingAnchor, multiplier: 1.0)
            ])
    }

    override func viewWillAppear(_ animated : Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillShowNotification),
                                       name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillHideNotification),
                                       name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Orientation/Resize calculation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("Will Transition to size \(size) from super view size \(self.view.frame.size)")
        detectOrientation()
    }
    
    func detectOrientation() {
        if(UIDevice.current.orientation.isLandscape) {
            print("Landscape")
        } else {
            print("Portrait")
        }
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (firstLayout) {
            firstLayout = false
            detectOrientation()
        }
    }
    
    // MARK: - Keyboard notification
    
    @objc func handleKeyboardWillShowNotification(_ notification: Notification) {
        print("keyboard will show")
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
    }
    
    @objc func handleKeyboardWillHideNotification(_ notification: Notification) {
        print("keyboard will hide")
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
    }
    
    func keyboardWillChangeFrameWithNotification(_ notification: Notification, showsKeyboard: Bool) {
        let userInfo = (notification as NSNotification).userInfo!
        let durationInfo = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) ?? NSNumber()
        let animationDuration: TimeInterval = durationInfo.doubleValue
        var viewHeight = view.bounds.height
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? CGRect.zero
        let withHardwareKeyboard = keyboardEndFrame.maxY > self.view.bounds.height
        if showsKeyboard {
//            if withHardwareKeyboard {
//                viewHeight -= toolBarHeight
//            } else {
                let keyboardHeight = keyboardEndFrame.height
                viewHeight -= keyboardHeight
//            }
        }

        print("textView height = \(viewHeight)")
        UIView.animate(
            withDuration: animationDuration,
            delay: 0.0,
            options: UIView.AnimationOptions.beginFromCurrentState,
            animations: { [weak self] in
                self?.textView.frame.size.height = viewHeight
            }, completion: nil)
    }
}


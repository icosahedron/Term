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
        
        // https://www.appcoda.com/uiscrollview-introduction/
        // UIScrollView introduction
        scrollView = UIScrollView(frame: view.bounds.inset(by: view.safeAreaInsets))
        scrollView.backgroundColor = UIColor.green
        scrollView.contentSize = view.bounds.inset(by: view.safeAreaInsets).size
        scrollView.contentOffset = CGPoint.zero
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.translatesAutoresizingMaskIntoConstraints = true
//        scrollView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        
        termView = TermTextView(frame: view.bounds.inset(by: view.safeAreaInsets), font: defaultFont!)
        termView.backgroundColor = UIColor.lightGray
        termView.translatesAutoresizingMaskIntoConstraints = true
        termView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
//        termView.translatesAutoresizingMaskIntoConstraints = false

        // https://stackoverflow.com/questions/5478969/uiscrollview-how-to-draw-content-on-demand
        // talks about how to use a CATiledLayer to draw content on demand, similar to a UITableView does with rows
        // https://medium.com/@ssamadgh/designing-apps-with-scroll-views-part-iii-optimizing-with-tiles-3875535b4114
        scrollView.addSubview(termView)
        view.addSubview(scrollView)
//        view.addSubview(termView)

        // this sets the scroll view to be fully within the safe area of the view controller
        // these resources helped a lot
        // https://useyourloaf.com/blog/safe-area-layout-guide/
        // https://developer.apple.com/documentation/uikit/nslayoutanchor
        // https://stackoverflow.com/questions/46317061/use-safe-area-layout-programmatically#46318300
        // Basically this is setting the text view anchors to equal the safe area guides.
        // The thing to remember is that these are equations, not assignments, which is why the guide is
        // equal to the textView in bottom and trailing.  Reversed, these go beyond the bottom and trailing
        // edges.
        // This code came from https://stackoverflow.com/a/46318300 and it seems to work really well.
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
           scrollView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
           scrollView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
//            scrollView.bottomAnchor.constraint(equalToSystemSpacingBelow: guide.bottomAnchor, multiplier: 1.0)
            guide.bottomAnchor.constraint(equalToSystemSpacingBelow: scrollView.bottomAnchor, multiplier: 1.0)
         ])

        // https://stackoverflow.com/a/39945124
        // use this to set termView to the same width as the scrollView to eliminate horizontal scrolling
//        termView.bindFrameToSuperviewBounds()
        
        // this is used when the KeyboardLayoutGuide is used to set the guidelines instead of the keyboard notifications below

//        let guide = view.safeAreaLayoutGuide
//        view.keyboardLayoutGuide.usesSafeArea = false

        // for the scrollview layout
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
//            scrollView.leadingAnchor.constraint(equalToSystemSpacingAfter: guide.leadingAnchor, multiplier: 1.0),
//            view.keyboardLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: self.scrollView.bottomAnchor, multiplier: 1.0),
//            guide.trailingAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.trailingAnchor, multiplier: 1.0)
//            ])

//        NSLayoutConstraint.activate([
//            termView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
//            termView.leadingAnchor.constraint(equalToSystemSpacingAfter: guide.leadingAnchor, multiplier: 1.0),
//            view.keyboardLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: self.termView.bottomAnchor, multiplier: 1.0),
//            guide.trailingAnchor.constraint(equalToSystemSpacingAfter: self.termView.trailingAnchor, multiplier: 1.0)
//            ])

//        self.termView.becomeFirstResponder()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        termView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Orientation/Resize calculation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let size = CGRect(origin: CGPoint.zero, size: size).inset(by: view.safeAreaInsets).size
        print("Will Transition to size \(size) from super view size \(view.frame.size)")
        detectOrientation()
        view.layoutSubviews()
        scrollView.contentSize = size
        scrollView.setNeedsLayout()
        scrollView.setNeedsDisplay()
        termView.setNeedsDisplay()
//        termView.resize(size)
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
        scrollView.contentSize = termView.bounds.size
        print("Set scrollView.contentSize = \(termView.bounds.size)")
    }
    
    @objc func adjustForKeyboard(notification: Notification) {

        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset

//        let selectedRange = yourTextView.selectedRange
//        yourTextView.scrollRangeToVisible(selectedRange)
    }

}


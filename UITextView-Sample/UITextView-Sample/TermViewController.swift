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
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.green
        scrollView.contentSize = view.bounds.size
        scrollView.contentOffset = CGPoint.zero
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        termView = TermTextView(frame: view.bounds, font: defaultFont!)
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
        let guide = view.safeAreaLayoutGuide
        view.keyboardLayoutGuide.usesSafeArea = false

        // for the scrollview layout
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
            scrollView.leadingAnchor.constraint(equalToSystemSpacingAfter: guide.leadingAnchor, multiplier: 1.0),
            view.keyboardLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: self.scrollView.bottomAnchor, multiplier: 1.0),
            guide.trailingAnchor.constraint(equalToSystemSpacingAfter: self.scrollView.trailingAnchor, multiplier: 1.0)
            ])

//        NSLayoutConstraint.activate([
//            termView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
//            termView.leadingAnchor.constraint(equalToSystemSpacingAfter: guide.leadingAnchor, multiplier: 1.0),
//            view.keyboardLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: self.termView.bottomAnchor, multiplier: 1.0),
//            guide.trailingAnchor.constraint(equalToSystemSpacingAfter: self.termView.trailingAnchor, multiplier: 1.0)
//            ])

//        self.termView.becomeFirstResponder()
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
        print("Will Transition to size \(size) from super view size \(view.frame.size)")
        detectOrientation()
        view.layoutSubviews()
        scrollView.contentSize = size
        scrollView.setNeedsLayout()
        scrollView.setNeedsDisplay()
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


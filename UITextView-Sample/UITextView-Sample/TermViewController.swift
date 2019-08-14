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
        
        var defaultFont = UIFont(name: "Menlo", size: 20.0)
        self.textView.font = defaultFont
        
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
        self.view.keyboardLayoutGuide.usesSafeArea = false

        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
            self.textView.leadingAnchor.constraint(equalToSystemSpacingAfter: guide.leadingAnchor, multiplier: 1.0),
            self.view.keyboardLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: self.textView.bottomAnchor, multiplier: 1.0),
            guide.trailingAnchor.constraint(equalToSystemSpacingAfter: self.textView.trailingAnchor, multiplier: 1.0)
            ])
        
        self.textView.resignFirstResponder()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (firstLayout) {
            firstLayout = false
            detectOrientation()
        }
    }
}


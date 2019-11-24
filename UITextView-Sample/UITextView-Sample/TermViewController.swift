//
//  ViewController.swift
//  UITextView-Sample
//
//  Created by Jay Kint on 8/10/19.
//  Copyright © 2019 werks.co. All rights reserved.
//

import UIKit

// https://developer.apple.com/library/archive/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/CustomTextProcessing/CustomTextProcessing.html
// An NSTextStorage object serves as the character data repository for Text Kit. The format for this data is an attributed string, which is a sequence of characters (in Unicode encoding) and
// associated attributes (such as font, color, and paragraph style). The classes that represent attributed strings are NSAttributedString and NSMutableAttributedString, of which NSTextStorage is
// a subclass. As described in Character Attributes, each character in a block of text has a dictionary of keys and values associated with it. A key names an attribute (such as
// NSFontAttributeName), and the associated value specifies the characteristics of that attribute (such as Helvetica 12-point).
//
// There are three stages to editing a text storage object programmatically. The first stage is to send it a beginEditing message to announce a group of changes.
//
// In the second stage, you send it some editing messages, such as replaceCharactersInRange:withString: and setAttributes:range:, to effect the changes in characters or attributes. Each time you
// send such a message, the text storage object invokes edited:range:changeInLength: to track the range of its characters affected since it received the beginEditing message.
//
// In the third stage, when you’re done changing the text storage object, you send it an endEditing message. This causes it to sends out the delegate message
// textStorage:willProcessEditing:range:changeInLength: and invoke its own processEditing method, fixing attributes within the recorded range of changed characters. See Attribute Fixing for
// information about attribute fixing.
//
//After fixing its attributes, the text storage object sends the delegate method textStorage:didProcessEditing:range:changeInLength:, giving the delegate an opportunity to verify and possibly
// change the attributes. (Although the delegate can change the text storage object’s character attributes in this method, it cannot change the characters themselves without leaving the text
// storage in an inconsistent state.) Finally, the text storage object sends the processEditingForTextStorage:edited:range:changeInLength:invalidatedRange: message to each associated layout
// manager—indicating the range in the text storage object that has changed, along with the nature of those changes. The layout managers in turn use this information to recalculate their glyph
// locations and redisplay if necessary.
//
// https://stackoverflow.com/questions/5871067/nstextview-line-break-on-character-not-word
// The line breaking setting in a NSTextView is actually a attribute of the text in it's textStorage.
// You need to get the NSTextStorage of that view which is a NSMutableAttributedString then set that string's style to your needed line break setting

class TermViewController: UIViewController, UITextViewDelegate {

    var textView : UITextView!
    var firstLayout : Bool = true
    var textStorage : ExampleStorage!
    var textLayout : NSLayoutManager!
    var textContainer : NSTextContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textStorage = ExampleStorage()
        self.textLayout = NSLayoutManager()
        self.textStorage.addLayoutManager(textLayout)
        self.textContainer = NSTextContainer()
        self.textLayout.addTextContainer(textContainer)
        
        self.textView = UITextView(frame: self.view.bounds, textContainer: textContainer)
//        self.textView = UITextView(frame: self.view.bounds)
        self.textView.delegate = self
        self.textView.translatesAutoresizingMaskIntoConstraints = false
//        self.textView.isEditable = true
        
        let defaultFont = UIFont(name: "Menlo", size: 20.0)
        self.textView.font = defaultFont
        
        self.view.addSubview(textView)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byCharWrapping
        textView.attributedText = NSAttributedString(string: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                                                     attributes:[NSAttributedString.Key.font : defaultFont!, NSAttributedString.Key.paragraphStyle : style])
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

class TermTextStorage : NSTextStorage {
    
//    var contents : NSMutableAttributedString = NSMutableAttributedString(string: "Hello world")
    
    var contents : NSTextStorage = NSTextStorage(string: "Hello world")
    
    override var string : String {
        get {
            print("string \(contents.string)")
            return contents.string
        }
    }
    
    override func replaceCharacters(in r: NSRange, with str: String)
    {
        print("replaceCharacters \(r) \(str)")
        contents.beginEditing()
        contents.replaceCharacters(in: r, with: str)
        contents.edited([.editedCharacters], range: r, changeInLength:(str as NSString).length - r.length)
        contents.endEditing()
    }
    
//    override func deleteCharacters(in r: NSRange)
//    {
//        print("deleteCharacters")
//        contents.deleteCharacters(in: r)
//    }
    
    override func setAttributes(_ attr: [NSAttributedString.Key : Any]?, range: NSRange)
    {
        print("setAttributes")
    }
    
//    override func addAttribute(_ a: NSAttributedString.Key, value: Any, range: NSRange)
//    {
//        print("addAttriburte")
//    }
//
//    override func addAttributes(_ attrs: [NSAttributedString.Key: Any]?, range: NSRange)
//    {
//        print("addAttributes")
//    }
//
//    override func removeAttribute(_ a: NSAttributedString.Key, range: NSRange)
//    {
//        print("removeAttribute")
//    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any]
    {
        print("attributes \(location) \(String(describing: range))")
        return contents.attributes(at: location, effectiveRange: range)
    }
}

final class ExampleStorage : NSTextStorage {

    private let container = NSTextStorage()

    override var string: String {
        return container.string
    }

    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return container.attributes(at: location, effectiveRange: range)
    }

    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        container.replaceCharacters(in: range, with: str)
        edited([.editedAttributes, .editedCharacters], range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
    }

    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        beginEditing()
        container.setAttributes(attrs, range: range)
        edited([.editedAttributes], range: range, changeInLength: 0)
        endEditing()
    }
}

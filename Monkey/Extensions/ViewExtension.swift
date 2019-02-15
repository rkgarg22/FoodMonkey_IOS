//
//  ViewExtension.swift
//  cozo
//
//  Created by Sierra 4 on 05/05/17.
//  Copyright © 2017 monika. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import SDWebImage

protocol StringType { var get: String { get } }

extension String: StringType { var get: String { return self } }

extension Optional where Wrapped: StringType {
    func unwrap() -> String {
        return self?.get ?? ""
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
extension UIButton {
    
    @IBInspectable
    open var exclusiveTouchEnabled : Bool {
        get {
            return self.isExclusiveTouch
        }
        set(value) {
            self.isExclusiveTouch = value
        }
    }
    
    func roundedButton(){
        let maskPAth1 = UIBezierPath(roundedRect: self.bounds,
                                     byRoundingCorners: [.bottomLeft , .bottomRight],
                                     cornerRadii:CGSize.init(width: 4.0, height: 4.0))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = self.bounds
        maskLayer1.path = maskPAth1.cgPath
        self.layer.mask = maskLayer1
        
    }
}




extension NSObject {
    var appDelegate:AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
}


extension UIImageView {
    
    func loadURL(urlString : String?,placeholder : String? , placeholderImage : UIImage?)  {
        
            if  placeholder != "" {
                
                self.sd_setImage(with:URL(string:/placeholder) , placeholderImage: placeholderImage, options: .continueInBackground , progress: { (min, max, url) in
                    
                }, completed: { (image, error, type, utlType)  in
                    self.image = image == nil ? placeholderImage : image
                    
                    self.sd_setImage(with:URL(string:/urlString) , placeholderImage: image, options: [.continueInBackground] , progress: { (min, max, url) in
                        
                    }, completed: { (image, error, type, utlType)  in
                        self.image = image == nil ? placeholderImage : image
                    })
                    
                })
                
            }else{
                self.sd_setImage(with:URL(string:/urlString) , placeholderImage: placeholderImage, options: [.continueInBackground] , progress: { (min, max,url) in
                    
                }, completed: { (image, error, type, utlType)  in
                    self.image = image == nil ? placeholderImage : image
                })
            }
            
            
        }
    
    
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        let c = self.characters
        if (c.count <= n) { return self }
        return String( Array(c).prefix(upTo: n) )
    }
    
    }


    
    infix operator =>
    infix operator =|
    infix operator =<
    
    typealias OptionalJSON = [String : JSON]?
    
    func =>(key : ParamKeys, json : OptionalJSON) -> String?{
        return json?[key.rawValue]?.stringValue
    }
    
    func =<(key : ParamKeys, json : OptionalJSON) -> [String : JSON]?{
        return json?[key.rawValue]?.dictionaryValue
    }
    
    func =|(key : ParamKeys, json : OptionalJSON) -> [JSON]?{
        return json?[key.rawValue]?.arrayValue
    }
    
    
    prefix operator /
    prefix func /(value : String?) -> String {
        return value.unwrap()
}


enum XibError : Error {
    case XibNotFound
    case None
}

extension UIView {
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func loadViewFromNib(withIdentifier identifier : String) throws -> UIView? {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:identifier, bundle: bundle)
        let xibs = nib.instantiate(withOwner: self, options: nil)
        
        if xibs.count == 0 {
            return nil
        }
        guard let firstXib = xibs[0] as? UIView else{
            throw XibError.XibNotFound
        }
        return firstXib
    }
}


extension UIImage {
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension String {
    func removeWhiteSpaces() -> String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func base64ToImage() -> UIImage? {
        
        if let url = URL(string: self),let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
            return image
        }
        
        return nil
        
    }
}


extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x:(labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,y:
            (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x:locationOfTouchInLabel.x - textContainerOffset.x,y:
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            self.addAttribute(NSFontAttributeName, value: UIFont.init(name: FontName.CatamaranThin.rawValue, size: 13)!, range: foundRange)
            self.addAttribute(NSForegroundColorAttributeName, value: UIColor.AppColorGreen , range: foundRange)
            return true
        }
        return false
    }
}


extension UIViewController {
    func setStatusBarColor(){
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 20))
        view.backgroundColor = UIColor.black
        self.view.addSubview(view)
    }
}

extension UITextView {
    
    func convertHashtags(text:String) -> NSAttributedString {
        
        var length : Int = 0
        let text:String = text
        let words:[String] = text.separate(withChar: " ")
        let hashtagWords = words.flatMap({$0.separate(withChar: "#")})
        let attrs = [NSFontAttributeName : UIFont.init(name: FontName.CatamaranThin.rawValue, size: 15) , NSForegroundColorAttributeName : UIColor.AppColorGray]
        let attrString = NSMutableAttributedString(string: text, attributes:attrs)
        for word in hashtagWords {
            if word.hasPrefix("#") {
                let matchRange:NSRange = NSMakeRange(length, word.characters.count)
                let stringifiedWord:String = word
                
                attrString.addAttribute(NSLinkAttributeName, value: "hash:\(stringifiedWord)", range: matchRange)
            }
            length += word.characters.count
        }
        return attrString
        
    }
}

extension String {
    public func separate(withChar char : String) -> [String]{
        var word : String = ""
        var words : [String] = [String]()
        for chararacter in self.characters {
            if String(chararacter) == char && word != "" {
                words.append(word)
                word = char
            }else {
                word += String(chararacter)
            }
        }
        words.append(word)
        return words
    }
    
    func getHashtags() -> [String]? {
        let hashtagDetector = try? NSRegularExpression(pattern: "#(\\w+)", options: NSRegularExpression.Options.caseInsensitive)
        let results = hashtagDetector?.matches(in: self, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, self.utf16.count)).map { $0 }
        
        return results?.map({
            (self as NSString).substring(with: $0.rangeAt(1))
        })
    }
    
  
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
}


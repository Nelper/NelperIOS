//
//  Extensions.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-16.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation


//MARK: Public vars

public struct Helper {
	/**
	- returns: the height of the statusBar
	*/
	static var statusBarHeight: CGFloat {
		return UIApplication.sharedApplication().statusBarFrame.height
	}
	
	static var appBuild: String {
		return NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
	}
	
	/**
	- returns: the language of the user's phone
	*/
	public func deviceLanguage() -> String {
		return NSBundle.mainBundle().preferredLocalizations[0]
	}
	
	static public func statusBarHidden(hidden: Bool, animation: UIStatusBarAnimation) {
		UIApplication.sharedApplication().setStatusBarHidden(hidden, withAnimation: animation)
	}
}

//MARK: Extenstions

extension UIImage {
	
	/// EZSwiftExtensions - rate: 0 to 1
	public func compressImage(rate rate: CGFloat) -> NSData {
		let compressedImage = UIImageJPEGRepresentation(self, rate)
		return compressedImage!
	}
	
	/// EZSwiftExtensions
	public func getSizeAsKilobytes() -> Int {
		let imageData = NSData(data: UIImageJPEGRepresentation(self, 1)!)
		return imageData.length / 1024
	}
	
	/// EZSwiftExtensions
	public class func scaleTo(image image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
		let newSize = CGSize(width: w, height: h)
		UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
		image.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
		let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
	
	/// EZSwiftExtensions
	public func aspectHeightForWidth(width: CGFloat) -> CGFloat {
		return (width * self.size.height) / self.size.width
	}
	
	/// EZSwiftExtensions
	public func aspectWidthForHeight(height: CGFloat) -> CGFloat {
		return (height * self.size.width) / self.size.height
	}
}

extension String {
	func isEmail() -> Bool {
		let regex = try! NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$",
			options: [.CaseInsensitive])
		
		return regex.firstMatchInString(self, options:[],
			range: NSMakeRange(0, utf16.count)) != nil
	}

	func isPhoneNumber() -> Bool {
		let regex = try! NSRegularExpression(pattern: "^\\d{10}$",
			options: [.CaseInsensitive])
		
		return regex.firstMatchInString(self, options:[],
			range: NSMakeRange(0, utf16.count)) != nil
	}
	
	func isAccepted(min: Int) -> Bool {
		if (self.utf16.count >= min) {
			return true
		} else {
			return false
		}
	}
}
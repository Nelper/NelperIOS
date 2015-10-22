//
//  Shapes.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-21.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class PageControllerOval: UIView {
	override func drawRect(rect: CGRect) {
		let ovalPath = UIBezierPath(ovalInRect: CGRectMake(0, 0, self.frame.width, self.frame.height))
		blackPrimary.colorWithAlphaComponent(0.5).setFill()
		ovalPath.fill()
	}
}
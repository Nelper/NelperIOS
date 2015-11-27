//
//  ProfileFeedbackView.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-27.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class ProfileFeedbackView: UIView {
	
	init(user: User) {
		super.init(frame: CGRectZero)
		
		self.createView(user)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func createView(user: User) {
		
	}
	
}
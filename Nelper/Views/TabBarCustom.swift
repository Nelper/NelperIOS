//
//  TabBarCustom.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-15.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TabBarCustom: UIView {
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		adjustView()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		adjustView()
	}
	
	func adjustView(){
		self.frame = CGRectMake(0, 0, self.frame.size.width, 45)
		self.backgroundColor = orangeTextColor
		
		
		
		
	}
	

	
	
	


}
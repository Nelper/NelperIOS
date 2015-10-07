//
//  MoreViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-09-25.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class MoreViewController: UIViewController {
	
//	init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, presentingViewController:UIViewController) {
//		super.init(nibName: nil, bundle: nil)
//	}
//	
//	required init?(coder aDecoder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
		self.view = UIVisualEffectView(effect: blurEffect)
		let testButton = UIButton()
		self.view.addSubview(testButton)
		testButton.backgroundColor = UIColor.redColor()
		testButton.snp_makeConstraints { (make) -> Void in
			make.center.equalTo(self.view.snp_center)
			make.width.equalTo(30)
			make.height.equalTo(30)
		}
	}
}


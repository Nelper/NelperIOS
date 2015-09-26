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
	
	convenience init() {
		self.init(nibName: "MoreViewController", bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		createView()
		adjustUI()
	}
	
	override func viewDidAppear(animated: Bool) {
		self.loadData()
	}
	
	func adjustUI() {
		
	}
	
	func createView() {
		
	}
	
	func loadData() {
		
	}
	
}


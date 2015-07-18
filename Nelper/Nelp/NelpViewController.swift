//
//  NelpViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-21.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import MapKit

class NelpViewController: UIViewController {
    


	@IBOutlet weak var mapViewContainer: UIView!
	@IBOutlet weak var taskTableView: UITableView!
    
    
    convenience init() {
        self.init(nibName: "NelpViewController", bundle: nil)
	
    }

    
  override func viewDidLoad() {
    
    super.viewDidLoad()
		
  }

}


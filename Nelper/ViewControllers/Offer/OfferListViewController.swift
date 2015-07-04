//
//  OfferViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-24.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

class OfferListViewController: UIViewController {
  
  var offerStore = OfferStore()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    offerStore.listMyOffers { (offers: [Offer]?, error: NSError?) -> Void in
      if error != nil {
        
      } else {
        if let offers = offers {
          for o in offers {
            println(o.desc)
          }
        }
      }
    }
  }
  
  @IBAction func onAddOfferClick(sender: UIBarButtonItem) {
    let vc = OfferCreateViewController(offerStore: offerStore)
    self.navigationController?.showViewController(vc, sender: self)
  }
}

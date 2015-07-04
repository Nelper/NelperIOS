//
//  OfferViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-24.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

class OfferListViewController: UIViewController,
  UITableViewDelegate, UITableViewDataSource, OfferCreateViewControllerDelegate {
  
  var offerStore = OfferStore()
  
  var offers = [Offer]()
  
  var tableView: UITableView!
  var refreshView: UIRefreshControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "onAddOfferClick")
    
    let tableView = UITableView()
    tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
    tableView.delegate = self
    tableView.dataSource = self
    tableView.registerClass(OfferTableViewCell.classForCoder(), forCellReuseIdentifier: OfferTableViewCell.reuseIdentifier)
    self.view = tableView
    self.tableView = tableView
    
    let refreshView = UIRefreshControl()
    refreshView.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.addSubview(refreshView)
    self.refreshView = refreshView
    
    loadData()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return offers.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier(OfferTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! OfferTableViewCell
    
    let offer = self.offers[indexPath.item]
    
    cell.setOffer(offer)
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  func offerAdded(offer: Offer) {
    self.offers.append(offer)
    self.tableView.reloadData()
  }
  
  func onAddOfferClick() {
    let vc = OfferCreateViewController(offerStore: offerStore)
    vc.delegate = self
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func onPullToRefresh() {
    loadData()
  }
  
  func loadData() {
    offerStore.listMyOffers { (offers: [Offer]?, error: NSError?) -> Void in
      if error != nil {
        
      } else {
        self.offers = offers!
        
        self.refreshView?.endRefreshing()
        self.tableView?.reloadData()
      }
    }
    
  }
  
}

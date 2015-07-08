//
//  OfferViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-24.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

class NelpTasksListViewController: UIViewController,
  UITableViewDelegate, UITableViewDataSource, NelpTaskCreateViewControllerDelegate {
  
  var nelpStore = NelpTasksStore()
  
  var nelpTasks = [NelpTask]()
  
  var tableView: UITableView!
  var refreshView: UIRefreshControl!
  
  convenience init() {
    self.init(nibName: "NelpTasksListViewController", bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "onAddNelpTaskClick")
    
    let tableView = UITableView()
    tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
    tableView.delegate = self
    tableView.dataSource = self
    tableView.registerClass(OfferTableViewCell.classForCoder(), forCellReuseIdentifier: OfferTableViewCell.reuseIdentifier)
    
    self.tableView = tableView
    
    let refreshView = UIRefreshControl()
    refreshView.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.addSubview(refreshView)
    self.refreshView = refreshView
    
    self.view = tableView
    
    loadData()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return nelpTasks.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier(OfferTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! OfferTableViewCell
    
    let nelpTask = self.nelpTasks[indexPath.item]
    
    cell.setNelpTask(nelpTask)
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  func nelpTaskAdded(nelpTask: NelpTask) {
    self.nelpTasks.append(nelpTask)
    self.tableView.reloadData()
  }
  
  func onAddNelpTaskClick() {
    let vc = NelpTaskCreateViewController(nelpTasksStore: NelpTasksStore())
    vc.delegate = self
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func onPullToRefresh() {
    loadData()
  }
  
  func loadData() {
    nelpStore.listMyOffers { (nelpTasks: [NelpTask]?, error: NSError?) -> Void in
      if error != nil {
        
      } else {
        self.nelpTasks = nelpTasks!
        
        self.refreshView?.endRefreshing()
        self.tableView?.reloadData()
      }
    }
    
  }
  
}

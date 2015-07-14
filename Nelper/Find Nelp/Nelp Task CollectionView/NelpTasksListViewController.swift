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
  
  
    @IBOutlet weak var tasksListContainer: UIView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var addTaskButton: UIButton!
		@IBOutlet weak var logoImage: UIImageView!
    
    var nelpStore = NelpTasksStore()
    var nelpTasks = [NelpTask]()
  
    var tableView: UITableView!
    var refreshView: UIRefreshControl!
    
  
    
    convenience init() {
        self.init(nibName: "NelpTasksListViewController", bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
		self.adjustUI()
		loadData()
		//If the users has no tasks, the TableView is not created, else it does.
    if (!self.nelpTasks.isEmpty){
        self.createTasksTableView()
    }
}

    //If the user has tasks, creates the tableView.
    func createTasksTableView(){
        let tableView = UITableView()
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(NelpTasksTableViewCell.classForCoder(), forCellReuseIdentifier: NelpTasksTableViewCell.reuseIdentifier)
        
        
        self.tableView = tableView
        
        let refreshView = UIRefreshControl()
        refreshView.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshView)
        self.refreshView = refreshView
        
        self.tasksListContainer.addSubview(tableView)
        
        loadData()
	}
	
	
	//Adjusts UI(Font,colors etc)
	func adjustUI(){
		self.navBar.backgroundColor = fireColor
		self.logoImage.image = UIImage(named: "logo_nobackground_v2")
		self.tasksListContainer.backgroundColor = fireColor
		
	}
    
    
	
	//Delegate methods
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return nelpTasks.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier(NelpTasksTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! NelpTasksTableViewCell
    
    let nelpTask = self.nelpTasks[indexPath.item]
    
    cell.setNelpTask(nelpTask)
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
    
  func nelpTaskAdded(nelpTask: NelpTask) {
    self.nelpTasks.append(nelpTask)
		self.loadData()
		if(self.tableView == nil){
			self.createTasksTableView()
			self.tableView.reloadData()
		}else{
    self.tableView?.reloadData()
		}
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
 
//When the add task button is tapped, shows the form to create a task.
	@IBAction func addTaskButtonTapped(sender: AnyObject) {
		var taskCreateVC = NelpTaskCreateViewController(nibName:"NelpTaskCreateViewController", bundle: nil)
		taskCreateVC.delegate = self
		self.presentViewController(taskCreateVC, animated:true, completion: nil)
	
	}
  
}

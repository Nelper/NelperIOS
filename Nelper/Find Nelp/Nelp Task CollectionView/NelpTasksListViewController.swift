//
//  OfferViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-24.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import SnapKit


class NelpTasksListViewController: UIViewController,
  UITableViewDelegate, UITableViewDataSource, NelpTaskCreateViewControllerDelegate {
  
	@IBOutlet weak var noTaskMessage: UILabel!
  
    @IBOutlet weak var tasksListContainer: UIView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var addTaskButton: UIButton!
		@IBOutlet weak var logoImage: UIImageView!
    
    var nelpStore = NelpTasksStore()
    var nelpTasks = [NelpTask]()
  
    var tableView: UITableView!
    var refreshView: UIRefreshControl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
		self.adjustUI()
		createTasksTableView()
		loadData()

}

	
//INIT
	convenience init() {
		self.init(nibName: "NelpTasksListViewController", bundle: nil)
	}
	
	
	//If the user has tasks, creates the tableView.
    func createTasksTableView(){
        let tableView = UITableView()
        tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(NelpTasksTableViewCell.classForCoder(), forCellReuseIdentifier: NelpTasksTableViewCell.reuseIdentifier)

        
        let refreshView = UIRefreshControl()
        refreshView.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshView)
        
			self.tasksListContainer.addSubview(tableView);
			
			tableView.snp_makeConstraints { (make) -> Void in
    make.edges.equalTo(self.tasksListContainer.snp_edges)
			}
				self.tableView = tableView

			self.refreshView = refreshView
	}
	
	
//UI
	func adjustUI(){
		self.navBar.backgroundColor = orangeMainColor
		self.logoImage.image = UIImage(named: "logo_nobackground_v2")
		self.logoImage.contentMode = UIViewContentMode.ScaleAspectFit
		self.tasksListContainer.backgroundColor = orangeSecondaryColor
		self.addTaskButton.titleLabel?.font = UIFont(name: "Railway", size: kButtonFontSize)
		self.noTaskMessage.font = UIFont(name: "Railway", size: kSubtitleFontSize)
	}
	
	
//DATA FETCHING
	
	func checkForEmptyTasks(){
		if(nelpTasks.isEmpty){
			if(self.tableView != nil){
			self.tableView.removeFromSuperview()
			}
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
				self.checkForEmptyTasks()
      }
    }
    
}
//DELEGATE METHODS

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
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if (editingStyle == UITableViewCellEditingStyle.Delete){
			var nelpTask = nelpTasks[indexPath.row];
			nelpTask.deleteInBackgroundWithBlock({ (YES, NSError: NSError?) -> Void in
				self.loadData()
				self.checkForEmptyTasks()
			})
		}
	}
	
	
	
	//Add actions to the table view cells
	

	
	func nelpTaskAdded(nelpTask: NelpTask) {
		self.nelpTasks.append(nelpTask)
		if(nelpTasks.count > 0){
			createTasksTableView()
		}else{
			self.tableView?.reloadData()
			self.loadData()
		}
	}
	
	
//IBACTIONS
	

	//When the add task button is tapped, shows the form to create a task.
	@IBAction func addTaskButtonTapped(sender: AnyObject) {
		var taskCreateVC = NelpTaskCreateViewController(nibName:"NelpTaskCreateViewController", bundle: nil)
		taskCreateVC.delegate = self
		self.presentViewController(taskCreateVC, animated:true, completion: nil)
	
	}
  
}

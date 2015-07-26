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
	
    @IBOutlet weak var navBar: UIView!
		@IBOutlet weak var logoImage: UIImageView!
	  @IBOutlet weak var settingsButton: UIButton!
	
	
	@IBOutlet weak var tabBarView: UIView!
	@IBOutlet weak var nelpTabBarImage: UIButton!
	@IBOutlet weak var findNelpTabBarImage: UIButton!
	@IBOutlet weak var profileTabBarImage: UIButton!
	
	@IBOutlet weak var askForNelpContainer: UIView!
	@IBOutlet weak var addTaskButton: UIButton!
	@IBOutlet weak var askForNelpLabel: UILabel!

	
	
	
	@IBOutlet weak var myNelpRequestsContainer: UIView!
	@IBOutlet weak var myNelpRequestsLabel: UILabel!
	
	@IBOutlet weak var taskListContainer: UIView!
	@IBOutlet weak var noTasksMessage: UILabel!
	
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
        
			self.taskListContainer.addSubview(tableView);
			
			tableView.snp_makeConstraints { (make) -> Void in
    make.edges.equalTo(self.taskListContainer.snp_edges)
			}
				self.tableView = tableView

			self.refreshView = refreshView
	}
	
	
//UI
	func adjustUI(){
		self.navBar.backgroundColor = orangeMainColor
		self.logoImage.image = UIImage(named: "logo_nobackground_v2")
		self.logoImage.contentMode = UIViewContentMode.ScaleAspectFit
		self.settingsButton.setBackgroundImage(UIImage(named: "cogwheel.png"), forState: UIControlState.Normal)
		
		self.askForNelpContainer.backgroundColor = orangeSecondaryColor

		self.myNelpRequestsContainer.backgroundColor = orangeMainColor
		self.myNelpRequestsLabel.text = "My Nelp Requests"
		self.myNelpRequestsLabel.font = UIFont(name: "Railway", size: kSubtitleFontSize)
		self.myNelpRequestsLabel!.textColor = whiteNelpyColor
		
		self.taskListContainer.backgroundColor = whiteNelpyColor
		self.noTasksMessage.font = UIFont(name: "Railway", size: kSubtitleFontSize)
		self.noTasksMessage.textColor = orangeMainColor
		self.noTasksMessage.text = "You have no active requests!"
		
		self.tabBarView.backgroundColor = orangeMainColor
		self.findNelpTabBarImage.setBackgroundImage(UIImage(named: "search_black.png"), forState: UIControlState.Normal)
		self.nelpTabBarImage.setBackgroundImage(UIImage(named: "help_white.png"), forState: UIControlState.Normal)
		self.profileTabBarImage.setBackgroundImage(UIImage(named: "profile_white.png"), forState: UIControlState.Normal)
		
		self.addTaskButton.setBackgroundImage(UIImage(named: "add_white.png"), forState: UIControlState.Normal)
		self.askForNelpLabel.text = "Ask for Nelp!"
		self.askForNelpLabel.textColor = whiteNelpyColor
		self.askForNelpLabel.font = UIFont(name: "Railway", size: kTitleFontSize)
		
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
	
	
	
	// NelpCreateTaskViewController Delegate
	

	
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
	
	@IBAction func nelpTabBarButtonTapped(sender: AnyObject) {
		var nextVC = NelpViewController()
		self.presentViewController(nextVC, animated: false, completion: nil)
	}
	
	@IBAction func profileTabBarButtonTapped(sender: AnyObject) {
		var nextVC = ProfileViewController()
		self.presentViewController(nextVC, animated: false, completion: nil)
	}
  
}

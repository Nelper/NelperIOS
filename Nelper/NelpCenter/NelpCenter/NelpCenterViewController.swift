//
//  NelpCenterViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-06.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage

class NelpCenterViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MyApplicationDetailsViewDelegate, SegmentControllerDelegate, MyTaskDetailsViewControllerDelegate {
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var containerView: UIView!
	
	var segmentControllerView: SegmentController!
	
	var profilePicture:UIImageView!
	var tasksContainer:UIView!
	var nelpTasks = [Task]()
	var nelpApplications = [TaskApplication]()
	var myTasksTableView: UITableView!
	var myApplicationsTableView:UITableView!
	var locationManager = CLLocationManager()
	var currentLocation: CLLocation?
	
	var noActiveApplications:Bool = false
	var noActiveTasks:Bool = false
	var emptyTableViewWarning:UILabel!
	
	var emptyApplicationsWarning = "No active applications."
	var emptyTasksWarning = "No active tasks."
	var goToButton:PrimaryActionButton!
	
	var tabBarViewController: TabBarViewController!
	var tabBarFakeView: UIImageView!
	
	//MARK: Initialization

	convenience init() {
		self.init(nibName: "NelpCenterViewController", bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tabBarViewController = UIApplication.sharedApplication().delegate!.window!?.rootViewController as! TabBarViewController
		
		self.loadData()
		self.createView()
		self.adjustUI()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tabBarViewController.tabBarWillHide(false)
		
		self.myTasksTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
		self.myApplicationsTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
	}
	
	override func viewDidAppear(animated: Bool) {
		SVProgressHUD.dismiss()
		super.viewDidAppear(animated)
		self.loadData()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	//MARK: View Creation
	
	func createView(){
		
		//Location
		self.locationManager.delegate = self
		
		if self.locationManager.location != nil {
			self.locationManager.delegate = self
			let userLocation: CLLocation = self.locationManager.location!
			self.currentLocation = userLocation
		}
		
		//Segment Controller
		
		self.segmentControllerView = SegmentController()
		self.containerView.addSubview(segmentControllerView)
		self.segmentControllerView.delegate = self
		self.segmentControllerView.items = ["My Tasks", "My Applications"]
		self.segmentControllerView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.centerX.equalTo(self.view.snp_centerX)
			make.width.equalTo(self.view.snp_width).offset(2)
			make.height.equalTo(50)
		}
		
		//Tasks container
		let tasksContainer = UIView()
		containerView.addSubview(tasksContainer)
		self.tasksContainer = tasksContainer
		tasksContainer.backgroundColor = Color.whiteBackground
		tasksContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(segmentControllerView.snp_bottom)
			make.width.equalTo(self.view.snp_width)
			make.bottom.equalTo(self.view.snp_bottom).offset(-49)
		}
		
		//Empty Applications/Tasks warning label
		
		let emptyTableViewWarning = UILabel()
		emptyTableViewWarning.textAlignment = NSTextAlignment.Center
		tasksContainer.addSubview(emptyTableViewWarning)
		self.emptyTableViewWarning = emptyTableViewWarning
		self.emptyTableViewWarning.font =  UIFont(name: "Lato-Regular", size: kTitle17)
		self.emptyTableViewWarning.textColor = Color.darkGrayDetails
		self.emptyTableViewWarning.snp_makeConstraints { (make) -> Void in
			make.center.equalTo(tasksContainer)
			make.left.equalTo(tasksContainer).offset(30)
			make.right.equalTo(tasksContainer).offset(-30)
		}
		
		self.emptyTableViewWarning.text = self.emptyTasksWarning
		
		//Go to button
		
		let goToButton = PrimaryActionButton()
		self.goToButton = goToButton
		tasksContainer.addSubview(goToButton)
		goToButton.setBackgroundColor(Color.redPrimary, forState: UIControlState.Normal)
		goToButton.setTitleColor(Color.whitePrimary, forState: .Normal)
		goToButton.setTitle("Post a Task", forState: .Normal)
		goToButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(emptyTableViewWarning.snp_bottom).offset(20)
			make.centerX.equalTo(tasksContainer)
		}
		
		self.createMyTasksTableView()
		self.createMyApplicationsTableView()
		
		let tabBarFakeView = UIImageView()
		self.tabBarFakeView = tabBarFakeView
		self.view.addSubview(tabBarFakeView)
		tabBarFakeView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
			make.height.equalTo(49)
		}
	}
	
	func createMyTasksTableView() {

		let tableView = UITableView()
		tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.registerClass(NelpTasksTableViewCell.classForCoder(), forCellReuseIdentifier: NelpTasksTableViewCell.reuseIdentifier)
		tableView.backgroundColor = Color.whiteBackground
		
		self.tasksContainer.addSubview(tableView)
		tableView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.tasksContainer.snp_edges)
		}
		self.myTasksTableView = tableView
		self.myTasksTableView.alpha = 0
		//self.myTasksTableView.transform = CGAffineTransformMakeTranslation(-500, 0)
		self.myTasksTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		
		if self.noActiveTasks == true{
			tableView.hidden = true
		}
	}
	
	func createMyApplicationsTableView() {
		
		let tableViewApplications = UITableView()
		tableViewApplications.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
		tableViewApplications.delegate = self
		tableViewApplications.dataSource = self
		tableViewApplications.registerClass(NelpApplicationsTableViewCell.classForCoder(), forCellReuseIdentifier: NelpApplicationsTableViewCell.reuseIdentifier)
		tableViewApplications.backgroundColor = Color.whiteBackground
		tableViewApplications.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)

		self.tasksContainer.addSubview(tableViewApplications)
		tableViewApplications.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.tasksContainer.snp_edges)
		}
		
		self.myApplicationsTableView = tableViewApplications
		self.myApplicationsTableView.alpha = 0
		self.myApplicationsTableView.transform = CGAffineTransformMakeTranslation(500, 0)
		self.myApplicationsTableView.hidden = true
		self.myApplicationsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		
		if self.noActiveApplications == true{
			tableViewApplications.hidden = true
		}
	}
	
	//MARK: UI
	
	func adjustUI() {
		self.extendedLayoutIncludesOpaqueBars = true
		self.navBar.setTitle("Nelp Center")
		
	}
	
	//MARK: DATA
	
	func onPullToRefresh() {
		loadData()
	}
	
	
	/**
	Load User's Task and Applications
	*/
	func loadData() {
		ApiHelper.listMyNelpTasksWithBlock { (nelpTasks: [Task]?, error: NSError?) -> Void in
			if error != nil {
				print(error, terminator: "")
			} else {
				self.nelpTasks = nelpTasks!
				if self.nelpTasks.count == 0{
					self.noActiveTasks = true
				}
				self.myTasksTableView?.reloadData()
			}
		}
		
		ApiHelper.listMyNelpApplicationsWithBlock { (nelpApplications: [TaskApplication]?, error: NSError?) -> Void in
			if error != nil {
				print(error, terminator: "")
			} else {
				self.nelpApplications = nelpApplications!
				if self.nelpApplications.count == 0{
					self.noActiveApplications = true
				}
				self.myApplicationsTableView?.reloadData()
			}
		}
	}
	
	
	//MARK: My Applications Details VC Delegate
	
	func didCancelApplication(application:TaskApplication){
		self.myApplicationsTableView.reloadData()
	}
	
	//MARK: My Task Details View Controller Delegate
	
	func didEditTask(task:Task){
	}
	
	
	//MARK: Tableview Delegate and Datasource
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if(tableView == self.myTasksTableView) {
			return nelpTasks.count
		} else if (tableView == self.myApplicationsTableView) {
			return nelpApplications.count
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if(tableView == myTasksTableView) {
			if (!self.nelpTasks.isEmpty) {
				let cellTask = NelpTasksTableViewCell()
				cellTask.selectionStyle = UITableViewCellSelectionStyle.None
				let task = self.nelpTasks[indexPath.item]
				cellTask.setNelpTask(task)
				cellTask.setImages(task)
				
				return cellTask
			}
		} else if (tableView == myApplicationsTableView) {
			if(!self.nelpApplications.isEmpty) {
				let cellApplication = NelpApplicationsTableViewCell()
				cellApplication.selectionStyle = UITableViewCellSelectionStyle.None
				let nelpApplication = self.nelpApplications[indexPath.item]
				cellApplication.setNelpApplication(nelpApplication)
				cellApplication.setImages(nelpApplication)
				
				return cellApplication
			}
		}
		let cell: UITableViewCell = UITableViewCell()
		return cell
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		if (indexPath.row == tableView.indexPathsForVisibleRows!.last!.row) {
			SVProgressHUD.dismiss()
			
			UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				self.myTasksTableView.alpha = 1
				//self.myTasksTableView.transform = CGAffineTransformMakeTranslation(0, 0)
				}, completion: nil)
		}
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if(tableView == myTasksTableView) {
			let task = nelpTasks[indexPath.row]
			
			if task.state == .Accepted {
				let nextVC = MyTaskDetailsAcceptedViewController()
				nextVC.task = task
				self.hideTabBar()
				dispatch_async(dispatch_get_main_queue()) {
					self.navigationController?.pushViewController(nextVC, animated: true)
				}
			} else {
			let nextVC = MyTaskDetailsViewController(task: task)
			nextVC.delegate = self
				self.hideTabBar()
			dispatch_async(dispatch_get_main_queue()) {
				self.navigationController?.pushViewController(nextVC, animated: true)
			}
			}
		} else if (tableView == myApplicationsTableView) {
			let application = nelpApplications[indexPath.row]
			
			if application.state == .Accepted{
				let nextVC = MyApplicationDetailsAcceptedViewController()
				nextVC.poster = application.task.user
				nextVC.application = application
				self.hideTabBar()
				dispatch_async(dispatch_get_main_queue()) {
					self.navigationController?.pushViewController(nextVC, animated: true)
				}
				
			} else {
				let nextVC = MyApplicationDetailsView(poster: application.task.user, application: application)
				nextVC.delegate = self
				self.hideTabBar()
				dispatch_async(dispatch_get_main_queue()) {
					self.navigationController?.pushViewController(nextVC, animated: true)
				}
			}
		}
		
	}
	
//	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//		if(tableView == myTasksTableView) {
//			if (editingStyle == UITableViewCellEditingStyle.Delete){
//				let task = nelpTasks[indexPath.row];
//				ApiHelper.deleteTask(task)
//				self.nelpTasks.removeAtIndex(indexPath.row)
//				self.myTasksTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
//			}
//		}
//	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if (tableView == myTasksTableView) {
			return 200
		} else if (tableView == myApplicationsTableView) {
			return 200
		}
		return 0
	}
	
	//MARK: Utilities
	
	func hideTabBar() {
		self.tabBarViewController!.tabBarWillHide(true)
		self.tabBarFakeView.image = self.tabBarViewController.tabBarImage
		self.tabBarViewController!.tabBar.hidden = true
	}
	
	//MARK: Actions
	
	/**
	User tapped Profile Button
	
	- parameter sender: Profile Button
	*/
	func profileButtonTapped(sender:UIButton) {
		let nextVC = FullProfileViewController()
		self.navigationController?.pushViewController(nextVC, animated: true)
	}
	
	func onIndexChange(index: Int) {
		if index == 0 {
			self.emptyTableViewWarning.text = self.emptyTasksWarning
			self.goToButton.setTitle("Post a Task", forState: .Normal)
			if self.noActiveTasks == false{
			self.myTasksTableView.hidden = false
			}
			self.segmentControllerView.userInteractionEnabled = false
			
			UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				self.myTasksTableView.alpha = 1
				self.myTasksTableView.transform = CGAffineTransformMakeTranslation(0, 0)
				
				self.myApplicationsTableView.alpha = 0
				
				}, completion: { (complete: Bool) in
					self.myApplicationsTableView.transform = CGAffineTransformMakeTranslation(200, 0)
					self.myApplicationsTableView.hidden = true
					self.segmentControllerView.userInteractionEnabled = true
			})
		} else if index == 1 {
			self.emptyTableViewWarning.text = self.emptyApplicationsWarning
			self.goToButton.setTitle("Browse Tasks", forState: .Normal)
			if self.noActiveApplications == false{
			self.myApplicationsTableView.hidden = false
			}
			self.segmentControllerView.userInteractionEnabled = false
			
			UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				self.myApplicationsTableView.alpha = 1
				self.myApplicationsTableView.transform = CGAffineTransformMakeTranslation(0, 0)
				
				self.myTasksTableView.alpha = 0
				
				}, completion: { (complete: Bool) in
					self.myTasksTableView.transform = CGAffineTransformMakeTranslation(-200, 0)
					self.myTasksTableView.hidden = true
					self.segmentControllerView.userInteractionEnabled = true
			})
		}
	}
}
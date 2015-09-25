//
//  NelpCenterViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-06.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import Alamofire

class NelpCenterViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MyApplicationDetailsViewDelegate {
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var tabBarView: UIView!
	
	var profilePicture:UIImageView!
	var segmentControl:UISegmentedControl!
	var tasksContainer:UIView!
	var nelpTasks = [FindNelpTask]()
	var nelpApplications = [NelpTaskApplication]()
	var myTasksTableView: UITableView!
	var myApplicationsTableView:UITableView!
	var refreshView: UIRefreshControl!
	var refreshViewApplication: UIRefreshControl!
	var locationManager = CLLocationManager()
	var currentLocation: CLLocation?
	var myTasksSegmentButton:UIButton!
	var myApplicationsSegmentButton:UIButton!
	var myTasksBottomBorder:UIView!
	var myApplicationsBottomBorder:UIView!
	
	//MARK: Initialization

	convenience init() {
		self.init(nibName: "NelpCenterViewController", bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		createView()
		createMyTasksTableView()
		createMyApplicationsTableView()
		myTasksSegmentButton.selected = true
		adjustUI()
	}
	
	override func viewDidAppear(animated: Bool) {
		self.loadData()
	}
	
	//MARK: View Creation
	
	func createView(){
		
		//Location
		self.locationManager.delegate = self;
		
		if self.locationManager.location != nil {
			self.locationManager.delegate = self;
			let userLocation: CLLocation = self.locationManager.location!
			self.currentLocation = userLocation
		}
		
		
		//Segment Control Container + SegmentControl
		let segmentContainer = UIView()
		containerView.addSubview(segmentContainer)
		segmentContainer.backgroundColor = whiteGrayColor
		segmentContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.left.equalTo(containerView.snp_left)
			make.right.equalTo(containerView.snp_right)
			make.height.equalTo(50)
		}
		
		let firstHalf = UIView()
		segmentContainer.addSubview(firstHalf)
		firstHalf.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(segmentContainer.snp_width).dividedBy(2)
			make.left.equalTo(segmentContainer.snp_left)
			make.top.equalTo(segmentContainer.snp_top).offset(1)
			make.bottom.equalTo(segmentContainer.snp_bottom).offset(-1)
		}
		
		let myTasksSegmentButton = UIButton()
		self.myTasksSegmentButton = myTasksSegmentButton
		myTasksSegmentButton.addTarget(self, action: "myTasksSegmentButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		firstHalf.addSubview(myTasksSegmentButton)
		myTasksSegmentButton.setTitle("My Tasks", forState: UIControlState.Normal)
		myTasksSegmentButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle16)
		myTasksSegmentButton.setTitleColor(blackNelpyColor, forState: UIControlState.Normal)
		myTasksSegmentButton.setTitleColor(nelperRedColor, forState: UIControlState.Selected)
		myTasksSegmentButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(firstHalf.snp_centerX)
			make.top.equalTo(firstHalf.snp_top)
			make.width.equalTo(firstHalf.snp_width)
			make.bottom.equalTo(firstHalf.snp_bottom).offset(-2)
		}
		
		let myTasksBottomBorder = UIView()
		self.myTasksBottomBorder = myTasksBottomBorder
		myTasksBottomBorder.backgroundColor = nelperRedColor
		firstHalf.addSubview(myTasksBottomBorder)
		myTasksBottomBorder.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(firstHalf.snp_bottom)
			make.width.equalTo(firstHalf.snp_width).dividedBy(1.2)
			make.centerX.equalTo(firstHalf.snp_centerX)
			make.height.equalTo(3)
		}
		
		let secondHalf = UIView()
		segmentContainer.addSubview(secondHalf)
		secondHalf.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(segmentContainer.snp_width).dividedBy(2)
			make.right.equalTo(segmentContainer.snp_right)
			make.top.equalTo(segmentContainer.snp_top).offset(1)
			make.bottom.equalTo(segmentContainer.snp_bottom).offset(-1)
		}
		
		let myApplicationsSegmentButton = UIButton()
		self.myApplicationsSegmentButton = myApplicationsSegmentButton
		myApplicationsSegmentButton.addTarget(self, action: "myApplicationsSegmentButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		
		secondHalf.addSubview(myApplicationsSegmentButton)
		myApplicationsSegmentButton.setTitle("My Applications", forState: UIControlState.Normal)
		myApplicationsSegmentButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle16)
		myApplicationsSegmentButton.setTitleColor(blackNelpyColor, forState: UIControlState.Normal)
		myApplicationsSegmentButton.setTitleColor(nelperRedColor, forState: UIControlState.Selected)
		myApplicationsSegmentButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(secondHalf.snp_centerX)
			make.width.equalTo(secondHalf.snp_width)
			make.top.equalTo(secondHalf.snp_top)
			make.bottom.equalTo(secondHalf.snp_bottom).offset(-2)
		}
		
		let myApplicationsBottomBorder = UIView()
		self.myApplicationsBottomBorder = myApplicationsBottomBorder
		myApplicationsBottomBorder.backgroundColor = nelperRedColor
		secondHalf.addSubview(myApplicationsBottomBorder)
		myApplicationsBottomBorder.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(secondHalf.snp_bottom)
			make.width.equalTo(secondHalf.snp_width).dividedBy(1.2)
			make.centerX.equalTo(secondHalf.snp_centerX)
			make.height.equalTo(3)
		}
		
		myApplicationsBottomBorder.hidden = true
		
		//Tasks container
		let tasksContainer = UIView()
		containerView.addSubview(tasksContainer)
		self.tasksContainer = tasksContainer
		tasksContainer.backgroundColor = whiteNelpyColor
		tasksContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(segmentContainer.snp_bottom).offset(8)
			make.width.equalTo(containerView.snp_width)
			make.bottom.equalTo(self.tabBarView.snp_top)
		}
	}
	
	
	
	func createMyTasksTableView(){
		
		//My Tasks
		
		let tableView = UITableView()
		tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
		tableView.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
		
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.registerClass(NelpTasksTableViewCell.classForCoder(), forCellReuseIdentifier: NelpTasksTableViewCell.reuseIdentifier)
		tableView.backgroundColor = whiteNelpyColor
		
		let refreshView = UIRefreshControl()
		refreshView.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
		tableView.addSubview(refreshView)
		
		self.tasksContainer.addSubview(tableView);
		tableView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.tasksContainer.snp_edges)
		}
		self.myTasksTableView = tableView
		self.refreshView = refreshView
		self.myTasksTableView.separatorStyle = UITableViewCellSeparatorStyle.None
	}
	
	
	func createMyApplicationsTableView(){
		let tableViewApplications = UITableView()
		tableViewApplications.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
		tableViewApplications.delegate = self
		tableViewApplications.dataSource = self
		tableViewApplications.registerClass(NelpApplicationsTableViewCell.classForCoder(), forCellReuseIdentifier: NelpApplicationsTableViewCell.reuseIdentifier)
		tableViewApplications.backgroundColor = whiteNelpyColor
		tableViewApplications.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
		
		
		
		let refreshViewApplication = UIRefreshControl()
		refreshViewApplication.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
		tableViewApplications.addSubview(refreshViewApplication)
		
		self.tasksContainer.addSubview(tableViewApplications);
		tableViewApplications.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.tasksContainer.snp_edges)
		}
		self.myApplicationsTableView = tableViewApplications
		self.refreshViewApplication = refreshViewApplication
		self.myApplicationsTableView.hidden = true
		self.myApplicationsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
		ApiHelper.listMyNelpTasksWithBlock{ (nelpTasks: [FindNelpTask]?, error: NSError?) -> Void in
			if error != nil {
				print(error, terminator: "")
			} else {
				self.nelpTasks = nelpTasks!
				self.refreshView?.endRefreshing()
				self.myTasksTableView?.reloadData()
			}
		}
		
		ApiHelper.listMyNelpApplicationsWithBlock { (nelpApplications: [NelpTaskApplication]?, error: NSError?) -> Void in
			if error != nil {
				print(error, terminator: "")
			} else {
				self.nelpApplications = nelpApplications!
				self.refreshViewApplication?.endRefreshing()
				self.myApplicationsTableView?.reloadData()
			}
		}
	}
	
	
	//MARK: My Applications Details VC Delegate
	
	func didCancelApplication(application:NelpTaskApplication){
		self.myApplicationsTableView.reloadData()
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
				
				let nelpTask = self.nelpTasks[indexPath.item]
				cellTask.setNelpTask(nelpTask)
				cellTask.setImages(nelpTask)
				
				return cellTask
			}
		} else if (tableView == myApplicationsTableView) {
			if(!self.nelpApplications.isEmpty) {
				let cellApplication = NelpApplicationsTableViewCell()
				
				let nelpApplication = self.nelpApplications[indexPath.item]
				cellApplication.setNelpApplication(nelpApplication)
				cellApplication.setImages(nelpApplication)
				
				return cellApplication
			}
		}
		let cell: UITableViewCell = UITableViewCell()
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if(tableView == myTasksTableView) {
			let task = nelpTasks[indexPath.row]
			
			if task.state == .Accepted {
				let nextVC = MyTaskDetailsAcceptedViewController()
				nextVC.task = task
				dispatch_async(dispatch_get_main_queue()) {
					self.presentViewController(nextVC, animated: true, completion: nil)
				}
			}else{
			let nextVC = MyTaskDetailsViewController(findNelpTask: task)
			dispatch_async(dispatch_get_main_queue()) {
				self.presentViewController(nextVC, animated: true, completion: nil)
			}
			}
		} else if (tableView == myApplicationsTableView) {
			let application = nelpApplications[indexPath.row]
			
			if application.state == .Accepted{
				let nextVC = MyApplicationDetailsAcceptedViewController()
				nextVC.poster = application.task.user
				nextVC.application = application
				dispatch_async(dispatch_get_main_queue()) {
					self.presentViewController(nextVC, animated: true, completion: nil)
				}
				
			}else{
			let nextVC = MyApplicationDetailsView(poster: application.task.user, application: application)
			nextVC.delegate = self
			
			dispatch_async(dispatch_get_main_queue()) {
				self.presentViewController(nextVC, animated: true, completion: nil)
			}
			}
		}
		
	}
	
//	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//		if(tableView == myTasksTableView) {
//			if (editingStyle == UITableViewCellEditingStyle.Delete){
//				let nelpTask = nelpTasks[indexPath.row];
//				ApiHelper.deleteTask(nelpTask)
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
	
	//MARK: Actions
	
	/**
	User tapped Profile Button
	
	- parameter sender: Profile Button
	*/
	func profileButtonTapped(sender:UIButton) {
		let nextVC = FullProfileViewController()
		self.presentViewController(nextVC, animated: true, completion: nil)
	}
	
	func myTasksSegmentButtonTapped(sender:UIButton) {
		self.myTasksSegmentButton.selected = true
		self.myTasksBottomBorder.hidden = false
		self.myApplicationsSegmentButton.selected = false
		self.myApplicationsBottomBorder.hidden = true
		self.myApplicationsTableView.hidden = true
		self.myTasksTableView.hidden = false
	}
	
	func myApplicationsSegmentButtonTapped(sender:UIButton) {
		self.myTasksSegmentButton.selected = false
		self.myTasksBottomBorder.hidden = true
		self.myApplicationsSegmentButton.selected = true
		self.myApplicationsBottomBorder.hidden = false
		self.myTasksTableView.hidden = true
		self.myApplicationsTableView.hidden = false
	}
	

	
}
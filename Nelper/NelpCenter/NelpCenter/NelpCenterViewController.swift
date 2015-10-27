//
//  NelpCenterViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-06.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import Alamofire

class NelpCenterViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MyApplicationDetailsViewDelegate, SegmentControllerDelegate {
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var tabBarView: UIView!
	
	var segmentControllerView: SegmentController!
	
	var profilePicture:UIImageView!
	var tasksContainer:UIView!
	var nelpTasks = [FindNelpTask]()
	var nelpApplications = [TaskApplication]()
	var myTasksTableView: UITableView!
	var myApplicationsTableView:UITableView!
	var locationManager = CLLocationManager()
	var currentLocation: CLLocation?
	
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
		adjustUI()
	}
	
	override func viewDidAppear(animated: Bool) {
		self.loadData()
		let rootvc:TabBarCustom = UIApplication.sharedApplication().delegate!.window!?.rootViewController as! TabBarCustom
		rootvc.presentedVC = self

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
		tasksContainer.backgroundColor = whiteBackground
		tasksContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(segmentControllerView.snp_bottom)
			make.width.equalTo(self.view.snp_width)
			make.bottom.equalTo(self.tabBarView.snp_top)
		}
	}
	
	func createMyTasksTableView() {

		let tableView = UITableView()
		tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.registerClass(NelpTasksTableViewCell.classForCoder(), forCellReuseIdentifier: NelpTasksTableViewCell.reuseIdentifier)
		tableView.backgroundColor = whiteBackground
		
		self.tasksContainer.addSubview(tableView)
		tableView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.tasksContainer.snp_edges)
		}
		self.myTasksTableView = tableView
		self.myTasksTableView.separatorStyle = UITableViewCellSeparatorStyle.None
	}
	
	func createMyApplicationsTableView() {
		
		let tableViewApplications = UITableView()
		tableViewApplications.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
		tableViewApplications.delegate = self
		tableViewApplications.dataSource = self
		tableViewApplications.registerClass(NelpApplicationsTableViewCell.classForCoder(), forCellReuseIdentifier: NelpApplicationsTableViewCell.reuseIdentifier)
		tableViewApplications.backgroundColor = whiteBackground
		tableViewApplications.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

		self.tasksContainer.addSubview(tableViewApplications)
		tableViewApplications.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.tasksContainer.snp_edges)
		}
		
		self.myApplicationsTableView = tableViewApplications
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
		ApiHelper.listMyNelpTasksWithBlock { (nelpTasks: [FindNelpTask]?, error: NSError?) -> Void in
			if error != nil {
				print(error, terminator: "")
			} else {
				self.nelpTasks = nelpTasks!
				self.myTasksTableView?.reloadData()
			}
		}
		
		ApiHelper.listMyNelpApplicationsWithBlock { (nelpApplications: [TaskApplication]?, error: NSError?) -> Void in
			if error != nil {
				print(error, terminator: "")
			} else {
				self.nelpApplications = nelpApplications!
				self.myApplicationsTableView?.reloadData()
			}
		}
	}
	
	
	//MARK: My Applications Details VC Delegate
	
	func didCancelApplication(application:TaskApplication){
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
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if(tableView == myTasksTableView) {
			let task = nelpTasks[indexPath.row]
			
			if task.state == .Accepted {
				let nextVC = MyTaskDetailsAcceptedViewController()
				nextVC.task = task
				nextVC.hidesBottomBarWhenPushed = true
				dispatch_async(dispatch_get_main_queue()) {
					self.navigationController?.pushViewController(nextVC, animated: true)
				}
			} else {
			let nextVC = MyTaskDetailsViewController(findNelpTask: task)
			nextVC.hidesBottomBarWhenPushed = true
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
				nextVC.hidesBottomBarWhenPushed = true
				dispatch_async(dispatch_get_main_queue()) {
					self.navigationController?.pushViewController(nextVC, animated: true)
				}
				
			} else {
			let nextVC = MyApplicationDetailsView(poster: application.task.user, application: application)
			nextVC.delegate = self
				nextVC.hidesBottomBarWhenPushed = true
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
			self.myApplicationsTableView.hidden = true
			self.myTasksTableView.hidden = false
		} else if index == 1 {
			self.myApplicationsTableView.hidden = false
			self.myTasksTableView.hidden = true
		}
	}
}
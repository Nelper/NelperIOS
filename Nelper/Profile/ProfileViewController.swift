//
//  ProfileViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-06.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
	
	@IBOutlet weak var navBar: UIView!
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
	
	//	INITIALIZER
	convenience init() {
		self.init(nibName: "ProfileViewController", bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		createView()
		createMyTasksTableView()
		self.segmentControl.selectedSegmentIndex = 0
		getFacebookInfos()
		adjustUI()
	}
	
	override func viewDidAppear(animated: Bool) {
		loadData()
	}
	
	//View Creation
	
	func createView(){
		
		//Location
		self.locationManager.delegate = self;
		
		if self.locationManager.location != nil {
			self.locationManager.delegate = self;
			var userLocation: CLLocation = self.locationManager.location
			self.currentLocation = userLocation
		}
		
		//Profile Header
		var profileView = UIView()
		self.containerView.addSubview(profileView)
		profileView.backgroundColor = blueGrayColor
		
		profileView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.containerView.snp_left)
			make.right.equalTo(self.containerView.snp_right)
			make.height.equalTo(self.containerView).dividedBy(4.5)
		}
		
		//Profile Picture
		var profilePicture = UIImageView()
		profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
		self.profilePicture = profilePicture
		self.profilePicture.clipsToBounds = true
		profileView.addSubview(profilePicture)
		
		var profilePictureSize: CGFloat = 84
		
		profilePicture.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(profileView.snp_left).offset(15)
			make.centerY.equalTo(profileView.snp_centerY)
			make.height.equalTo(profilePictureSize)
			make.width.equalTo(profilePictureSize)
		}
		
		self.profilePicture.layer.cornerRadius = 84 / 2
		self.profilePicture.layer.borderColor = grayDetails.CGColor
		self.profilePicture.layer.borderWidth = 2
		
		//Name
		var name = UILabel()
		profileView.addSubview(name)
		name.numberOfLines = 0
		name.textColor = whiteNelpyColor
		name.text = PFUser.currentUser()?.objectForKey("name") as? String
		name.font = UIFont(name: "ABeeZee-Regular", size: kSubtitleFontSize)
		
		name.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(profilePicture.snp_right).offset(15)
			make.top.equalTo(profilePicture.snp_top).offset(6)
		}
		
		//Profile Icon
		var profileIcon = UIImageView()
		profileView.addSubview(profileIcon)
		profileIcon.contentMode = UIViewContentMode.ScaleAspectFit
		
		profileIcon.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(30)
			make.height.equalTo(30)
			make.left.equalTo(name.snp_left)
			make.top.equalTo(name.snp_bottom).offset(13)
		}
		profileIcon.image = UIImage(named:"profile_white.png")
		
		//Profile Button
		var profileButton = UIButton()
		profileView.addSubview(profileButton)
		profileButton.addTarget(self, action: "profileButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		profileButton.setTitle("MY PROFILE", forState: UIControlState.Normal)
		profileButton.titleLabel?.font = UIFont(name: "ABeeZee-Regular", size: kProfileButtonSize)
		profileButton.titleLabel?.textColor = whiteNelpyColor
		profileButton.backgroundColor = blueGrayColor
		profileButton.layer.borderWidth = 2
		profileButton.layer.borderColor = whiteNelpyColor.CGColor
		profileButton.layer.cornerRadius = 3
		
		profileButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(profileIcon.snp_centerY)
			make.left.equalTo(profileIcon.snp_right).offset(10)
			make.height.equalTo(30)
			make.width.equalTo(130)
		}
		
		//Logout Button
		var logoutButton = UIButton()
		profileView.addSubview(logoutButton)
		logoutButton.setTitle("Logout", forState: UIControlState.Normal)
		logoutButton.titleLabel?.font = UIFont(name: "ABeeZee-Regular", size: kLogoutButtonSize)
		logoutButton.titleLabel?.textColor = whiteNelpyColor
		logoutButton.backgroundColor = blueGrayColor
		
		logoutButton.addTarget(self, action: "logoutButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		
		logoutButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileView.snp_top)
			make.right.equalTo(profileView.snp_right)
			make.height.equalTo(20)
			make.width.equalTo(50)
		}
		
		//Segment Control Container + SegmentControl
		var segmentContainer = UIView()
		containerView.addSubview(segmentContainer)
		segmentContainer.backgroundColor = whiteNelpyColor
		segmentContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileView.snp_bottom)
			make.left.equalTo(containerView.snp_left)
			make.right.equalTo(containerView.snp_right)
			make.height.equalTo(profileView.snp_height).dividedBy(2.75)
		}
		
		var segmentControl = UISegmentedControl()
		self.segmentControl = segmentControl
		self.segmentControl.addTarget(self, action: "segmentTouched:", forControlEvents: UIControlEvents.ValueChanged)
		segmentContainer.addSubview(segmentControl)
		segmentControl.insertSegmentWithTitle("My Tasks", atIndex: 0, animated: false)
		segmentControl.insertSegmentWithTitle("My Applications", atIndex: 1, animated: false)
		segmentControl.tintColor = orangeTextColor
		segmentControl.snp_makeConstraints { (make) -> Void in
			make.center.equalTo(segmentContainer.snp_center)
			make.width.equalTo(segmentContainer.snp_width).offset(-20)
		}
		
		//Tasks container
		var tasksContainer = UIView()
		containerView.addSubview(tasksContainer)
		self.tasksContainer = tasksContainer
		tasksContainer.backgroundColor = whiteNelpyColor
		tasksContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(segmentContainer.snp_bottom)
			make.width.equalTo(containerView.snp_width)
			make.bottom.equalTo(self.tabBarView.snp_top)
		}
	}
	
	
	func createMyTasksTableView(){
		
		//My Tasks
		
		let tableView = UITableView()
		tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
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
		
		//My Applications
		
		let tableViewApplications = UITableView()
		tableViewApplications.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
		tableViewApplications.delegate = self
		tableViewApplications.dataSource = self
		tableViewApplications.registerClass(NelpApplicationsTableViewCell.classForCoder(), forCellReuseIdentifier: NelpApplicationsTableViewCell.reuseIdentifier)
		tableViewApplications.backgroundColor = whiteNelpyColor
		
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
	
	//	UI
	
	func adjustUI() {
		self.tabBarView.backgroundColor = tabBarColor
	}
	
	//	DATA
	
	func getFacebookInfos() {
		
		var fbProfilePicture = (PFUser.currentUser()!.objectForKey("pictureURL") as? String)!
		request(.GET,fbProfilePicture).response(){
			(_, _, data, _) in
			var image = UIImage(data: data as NSData!)
			self.profilePicture.image = image
		}
	}
	
	func checkForEmptyTasks() {
		if(nelpTasks.isEmpty) {
			if(self.myTasksTableView != nil) {
				self.myTasksTableView.removeFromSuperview()
			}
		}
	}
	
	
	func onPullToRefresh() {
		loadData()
	}
	
	
	func loadData() {
		ApiHelper.listMyNelpTasksWithBlock{ (nelpTasks: [FindNelpTask]?, error: NSError?) -> Void in
			if error != nil {
				
			} else {
				self.nelpTasks = nelpTasks!
				self.refreshView?.endRefreshing()
				self.myTasksTableView?.reloadData()
				self.checkForEmptyTasks()
			}
		}
		
		ApiHelper.listMyNelpApplicationsWithBlock { (nelpApplications: [NelpTaskApplication]?, error: NSError?) -> Void in
			if error != nil{
				
			} else {
				self.nelpApplications = nelpApplications!
				println(nelpApplications)
				self.refreshViewApplication?.endRefreshing()
				self.myApplicationsTableView?.reloadData()
			}
		}
	}
	
	//DELEGATE METHODS
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if(tableView == self.myTasksTableView){
			return nelpTasks.count
		}else if (tableView == self.myApplicationsTableView){
			return nelpApplications.count
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if(tableView == myTasksTableView) {
			if (!self.nelpTasks.isEmpty) {
				let cellTask = tableView.dequeueReusableCellWithIdentifier(NelpTasksTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! NelpTasksTableViewCell
				
				
				let nelpTask = self.nelpTasks[indexPath.item]
				
				cellTask.setNelpTask(nelpTask)
				cellTask.setImages(nelpTask)
				
				return cellTask
			}
		}else if (tableView == myApplicationsTableView) {
			if(!self.nelpApplications.isEmpty) {
				let cellApplication = tableView.dequeueReusableCellWithIdentifier(NelpApplicationsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! NelpApplicationsTableViewCell
				
				let nelpApplication = self.nelpApplications[indexPath.item]
				if self.currentLocation != nil{
					cellApplication.setLocation(self.currentLocation!, nelpApplication: nelpApplication)
				}
				cellApplication.setNelpApplication(nelpApplication)
				cellApplication.setImages(nelpApplication)
				
				return cellApplication
			}
		}
		var cell: UITableViewCell!
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if(tableView == myTasksTableView) {
			if (editingStyle == UITableViewCellEditingStyle.Delete){
				var nelpTask = nelpTasks[indexPath.row];
				ApiHelper.deleteTask(nelpTask)
				self.nelpTasks.removeAtIndex(indexPath.row)
				self.myTasksTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
				self.checkForEmptyTasks()
			}
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if (tableView == myTasksTableView){
			return 230
		}else if (tableView == myApplicationsTableView) {
			return 295
		}
		return 0
	}
	
	//ACTIONS
	
	func profileButtonTapped(sender:UIButton){
		var nextVC = FullProfileViewController()
		self.presentViewController(nextVC, animated: true, completion: nil)
	}
	
	func segmentTouched(sender:UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			self.myApplicationsTableView.hidden = true
			self.myTasksTableView.hidden = false
		}else if sender.selectedSegmentIndex == 1 {
			self.myTasksTableView.hidden = true
			self.myApplicationsTableView.hidden = false
			
		}
		
	}
	
	func logoutButtonTapped(sender: AnyObject) {
		ApiHelper.logout()
		
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		appDelegate.showLogin(true)
	}
	
	@IBAction func nelpTabBarButtonTapped(sender: AnyObject) {
		var nextVC = NelpViewController()
		self.presentViewController(nextVC, animated: false, completion: nil)
	}
	
	@IBAction func findNelpTabBarButtonTapped(sender: AnyObject) {
		var nextVC = NelpTasksListViewController()
		self.presentViewController(nextVC, animated: false, completion: nil)
	}
	
}
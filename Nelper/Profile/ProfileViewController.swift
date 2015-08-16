//
//  ProfileViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-06.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var navBar: UIView!
	@IBOutlet weak var tabBarView: UIView!
	@IBOutlet weak var nelpTabBarImage: UIButton!
	@IBOutlet weak var findNelpTabBarImage: UIButton!
	@IBOutlet weak var profileTabBarImage: UIButton!
	@IBOutlet weak var containerView: UIView!
	
	var profilePicture:UIImageView!
	var segmentControl:UISegmentedControl!
	var tasksContainer:UIView!
	var nelpTasks = [FindNelpTask]()
	var myTasksTableView: UITableView!
	var myApplicationsTableView:UITableView!
	var refreshView: UIRefreshControl!
	var refreshViewApplication: UIRefreshControl!
	
//	INITIALIZER
  convenience init() {
    self.init(nibName: "ProfileViewController", bundle: nil)
	}
  
  override func viewDidLoad() {
    super.viewDidLoad()
		createView()
		createMyTasksTableView()
		self.segmentControl.selectedSegmentIndex = 0
		getFacebookInfos()
		loadData()
		adjustUI()
	}
	
//View Creation
	
	func createView(){
		
		//Profile Header
		var profileView = UIView()
		self.containerView.addSubview(profileView)
		profileView.backgroundColor = blueGrayColor
		profileView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.containerView.snp_left)
			make.right.equalTo(self.containerView.snp_right)
			make.height.equalTo(self.containerView).dividedBy(3)
		}
		
		//Profile Picture
		var profilePicture = UIImageView()
		profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
		self.profilePicture = profilePicture
		self.profilePicture.clipsToBounds = true
		profileView.addSubview(profilePicture)
		profilePicture.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(profileView.snp_left).offset(10)
			make.centerY.equalTo(profileView.snp_centerY)
			make.height.equalTo(100)
			make.width.equalTo(100)
		}
		self.profilePicture.layer.cornerRadius = 100 / 2;
		self.profilePicture.layer.borderColor = whiteNelpyColor.CGColor
		self.profilePicture.layer.borderWidth = 2
		
		//Name
		var name = UILabel()
		profileView.addSubview(name)
		name.numberOfLines = 0
		name.textColor = whiteNelpyColor
		name.text = PFUser.currentUser()?.objectForKey("name") as? String
		name.font = UIFont(name: "ABeeZee-Regular", size: kSubtitleFontSize)
		name.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(profilePicture.snp_right).offset(4)
			make.top.equalTo(profilePicture.snp_top)
		}
		//Profile Icon
		var profileIcon = UIImageView()
		profileView.addSubview(profileIcon)
		profileIcon.contentMode = UIViewContentMode.ScaleAspectFit
		profileIcon.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(30)
			make.height.equalTo(30)
			make.left.equalTo(profilePicture.snp_right).offset(10)
			make.top.equalTo(name.snp_bottom).offset(16)
		}
		profileIcon.image = UIImage(named:"profile_white.png")
		//Profile Button
		var profileButton = UIButton()
		profileView.addSubview(profileButton)
		profileButton.setTitle("MY PROFILE", forState: UIControlState.Normal)
		profileButton.titleLabel?.font = UIFont(name: "ABeeZee-Regular", size: kProfileButtonSize)
		profileButton.titleLabel?.textColor = whiteNelpyColor
		profileButton.backgroundColor = blueGrayColor
		profileButton.layer.borderWidth = 2
		profileButton.layer.borderColor = whiteNelpyColor.CGColor
		profileButton.layer.cornerRadius = 6
		
		profileButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(profileIcon.snp_centerY)
			make.left.equalTo(profileIcon.snp_right).offset(4)
			make.height.equalTo(35)
			make.width.equalTo(135)
		}
		
		//Segment Control Container + SegmentControl
		var segmentContainer = UIView()
		containerView.addSubview(segmentContainer)
		segmentContainer.backgroundColor = whiteNelpyColor
		segmentContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileView.snp_bottom)
			make.left.equalTo(containerView.snp_left)
			make.right.equalTo(containerView.snp_right)
			make.height.equalTo(profileView.snp_height).dividedBy(4)
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
		
		//My Applications
		
		let tableViewApplications = UITableView()
		tableViewApplications.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
		tableViewApplications.delegate = self
		tableViewApplications.dataSource = self
		tableViewApplications.registerClass(NelpTasksTableViewCell.classForCoder(), forCellReuseIdentifier: NelpTasksTableViewCell.reuseIdentifier)
		tableViewApplications.backgroundColor = whiteNelpyColor
		
		let refreshViewApplication = UIRefreshControl()
		refreshViewApplication.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
		tableViewApplications.addSubview(refreshViewApplication)
		
		self.tasksContainer.addSubview(tableViewApplications);
		tableView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.tasksContainer.snp_edges)
		}
		self.myApplicationsTableView = tableViewApplications
		self.refreshViewApplication = refreshViewApplication
		self.myApplicationsTableView.hidden = true
		
	}
	
	//	UI
	
	func adjustUI(){
		self.profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2;
		self.tabBarView.backgroundColor = tabBarColor
		self.nelpTabBarImage.setBackgroundImage(UIImage(named: "help_dark.png"), forState: UIControlState.Normal)
		self.findNelpTabBarImage.setBackgroundImage(UIImage(named: "search_dark.png"), forState: UIControlState.Normal)
		self.profileTabBarImage.setBackgroundImage(UIImage(named: "profile_orange.png"), forState: UIControlState.Normal)
	}

//	DATA
	func getFacebookInfos(){
		
		var fbProfilePicture = (PFUser.currentUser()!.objectForKey("pictureURL") as? String)!
		request(.GET,fbProfilePicture).response(){
				(_, _, data, _) in
				var image = UIImage(data: data as NSData!)
				self.profilePicture.image = image
				self.profilePicture.layer.cornerRadius = 100 / 2;
				}
}

func checkForEmptyTasks(){
	if(nelpTasks.isEmpty){
		if(self.myTasksTableView != nil){
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
}
	
	//DELEGATE METHODS
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return nelpTasks.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier(NelpTasksTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! NelpTasksTableViewCell
		
		let nelpTask = self.nelpTasks[indexPath.item]
		
		cell.setNelpTask(nelpTask)
		cell.setImages(nelpTask)
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if (editingStyle == UITableViewCellEditingStyle.Delete){
			var nelpTask = nelpTasks[indexPath.row];
			ApiHelper.deleteTask(nelpTask)
			self.nelpTasks.removeAtIndex(indexPath.row)
			self.myTasksTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
			self.checkForEmptyTasks()
			
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 260
	}
	
	//ACTIONS
	
	func segmentTouched(sender:UISegmentedControl){
		if sender.selectedSegmentIndex == 0 {
			self.myApplicationsTableView.hidden = true
			self.myTasksTableView.hidden = false
		}else if sender.selectedSegmentIndex == 1{
			self.myTasksTableView.hidden = true
			self.myApplicationsTableView.hidden = false
			
		}
		
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
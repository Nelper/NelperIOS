//
//  FullProfileViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-17.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire
import SnapKit

class FullProfileViewController: UIViewController{
	
	@IBOutlet weak var navBar: UIView!
	@IBOutlet weak var containerView: UIView!
	
	
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
		getFacebookInfos()

	}
	
	override func viewDidAppear(animated: Bool) {
		loadData()
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
	
	func loadData() {
		
	}
	
}

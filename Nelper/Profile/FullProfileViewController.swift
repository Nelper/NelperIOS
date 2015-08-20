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

class FullProfileViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource{
	
	@IBOutlet weak var navBar: UIView!
	@IBOutlet weak var backGroundView: UIView!
	@IBOutlet weak var contentView: UIView!


	
	var profilePicture:UIImageView!
	var aboutTextView: UITextView!
	var skillsTableView:UITableView!
	var arrayOfSkills = [String]()
	var newSkillToAdd:String!
	var skillsLabel:UILabel!
	
	//	INITIALIZER
	convenience init() {
		self.init(nibName: "FullProfileViewController", bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		createView()
		setInformations()
		getFacebookInfos()

	}
	
	override func viewDidAppear(animated: Bool) {
		loadData()
	}
	
	//View Creation
	
	func createView(){
		
		self.contentView.backgroundColor = whiteNelpyColor
		self.backGroundView.backgroundColor = whiteNelpyColor
		
		//Profile Header
		var profileView = UIView()
		self.contentView.addSubview(profileView)
		profileView.backgroundColor = blueGrayColor
		
		profileView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo(self.contentView).dividedBy(6)
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
		name.textColor = navBarColor
		name.text = PFUser.currentUser()?.objectForKey("name") as? String
		name.font = UIFont(name: "ABeeZee-Regular", size: kSubtitleFontSize)
		
		name.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(profilePicture.snp_right).offset(15)
			make.top.equalTo(profilePicture.snp_top).offset(6)
		}
		//FeedBack Stars
		
		var firstStar = UIImageView()
		profileView.addSubview(firstStar)
		firstStar.contentMode = UIViewContentMode.ScaleAspectFill
		firstStar.image = UIImage(named: "empty_star")
		firstStar.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(name.snp_left)
			make.top.equalTo(name.snp_bottom).offset(8)
			make.height.equalTo(20)
			make.width.equalTo(20)
		}
		
		var secondStar = UIImageView()
		profileView.addSubview(secondStar)
		secondStar.contentMode = UIViewContentMode.ScaleAspectFill
		secondStar.image = UIImage(named: "empty_star")
		secondStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(firstStar.snp_bottom)
			make.left.equalTo(firstStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		var thirdStar = UIImageView()
		profileView.addSubview(thirdStar)
		thirdStar.contentMode = UIViewContentMode.ScaleAspectFill
		thirdStar.image = UIImage(named: "empty_star")
		thirdStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(secondStar.snp_bottom)
			make.left.equalTo(secondStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		var fourthStar = UIImageView()
		profileView.addSubview(fourthStar)
		fourthStar.contentMode = UIViewContentMode.ScaleAspectFill
		fourthStar.image = UIImage(named: "empty_star")
		fourthStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(thirdStar.snp_bottom)
			make.left.equalTo(thirdStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		var fifthStar = UIImageView()
		profileView.addSubview(fifthStar)
		fifthStar.contentMode = UIViewContentMode.ScaleAspectFill
		fifthStar.image = UIImage(named: "empty_star")
		fifthStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(fourthStar.snp_bottom)
			make.left.equalTo(fourthStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		//Number of tasks completed
		
		var numberOfTasksLabel = UILabel()
		profileView.addSubview(numberOfTasksLabel)
		numberOfTasksLabel.textColor = navBarColor
		numberOfTasksLabel.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		numberOfTasksLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(name.snp_left)
			make.top.equalTo(firstStar.snp_bottom).offset(4)
		}
		
		//About
		
		var aboutLabel = UILabel()
		self.contentView.addSubview(aboutLabel)
		aboutLabel.textColor = blackNelpyColor
		aboutLabel.text = "About"
		aboutLabel.font = UIFont(name: "ABeeZee-Regular", size: kSubtitleFontSize)
		aboutLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(profilePicture.snp_left)
			make.top.equalTo(profileView.snp_bottom).offset(20)
		}
		
		var aboutTextView = UITextView()
		self.contentView.addSubview(aboutTextView)
		self.aboutTextView = aboutTextView
		aboutTextView.backgroundColor = whiteNelpyColor
		aboutTextView.textColor = UIColor.yellowColor()
		aboutTextView.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		aboutTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(aboutLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutLabel.snp_left).offset(4)
			make.width.equalTo(contentView.snp_width).dividedBy(1.2)
			make.height.equalTo(contentView.snp_height).dividedBy(10)
		}
		
		var editAboutIcon = UIButton()
		self.contentView.addSubview(editAboutIcon)
		editAboutIcon.setBackgroundImage(UIImage(named: "pen.png"), forState: UIControlState.Normal)
		editAboutIcon.addTarget(self, action: "editAbout:", forControlEvents: UIControlEvents.TouchUpInside)
		editAboutIcon.contentMode = UIViewContentMode.ScaleAspectFill
		editAboutIcon.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(aboutTextView.snp_right)
			make.top.equalTo(aboutTextView.snp_top)
			make.width.equalTo(30)
			make.height.equalTo(30)
		}
		
		//My skills
		
		var skillsLabel = UILabel()
		self.skillsLabel = skillsLabel
		self.contentView.addSubview(skillsLabel)
		skillsLabel.textColor = blackNelpyColor
		skillsLabel.text = "Skills"
		skillsLabel.font = UIFont(name: "ABeeZee-Regular", size: kSubtitleFontSize)
		skillsLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(aboutTextView.snp_bottom).offset(10)
			make.left.equalTo(aboutLabel)
		}
		
		var skillsTableView = UITableView()
		skillsTableView.scrollEnabled = false
		self.skillsTableView = skillsTableView
		self.contentView.addSubview(skillsTableView)
		skillsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		skillsTableView.delegate = self
		skillsTableView.dataSource = self
		skillsTableView.registerClass(skillsTableViewCell.classForCoder(), forCellReuseIdentifier: skillsTableViewCell.reuseIdentifier)
		skillsTableView.backgroundColor = whiteNelpyColor
		skillsTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(skillsLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutTextView.snp_left)
			make.right.equalTo(contentView.snp_right).offset(-19)
			make.height.equalTo(60)
		}
		
		var addSkillButton = UIButton()
		self.contentView.addSubview(addSkillButton)
		addSkillButton.addTarget(self, action: "addSkillButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		addSkillButton.setTitle("Add new skill", forState: UIControlState.Normal)
		addSkillButton.setTitleColor(orangeTextColor, forState: UIControlState.Normal)
		addSkillButton.titleLabel?.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		addSkillButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(skillsTableView.snp_bottom).offset(4).priorityLow()
			make.left.equalTo(skillsTableView.snp_left)
		}
		
	}
	
	//TableView Delegate Method
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if(tableView == skillsTableView){
			println("\(self.arrayOfSkills.count)")
			skillsTableView.snp_remakeConstraints { (make) -> Void in
				make.top.equalTo(skillsLabel.snp_bottom).offset(6)
				make.left.equalTo(aboutTextView.snp_left)
				make.right.equalTo(contentView.snp_right).offset(-19)
				make.height.equalTo(60).multipliedBy(self.arrayOfSkills.count).priorityHigh()
			}
			return arrayOfSkills.count
			
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if(tableView == skillsTableView) {
			if (!self.arrayOfSkills.isEmpty) {
				let skillCell = tableView.dequeueReusableCellWithIdentifier(skillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! skillsTableViewCell
				
				let skill = self.arrayOfSkills[indexPath.item]
				
				skillCell.sendSkillName(skill)
				
				return skillCell
			}
		}
		
		var cell: UITableViewCell!
		return cell

	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 60
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
		//get user skills etc...
		
		var testSkill = "English"
		var testArrayOfSkills = [testSkill]
		self.arrayOfSkills = testArrayOfSkills
		
	}
	
	func setInformations() {
		
		
	}
	
	//Actions
	
	func editAbout(sender:UIButton){
		
	}
	
	func addSkillButtonTapped(sender:UIButton){
		var popup = UIAlertController(title: "Add a Skill", message: "", preferredStyle: UIAlertControllerStyle.Alert)
		popup.addTextFieldWithConfigurationHandler { (textField) -> Void in
			self.newSkillToAdd = textField.text!
			}
		popup.addAction(UIAlertAction(title: "Add", style: .Default , handler: { (action) -> Void in
			self.arrayOfSkills.append(self.newSkillToAdd)
			self.refreshTableView()
		}))
		popup.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
			self.dismissViewControllerAnimated(true, completion: nil)
		}))
		
		presentViewController(popup, animated: true, completion: nil)
		
	}
	
	func refreshTableView(){
		self.skillsTableView.reloadData()
	}
	
}

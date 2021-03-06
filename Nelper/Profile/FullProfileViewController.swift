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

class FullProfileViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, SkillsTableViewCellDelegate{
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var backGroundView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!

	var profilePicture:UIImageView!
	var aboutTextView: UITextView!
	var skillsTableView:UITableView!
	var arrayOfSkills = [Dictionary<String,String>]()
	var skillsLabel:UILabel!
	var educationLabel:UILabel!
	var arrayOfEducation = [Dictionary<String,String>]()
	var educationTableView:UITableView!
	var contentView: UIView!
	var experienceLabel:UILabel!
	var experienceTableView:UITableView!
	var arrayOfExperience = [Dictionary<String,String>]()
	var tap: UITapGestureRecognizer?
	var firstStar:UIImageView!
	var secondStar:UIImageView!
	var thirdStar:UIImageView!
	var fourthStar:UIImageView!
	var fifthStar:UIImageView!
	var whiteContainer:UIView!

	let kCellHeight = 60
	
	//MARK: Initialization
	
	convenience init() {
		self.init(nibName: "FullProfileViewController", bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.automaticallyAdjustsScrollViewInsets = false
		createView()
		loadData()
		refreshTableView()
		setProfilePicture()
		
		// looks for tap (keyboard dismiss)
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		self.tap = tap
		contentView.addGestureRecognizer(tap)
	}
	
	override func viewDidAppear(animated: Bool) {
	}
	
	//MARK: View Creation
	func createView(){
		
		//navbar
		self.navBar.setTitle("My Profile")
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = previousBtn
		
		//Profile Header
		let profileView = UIView()
		self.view.addSubview(profileView)
		profileView.backgroundColor = Color.redPrimary
		
		profileView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.height.equalTo(125)
		}
		
		//Profile Picture
		let profilePicture = UIImageView()
		profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
		self.profilePicture = profilePicture
		self.profilePicture.clipsToBounds = true
		profileView.addSubview(profilePicture)
		
		let profilePictureSize: CGFloat = 84
		
		profilePicture.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(profileView.snp_left).offset(15)
			make.centerY.equalTo(profileView.snp_centerY)
			make.height.equalTo(profilePictureSize)
			make.width.equalTo(profilePictureSize)
		}
		
		self.profilePicture.layer.cornerRadius = 84 / 2
		self.profilePicture.layer.borderColor = Color.darkGrayDetails.CGColor
		self.profilePicture.layer.borderWidth = 2
		
		//Name
		let name = UILabel()
		profileView.addSubview(name)
		name.numberOfLines = 0
		name.textColor = Color.whiteBackground
		name.text = PFUser.currentUser()?.objectForKey("name") as? String
		name.font = UIFont(name: "Lato-Regular", size: kText15)
		
		name.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(profilePicture.snp_right).offset(15)
			make.top.equalTo(profilePicture.snp_top)
		}
		//FeedBack Stars
		
		let firstStar = UIImageView()
		self.firstStar = firstStar
		profileView.addSubview(firstStar)
		firstStar.contentMode = UIViewContentMode.ScaleAspectFill
		firstStar.image = UIImage(named: "empty_star_white")
		firstStar.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(name.snp_left)
			make.top.equalTo(name.snp_bottom).offset(8)
			make.height.equalTo(20)
			make.width.equalTo(20)
		}
		
		let secondStar = UIImageView()
		self.secondStar = secondStar
		profileView.addSubview(secondStar)
		secondStar.contentMode = UIViewContentMode.ScaleAspectFill
		secondStar.image = UIImage(named: "empty_star_white")
		secondStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(firstStar.snp_bottom)
			make.left.equalTo(firstStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		let thirdStar = UIImageView()
		self.thirdStar = thirdStar
		profileView.addSubview(thirdStar)
		thirdStar.contentMode = UIViewContentMode.ScaleAspectFill
		thirdStar.image = UIImage(named: "empty_star_white")
		thirdStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(secondStar.snp_bottom)
			make.left.equalTo(secondStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		let fourthStar = UIImageView()
		self.fourthStar = fourthStar
		profileView.addSubview(fourthStar)
		fourthStar.contentMode = UIViewContentMode.ScaleAspectFill
		fourthStar.image = UIImage(named: "empty_star_white")
		fourthStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(thirdStar.snp_bottom)
			make.left.equalTo(thirdStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		let fifthStar = UIImageView()
		self.fifthStar = fifthStar
		profileView.addSubview(fifthStar)
		fifthStar.contentMode = UIViewContentMode.ScaleAspectFill
		fifthStar.image = UIImage(named: "empty_star_white")
		fifthStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(fourthStar.snp_bottom)
			make.left.equalTo(fourthStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		//Number of tasks completed
		
		let numberOfTasksLabel = UILabel()
		profileView.addSubview(numberOfTasksLabel)
		numberOfTasksLabel.text = "12 tasks completed"
		numberOfTasksLabel.textColor = Color.whiteBackground
		numberOfTasksLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		numberOfTasksLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(name.snp_left)
			make.top.equalTo(firstStar.snp_bottom).offset(8)
			make.right.equalTo(self.view.snp_right).offset(-4)
		}

		
		self.scrollView.backgroundColor = Color.whiteBackground

		
        let contentView = UIView()
        self.contentView = contentView
        self.scrollView.addSubview(contentView)
        contentView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.scrollView.snp_top)
            make.left.equalTo(self.scrollView.snp_left)
            make.right.equalTo(self.scrollView.snp_right)
            make.height.greaterThanOrEqualTo(self.backGroundView.snp_height)
            make.width.equalTo(self.backGroundView.snp_width)
        }
		
		self.contentView.backgroundColor = Color.whiteBackground
		self.backGroundView.backgroundColor = Color.whiteBackground
		
		
		
		//White Container
		
		let whiteContainer = UIView()
		self.contentView.addSubview(whiteContainer)
		self.whiteContainer = whiteContainer
		whiteContainer.layer.borderColor = Color.darkGrayDetails.CGColor
		whiteContainer.layer.borderWidth = 1
		whiteContainer.backgroundColor = Color.whitePrimary
		whiteContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(10)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
			make.bottom.equalTo(contentView.snp_bottom).offset(-10)
		}
		
		
		//About
		
		let aboutLabel = UILabel()
		self.whiteContainer.addSubview(aboutLabel)
		aboutLabel.textColor = Color.blackPrimary
		aboutLabel.text = "About me"
		aboutLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		aboutLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(profilePicture.snp_left)
			make.top.equalTo(whiteContainer.snp_top).offset(10)
		}
		
		let aboutTextView = UITextView()
		self.whiteContainer.addSubview(aboutTextView)
		self.aboutTextView = aboutTextView
		aboutTextView.scrollEnabled = false
		aboutTextView.textColor = Color.blackPrimary
		aboutTextView.backgroundColor = Color.whitePrimary
		aboutTextView.editable = false
		aboutTextView.font = UIFont(name: "Lato-Regular", size: kText15)
		aboutTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(aboutLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutLabel.snp_left).offset(4)
			make.width.equalTo(contentView.snp_width).dividedBy(1.2)
		}
		
		let fixedWidth = aboutTextView.frame.size.width
		aboutTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		let newSize = aboutTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		var newFrame = aboutTextView.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		aboutTextView.frame = newFrame;
		
		let editAboutIcon = UIButton()
		self.whiteContainer.addSubview(editAboutIcon)
		editAboutIcon.setBackgroundImage(UIImage(named: "pen.png"), forState: UIControlState.Normal)
		editAboutIcon.addTarget(self, action: "editAbout:", forControlEvents: UIControlEvents.TouchUpInside)
		editAboutIcon.contentMode = UIViewContentMode.ScaleAspectFill
		editAboutIcon.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.contentView.snp_right).offset(-19)
			make.top.equalTo(aboutTextView.snp_top)
			make.width.equalTo(23)
			make.height.equalTo(23)
		}
		
		//My skills
		
		let skillsLabel = UILabel()
		self.skillsLabel = skillsLabel
		self.whiteContainer.addSubview(skillsLabel)
		skillsLabel.textColor = Color.blackPrimary
		skillsLabel.text = "Skills"
		skillsLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		skillsLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(aboutTextView.snp_bottom).offset(10)
			make.left.equalTo(aboutLabel)
		}
		
		let skillsTableView = UITableView()
		skillsTableView.scrollEnabled = false
		self.skillsTableView = skillsTableView
		self.whiteContainer.addSubview(skillsTableView)
		skillsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		skillsTableView.delegate = self
		skillsTableView.dataSource = self
		skillsTableView.registerClass(SkillsTableViewCell.classForCoder(), forCellReuseIdentifier: SkillsTableViewCell.reuseIdentifier)
		skillsTableView.backgroundColor = Color.whiteBackground
		skillsTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(skillsLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutTextView.snp_left)
			make.right.equalTo(contentView.snp_right).offset(-19)
		}
		
		let addSkillButton = UIButton()
		self.whiteContainer.addSubview(addSkillButton)
		addSkillButton.addTarget(self, action: "addSkillButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		addSkillButton.setBackgroundImage(UIImage(named: "plus_green"), forState: UIControlState.Normal)
		addSkillButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(skillsLabel.snp_centerY)
            make.right.equalTo(contentView.snp_right).offset(-25)
						make.height.equalTo(20)
						make.width.equalTo(20)
		}
		
		//Education
		
		let educationLabel = UILabel()
		self.educationLabel = educationLabel
		self.whiteContainer.addSubview(educationLabel)
		educationLabel.textColor = Color.blackPrimary
		educationLabel.text = "Education"
		educationLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		educationLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(skillsTableView.snp_bottom).offset(10)
			make.left.equalTo(aboutLabel)
		}
		
		let educationTableView = UITableView()
		educationTableView.scrollEnabled = false
		self.educationTableView = educationTableView
		self.whiteContainer.addSubview(educationTableView)
		educationTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		educationTableView.delegate = self
		educationTableView.dataSource = self
		educationTableView.registerClass(SkillsTableViewCell.classForCoder(), forCellReuseIdentifier: SkillsTableViewCell.reuseIdentifier)
		educationTableView.backgroundColor = Color.whiteBackground
		educationTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(educationLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutTextView.snp_left)
			make.right.equalTo(contentView.snp_right).offset(-19)
		}
		
		let addEducationButton = UIButton()
		self.whiteContainer.addSubview(addEducationButton)
		addEducationButton.addTarget(self, action: "addEducationButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		addEducationButton.setBackgroundImage(UIImage(named:"plus_green"), forState: UIControlState.Normal)
		addEducationButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(educationLabel.snp_centerY)
			make.right.equalTo(contentView.snp_right).offset(-25)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		//Work Experience
		
		let experienceLabel = UILabel()
		self.experienceLabel = experienceLabel
		self.whiteContainer.addSubview(experienceLabel)
		experienceLabel.textColor = Color.blackPrimary
		experienceLabel.text = "Work experience"
		experienceLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		experienceLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(educationTableView.snp_bottom).offset(10)
			make.left.equalTo(aboutLabel)
		}
		
		let experienceTableView = UITableView()
		experienceTableView.scrollEnabled = false
		self.experienceTableView = experienceTableView
		self.whiteContainer.addSubview(experienceTableView)
		experienceTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		experienceTableView.delegate = self
		experienceTableView.dataSource = self
		experienceTableView.registerClass(SkillsTableViewCell.classForCoder(), forCellReuseIdentifier: SkillsTableViewCell.reuseIdentifier)
		experienceTableView.backgroundColor = Color.whiteBackground
		experienceTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(experienceLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutTextView.snp_left)
			make.right.equalTo(contentView.snp_right).offset(-19)
		}
		
		let addExperienceButton = UIButton()
		self.whiteContainer.addSubview(addExperienceButton)
		addExperienceButton.addTarget(self, action: "addExperienceButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		addExperienceButton.setBackgroundImage(UIImage(named:"plus_green"), forState: UIControlState.Normal)
		addExperienceButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(experienceLabel.snp_centerY)
			make.right.equalTo(contentView.snp_right).offset(-25)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		let fakeView = UIView()
		whiteContainer.addSubview(fakeView)
		fakeView.backgroundColor = UIColor.clearColor()
		fakeView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(experienceTableView.snp_bottom)
			make.bottom.equalTo(whiteContainer.snp_bottom)
		}
		
	}
	
	//MARK: Table View Delegate and Datasource
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if(tableView == skillsTableView){
			return arrayOfSkills.count
		}else if tableView == educationTableView{
			return arrayOfEducation.count
		}else if tableView == experienceTableView{
			return arrayOfExperience.count
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if(tableView == skillsTableView) {
			if (!self.arrayOfSkills.isEmpty) {
				let skillCell = tableView.dequeueReusableCellWithIdentifier(SkillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! SkillsTableViewCell
				
				let skill = self.arrayOfSkills[indexPath.item]
				skillCell.delegate = self
				skillCell.sendCellType("skills")
				skillCell.sendSkillName(skill["title"]!)
				skillCell.setIndex(indexPath.item)
				
				return skillCell
			}
		}else if tableView == educationTableView{
			if (!self.arrayOfEducation.isEmpty) {
				let educationCell = tableView.dequeueReusableCellWithIdentifier(SkillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! SkillsTableViewCell
				
				let education = self.arrayOfEducation[indexPath.item]
				educationCell.delegate = self
				educationCell.sendCellType("education")
				educationCell.sendSkillName(education["title"]!)
				educationCell.setIndex(indexPath.item)
				
				return educationCell
			}
		}else if tableView == experienceTableView{
			let experienceCell = tableView.dequeueReusableCellWithIdentifier(SkillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! SkillsTableViewCell
			let experience = self.arrayOfExperience[indexPath.item]
			experienceCell.delegate = self
			experienceCell.sendCellType("experience")
			experienceCell.sendSkillName(experience["title"]!)
			experienceCell.setIndex(indexPath.item)
			return experienceCell
		}
		let cell: UITableViewCell = UITableViewCell()
		return cell

	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 60
	}
	
	//MARK: View Delegate Methods
	
	override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
		let frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height + 10)
        self.scrollView.contentSize = frame.size
    }
	
	//MARK: Data
	
	/**
	Sets the user profile picture
	*/
	func setProfilePicture() {
		
		let image = UIImage(named: "noProfilePicture")
		
		if PFUser.currentUser()!.objectForKey("customPicture") != nil {
			let profilePic = (PFUser.currentUser()!.objectForKey("customPicture") as? PFFile)!
			request(.GET,profilePic.url!).response() {
				(_, _, data, _) in
				let image = UIImage(data: data as NSData!)
				self.profilePicture.image = image
			}
			
		} else if PFUser.currentUser()!.objectForKey("pictureURL") != nil {
			let profilePic = (PFUser.currentUser()!.objectForKey("pictureURL") as? String)!
			request(.GET,profilePic).response() {
				(_, _, data, _) in
				let image = UIImage(data: data as NSData!)
				self.profilePicture.image = image
			}
		}
		
		self.profilePicture.image = image
	}
	
	
	/**
	Load the current user profile information
	*/
	func loadData() {
		//get user skills etc...
		if PFUser.currentUser()?.objectForKey("about") != nil{
		self.aboutTextView.text = PFUser.currentUser()!["about"] as! String
		}
		if PFUser.currentUser()?.objectForKey("experience") != nil{
		self.arrayOfExperience = PFUser.currentUser()!["experience"] as! [Dictionary<String,String>]
		}
		if PFUser.currentUser()?.objectForKey("skills") != nil{
			self.arrayOfSkills = PFUser.currentUser()!["skills"] as! [Dictionary<String,String>]
		}
		if PFUser.currentUser()?.objectForKey("education") != nil{
		self.arrayOfEducation = PFUser.currentUser()!["education"] as! [Dictionary<String,String>]
		} 
		
	}
	
	//MARK: Actions
	
	func backButtonTapped(sender:UIButton) {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	/**
	Allows the user to edit the about section
	
	- parameter sender: Edit About Button
	*/
	func editAbout(sender:UIButton) {
		self.aboutTextView.editable = true
		self.aboutTextView.becomeFirstResponder()
		
	}
	
	
	/**
	Dismiss Keyboard when screen is tapped
	*/
	func dismissKeyboard() {
		view.endEditing(true)
		if(self.aboutTextView.editable == true) {
			self.aboutTextView.editable = false
			PFUser.currentUser()!["about"] = self.aboutTextView.text
		}
	}
	

	/**
	Allow the user to add skill to his profile
	
	- parameter sender: Skill edit button
	*/
	func addSkillButtonTapped(sender:UIButton) {
		var skillsTextField: UITextField?
		
		let popup = UIAlertController(title: "Add a Skill", message: "", preferredStyle: UIAlertControllerStyle.Alert)
		popup.addTextFieldWithConfigurationHandler { (textField) -> Void in
			skillsTextField = textField
		}
		popup.addAction(UIAlertAction(title: "Add", style: .Default , handler: { (action) -> Void in
			let skillTitle = skillsTextField!.text
			self.arrayOfSkills.append(["title": skillTitle!])
			self.refreshTableView()
		}))
		popup.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
		}))
		presentViewController(popup, animated: true, completion: nil)
		popup.view.tintColor = Color.redPrimary
    }
	
	
	//Add Education Button
	func addEducationButtonTapped(sender:UIButton) {
		var educationTextField: UITextField?
		
		let popup = UIAlertController(title: "Add Education", message: "", preferredStyle: UIAlertControllerStyle.Alert)
		popup.addTextFieldWithConfigurationHandler { (textField) -> Void in
			educationTextField = textField
		}
		popup.addAction(UIAlertAction(title: "Add", style: .Default , handler: { (action) -> Void in
			let educationTitle = educationTextField!.text
			self.arrayOfEducation.append(["title": educationTitle!])
			self.refreshTableView()
		}))
		popup.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
		}))
		
		presentViewController(popup, animated: true, completion: nil)
		popup.view.tintColor = Color.redPrimary
	}
	
	//Add Experience Button
	func addExperienceButtonTapped(sender:UIButton) {
		var experienceTextField: UITextField?
		
		let popup = UIAlertController(title: "Add Experience", message: "", preferredStyle: UIAlertControllerStyle.Alert)
		popup.addTextFieldWithConfigurationHandler { (textField) -> Void in
			experienceTextField = textField
		}
		popup.addAction(UIAlertAction(title: "Add", style: .Default , handler: { (action) -> Void in
			let experienceTitle = experienceTextField!.text
			self.arrayOfExperience.append(["title": experienceTitle!])
			self.refreshTableView()
		}))
		popup.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
		}))
		
		presentViewController(popup, animated: true, completion: nil)
		popup.view.tintColor = Color.redPrimary
	}

	
	/**
	Refresh table view after each edit
	*/
    func refreshTableView(){
		self.skillsTableView.reloadData()
		self.educationTableView.reloadData()
		self.experienceTableView.reloadData()
		
		var arrayExperience = [Dictionary<String,String>]()
			for experience in self.arrayOfExperience{
				var dictionary = [String:String]()
				dictionary["title"] = experience["title"]
				arrayExperience.append(dictionary)
			}
			
			var arraySkills = [Dictionary<String,String>]()
			for skill in self.arrayOfSkills{
				var dictionary = [String:String]()
				dictionary["title"] = skill["title"]
				arraySkills.append(dictionary)
			}
			
			var arrayEducation = [Dictionary<String,String>]()
			for education in self.arrayOfEducation{
				var dictionary = [String:String]()
				dictionary["title"] = education["title"]
				arrayEducation.append(dictionary)
			}
			
			self.skillsTableView.snp_updateConstraints { (make) -> Void in
				make.height.equalTo(self.arrayOfSkills.count * Int(kCellHeight))
			}
			self.educationTableView.snp_updateConstraints { (make) -> Void in
				make.height.equalTo(self.arrayOfEducation.count * Int(kCellHeight))
			}
			self.experienceTableView.snp_updateConstraints { (make) -> Void in
				make.height.equalTo(self.arrayOfExperience.count * Int(kCellHeight))
			}
			
		PFUser.currentUser()!["experience"] = arrayExperience
		PFUser.currentUser()!["skills"] = arraySkills
		PFUser.currentUser()!["education"] = arrayEducation
		PFUser.currentUser()!.saveInBackground()
	}

	
	/**
	Triggered when delete button is tapped on a cell
	
	- parameter index: Cell Index
	- parameter type:  Type of cell (education,skill,work..)
	*/
	func didTapDeleteButton(index: Int, type:String) {
		if type == "skills"{
			self.arrayOfSkills.removeAtIndex(index)
			self.skillsTableView.snp_updateConstraints { (make) -> Void in
			}
			self.refreshTableView()
		}else if type == "education" {
			self.arrayOfEducation.removeAtIndex(index)
			self.educationTableView.snp_updateConstraints { (make) -> Void in
			}
			self.refreshTableView()
		}else if type == "experience"{
			self.arrayOfExperience.removeAtIndex(index)
			self.experienceTableView.snp_updateConstraints { (make) -> Void in
			}
			self.refreshTableView()
		}
	}
}

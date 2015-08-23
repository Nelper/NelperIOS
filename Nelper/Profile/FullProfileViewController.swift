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
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var backGroundView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!

	
	var profilePicture:UIImageView!
	var aboutTextView: UITextView!
	var skillsTableView:UITableView!
	var arrayOfSkills = [String]()
	var skillsLabel:UILabel!
	var educationLabel:UILabel!
	var arrayOfEducation = [String]()
	var educationTableView:UITableView!
	var contentView: UIView!
	var experienceLabel:UILabel!
	var experienceTableView:UITableView!
	var arrayOfExperience = [String]()
	var tap: UITapGestureRecognizer?

	//	INITIALIZER
	convenience init() {
		self.init(nibName: "FullProfileViewController", bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.automaticallyAdjustsScrollViewInsets = false
		loadData()
		createView()
		setInformations()
		getFacebookInfos()
		// looks for tap (keyboard dismiss)
		var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		self.tap = tap
		contentView.addGestureRecognizer(tap)
		
	}
	
	override func viewDidAppear(animated: Bool) {
        self.addScrollContent()
	}
	
	//View Creation
	func createView(){
		
		self.scrollView.backgroundColor = whiteNelpyColor
		let backBtn = UIButton()
		backBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = backBtn
        
        var contentView = UIView()
        self.contentView = contentView
        self.scrollView.addSubview(contentView)
        contentView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.scrollView.snp_top)
            make.left.equalTo(self.scrollView.snp_left)
            make.right.equalTo(self.scrollView.snp_right)
//            make.bottom.equalTo(self.scrollView.snp_bottom)
            make.height.greaterThanOrEqualTo(self.backGroundView.snp_height)
            make.width.equalTo(self.backGroundView.snp_width)
        }
		
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
			make.height.equalTo(150)
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
		numberOfTasksLabel.text = "12 tasks completed"
		numberOfTasksLabel.textColor = navBarColor
		numberOfTasksLabel.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		numberOfTasksLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(name.snp_left)
			make.top.equalTo(firstStar.snp_bottom).offset(8)
			make.right.equalTo(self.contentView.snp_right).offset(-4)
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
		aboutTextView.textColor = blackNelpyColor
		aboutTextView.backgroundColor = whiteNelpyColor
		aboutTextView.editable = false
		aboutTextView.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
		aboutTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(aboutLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutLabel.snp_left).offset(4)
			make.width.equalTo(contentView.snp_width).dividedBy(1.2)
			make.height.equalTo(90)
		}
		
		var editAboutIcon = UIButton()
		self.contentView.addSubview(editAboutIcon)
		editAboutIcon.setBackgroundImage(UIImage(named: "pen.png"), forState: UIControlState.Normal)
		editAboutIcon.addTarget(self, action: "editAbout:", forControlEvents: UIControlEvents.TouchUpInside)
		editAboutIcon.contentMode = UIViewContentMode.ScaleAspectFill
		editAboutIcon.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.contentView.snp_right).offset(-19)
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
			make.height.equalTo(self.arrayOfSkills.count * 60)
		}
		
		var addSkillButton = UIButton()
		self.contentView.addSubview(addSkillButton)
		addSkillButton.addTarget(self, action: "addSkillButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		addSkillButton.setBackgroundImage(UIImage(named: "plus_orange"), forState: UIControlState.Normal)
		addSkillButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(skillsLabel.snp_centerY)
            make.right.equalTo(contentView.snp_right).offset(-20)
						make.height.equalTo(30)
						make.width.equalTo(30)
		}
		
		//Education
		
		var educationLabel = UILabel()
		self.educationLabel = educationLabel
		self.contentView.addSubview(educationLabel)
		educationLabel.textColor = blackNelpyColor
		educationLabel.text = "Education"
		educationLabel.font = UIFont(name: "ABeeZee-Regular", size: kSubtitleFontSize)
		educationLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(skillsTableView.snp_bottom).offset(10)
			make.left.equalTo(aboutLabel)
		}
		
		var educationTableView = UITableView()
		educationTableView.scrollEnabled = false
		self.educationTableView = educationTableView
		self.contentView.addSubview(educationTableView)
		educationTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		educationTableView.delegate = self
		educationTableView.dataSource = self
		educationTableView.registerClass(skillsTableViewCell.classForCoder(), forCellReuseIdentifier: skillsTableViewCell.reuseIdentifier)
		educationTableView.backgroundColor = whiteNelpyColor
		educationTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(educationLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutTextView.snp_left)
			make.right.equalTo(contentView.snp_right).offset(-19)
            make.height.equalTo(self.arrayOfEducation.count * 60)

		}
		
		var addEducationButton = UIButton()
		self.contentView.addSubview(addEducationButton)
		addEducationButton.addTarget(self, action: "addEducationButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		addEducationButton.setBackgroundImage(UIImage(named:"plus_orange"), forState: UIControlState.Normal)
		addEducationButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(educationLabel.snp_centerY)
			make.right.equalTo(contentView.snp_right).offset(-20)
			make.width.equalTo(30)
			make.height.equalTo(30)
		}
		
		//Work Experience
		
		var experienceLabel = UILabel()
		self.experienceLabel = experienceLabel
		self.contentView.addSubview(experienceLabel)
		experienceLabel.textColor = blackNelpyColor
		experienceLabel.text = "Work experience"
		experienceLabel.font = UIFont(name: "ABeeZee-Regular", size: kSubtitleFontSize)
		experienceLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(educationTableView.snp_bottom).offset(10)
			make.left.equalTo(aboutLabel)
		}
		
		var experienceTableView = UITableView()
		experienceTableView.scrollEnabled = false
		self.experienceTableView = experienceTableView
		self.contentView.addSubview(experienceTableView)
		experienceTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		experienceTableView.delegate = self
		experienceTableView.dataSource = self
		experienceTableView.registerClass(skillsTableViewCell.classForCoder(), forCellReuseIdentifier: skillsTableViewCell.reuseIdentifier)
		experienceTableView.backgroundColor = whiteNelpyColor
		experienceTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(experienceLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutTextView.snp_left)
			make.right.equalTo(contentView.snp_right).offset(-19)
			make.height.equalTo(self.arrayOfExperience.count * 60)
			
		}
		
		var addExperienceButton = UIButton()
		self.contentView.addSubview(addExperienceButton)
		addExperienceButton.addTarget(self, action: "addExperienceButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		addExperienceButton.setBackgroundImage(UIImage(named:"plus_orange"), forState: UIControlState.Normal)
		addExperienceButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(experienceLabel.snp_centerY)
			make.right.equalTo(contentView.snp_right).offset(-20)
			make.width.equalTo(30)
			make.height.equalTo(30)
		}
		
	}
	
	//keyboard dismiss on screen touch
	func DismissKeyboard() {
		view.endEditing(true)
		if(self.aboutTextView.editable == true){
			self.aboutTextView.editable = false
		}
	}
	
	//TableView Delegate Method
	
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
				let skillCell = tableView.dequeueReusableCellWithIdentifier(skillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! skillsTableViewCell
				
				let skill = self.arrayOfSkills[indexPath.item]
				
				skillCell.sendSkillName(skill)
				
				return skillCell
			}
		}else if tableView == educationTableView{
			if (!self.arrayOfEducation.isEmpty) {
				let educationCell = tableView.dequeueReusableCellWithIdentifier(skillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! skillsTableViewCell
				
				let education = self.arrayOfEducation[indexPath.item]
				
				educationCell.sendSkillName(education)
				
				return educationCell
			}
		}else if tableView == experienceTableView{
			let experienceCell = tableView.dequeueReusableCellWithIdentifier(skillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! skillsTableViewCell
			let experience = self.arrayOfExperience[indexPath.item]
			experienceCell.sendSkillName(experience)
			return experienceCell
		}
		var cell: UITableViewCell!
		return cell

	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 60
	}
	
	//View Delegate
	
	override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = self.contentView.frame.size
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
		
		var testEducation = "Computer Science, UQAM"
		var testEducationArray = [testEducation]
		self.arrayOfEducation = testEducationArray
		
		var testExperience = "Worked at the Apple Store"
		var testExperienceArray = [testExperience]
		self.arrayOfExperience = testExperienceArray
		
	}
	
	func setInformations() {
		
		
	}
	
	//Actions
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func editAbout(sender:UIButton){
		self.aboutTextView.editable = true
		self.aboutTextView.becomeFirstResponder()
		
	}
	
	//Add Skill Button
	func addSkillButtonTapped(sender:UIButton){
		var popup = UIAlertController(title: "Add a Skill", message: "", preferredStyle: UIAlertControllerStyle.Alert)
		popup.addTextFieldWithConfigurationHandler { (textField) -> Void in
        }
		
		popup.addAction(UIAlertAction(title: "Add", style: .Default , handler: { (action) -> Void in
			var skillTitle: String = (popup.textFields?.first as! UITextField).text
			self.arrayOfSkills.append(skillTitle)
            self.skillsTableView.snp_updateConstraints { (make) -> Void in
                make.height.equalTo(self.arrayOfSkills.count * 60)
            }
            self.addScrollContent()
			self.refreshTableView()
		}))
		
		popup.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
		}))
		
		presentViewController(popup, animated: true, completion: nil)
    }
	
	
	//Add Education Button
	func addEducationButtonTapped(sender:UIButton){
		var popup = UIAlertController(title: "Add Education", message: "", preferredStyle: UIAlertControllerStyle.Alert)
		popup.addTextFieldWithConfigurationHandler { (textField) -> Void in
		}
		
		popup.addAction(UIAlertAction(title: "Add", style: .Default , handler: { (action) -> Void in
			var educationTitle: String = (popup.textFields?.first as! UITextField).text
			self.arrayOfEducation.append(educationTitle)
            self.educationTableView.snp_updateConstraints { (make) -> Void in
                make.height.equalTo(self.arrayOfEducation.count * 60)
            }
            self.addScrollContent()
			self.refreshTableView()
		}))
		
		popup.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
		}))
		
		presentViewController(popup, animated: true, completion: nil)
	}
	
	//Add Experience Button
	func addExperienceButtonTapped(sender:UIButton){
		var popup = UIAlertController(title: "Add Experience", message: "", preferredStyle: UIAlertControllerStyle.Alert)
		popup.addTextFieldWithConfigurationHandler { (textField) -> Void in
		}
		
		popup.addAction(UIAlertAction(title: "Add", style: .Default , handler: { (action) -> Void in
			var experienceTitle: String = (popup.textFields?.first as! UITextField).text
			self.arrayOfExperience.append(experienceTitle)
			self.experienceTableView.snp_updateConstraints { (make) -> Void in
				make.height.equalTo(self.arrayOfExperience.count * 60)
			}
			self.addScrollContent()
			self.refreshTableView()
		}))
		
		popup.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
		}))
		
		presentViewController(popup, animated: true, completion: nil)
	}
	
	//Refresh table view and re-draw frame
    func refreshTableView(){
		self.skillsTableView.reloadData()
		self.educationTableView.reloadData()
		self.experienceTableView.reloadData()
	}
    
	
		func addScrollContent(){
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height + 60)
        self.contentView.snp_updateConstraints { (make) -> Void in
            make.height.equalTo(self.scrollView.contentSize.height)
        }
        println("\(self.scrollView.contentSize.height)")
			}
}

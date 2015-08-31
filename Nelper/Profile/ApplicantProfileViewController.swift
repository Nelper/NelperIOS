//
//  ApplicantProfileViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-27.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire

protocol ApplicantProfileViewControllerDelegate{
	func didTapDenyButton(applicant:User)
}

class ApplicantProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var acceptDenyBar: UIView!
	@IBOutlet weak var containerView: UIView!
	
	let kCellHeight:CGFloat = 45
	
	var applicant: User!
	var delegate:ApplicantProfileViewControllerDelegate?
	var application: NelpTaskApplication!
	var picture:UIImageView!
	var firstStar:UIImageView!
	var secondStar:UIImageView!
	var thirdStar:UIImageView!
	var fourthStar:UIImageView!
	var fifthStar:UIImageView!
	var scrollView:UIScrollView!
	var skillsLabel:UILabel!
	var aboutLabel:UILabel!
	var educationLabel:UILabel!
	var experienceLabel:UILabel!
	
	var contentView:UIView!
	var profileSegmentButton:UIButton!
	var reviewSegmentButton:UIButton!
	var bottomFeedbackBorder:UIView!
	var bottomProfileBorder:UIView!
	var whiteContainer:UIView!
	var aboutTextView:UITextView!
	var skillsTableView:UITableView!
	var educationTableView:UITableView!
	var experienceTableView:UITableView!
	var arrayOfSkills = [Dictionary<String,String>]()
	var arrayOfExperience = [Dictionary<String,String>]()
	var arrayOfEducation = [Dictionary<String,String>]()
	var skillsBottomLine:UIView!
	var experienceBottomLine:UIView!
	var educationBottomLine:UIView!
	var denyButton:UIButton!
	var acceptButton:UIButton!


	//Init
	convenience init(applicant:User, application:NelpTaskApplication){
		self.init(nibName: "ApplicantProfileViewController", bundle: nil)
		self.applicant = applicant
		self.application = application
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.loadData()
		self.createView()
		self.profileSegmentButton.selected = true
	}
	
	//UI
	
	func createView(){
		self.setImages(self.applicant)
		
		//Profile + Header
		var profileContainer = UIView()
		self.containerView.addSubview(profileContainer)
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.containerView.snp_left)
			make.right.equalTo(self.containerView.snp_right)
			make.height.equalTo(125)
		}
		profileContainer.backgroundColor = blueGrayColor
		
		//Profile Picture
		let pictureSize: CGFloat = 85
		let picture = UIImageView()
		self.picture = picture
		self.picture.layer.cornerRadius = pictureSize / 2;
		self.picture.layer.masksToBounds = true
		self.picture.clipsToBounds = true
		self.picture.contentMode = UIViewContentMode.ScaleAspectFill
		self.picture.layer.borderColor = darkGrayDetails.CGColor
		self.picture.layer.borderWidth = 2
		profileContainer.addSubview(picture)
		
		picture.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(profileContainer.snp_centerY)
			make.left.equalTo(profileContainer.snp_left).offset(15)
			make.height.equalTo(pictureSize)
			make.width.equalTo(pictureSize)
		}
		
		
		//Name
		var name = UILabel()
		profileContainer.addSubview(name)
		name.numberOfLines = 0
		name.textColor = whiteNelpyColor
		name.text = self.applicant.name
		name.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		
		name.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(picture.snp_right).offset(15)
			make.top.equalTo(picture.snp_top)
		}
		//FeedBack Stars
		
		var firstStar = UIImageView()
		self.firstStar = firstStar
		profileContainer.addSubview(firstStar)
		firstStar.contentMode = UIViewContentMode.ScaleAspectFill
		firstStar.image = UIImage(named: "empty_star")
		firstStar.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(name.snp_left)
			make.top.equalTo(name.snp_bottom).offset(8)
			make.height.equalTo(20)
			make.width.equalTo(20)
		}
		
		var secondStar = UIImageView()
		self.secondStar = secondStar
		profileContainer.addSubview(secondStar)
		secondStar.contentMode = UIViewContentMode.ScaleAspectFill
		secondStar.image = UIImage(named: "empty_star")
		secondStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(firstStar.snp_bottom)
			make.left.equalTo(firstStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		var thirdStar = UIImageView()
		self.thirdStar = thirdStar
		profileContainer.addSubview(thirdStar)
		thirdStar.contentMode = UIViewContentMode.ScaleAspectFill
		thirdStar.image = UIImage(named: "empty_star")
		thirdStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(secondStar.snp_bottom)
			make.left.equalTo(secondStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		var fourthStar = UIImageView()
		self.fourthStar = fourthStar
		profileContainer.addSubview(fourthStar)
		fourthStar.contentMode = UIViewContentMode.ScaleAspectFill
		fourthStar.image = UIImage(named: "empty_star")
		fourthStar.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(thirdStar.snp_bottom)
			make.left.equalTo(thirdStar.snp_right).offset(4)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		var fifthStar = UIImageView()
		self.fifthStar = fifthStar
		profileContainer.addSubview(fifthStar)
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
		profileContainer.addSubview(numberOfTasksLabel)
		numberOfTasksLabel.text = "12 tasks completed"
		numberOfTasksLabel.textColor = whiteNelpyColor
		numberOfTasksLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		numberOfTasksLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(name.snp_left)
			make.top.equalTo(firstStar.snp_bottom).offset(8)
			make.right.equalTo(profileContainer.snp_right).offset(-4)
		}

		//Asking for Container
		
		var askingForPriceContainer = UIView()
		self.containerView.addSubview(askingForPriceContainer)
		askingForPriceContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_bottom)
			make.left.equalTo(self.containerView.snp_left)
			make.right.equalTo(self.containerView.snp_right)
			make.height.equalTo(60)
		}
		askingForPriceContainer.backgroundColor = navBarColor
		
		var moneyIcon = UIImageView()
		askingForPriceContainer.addSubview(moneyIcon)
		moneyIcon.image = UIImage(named: "money_icon")
		moneyIcon.contentMode = UIViewContentMode.ScaleAspectFill
		moneyIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(askingForPriceContainer.snp_centerY)
			make.left.equalTo(askingForPriceContainer.snp_left).offset(30)
			make.height.equalTo(50)
			make.width.equalTo(50)
		}
		
		var askingForLabel = UILabel()
		askingForLabel.textColor = blackNelpyColor
		askingForLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		if self.application.price != nil{
		askingForLabel.text = "\(self.application.price)$"
		}
		
		//Segment Container
		var segmentControlContainer = UIView()
		self.containerView.addSubview(segmentControlContainer)
		segmentControlContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(askingForPriceContainer.snp_bottom)
			make.left.equalTo(self.containerView.snp_left)
			make.right.equalTo(self.containerView.snp_right)
			make.height.equalTo(50)
		}
		segmentControlContainer.layer.borderWidth = 1
		segmentControlContainer.layer.borderColor = darkGrayDetails.CGColor
		segmentControlContainer.backgroundColor = navBarColor
		
			//Hack for positioning of custom Segment bar
		
		var firstHalf = UIView()
		segmentControlContainer.addSubview(firstHalf)
		firstHalf.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(segmentControlContainer.snp_width).dividedBy(2)
			make.left.equalTo(segmentControlContainer.snp_left)
			make.top.equalTo(segmentControlContainer.snp_top).offset(1)
			make.bottom.equalTo(segmentControlContainer.snp_bottom).offset(-1)
		}
		
		var profileSegmentButton = UIButton()
		self.profileSegmentButton = profileSegmentButton
		profileSegmentButton.addTarget(self, action: "profileSegmentButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		firstHalf.addSubview(profileSegmentButton)
		profileSegmentButton.setTitle("Profile", forState: UIControlState.Normal)
		profileSegmentButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		profileSegmentButton.setTitleColor(blackNelpyColor, forState: UIControlState.Normal)
		profileSegmentButton.setTitleColor(blueGrayColor, forState: UIControlState.Selected)
		profileSegmentButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(firstHalf.snp_centerX)
			make.top.equalTo(firstHalf.snp_top)
			make.width.equalTo(firstHalf.snp_width)
			make.bottom.equalTo(firstHalf.snp_bottom).offset(-2)
		}
		
		let bottomProfileBorder = UIView()
		self.bottomProfileBorder = bottomProfileBorder
		bottomProfileBorder.backgroundColor = blueGrayColor
		firstHalf.addSubview(bottomProfileBorder)
		bottomProfileBorder.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(firstHalf.snp_bottom)
			make.width.equalTo(firstHalf.snp_width).dividedBy(1.2)
			make.centerX.equalTo(firstHalf.snp_centerX)
			make.height.equalTo(2)
		}

		var secondHalf = UIView()
		segmentControlContainer.addSubview(secondHalf)
		secondHalf.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(segmentControlContainer.snp_width).dividedBy(2)
			make.right.equalTo(segmentControlContainer.snp_right)
			make.top.equalTo(segmentControlContainer.snp_top).offset(1)
			make.bottom.equalTo(segmentControlContainer.snp_bottom).offset(-1)
		}
		
		var reviewSegmentButton = UIButton()
		self.reviewSegmentButton = reviewSegmentButton
		reviewSegmentButton.addTarget(self, action: "reviewSegmentButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)

		secondHalf.addSubview(reviewSegmentButton)
		reviewSegmentButton.setTitle("Feedback", forState: UIControlState.Normal)
		reviewSegmentButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		reviewSegmentButton.setTitleColor(blackNelpyColor, forState: UIControlState.Normal)
		reviewSegmentButton.setTitleColor(blueGrayColor, forState: UIControlState.Selected)
		reviewSegmentButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(secondHalf.snp_centerX)
			make.width.equalTo(secondHalf.snp_width)
			make.top.equalTo(secondHalf.snp_top)
			make.bottom.equalTo(secondHalf.snp_bottom).offset(-2)
		}
		
		let bottomFeedbackBorder = UIView()
		self.bottomFeedbackBorder = bottomFeedbackBorder
		bottomFeedbackBorder.backgroundColor = blueGrayColor
		secondHalf.addSubview(bottomFeedbackBorder)
		bottomFeedbackBorder.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(secondHalf.snp_bottom)
			make.width.equalTo(secondHalf.snp_width).dividedBy(1.2)
			make.centerX.equalTo(secondHalf.snp_centerX)
			make.height.equalTo(2)
		}
		
		bottomFeedbackBorder.hidden = true
		
		
		//Background View + ScrollView
		
		var background = UIView()
		self.containerView.addSubview(background)
		background.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(segmentControlContainer.snp_bottom)
			make.left.equalTo(self.containerView.snp_left)
			make.right.equalTo(self.containerView.snp_right)
			make.bottom.equalTo(self.acceptDenyBar.snp_top)
		}
		
		var scrollView = UIScrollView()
		self.scrollView = scrollView
		self.view.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(background.snp_edges)
		}
		
		
		scrollView.backgroundColor = whiteNelpyColor
		let backBtn = UIButton()
		backBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = backBtn
		
		var contentView = UIView()
		self.contentView = contentView
		scrollView.addSubview(contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			//            make.bottom.equalTo(self.scrollView.snp_bottom)
			make.height.greaterThanOrEqualTo(background.snp_height)
			make.width.equalTo(background.snp_width)
		}
		self.contentView.backgroundColor = whiteNelpyColor
		background.backgroundColor = whiteNelpyColor
		
		
		//White Container
		
		var whiteContainer = UIView()
		self.contentView.addSubview(whiteContainer)
		self.whiteContainer = whiteContainer
		whiteContainer.layer.borderColor = darkGrayDetails.CGColor
		whiteContainer.layer.borderWidth = 1
		whiteContainer.backgroundColor = navBarColor
		whiteContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(10)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
			make.bottom.equalTo(contentView.snp_bottom).offset(-10)
		}
		
		
		//About
		
		var aboutLabel = UILabel()
		self.aboutLabel = aboutLabel
		self.whiteContainer.addSubview(aboutLabel)
		aboutLabel.textColor = blackNelpyColor
		aboutLabel.text = "About"
		aboutLabel.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		aboutLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(whiteContainer.snp_left).offset(20)
			make.top.equalTo(whiteContainer.snp_top).offset(10)
			make.height.equalTo(30)
		}
		
		var aboutTextView = UITextView()
		self.whiteContainer.addSubview(aboutTextView)
		self.aboutTextView = aboutTextView
		aboutTextView.scrollEnabled = false
		aboutTextView.textColor = blackNelpyColor
		aboutTextView.backgroundColor = navBarColor
		aboutTextView.editable = false
		aboutTextView.text = self.applicant.about
		aboutTextView.font = UIFont(name: "HelveticaNeue", size: kAboutTextFontSize)
		aboutTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(aboutLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutLabel.snp_left).offset(4)
			make.width.equalTo(contentView.snp_width).dividedBy(1.02)
		}
		
		let fixedWidth = aboutTextView.frame.size.width
		aboutTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		let newSize = aboutTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		var newFrame = aboutTextView.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		aboutTextView.frame = newFrame;
		
		var aboutBottomLine = UIView()
		aboutBottomLine.backgroundColor = darkGrayDetails
		whiteContainer.addSubview(aboutBottomLine)
		aboutBottomLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(aboutTextView.snp_bottom).offset(4)
			make.width.equalTo(whiteContainer.snp_width).dividedBy(1.4)
			make.centerX.equalTo(whiteContainer.snp_centerX)
			make.height.equalTo(0.5)
		}
		
		if self.applicant.about == nil || self.applicant.about.isEmpty{
			aboutLabel.hidden = true
			aboutBottomLine.hidden = true
			aboutLabel.snp_updateConstraints(closure: { (make) -> Void in
				make.height.equalTo(0)
			})
			aboutTextView.snp_updateConstraints(closure: { (make) -> Void in
				make.height.equalTo(0)
			})
		}
		
		
		//My skills
		
		var skillsLabel = UILabel()
		self.skillsLabel = skillsLabel
		self.whiteContainer.addSubview(skillsLabel)
		skillsLabel.textColor = blackNelpyColor
		skillsLabel.text = "Skills"
		skillsLabel.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		skillsLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(aboutTextView.snp_bottom).offset(10)
			make.left.equalTo(aboutLabel)
			make.height.equalTo(30)
		}
		
		var skillsTableView = UITableView()
		skillsTableView.scrollEnabled = false
		self.skillsTableView = skillsTableView
		self.whiteContainer.addSubview(skillsTableView)
		skillsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		skillsTableView.delegate = self
		skillsTableView.dataSource = self
		skillsTableView.registerClass(skillsTableViewCell.classForCoder(), forCellReuseIdentifier: skillsTableViewCell.reuseIdentifier)
		skillsTableView.backgroundColor = navBarColor
		skillsTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(skillsLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutTextView.snp_left)
			make.right.equalTo(contentView.snp_right).offset(-19)
			if self.applicant.skills != nil{
			make.height.equalTo(self.applicant.skills.count * Int(kCellHeight))
			}
		}
		
		var skillsBottomLine = UIView()
		self.skillsBottomLine = skillsBottomLine
		skillsBottomLine.backgroundColor = darkGrayDetails
		whiteContainer.addSubview(skillsBottomLine)
		skillsBottomLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(skillsTableView.snp_bottom).offset(4)
			make.width.equalTo(whiteContainer.snp_width).dividedBy(1.4)
			make.centerX.equalTo(whiteContainer.snp_centerX)
			make.height.equalTo(0.5)
		}
		
		//Education
		
		var educationLabel = UILabel()
		self.educationLabel = educationLabel
		self.whiteContainer.addSubview(educationLabel)
		educationLabel.textColor = blackNelpyColor
		educationLabel.text = "Education"
		educationLabel.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		educationLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(skillsTableView.snp_bottom).offset(10)
			make.left.equalTo(aboutLabel)
			make.height.equalTo(30)
		}
		
		var educationTableView = UITableView()
		educationTableView.scrollEnabled = false
		self.educationTableView = educationTableView
		self.whiteContainer.addSubview(educationTableView)
		educationTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		educationTableView.delegate = self
		educationTableView.dataSource = self
		educationTableView.registerClass(skillsTableViewCell.classForCoder(), forCellReuseIdentifier: skillsTableViewCell.reuseIdentifier)
		educationTableView.backgroundColor = navBarColor
		educationTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(educationLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutTextView.snp_left)
			make.right.equalTo(contentView.snp_right).offset(-19)
			if self.applicant.education != nil{
			make.height.equalTo(self.applicant.education.count * Int(kCellHeight))
			}
		}
		
		var educationBottomLine = UIView()
		self.educationBottomLine = educationBottomLine
		educationBottomLine.backgroundColor = darkGrayDetails
		whiteContainer.addSubview(educationBottomLine)
		educationBottomLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(educationTableView.snp_bottom).offset(4)
			make.width.equalTo(whiteContainer.snp_width).dividedBy(1.4)
			make.centerX.equalTo(whiteContainer.snp_centerX)
			make.height.equalTo(0.5)
		}
		
		//Work Experience
		
		var experienceLabel = UILabel()
		self.experienceLabel = experienceLabel
		self.whiteContainer.addSubview(experienceLabel)
		experienceLabel.textColor = blackNelpyColor
		experienceLabel.text = "Work experience"
		experienceLabel.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		experienceLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(educationTableView.snp_bottom).offset(10)
			make.left.equalTo(aboutLabel)
			make.height.equalTo(30)
		}
		
		var experienceTableView = UITableView()
		experienceTableView.scrollEnabled = false
		self.experienceTableView = experienceTableView
		self.whiteContainer.addSubview(experienceTableView)
		experienceTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		experienceTableView.delegate = self
		experienceTableView.dataSource = self
		experienceTableView.registerClass(skillsTableViewCell.classForCoder(), forCellReuseIdentifier: skillsTableViewCell.reuseIdentifier)
		experienceTableView.backgroundColor = navBarColor
		experienceTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(experienceLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutTextView.snp_left)
			make.right.equalTo(contentView.snp_right).offset(-19)
			if self.applicant.experience != nil{
			make.height.equalTo(self.applicant.experience.count * Int(kCellHeight))
			make.bottom.equalTo(whiteContainer.snp_bottom).offset(-10)
			}
		}

		
		//Accept Deny Bar
		
		self.acceptDenyBar.backgroundColor = blueGrayColor
		
		var acceptButton = UIButton()
		self.acceptButton = acceptButton
		self.acceptDenyBar.addSubview(acceptButton)
		self.acceptButton.addTarget(self, action: "acceptButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		acceptButton.setBackgroundImage(UIImage(named:"white_accepted.png"), forState: UIControlState.Normal)
		acceptButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(acceptDenyBar.snp_centerX).offset(60)
			make.centerY.equalTo(acceptDenyBar.snp_centerY)
			make.width.equalTo(50)
			make.height.equalTo(50)
		}
		
		var denyButton = UIButton()
		self.acceptDenyBar.addSubview(denyButton)
		self.denyButton = denyButton
		self.denyButton.addTarget(self, action: "denyButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		denyButton.setBackgroundImage(UIImage(named:"white_denied.png"), forState: UIControlState.Normal)
		denyButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(acceptDenyBar.snp_centerX).offset(-60)
			make.centerY.equalTo(acceptDenyBar.snp_centerY)
			make.width.equalTo(50)
			make.height.equalTo(50)
		}
		
	}
	
	//DATA
	
	func setImages(applicant:User){
		if(applicant.profilePictureURL != nil){
			var fbProfilePicture = applicant.profilePictureURL
			request(.GET,fbProfilePicture!).response(){
				(_, _, data, _) in
				var image = UIImage(data: data as NSData!)
				self.picture.image = image
			}
		}
	}
	
	func loadData() {
	}
	
	//TableView Delegate Methods
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if(tableView == skillsTableView){
		if self.applicant.skills != nil {
			if self.applicant.skills.count == 0{
				self.skillsLabel.hidden = true
				self.skillsBottomLine.hidden = true
				self.skillsLabel.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
				self.skillsTableView.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
			}
			return self.applicant.skills.count
		}else{
			self.skillsLabel.hidden = true
			self.skillsLabel.snp_updateConstraints(closure: { (make) -> Void in
				make.height.equalTo(0)
			})
			self.skillsTableView.snp_updateConstraints(closure: { (make) -> Void in
				make.height.equalTo(0)
			})
			self.skillsBottomLine.hidden = true
			}
		}else if tableView == educationTableView{
			if self.applicant.education != nil{
				if self.applicant.education.count == 0{
					self.educationLabel.hidden = true
					self.educationBottomLine.hidden = true
					self.educationLabel.snp_updateConstraints(closure: { (make) -> Void in
						make.height.equalTo(0)
					})
					self.educationTableView.snp_updateConstraints(closure: { (make) -> Void in
						make.height.equalTo(0)
					})
				}
			return self.applicant.education.count
			}else{
				self.educationLabel.hidden = true
				self.educationLabel.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
				self.educationTableView.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
				self.educationBottomLine.hidden = true
			}
		}else if tableView == experienceTableView{
			if self.applicant.experience != nil{
				if self.applicant.experience.count == 0{
					self.experienceLabel.hidden = true
					self.experienceLabel.snp_updateConstraints(closure: { (make) -> Void in
						make.height.equalTo(0)
					})
					self.experienceTableView.snp_updateConstraints(closure: { (make) -> Void in
						make.height.equalTo(0)
					})
				}
			return self.applicant.experience.count
			}else{
				self.experienceLabel.hidden = true
				self.experienceLabel.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
				self.experienceTableView.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})

			}
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if(tableView == skillsTableView) {
			
				let skillCell = tableView.dequeueReusableCellWithIdentifier(skillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! skillsTableViewCell
				
				let skill = self.applicant.skills[indexPath.item]
				skillCell.sendCellType("skills")
				skillCell.sendSkillName(skill["title"]!)
				skillCell.setIndex(indexPath.item)
				skillCell.hideTrashCanIcon()
				
				return skillCell
			
		}else if tableView == educationTableView{
	
				let educationCell = tableView.dequeueReusableCellWithIdentifier(skillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! skillsTableViewCell
				
				let education = self.applicant.education[indexPath.item]
				educationCell.sendCellType("education")
				educationCell.sendSkillName(education["title"]!)
				educationCell.setIndex(indexPath.item)
				educationCell.hideTrashCanIcon()
				
				return educationCell
			
		}else if tableView == experienceTableView{
			let experienceCell = tableView.dequeueReusableCellWithIdentifier(skillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! skillsTableViewCell
			let experience = self.applicant.experience[indexPath.item]
			experienceCell.sendCellType("experience")
			experienceCell.sendSkillName(experience["title"]!)
			experienceCell.setIndex(indexPath.item)
			experienceCell.hideTrashCanIcon()
			return experienceCell
		}
		var cell = UITableViewCell()
		return cell
		
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return kCellHeight
	}

	//View Delegate Methods
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	
	//Actions
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func acceptButtonTapped(sender:UIButton){
		
	}
	
	func denyButtonTapped(sender:UIButton){
		self.application.state = .Denied
		println(self.application.objectId)
		var query = PFQuery(className: "NelpTaskApplication")
		query.getObjectInBackgroundWithId(self.application.objectId, block: { (application , error) -> Void in
			if error != nil{
				println(error)
			}else if let application = application{
					application["state"] = self.application.state.rawValue
					application.saveInBackground()
				}
		})
		self.delegate!.didTapDenyButton(self.applicant)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	
	
	func reviewSegmentButtonTapped(sender:UIButton){
		self.profileSegmentButton.selected = false
		self.bottomProfileBorder.hidden = true
		self.reviewSegmentButton.selected = true
		self.bottomFeedbackBorder.hidden = false
	}
	
	func profileSegmentButtonTapped(sender:UIButton){
		self.profileSegmentButton.selected = true
		self.bottomProfileBorder.hidden = false
		self.reviewSegmentButton.selected = false
		self.bottomFeedbackBorder.hidden = true
		
	}
}
//
//  PosterProfileViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-10.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire

class PosterProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SegmentControllerDelegate {
	
	let kCellHeight:CGFloat = 45
	
	var segmentControllerView: SegmentController!
	var ratingStarsView: RatingStars!
	
	var navBar:NavBar!
	var poster: User!
	var hideChatButton:Bool?
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
	var containerView:UIView!
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
	var profileContainer:UIView!
	var chatButton:UIButton!
	var conversationController:UINavigationController?
	var tempVC:UIViewController!
	var fakeButton:UIButton!
	var aboutLogo:UIImageView!
	var experienceLogo:UIImageView!
	var educationLogo:UIImageView!
	var skillsLogo:UIImageView!
	
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.createView()

	}
	
	override func viewDidAppear(animated: Bool) {
	}
	
	//MARK: UI
	
	func createView(){
		
		let navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(navBar)
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		navBar.closeButton = previousBtn
		navBar.setTitle(self.poster.name)
		
		let contentView = UIView()
		self.contentView = contentView
		self.view.addSubview(contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.width.equalTo(self.view.snp_width)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		contentView.backgroundColor = whiteNelpyColor
		
		self.setImages(self.poster)
		
		//Profile + Header
		
		let profileContainer = UIView()
		self.profileContainer = profileContainer
		self.contentView.addSubview(profileContainer)
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo(125)
		}
		profileContainer.backgroundColor = nelperRedColor
		
		//Profile Picture
		
		let pictureSize: CGFloat = 85
		let picture = UIImageView()
		self.picture = picture
		self.picture.layer.cornerRadius = pictureSize / 2;
		self.picture.layer.masksToBounds = true
		self.picture.clipsToBounds = true
		self.picture.contentMode = UIViewContentMode.ScaleAspectFill
		profileContainer.addSubview(picture)
		
		picture.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_top)
			make.centerX.equalTo(profileContainer.snp_centerX)
			make.height.equalTo(pictureSize)
			make.width.equalTo(pictureSize)
		}
		
		//Rating
		
		ratingStarsView = RatingStars()
		ratingStarsView.userRating = self.poster.rating
		ratingStarsView.style = "light"
		ratingStarsView.userCompletedTasks = 10
		profileContainer.addSubview(ratingStarsView)
		ratingStarsView.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(picture.snp_centerX)
			make.top.equalTo(picture.snp_bottom).offset(8)
			make.width.equalTo((ratingStarsView.starWidth + ratingStarsView.starPadding) * 6)
			make.height.equalTo(ratingStarsView.starHeight)
		}
		
		//SegmentControl
		
		self.segmentControllerView = SegmentController()
		self.contentView.addSubview(segmentControllerView)
		self.segmentControllerView.delegate = self
		self.segmentControllerView.items = ["Profile", "Feedback"]
		self.segmentControllerView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_bottom)
			make.centerX.equalTo(self.view.snp_centerX)
			make.width.equalTo(self.view.snp_width).offset(2)
			make.height.equalTo(50)
		}
		
		//Background View + ScrollView
		
		let background = UIView()
		self.contentView.addSubview(background)
		background.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(segmentControllerView.snp_bottom)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		self.view.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(background.snp_edges)
		}
		scrollView.backgroundColor = whiteNelpyColor
		
		let containerView = UIView()
		self.containerView = containerView
		scrollView.addSubview(containerView)
		containerView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.height.greaterThanOrEqualTo(background.snp_height)
			make.width.equalTo(background.snp_width)
		}
		self.containerView.backgroundColor = whiteNelpyColor
		background.backgroundColor = whiteNelpyColor
		
		
		//White Container
		
		let whiteContainer = UIView()
		self.containerView.addSubview(whiteContainer)
		self.whiteContainer = whiteContainer
		whiteContainer.layer.borderColor = grayDetails.CGColor
		whiteContainer.layer.borderWidth = 1
		whiteContainer.backgroundColor = whiteGrayColor
		whiteContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(containerView.snp_top).offset(20)
			make.left.equalTo(containerView.snp_left)
			make.right.equalTo(containerView.snp_right)
			make.bottom.equalTo(containerView.snp_bottom).offset(-20)
		}
		
		
		//About
		
		let aboutLogo = UIImageView()
		self.aboutLogo = aboutLogo
		whiteContainer.addSubview(aboutLogo)
		aboutLogo.image = UIImage(named: "about")
		aboutLogo.contentMode = UIViewContentMode.ScaleAspectFit
		aboutLogo.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(whiteContainer.snp_left).offset(20)
			make.top.equalTo(whiteContainer.snp_top).offset(10)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let aboutLabel = UILabel()
		self.aboutLabel = aboutLabel
		self.whiteContainer.addSubview(aboutLabel)
		aboutLabel.textColor = blackNelpyColor
		aboutLabel.text = "About"
		aboutLabel.font = UIFont(name: "Lato-Regular", size: kTitle16)
		aboutLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(aboutLogo.snp_right).offset(15)
			make.centerY.equalTo(aboutLogo.snp_centerY)
			make.height.equalTo(30)
		}
		
		let aboutTextView = UITextView()
		self.whiteContainer.addSubview(aboutTextView)
		self.aboutTextView = aboutTextView
		aboutTextView.scrollEnabled = false
		aboutTextView.textColor = blackNelpyColor
		aboutTextView.backgroundColor = whiteGrayColor
		aboutTextView.editable = false
		aboutTextView.text = self.poster.about
		aboutTextView.font = UIFont(name: "Lato-Light", size: kText14)
		aboutTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(aboutLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutLogo.snp_left).offset(4)
			make.width.equalTo(contentView.snp_width).dividedBy(1.02)
		}
		
		let fixedWidth = aboutTextView.frame.size.width
		aboutTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		let newSize = aboutTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		var newFrame = aboutTextView.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		aboutTextView.frame = newFrame;
		
		let aboutBottomLine = UIView()
		aboutBottomLine.backgroundColor = grayDetails
		whiteContainer.addSubview(aboutBottomLine)
		aboutBottomLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(aboutTextView.snp_bottom).offset(6)
			make.width.equalTo(whiteContainer.snp_width).dividedBy(1.4)
			make.centerX.equalTo(whiteContainer.snp_centerX)
			make.height.equalTo(0.5)
		}
		
		if self.poster.about == nil || self.poster.about.isEmpty{
			aboutLabel.hidden = true
			aboutBottomLine.hidden = true
			aboutLogo.hidden = true
			aboutLabel.snp_updateConstraints(closure: { (make) -> Void in
				make.height.equalTo(0)
			})
			aboutTextView.snp_updateConstraints(closure: { (make) -> Void in
				make.height.equalTo(0)
			})
			aboutLogo.snp_updateConstraints(closure: { (make) -> Void in
				make.height.equalTo(0)
			})
		}
		
		
		//My skills
		
		let skillsLogo = UIImageView()
		whiteContainer.addSubview(skillsLogo)
		self.skillsLogo = skillsLogo
		skillsLogo.image = UIImage(named: "skills")
		skillsLogo.contentMode = UIViewContentMode.ScaleAspectFit
		skillsLogo.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(aboutLogo.snp_left)
			make.top.equalTo(aboutBottomLine.snp_bottom).offset(15)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let skillsLabel = UILabel()
		self.skillsLabel = skillsLabel
		self.whiteContainer.addSubview(skillsLabel)
		skillsLabel.textColor = blackNelpyColor
		skillsLabel.text = "Skills"
		skillsLabel.font = UIFont(name: "Lato-Regular", size: kTitle16)
		skillsLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(skillsLogo.snp_centerY)
			make.left.equalTo(aboutLabel.snp_left)
			make.height.equalTo(30)
		}
		
		let skillsTableView = UITableView()
		skillsTableView.scrollEnabled = false
		self.skillsTableView = skillsTableView
		self.whiteContainer.addSubview(skillsTableView)
		skillsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		skillsTableView.delegate = self
		skillsTableView.dataSource = self
		skillsTableView.registerClass(SkillsTableViewCell.classForCoder(), forCellReuseIdentifier: SkillsTableViewCell.reuseIdentifier)
		skillsTableView.backgroundColor = whiteGrayColor
		skillsTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(skillsLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutLabel.snp_left).offset(-26)
			make.right.equalTo(containerView.snp_right).offset(-19)
			if self.poster.skills != nil{
				make.height.equalTo(self.poster.skills.count * Int(kCellHeight))
			}
		}
		
		let skillsBottomLine = UIView()
		self.skillsBottomLine = skillsBottomLine
		skillsBottomLine.backgroundColor = grayDetails
		whiteContainer.addSubview(skillsBottomLine)
		skillsBottomLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(skillsTableView.snp_bottom).offset(6)
			make.width.equalTo(whiteContainer.snp_width).dividedBy(1.4)
			make.centerX.equalTo(whiteContainer.snp_centerX)
			make.height.equalTo(0.5)
		}
		
		//Education
		
		let educationLogo = UIImageView()
		whiteContainer.addSubview(educationLogo)
		self.educationLogo = educationLogo
		educationLogo.image = UIImage(named: "diplome")
		educationLogo.contentMode = UIViewContentMode.ScaleAspectFit
		educationLogo.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(aboutLogo.snp_left)
			make.top.equalTo(skillsBottomLine.snp_bottom).offset(15)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let educationLabel = UILabel()
		self.educationLabel = educationLabel
		self.whiteContainer.addSubview(educationLabel)
		educationLabel.textColor = blackNelpyColor
		educationLabel.text = "Education"
		educationLabel.font = UIFont(name: "Lato-Regular", size: kTitle16)
		educationLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(educationLogo.snp_centerY)
			make.left.equalTo(aboutLabel.snp_left)
			make.height.equalTo(30)
		}
		
		let educationTableView = UITableView()
		educationTableView.scrollEnabled = false
		self.educationTableView = educationTableView
		self.whiteContainer.addSubview(educationTableView)
		educationTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		educationTableView.delegate = self
		educationTableView.dataSource = self
		educationTableView.registerClass(SkillsTableViewCell.classForCoder(), forCellReuseIdentifier: SkillsTableViewCell.reuseIdentifier)
		educationTableView.backgroundColor = whiteGrayColor
		educationTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(educationLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutLabel.snp_left).offset(-26)
			make.right.equalTo(containerView.snp_right).offset(-19)
			if self.poster.education != nil{
				make.height.equalTo(self.poster.education.count * Int(kCellHeight))
			}
		}
		
		let educationBottomLine = UIView()
		self.educationBottomLine = educationBottomLine
		educationBottomLine.backgroundColor = grayDetails
		whiteContainer.addSubview(educationBottomLine)
		educationBottomLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(educationTableView.snp_bottom).offset(6)
			make.width.equalTo(whiteContainer.snp_width).dividedBy(1.4)
			make.centerX.equalTo(whiteContainer.snp_centerX)
			make.height.equalTo(0.5)
		}
		
		//Work Experience
		
		let experienceLogo = UIImageView()
		whiteContainer.addSubview(experienceLogo)
		self.experienceLogo = experienceLogo
		experienceLogo.image = UIImage(named: "suitcase")
		experienceLogo.contentMode = UIViewContentMode.ScaleAspectFit
		experienceLogo.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(aboutLogo.snp_left)
			make.top.equalTo(educationBottomLine.snp_bottom).offset(15)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let experienceLabel = UILabel()
		self.experienceLabel = experienceLabel
		self.whiteContainer.addSubview(experienceLabel)
		experienceLabel.textColor = blackNelpyColor
		experienceLabel.text = "Work experience"
		experienceLabel.font = UIFont(name: "Lato-Regular", size: kTitle16)
		experienceLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(aboutLabel.snp_left)
			make.centerY.equalTo(experienceLogo.snp_centerY)
			make.height.equalTo(30)
		}
		
		let experienceTableView = UITableView()
		experienceTableView.scrollEnabled = false
		self.experienceTableView = experienceTableView
		self.whiteContainer.addSubview(experienceTableView)
		experienceTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		experienceTableView.delegate = self
		experienceTableView.dataSource = self
		experienceTableView.registerClass(SkillsTableViewCell.classForCoder(), forCellReuseIdentifier: SkillsTableViewCell.reuseIdentifier)
		experienceTableView.backgroundColor = whiteGrayColor
		experienceTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(experienceLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutLabel.snp_left).offset(-26)
			make.right.equalTo(containerView.snp_right).offset(-19)
			if self.poster.experience != nil{
				make.height.equalTo(self.poster.experience.count * Int(kCellHeight))
			}
		}
		
		//fake view
		
		let fakeView = UIView()
		whiteContainer.addSubview(fakeView)
		fakeView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(experienceTableView.snp_bottom)
			make.bottom.equalTo(whiteContainer.snp_bottom)
		}
		
		//Chat Button
		
		if self.hideChatButton != true {
		let chatButton = UIButton()
		self.chatButton = chatButton
		self.view.addSubview(chatButton)
		chatButton.backgroundColor = grayBlueColor
		chatButton.setImage(UIImage(named: "chat_icon"), forState: UIControlState.Normal)
		chatButton.setImage(UIImage(named: "down_arrow"), forState: UIControlState.Selected)
		chatButton.addTarget(self, action: "chatButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		chatButton.imageView!.contentMode = UIViewContentMode.Center
		chatButton.clipsToBounds = true
		chatButton.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(whiteContainer.snp_right).offset(2)
			make.bottom.equalTo(self.view.snp_bottom)
			make.width.equalTo(100)
			make.height.equalTo(40)
		}
		
		
		
		//Fake button for animation
		let fakeButton = UIButton()
		self.fakeButton = fakeButton
		self.view.addSubview(fakeButton)
		fakeButton.backgroundColor = grayBlueColor
		fakeButton.setImage(UIImage(named: "chat_icon"), forState: UIControlState.Normal)
		fakeButton.setImage(UIImage(named: "collapse_chat"), forState: UIControlState.Selected)
		fakeButton.imageView!.contentMode = UIViewContentMode.Center
		fakeButton.clipsToBounds = true
		fakeButton.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(whiteContainer.snp_right).offset(2)
			make.bottom.equalTo(self.view.snp_bottom)
			make.width.equalTo(100)
			make.height.equalTo(40)
		}
		
		fakeButton.hidden = true
		}

	}
	
	//MARK: DATA
	
	/**
	Set profile image
	
	- parameter poster: Task Poster
	*/
	func setImages(poster:User){
		if(poster.profilePictureURL != nil){
			let fbProfilePicture = poster.profilePictureURL
			request(.GET,fbProfilePicture!).response(){
				(_, _, data, _) in
				let image = UIImage(data: data as NSData!)
				self.picture.image = image
			}
		}
	}
	
	//MARK: Tableview delegate and datasource
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if(tableView == skillsTableView){
			if self.poster.skills != nil {
				if self.poster.skills.count == 0{
					self.skillsLabel.hidden = true
					self.skillsBottomLine.hidden = true
					self.skillsLabel.snp_updateConstraints(closure: { (make) -> Void in
						make.height.equalTo(0)
					})
					self.skillsTableView.snp_updateConstraints(closure: { (make) -> Void in
						make.height.equalTo(0)
					})
					self.skillsLogo.snp_updateConstraints(closure: { (make) -> Void in
						make.height.equalTo(0)
					})
				}
				return self.poster.skills.count
			}else{
				self.skillsLabel.hidden = true
				self.skillsLabel.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
				self.skillsTableView.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
				self.skillsLogo.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
				self.skillsBottomLine.hidden = true
			}
		}else if tableView == educationTableView{
			if self.poster.education != nil{
				if self.poster.education.count == 0{
					self.educationLabel.hidden = true
					self.educationBottomLine.hidden = true
					self.educationLabel.snp_updateConstraints(closure: { (make) -> Void in
						make.height.equalTo(0)
					})
					self.educationTableView.snp_updateConstraints(closure: { (make) -> Void in
						make.height.equalTo(0)
					})
					self.educationLogo.snp_updateConstraints(closure: { (make) -> Void in
						make.height.equalTo(0)
					})
				}
				return self.poster.education.count
			}else{
				self.educationLabel.hidden = true
				self.educationLabel.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
				self.educationTableView.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
				self.educationLogo.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
				self.educationBottomLine.hidden = true
			}
		}else if tableView == experienceTableView{
			if self.poster.experience != nil{
				if self.poster.experience.count == 0{
					self.experienceLabel.hidden = true
					self.experienceLabel.snp_updateConstraints(closure: { (make) -> Void in
						make.height.equalTo(0)
					})
					self.experienceTableView.snp_updateConstraints(closure: { (make) -> Void in
						make.height.equalTo(0)
					})
					self.experienceLogo.snp_updateConstraints(closure: { (make) -> Void in
						make.height.equalTo(0)
					})
				}
				return self.poster.experience.count
			}else{
				self.experienceLabel.hidden = true
				self.experienceLabel.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
				self.experienceTableView.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
				self.experienceLogo.snp_updateConstraints(closure: { (make) -> Void in
					make.height.equalTo(0)
				})
				
			}
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if(tableView == skillsTableView) {
			
			let skillCell = tableView.dequeueReusableCellWithIdentifier(SkillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! SkillsTableViewCell
			
			let skill = self.poster.skills[indexPath.item]
			skillCell.sendCellType("skills")
			skillCell.sendSkillName(skill["title"]!)
			skillCell.setIndex(indexPath.item)
			skillCell.hideTrashCanIcon()
			
			return skillCell
			
		}else if tableView == educationTableView{
			
			let educationCell = tableView.dequeueReusableCellWithIdentifier(SkillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! SkillsTableViewCell
			
			let education = self.poster.education[indexPath.item]
			educationCell.sendCellType("education")
			educationCell.sendSkillName(education["title"]!)
			educationCell.setIndex(indexPath.item)
			educationCell.hideTrashCanIcon()
			
			return educationCell
			
		}else if tableView == experienceTableView{
			let experienceCell = tableView.dequeueReusableCellWithIdentifier(SkillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! SkillsTableViewCell
			let experience = self.poster.experience[indexPath.item]
			experienceCell.sendCellType("experience")
			experienceCell.sendSkillName(experience["title"]!)
			experienceCell.setIndex(indexPath.item)
			experienceCell.hideTrashCanIcon()
			return experienceCell
		}
		let cell = UITableViewCell()
		return cell
		
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return kCellHeight
	}
	
	//MARK: View delegate methods
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.containerView.frame.size
		
		if self.chatButton != nil {
		let maskPath = UIBezierPath(roundedRect: chatButton.bounds, byRoundingCorners: UIRectCorner.TopLeft, cornerRadii: CGSizeMake(20.0, 20.0))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.chatButton.bounds
		maskLayer.path = maskPath.CGPath
		
		let maskLayerFake = CAShapeLayer()
		maskLayerFake.frame = self.fakeButton.bounds
		maskLayerFake.path = maskPath.CGPath
		
		self.chatButton.layer.mask = maskLayer
		self.fakeButton.layer.mask = maskLayerFake
		}
	}
	
	
	//MARK: Actions
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	/**
	Create the conversation between the two correspondants, hack to properly present the chat view (Fat and ugly method, need refactoring)
	
	- parameter sender: chat button
	*/
	
	func chatButtonTapped(sender:UIButton){
		self.chatButton.selected = !self.chatButton.selected
		if self.conversationController == nil{
			let participants = Set([self.poster.objectId])
			print(participants)
			
			
			let conversation = try? LayerManager.sharedInstance.layerClient.newConversationWithParticipants(Set([self.poster.objectId]), options: nil)
			
			//		var nextVC = ATLConversationViewController(layerClient: LayerManager.sharedInstance.layerClient)
			let nextVC = ApplicantChatViewController(layerClient: LayerManager.sharedInstance.layerClient)
			nextVC.displaysAddressBar = false
			if conversation != nil{
				nextVC.conversation = conversation
			}else{
				let query:LYRQuery = LYRQuery(queryableClass: LYRConversation.self)
				query.predicate = LYRPredicate(property: "participants", predicateOperator: LYRPredicateOperator.IsEqualTo, value: participants)
				let result = try? LayerManager.sharedInstance.layerClient.executeQuery(query)
				nextVC.conversation = result!.firstObject as! LYRConversation
			}
			let conversationNavController = UINavigationController(rootViewController: nextVC)
			self.conversationController = conversationNavController
			self.conversationController!.setNavigationBarHidden(true, animated: false)

		}
		
		if self.chatButton.selected{
			
			let tempVC = UIViewController()
			self.tempVC = tempVC
			self.addChildViewController(tempVC)
			self.view.addSubview(tempVC.view)
			//		tempVC.view.backgroundColor = UIColor.yellowColor()
			tempVC.didMoveToParentViewController(self)
			tempVC.view.backgroundColor = UIColor.clearColor()
			tempVC.view.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.profileContainer.snp_bottom)
				make.bottom.equalTo(self.view.snp_bottom)
				make.width.equalTo(self.view.snp_width)
			}
			
			tempVC.addChildViewController(self.conversationController!)
			self.conversationController!.view.frame = CGRectMake(0, tempVC.view.frame.height, tempVC.view.frame.width, tempVC.view.frame.height)
			tempVC.view.addSubview(self.conversationController!.view)
			
			self.view.layoutIfNeeded()
			UIView.animateWithDuration(0.5, animations: { () -> Void in
				self.fakeButton.hidden = false
				self.conversationController!.view.addSubview(self.chatButton)
				self.chatButton.snp_remakeConstraints(closure: { (make) -> Void in
					make.right.equalTo(self.view.snp_right).offset(2)
					make.bottom.equalTo(self.conversationController!.view.snp_top)
					make.width.equalTo(100)
					make.height.equalTo(40)
				})
				self.conversationController!.view.frame = CGRectMake(0, 0, tempVC.view.frame.width, tempVC.view.frame.height)
				}) { (didFinish) -> Void in
					self.chatButton.snp_remakeConstraints(closure: { (make) -> Void in
						self.view.addSubview(self.chatButton)
						make.right.equalTo(self.view.snp_right).offset(2)
						make.bottom.equalTo(self.profileContainer.snp_bottom)
						make.width.equalTo(100)
						make.height.equalTo(40)
					})
					self.conversationController!.didMoveToParentViewController(tempVC)
			}
		}else{
			UIView.animateWithDuration(0.5, animations: { () -> Void in
				
				self.conversationController!.view.addSubview(self.chatButton)
				self.chatButton.snp_remakeConstraints(closure: { (make) -> Void in
					make.right.equalTo(self.view.snp_right).offset(2)
					make.bottom.equalTo(self.self.conversationController!.view.snp_top)
					make.width.equalTo(100)
					make.height.equalTo(40)
				})
				self.conversationController!.view.frame = CGRectMake(0, self.tempVC.view.frame.height, self.tempVC.view.frame.width, self.tempVC.view.frame.height)
				}) { (didFinish) -> Void in
					self.view.addSubview(self.chatButton)
					self.chatButton.snp_remakeConstraints(closure: { (make) -> Void in
						make.right.equalTo(self.view.snp_right).offset(2)
						make.bottom.equalTo(self.view.snp_bottom)
						make.width.equalTo(100)
						make.height.equalTo(40)
					})
					self.conversationController!.view.removeFromSuperview()
					self.conversationController!.removeFromParentViewController()
					self.tempVC.view.removeFromSuperview()
					self.tempVC.removeFromParentViewController()
					self.fakeButton.hidden = true
			}
		}
	}
	/**
	Fake segment Control actions
	
	- parameter sender: <#sender description#>
	*/

	func onIndexChange(index: Int) {
		if index == 0 {

		} else if index == 1 {

		}
	}
	
 /**
	*  Remove Chat Button for certain profile view (Such as task details)
	*/
	
	func removeChatButton(){
		self.hideChatButton = true
	}
}

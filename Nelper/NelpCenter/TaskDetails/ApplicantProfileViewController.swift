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
	func dismissVC()
}

class ApplicantProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SegmentControllerDelegate {
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var acceptDenyBar: UIView!
	@IBOutlet weak var containerView: UIView!
	
	let kCellHeight:CGFloat = 45
	
	var segmentControllerView: SegmentController!
	var ratingStarsView: RatingStars!
	
	var previousVC:MyTaskDetailsViewController!
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
	var isAccepted:Bool?
	
	var contentView:UIView!
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
	
	convenience init(applicant:User, application:NelpTaskApplication){
		self.init(nibName: "ApplicantProfileViewController", bundle: nil)
		self.applicant = applicant
		self.application = application
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navBar.setTitle(self.applicant.name)
		self.createView()
		if self.isAccepted == true {
			self.setAsAccepted()
		}
	}
	
	//MARK: UI
	
	func createView(){
		
		self.setImages(self.applicant)
		
		//Profile + Header
		
		let profileContainer = UIView()
		self.profileContainer = profileContainer
		self.containerView.addSubview(profileContainer)
		profileContainer.backgroundColor = redPrimary
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.left.equalTo(self.containerView.snp_left)
			make.right.equalTo(self.containerView.snp_right)
			make.height.equalTo(125)
		}
		
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
		ratingStarsView.userCompletedTasks = self.applicant.completedTasks
		ratingStarsView.userRating = self.applicant.rating
		ratingStarsView.style = "light"
		profileContainer.addSubview(ratingStarsView)
		ratingStarsView.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(picture.snp_centerX)
			make.top.equalTo(picture.snp_bottom).offset(8)
			make.width.equalTo((ratingStarsView.starWidth + ratingStarsView.starPadding) * 6)
			make.height.equalTo(ratingStarsView.starHeight)
		}

		//Asking for Container
		
		//		let askingForPriceContainer = UIView()
		//		self.containerView.addSubview(askingForPriceContainer)
		//		askingForPriceContainer.snp_makeConstraints { (make) -> Void in
		//			make.top.equalTo(profileContainer.snp_bottom)
		//			make.left.equalTo(self.containerView.snp_left)
		//			make.right.equalTo(self.containerView.snp_right)
		//			make.height.equalTo(60)
		//		}
		//		askingForPriceContainer.backgroundColor = whitePrimary
		//
		//		let moneyIcon = UIImageView()
		//		askingForPriceContainer.addSubview(moneyIcon)
		//		moneyIcon.image = UIImage(named: "money_icon")
		//		moneyIcon.contentMode = UIViewContentMode.ScaleAspectFill
		//		moneyIcon.snp_makeConstraints { (make) -> Void in
		//			make.centerY.equalTo(askingForPriceContainer.snp_centerY)
		//			make.left.equalTo(askingForPriceContainer.snp_left).offset(30)
		//			make.height.equalTo(50)
		//			make.width.equalTo(50)
		//		}
		//
		//		let askingForLabel = UILabel()
		//		askingForLabel.textColor = blackPrimary
		//		askingForLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		//		if self.application.price != nil{
		//		askingForLabel.text = "\(self.application.price)$"
		//		}
		
		//Segment Controller
		
		self.segmentControllerView = SegmentController()
		self.containerView.addSubview(segmentControllerView)
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
		self.containerView.addSubview(background)
		background.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(segmentControllerView.snp_bottom)
			make.left.equalTo(self.containerView.snp_left)
			make.right.equalTo(self.containerView.snp_right)
			make.bottom.equalTo(self.acceptDenyBar.snp_top)
		}
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		self.view.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(background.snp_edges)
		}
		
		
		scrollView.backgroundColor = whiteBackground
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.closeButton = previousBtn
		
		
		let contentView = UIView()
		self.contentView = contentView
		scrollView.addSubview(contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.height.greaterThanOrEqualTo(background.snp_height)
			make.width.equalTo(background.snp_width)
		}
		self.contentView.backgroundColor = whiteBackground
		background.backgroundColor = whiteBackground
		
		
		//White Container
		
		let whiteContainer = UIView()
		self.contentView.addSubview(whiteContainer)
		self.whiteContainer = whiteContainer
		whiteContainer.layer.borderColor = grayDetails.CGColor
		whiteContainer.layer.borderWidth = 1
		whiteContainer.backgroundColor = whitePrimary
		whiteContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
			make.bottom.equalTo(contentView.snp_bottom).offset(-10)
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
		aboutLabel.textColor = blackPrimary
		aboutLabel.text = "About"
		aboutLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		aboutLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(aboutLogo.snp_right).offset(4)
			make.centerY.equalTo(aboutLogo.snp_centerY)
			make.height.equalTo(30)
		}
		
		let aboutTextView = UITextView()
		self.whiteContainer.addSubview(aboutTextView)
		self.aboutTextView = aboutTextView
		aboutTextView.scrollEnabled = false
		aboutTextView.textColor = blackPrimary
		aboutTextView.backgroundColor = whitePrimary
		aboutTextView.editable = false
		aboutTextView.text = self.applicant.about
		aboutTextView.font = UIFont(name: "Lato-Regular", size: kText15)
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
		
		let skillsLabel = UILabel()
		self.skillsLabel = skillsLabel
		self.whiteContainer.addSubview(skillsLabel)
		skillsLabel.textColor = blackPrimary
		skillsLabel.text = "Skills"
		skillsLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		skillsLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(aboutTextView.snp_bottom).offset(10)
			make.left.equalTo(aboutLabel.snp_left)
			make.height.equalTo(30)
		}
		
		let skillsLogo = UIImageView()
		whiteContainer.addSubview(skillsLogo)
		self.skillsLogo = skillsLogo
		skillsLogo.image = UIImage(named: "skills")
		skillsLogo.contentMode = UIViewContentMode.ScaleAspectFit
		skillsLogo.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(skillsLabel.snp_left).offset(-4)
			make.centerY.equalTo(skillsLabel.snp_centerY)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let skillsTableView = UITableView()
		skillsTableView.scrollEnabled = false
		self.skillsTableView = skillsTableView
		self.whiteContainer.addSubview(skillsTableView)
		skillsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		skillsTableView.delegate = self
		skillsTableView.dataSource = self
		skillsTableView.registerClass(SkillsTableViewCell.classForCoder(), forCellReuseIdentifier: SkillsTableViewCell.reuseIdentifier)
		skillsTableView.backgroundColor = whitePrimary
		skillsTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(skillsLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutLabel.snp_left)
			make.right.equalTo(containerView.snp_right).offset(-19)
			if self.applicant.skills != nil{
				make.height.equalTo(self.applicant.skills.count * Int(kCellHeight))
			}
		}
		
		let skillsBottomLine = UIView()
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
		
		let educationLabel = UILabel()
		self.educationLabel = educationLabel
		self.whiteContainer.addSubview(educationLabel)
		educationLabel.textColor = blackPrimary
		educationLabel.text = "Education"
		educationLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		educationLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(skillsTableView.snp_bottom).offset(10)
			make.left.equalTo(aboutLabel)
			make.height.equalTo(30)
		}
		
		let educationLogo = UIImageView()
		whiteContainer.addSubview(educationLogo)
		self.educationLogo = educationLogo
		educationLogo.image = UIImage(named: "diplome")
		educationLogo.contentMode = UIViewContentMode.ScaleAspectFit
		educationLogo.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(educationLabel.snp_left).offset(-4)
			make.centerY.equalTo(educationLabel.snp_centerY)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let educationTableView = UITableView()
		educationTableView.scrollEnabled = false
		self.educationTableView = educationTableView
		self.whiteContainer.addSubview(educationTableView)
		educationTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		educationTableView.delegate = self
		educationTableView.dataSource = self
		educationTableView.registerClass(SkillsTableViewCell.classForCoder(), forCellReuseIdentifier: SkillsTableViewCell.reuseIdentifier)
		educationTableView.backgroundColor = whitePrimary
		educationTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(educationLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutLabel.snp_left)
			make.right.equalTo(containerView.snp_right).offset(-19)
			if self.applicant.education != nil{
				make.height.equalTo(self.applicant.education.count * Int(kCellHeight))
			}
		}
		
		let educationBottomLine = UIView()
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
		
		let experienceLabel = UILabel()
		self.experienceLabel = experienceLabel
		self.whiteContainer.addSubview(experienceLabel)
		experienceLabel.textColor = blackPrimary
		experienceLabel.text = "Work experience"
		experienceLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		experienceLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(educationTableView.snp_bottom).offset(10)
			make.left.equalTo(aboutLabel)
			make.height.equalTo(30)
		}
		
		let experienceLogo = UIImageView()
		whiteContainer.addSubview(experienceLogo)
		self.experienceLogo = experienceLogo
		experienceLogo.image = UIImage(named: "suitcase")
		experienceLogo.contentMode = UIViewContentMode.ScaleAspectFit
		experienceLogo.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(experienceLabel.snp_left).offset(-4)
			make.centerY.equalTo(experienceLabel.snp_centerY)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let experienceTableView = UITableView()
		experienceTableView.scrollEnabled = false
		self.experienceTableView = experienceTableView
		self.whiteContainer.addSubview(experienceTableView)
		experienceTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		experienceTableView.delegate = self
		experienceTableView.dataSource = self
		experienceTableView.registerClass(SkillsTableViewCell.classForCoder(), forCellReuseIdentifier: SkillsTableViewCell.reuseIdentifier)
		experienceTableView.backgroundColor = whitePrimary
		experienceTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(experienceLabel.snp_bottom).offset(6)
			make.left.equalTo(aboutLabel.snp_left)
			make.right.equalTo(containerView.snp_right).offset(-19)
			if self.applicant.experience != nil{
				make.height.equalTo(self.applicant.experience.count * Int(kCellHeight))
			}
		}
		
		//fake view
		
		let fakeView = UIView()
		whiteContainer.addSubview(fakeView)
		fakeView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(experienceTableView.snp_bottom)
			make.bottom.equalTo(whiteContainer.snp_bottom)
		}
		
		//Accept Deny Bar
		
		self.acceptDenyBar.backgroundColor = redPrimary
		
		let acceptButton = UIButton()
		self.acceptButton = acceptButton
		self.acceptDenyBar.addSubview(acceptButton)
		self.acceptButton.addTarget(self, action: "acceptButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		acceptButton.setBackgroundImage(UIImage(named:"white_accepted.png"), forState: UIControlState.Normal)
		acceptButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(acceptDenyBar.snp_centerX).offset(60)
			make.centerY.equalTo(acceptDenyBar.snp_centerY)
			make.width.equalTo(40)
			make.height.equalTo(40)
		}
		
		let denyButton = UIButton()
		self.acceptDenyBar.addSubview(denyButton)
		self.denyButton = denyButton
		self.denyButton.addTarget(self, action: "denyButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		denyButton.setBackgroundImage(UIImage(named:"white_denied.png"), forState: UIControlState.Normal)
		denyButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(acceptDenyBar.snp_centerX).offset(-60)
			make.centerY.equalTo(acceptDenyBar.snp_centerY)
			make.width.equalTo(40)
			make.height.equalTo(40)
		}
		
		//Chat Button
		
		let chatButton = UIButton()
		self.chatButton = chatButton
		self.view.addSubview(chatButton)
		chatButton.backgroundColor = grayBlue
		chatButton.setImage(UIImage(named: "chat_icon"), forState: UIControlState.Normal)
		chatButton.setImage(UIImage(named: "down_arrow"), forState: UIControlState.Selected)
		chatButton.addTarget(self, action: "chatButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		chatButton.imageView!.contentMode = UIViewContentMode.Center
		chatButton.clipsToBounds = true
		chatButton.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(whiteContainer.snp_right).offset(2)
			make.bottom.equalTo(acceptDenyBar.snp_top)
			make.width.equalTo(100)
			make.height.equalTo(40)
		}
		
		
		
		//Fake button for animation
		let fakeButton = UIButton()
		self.fakeButton = fakeButton
		self.view.addSubview(fakeButton)
		fakeButton.backgroundColor = grayBlue
		fakeButton.setImage(UIImage(named: "chat_icon"), forState: UIControlState.Normal)
		fakeButton.setImage(UIImage(named: "collapse_chat"), forState: UIControlState.Selected)
		fakeButton.imageView!.contentMode = UIViewContentMode.Center
		fakeButton.clipsToBounds = true
		fakeButton.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(whiteContainer.snp_right).offset(2)
			make.bottom.equalTo(acceptDenyBar.snp_top)
			make.width.equalTo(100)
			make.height.equalTo(40)
		}
		
		fakeButton.hidden = true
	}
	
	//MARK: DATA
	
	/**
	Set the Applicant Profile Picture
	
	- parameter applicant: The Applicant
	*/

	func setImages(applicant:User){
		if(applicant.profilePictureURL != nil){
			let fbProfilePicture = applicant.profilePictureURL
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
					self.skillsLogo.snp_updateConstraints(closure: { (make) -> Void in
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
				self.skillsLogo.snp_updateConstraints(closure: { (make) -> Void in
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
					self.educationLogo.snp_updateConstraints(closure: { (make) -> Void in
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
				self.educationLogo.snp_updateConstraints(closure: { (make) -> Void in
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
					self.experienceLogo.snp_updateConstraints(closure: { (make) -> Void in
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
			
			let skill = self.applicant.skills[indexPath.item]
			skillCell.sendCellType("skills")
			skillCell.sendSkillName(skill["title"]!)
			skillCell.setIndex(indexPath.item)
			skillCell.hideTrashCanIcon()
			
			return skillCell
			
		}else if tableView == educationTableView{
			
			let educationCell = tableView.dequeueReusableCellWithIdentifier(SkillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! SkillsTableViewCell
			
			let education = self.applicant.education[indexPath.item]
			educationCell.sendCellType("education")
			educationCell.sendSkillName(education["title"]!)
			educationCell.setIndex(indexPath.item)
			educationCell.hideTrashCanIcon()
			
			return educationCell
			
		}else if tableView == experienceTableView{
			let experienceCell = tableView.dequeueReusableCellWithIdentifier(SkillsTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! SkillsTableViewCell
			let experience = self.applicant.experience[indexPath.item]
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
		self.scrollView.contentSize = self.contentView.frame.size
		
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
	
	//MARK: Setters
	
	/**
	Sets the Applicant as Accepted in order to make some small UI Changes
	*/
	func setAsAccepted(){
		self.denyButton.removeFromSuperview()
		self.acceptButton.snp_remakeConstraints { (make) -> Void in
			make.centerY.equalTo(self.acceptDenyBar.snp_centerY)
			make.centerX.equalTo(self.acceptDenyBar.snp_centerX)
			make.height.equalTo(50)
			make.width.equalTo(50)
		}
		self.acceptButton.userInteractionEnabled = false
	}
	
	//MARK: Actions
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func acceptButtonTapped(sender:UIButton){
		self.application.state = .Accepted
		let query = PFQuery(className: "NelpTaskApplication")
		query.getObjectInBackgroundWithId(self.application.objectId, block: { (application , error) -> Void in
			if error != nil{
				print(error)
			}else if let application = application{
				application["state"] = self.application.state.rawValue
				application.saveInBackground()
			}
		})
		self.application.task.state = .Accepted
		let queryTask = PFQuery(className: "NelpTask")
		queryTask.getObjectInBackgroundWithId(self.application.task.objectId, block: { (task , error) -> Void in
			if error != nil{
				print(error)
			}else if let task = task{
				task["state"] = self.application.task.state.rawValue
				task.saveInBackground()
			}
		})
		self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func denyButtonTapped(sender:UIButton){
		self.application.state = .Denied
		let query = PFQuery(className: "NelpTaskApplication")
		query.getObjectInBackgroundWithId(self.application.objectId, block: { (application , error) -> Void in
			if error != nil{
				print(error)
			}else if let application = application{
				application["state"] = self.application.state.rawValue
				application.saveInBackground()
			}
		})
		self.delegate!.didTapDenyButton(self.applicant)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	/**
	Create the conversation between the two correspondants, hack to properly present the chat view (Fat and ugly method, need refactoring)
	
	- parameter sender: chat button
	*/
	
	func chatButtonTapped(sender:UIButton){
		
		self.chatButton.selected = !self.chatButton.selected
		if self.conversationController == nil{
			let participants = Set([self.applicant.objectId])
			print(participants)
			
			let conversation = try? LayerManager.sharedInstance.layerClient.newConversationWithParticipants(Set([self.applicant.objectId]), options: nil)
			
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
				make.bottom.equalTo(acceptDenyBar.snp_bottom)
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
		} else {
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
						make.bottom.equalTo(self.acceptDenyBar.snp_top)
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
	
	func onIndexChange(index: Int) {
		if index == 0 {

		} else if index == 1 {

		}
	}
	
}
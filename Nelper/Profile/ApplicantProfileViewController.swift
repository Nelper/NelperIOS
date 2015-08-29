//
//  ApplicantProfileViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-27.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire

class ApplicantProfileViewController: UIViewController{
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var acceptDenyBar: UIView!
	@IBOutlet weak var containerView: UIView!
	
	var applicant: User!
	var picture:UIImageView!
	var firstStar:UIImageView!
	var secondStar:UIImageView!
	var thirdStar:UIImageView!
	var fourthStar:UIImageView!
	var fifthStar:UIImageView!
	
	var contentView:UIView!
	
	//Init
	convenience init(applicant:User){
		self.init(nibName: "ApplicantProfileViewController", bundle: nil)
		self.applicant = applicant
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.createView()
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
		firstHalf.addSubview(profileSegmentButton)
		profileSegmentButton.setTitle("Profile", forState: UIControlState.Normal)
		profileSegmentButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		profileSegmentButton.setTitleColor(blueGrayColor, forState: UIControlState.Normal)
		profileSegmentButton.setTitleColor(blueGrayColor, forState: UIControlState.Selected)
		profileSegmentButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(firstHalf.snp_centerX)
			make.top.equalTo(firstHalf.snp_top)
			make.width.equalTo(firstHalf.snp_width)
			make.bottom.equalTo(firstHalf.snp_bottom).offset(-2)
		}
		
		let bottomProfileBorder = UIView()
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
	
	
		//Accept Deny Bar
		
		self.acceptDenyBar.backgroundColor = blueGrayColor
		
		var acceptButton = UIButton()
		self.acceptDenyBar.addSubview(acceptButton)
		acceptButton.setBackgroundImage(UIImage(named:"white_accepted.png"), forState: UIControlState.Normal)
		acceptButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(acceptDenyBar.snp_centerX).offset(60)
			make.centerY.equalTo(acceptDenyBar.snp_centerY)
			make.width.equalTo(50)
			make.height.equalTo(50)
		}
		
		var denyButton = UIButton()
		self.acceptDenyBar.addSubview(denyButton)
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
	
	//Actions
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
}
//
//  MyApplicationDetailsView.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-01.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire
import iCarousel

protocol MyApplicationDetailsViewDelegate {
	func didCancelApplication(application:TaskApplication)
}

class MyApplicationDetailsView: UIViewController {
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var containerView: UIView!
	
	let kCellHeight: CGFloat = 45
	
	var poster: User!
	var application: TaskApplication!
	var picture: UIImageView!
	var scrollView: UIScrollView!
	var delegate: MyApplicationDetailsViewDelegate!
	
	var contentView: UIView!
	var whiteContainer: UIView!
	var statusContainer: UIView!
	var chatButton: UIButton!
	var conversationController: UINavigationController?
	var tempVC: UIViewController!
	var fakeButton: UIButton!
	var cityLabel: UILabel!
	var postDateLabel: UILabel!
	var applicationStatusIcon: UIImageView!
	var statusLabel: UILabel!
	var cancelButton: SecondaryActionButton!
	var whiteView:UIView!
	
	
	//MARK: Initialization
	
	convenience init(poster: User, application: TaskApplication){
		self.init(nibName: "MyApplicationDetailsView", bundle: nil)
		self.poster = poster
		self.application = application
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let previousBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = previousBtn
		self.navBar.setTitle("My Application")
		self.createView()
		self.setImages(self.poster)
	}
	
	//MARK: View Creation
	
	func createView() {
		
		//Background View + ScrollView
		
		let background = UIView()
		self.containerView.addSubview(background)
		background.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.containerView)
			make.left.equalTo(self.containerView.snp_left)
			make.right.equalTo(self.containerView.snp_right)
			make.bottom.equalTo(self.containerView.snp_bottom)
		}
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		self.containerView.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(background.snp_edges)
		}
		
		scrollView.backgroundColor = Color.whiteBackground
		
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
		self.contentView.backgroundColor = Color.whiteBackground
		background.backgroundColor = Color.whiteBackground
		
		//Status Container
		
		let statusContainer = ApplicationSummaryView(application: self.application)
		self.statusContainer = statusContainer
		self.contentView.addSubview(statusContainer)
		statusContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView).offset(20)
			make.left.equalTo(self.containerView.snp_left).offset(-1)
			make.right.equalTo(self.containerView.snp_right).offset(1)
		}
				
		//Profile Container
		
		let profileContainer = ProfileCellView(user: self.application.task.user)
		profileContainer.button.addTarget(self, action: "didTapProfile:", forControlEvents: .TouchUpInside)
		self.picture = profileContainer.picture
		self.contentView.addSubview(profileContainer)
		profileContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(statusContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
			make.height.equalTo(90)
		}
		
		//Task info container
		
		let taskInfoContainer = TaskInfoView(application: self.application, accepted: false)
		contentView.addSubview(taskInfoContainer)
		taskInfoContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(profileContainer.snp_bottom).offset(20)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
		}
		
		//Cancel
		
		let cancelContainer = UIView()
		contentView.addSubview(cancelContainer)
		cancelContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskInfoContainer.snp_bottom).offset(30)
			make.width.equalTo(self.contentView.snp_width)
			make.height.equalTo(100)
			make.bottom.equalTo(self.contentView.snp_bottom)
		}
		
		let cancelButton = SecondaryActionButton()
		cancelContainer.addSubview(cancelButton)
		cancelButton.setTitle("Cancel Application", forState: UIControlState.Normal)
		cancelButton.addTarget(self, action: "didTapCancelButton:", forControlEvents: UIControlEvents.TouchUpInside)
		cancelButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cancelContainer.snp_top)
			make.centerX.equalTo(cancelContainer.snp_centerX)
		}
		
		//Chat Button
		
		let chatButton = UIButton()
		self.chatButton = chatButton
		self.view.addSubview(chatButton)
		chatButton.backgroundColor = Color.grayBlue
		chatButton.setImage(UIImage(named: "chat_icon"), forState: UIControlState.Normal)
		chatButton.setImage(UIImage(named: "down_arrow"), forState: UIControlState.Selected)
		chatButton.addTarget(self, action: "chatButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		chatButton.imageView!.contentMode = UIViewContentMode.Center
		chatButton.clipsToBounds = true
		chatButton.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.contentView.snp_right).offset(2)
			make.bottom.equalTo(self.view.snp_bottom)
			make.width.equalTo(100)
			make.height.equalTo(40)
		}
		
		//Fake button for animation
		let fakeButton = UIButton()
		self.fakeButton = fakeButton
		self.view.addSubview(fakeButton)
		fakeButton.backgroundColor = Color.grayBlue
		fakeButton.setImage(UIImage(named: "chat_icon"), forState: UIControlState.Normal)
		fakeButton.setImage(UIImage(named: "collapse_chat"), forState: UIControlState.Selected)
		fakeButton.imageView!.contentMode = UIViewContentMode.Center
		fakeButton.clipsToBounds = true
		fakeButton.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.contentView.snp_right).offset(2)
			make.bottom.equalTo(self.view.snp_bottom)
			make.width.equalTo(100)
			make.height.equalTo(40)
		}
		
		fakeButton.hidden = true
	}
	
	
	//MARK: DATA
	
	/**
	Sets the Applications images(Category, Task poster profile pic)
	
	- parameter applicant: Task Poster
	*/
	func setImages(applicant:User) {
		if(applicant.profilePictureURL != nil) {
			let fbProfilePicture = applicant.profilePictureURL
			request(.GET,fbProfilePicture!).response() {
				(_, _, data, _) in
				let image = UIImage(data: data as NSData!)
				self.picture.image = image
			}
		}
	}
	
	//MARK: View Delegate Methods
	
	/**
	Used to set the Scrollview proper contentsize AND shape the chat button
	*/
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
		
		let maskPath = UIBezierPath(roundedRect: chatButton.bounds, byRoundingCorners: UIRectCorner.TopLeft, cornerRadii: CGSizeMake(20.0, 20.0))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.chatButton.bounds
		maskLayer.path = maskPath.CGPath
		
		_ = UIBezierPath(roundedRect: self.fakeButton.bounds, byRoundingCorners: UIRectCorner.TopLeft, cornerRadii: CGSizeMake(20.0, 20.0))
		let maskLayerFake = CAShapeLayer()
		maskLayerFake.frame = self.fakeButton.bounds
		maskLayerFake.path = maskPath.CGPath
		
		self.chatButton.layer.mask = maskLayer
		self.fakeButton.layer.mask = maskLayerFake
	}
	
	//MARK: Actions
	
	func backButtonTapped(sender:UIButton){
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func didTapCancelButton(sender:UIButton){
		if sender.selected == false {
			sender.selected = true
			sender.setTitle("Sure?", forState: UIControlState.Selected)
			
		} else if sender.selected == true{
			ApiHelper.cancelApplyForTaskWithApplication(self.application)
			self.application.state = .Canceled
			self.delegate.didCancelApplication(self.application)
			self.navigationController?.popViewControllerAnimated(true)
		}
	}
	
	/**
	When the task poster view is tapped
	
	- parameter sender: Poster Profile View
	*/
	func didTapProfile(sender:UIView){
		let nextVC = PosterProfileViewController()
		nextVC.poster = self.poster
		nextVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
		self.navigationController?.pushViewController(nextVC, animated: true)
	}
	
	
	/**
	Create the conversation between the two correspondants, hack to properly present the chat view (Fat and ugly method, need refactoring)
	
	- parameter sender: chat button
	*/
	
	func chatButtonTapped(sender:UIButton){
		
		self.chatButton.selected = !self.chatButton.selected
		
		if self.conversationController == nil{
			let _:NSError?
			let participants = Set([self.poster.objectId])
			print(participants)
			
			
			let conversation = try? LayerManager.sharedInstance.layerClient.newConversationWithParticipants(Set([self.poster.objectId]), options: nil)
			
			//	var nextVC = ATLConversationViewController(layerClient: LayerManager.sharedInstance.layerClient)
			let nextVC = ApplicantChatViewController(layerClient: LayerManager.sharedInstance.layerClient)
			nextVC.displaysAddressBar = false
			if conversation != nil{
				nextVC.conversation = conversation
			} else {
				let query:LYRQuery = LYRQuery(queryableClass: LYRConversation.self)
				query.predicate = LYRPredicate(property: "participants", predicateOperator: LYRPredicateOperator.IsEqualTo, value: participants)
				let result = try! LayerManager.sharedInstance.layerClient.executeQuery(query)
				nextVC.conversation = result.firstObject as! LYRConversation
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
			//tempVC.view.backgroundColor = UIColor.yellowColor()
			tempVC.didMoveToParentViewController(self)
			tempVC.view.backgroundColor = UIColor.clearColor()
			tempVC.view.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.statusContainer.snp_top)
				make.bottom.equalTo(self.view.snp_bottom)
				make.width.equalTo(self.view.snp_width)
			}
			//Temporary hack for Atlas bug
			
			let whiteView = UIView()
			self.whiteView = whiteView
			whiteView.alpha = 0
			whiteView.backgroundColor = UIColor.whiteColor()
			tempVC.view.addSubview(whiteView)
			whiteView.snp_makeConstraints(closure: { (make) -> Void in
				make.bottom.equalTo(tempVC.view)
				make.width.equalTo(tempVC.view)
				make.height.equalTo(80)
			})
			
			
			tempVC.addChildViewController(self.conversationController!)
			_ = UIScreen.mainScreen().bounds.height -  (UIScreen.mainScreen().bounds.height - self.statusContainer.frame.height)
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
						make.bottom.equalTo(self.statusContainer.snp_top)
						make.width.equalTo(100)
						make.height.equalTo(40)
					})
					whiteView.alpha = 1
					self.conversationController!.didMoveToParentViewController(tempVC)
			}
		}else{
			
			
			UIView.animateWithDuration(0.5, animations: { () -> Void in
				self.whiteView.alpha = 0
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
}

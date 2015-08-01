//
//  ProfileViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-06.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {
	
	
	
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var navBar: UIView!
	@IBOutlet weak var settingsButton: UIButton!
	
	
	@IBOutlet weak var infoContainer: UIView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var profilePicture: UIImageView!
	@IBOutlet weak var firstStar: UIImageView!
	@IBOutlet weak var secondStar: UIImageView!
	@IBOutlet weak var thirdStar: UIImageView!
	@IBOutlet weak var fourthStar: UIImageView!
	@IBOutlet weak var fifthStar: UIImageView!
	@IBOutlet weak var completedTasksString: UILabel!
	
	@IBOutlet weak var taskTypeSelectorContainer: UIView!
	@IBOutlet weak var activeTasksButton: UIButton!
	@IBOutlet weak var completedTasksButton: UIButton!
	
	@IBOutlet weak var taskVCContainer: UIView!
	
	@IBOutlet weak var tabBarView: UIView!
	@IBOutlet weak var nelpTabBarImage: UIButton!
	@IBOutlet weak var findNelpTabBarImage: UIButton!
	@IBOutlet weak var profileTabBarImage: UIButton!
	
	
	var tasksCompleted = 0
	
//	INITIALIZER
  convenience init() {
    self.init(nibName: "ProfileViewController", bundle: nil)
	}
  
  override func viewDidLoad() {
    super.viewDidLoad()
		
		if(PFUser.currentUser()?.username == nil){
		showNeedToLoginScreen()
		}else{
		getFacebookInfos()
		adjustUI()
		}
	}
	
//	DATA
	func getFacebookInfos(){
		
		var fbProfilePicture = (PFUser.currentUser()!.objectForKey("pictureURL") as? String)!
		request(.GET,fbProfilePicture).response(){
				(_, _, data, _) in
				var image = UIImage(data: data as NSData!)
				self.profilePicture.image = image
				}
}

//	UI
	
	func adjustUI(){
		self.logoImage.image = UIImage(named: "logo_nobackground_v2")
		self.logoImage.contentMode = UIViewContentMode.ScaleAspectFit
		self.settingsButton.setBackgroundImage(UIImage(named:"cogwheel.png"), forState: UIControlState.Normal)
		self.navBar.backgroundColor = orangeMainColor
		
		self.infoContainer.backgroundColor = orangeSecondaryColor
		self.nameLabel.text = PFUser.currentUser()?.objectForKey("name") as? String
		self.nameLabel.font = UIFont(name: "Railway", size: kTitleFontSize)
		self.nameLabel.textColor = whiteNelpyColor
		self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
		self.profilePicture.clipsToBounds = true;
		self.profilePicture.layer.borderWidth = 3;
		self.profilePicture.layer.borderColor = whiteNelpyColor.CGColor
		
		self.firstStar.image = UIImage(named:"empty_star.png")
		self.secondStar.image = UIImage(named:"empty_star.png")
		self.thirdStar.image = UIImage(named:"empty_star.png")
		self.fourthStar.image = UIImage(named:"empty_star.png")
		self.fifthStar.image = UIImage(named:"empty_star.png")
		
		self.completedTasksString.text = "\(String(tasksCompleted)) tasks completed"
		self.completedTasksString.font = UIFont(name: "Railway", size: kSubtitleFontSize)
		self.completedTasksString.textColor = whiteNelpyColor
		
		self.taskTypeSelectorContainer.backgroundColor = orangeMainColor
		self.activeTasksButton.titleLabel?.font = UIFont(name: "Railway", size: kTextFontSize);
		self.activeTasksButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.completedTasksButton.titleLabel?.font = UIFont(name: "Railway", size: kTextFontSize);
		self.completedTasksButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		
		self.taskVCContainer.backgroundColor = whiteNelpyColor
		
		self.tabBarView.backgroundColor = orangeMainColor
		self.nelpTabBarImage.setBackgroundImage(UIImage(named: "help_white.png"), forState: UIControlState.Normal)
		self.findNelpTabBarImage.setBackgroundImage(UIImage(named: "search_white.png"), forState: UIControlState.Normal)
		self.profileTabBarImage.setBackgroundImage(UIImage(named: "profile_black.png"), forState: UIControlState.Normal)
}
		
		func showNeedToLoginScreen(){
			
			self.logoImage.image = UIImage(named: "logo_nobackground_v2")
			self.logoImage.contentMode = UIViewContentMode.ScaleAspectFit
			self.settingsButton.setBackgroundImage(UIImage(named:"cogwheel.png"), forState: UIControlState.Normal)
			self.navBar.backgroundColor = orangeMainColor
			self.tabBarView.backgroundColor = orangeMainColor
			self.nelpTabBarImage.setBackgroundImage(UIImage(named: "help_white.png"), forState: UIControlState.Normal)
			self.findNelpTabBarImage.setBackgroundImage(UIImage(named: "search_white.png"), forState: UIControlState.Normal)
			self.profileTabBarImage.setBackgroundImage(UIImage(named: "profile_black.png"), forState: UIControlState.Normal)
			self.taskVCContainer.backgroundColor = orangeSecondaryColor
			
			self.infoContainer.backgroundColor = orangeSecondaryColor
			self.nameLabel.removeFromSuperview()
			self.profilePicture.removeFromSuperview()
			self.firstStar.removeFromSuperview()
			self.secondStar.removeFromSuperview()
			self.thirdStar.removeFromSuperview()
			self.fourthStar.removeFromSuperview()
			self.fifthStar.removeFromSuperview()
			self.completedTasksString.removeFromSuperview()
			self.activeTasksButton.removeFromSuperview()
			self.completedTasksButton.removeFromSuperview()
			
			
			self.taskTypeSelectorContainer.backgroundColor = orangeSecondaryColor
			
			var button = UIButton()
			button.backgroundColor = facebookBlueColor
			button.layer.cornerRadius = 6
			button.setTitle("Login with Facebook", forState: UIControlState.Normal)
			button.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
			button.titleLabel?.font = UIFont(name: "Railway", size: kSubtitleFontSize)
			button.layer.borderColor = blackNelpyColor.CGColor
			button.layer.borderWidth = 2
			button.setImage(UIImage(named: "facebookButtonIcon"), forState: UIControlState.Normal)
			button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 6)
			self.taskTypeSelectorContainer.addSubview(button)
			button.addTarget(self, action: "facebookLoginPressed:", forControlEvents: .TouchUpInside)
			
			button.snp_makeConstraints { (make) -> Void in
				make.center.equalTo(self.taskTypeSelectorContainer)
				make.width.equalTo(225)
				make.height.equalTo(50)
			}
			
			var nelpyBubble = UIImageView()
			nelpyBubble.image = UIImage(named: "bubble.png")
			self.infoContainer.addSubview(nelpyBubble)
			
			nelpyBubble.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.logoImage).offset(40)
				make.left.equalTo(self.infoContainer.snp_left).offset(40)
				make.right.equalTo(self.infoContainer.snp_right).offset(-40)
				make.height.equalTo(70)
			}
			
			var nelpyText = UILabel()
			nelpyText.numberOfLines = 0
			nelpyText.text = "You need to login to have a profile!"
			nelpyText.textColor = blackNelpyColor
			nelpyText.font = UIFont(name: "Railway", size: kTextFontSize)
			nelpyText.textAlignment = NSTextAlignment.Center
			self.infoContainer.addSubview(nelpyText)
			
			nelpyText.snp_makeConstraints { (make) -> Void in
				
				make.top.equalTo(self.logoImage).offset(50)
				make.left.equalTo(self.infoContainer.snp_left).offset(50)
				make.right.equalTo(self.infoContainer.snp_right).offset(-50)
				make.height.equalTo(60)
				
			}
			
		}
	
	func facebookLoginPressed (sender:UIButton!){
		
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
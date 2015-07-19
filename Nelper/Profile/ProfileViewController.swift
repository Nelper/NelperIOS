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
	
	var tasksCompleted = 0
	
//	INITIALIZER
  convenience init() {
    self.init(nibName: "ProfileViewController", bundle: nil)
	}
  
  override func viewDidLoad() {
    super.viewDidLoad()
		getFacebookInfos()
		adjustUI()
	}
	
//	DATA
	func getFacebookInfos(){
		
		var fbProfilePicture = (PFUser.currentUser()!.objectForKey("pictureURL") as? String)!
		request(.GET,fbProfilePicture).response(){
				(_, _, data, _) in
				var image = UIImage(data: data as! NSData)
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
}


}
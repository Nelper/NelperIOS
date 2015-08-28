//
//  ApplicantProfileViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-27.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class ApplicantProfileViewController: UIViewController{
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var background: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var acceptDenyBar: UIView!
	
	var applicant: User!
	
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
			make.height.greaterThanOrEqualTo(self.background.snp_height)
			make.width.equalTo(self.background.snp_width)
		}
		self.contentView.backgroundColor = whiteNelpyColor
		self.background.backgroundColor = whiteNelpyColor
	
	
		//Accept Deny Bar
		
		self.acceptDenyBar.backgroundColor = blueGrayColor
		
		var acceptButton = UIButton()
		self.acceptDenyBar.addSubview(acceptButton)
		acceptButton.setBackgroundImage(UIImage(named:"accepted.png"), forState: UIControlState.Normal)
		acceptButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(acceptDenyBar.snp_centerX).offset(-60)
			make.centerY.equalTo(acceptDenyBar.snp_centerY)
			make.width.equalTo(50)
			make.height.equalTo(50)
		}
		
		var denyButton = UIButton()
		self.acceptDenyBar.addSubview(denyButton)
		denyButton.setBackgroundImage(UIImage(named:"denied.png"), forState: UIControlState.Normal)
		denyButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(acceptDenyBar.snp_centerX).offset(60)
			make.centerY.equalTo(acceptDenyBar.snp_centerY)
			make.width.equalTo(50)
			make.height.equalTo(50)
		}
		
	}
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
}
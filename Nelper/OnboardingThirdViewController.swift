//
//  OnboardingThirdViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-29.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class OnboardingThirdViewController: UIViewController {
	
	var goButton: PrimaryActionButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.createView()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		UIView.animateWithDuration(0.4, delay: 0.0, options: [.CurveEaseOut], animations:  {
			self.goButton.transform = CGAffineTransformMakeTranslation(0, 0)
			self.goButton.alpha = 1
			}, completion: nil)
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		
		self.goButton.transform = CGAffineTransformMakeTranslation(self.view.frame.width, 0)
		self.goButton.alpha = 0
	}
	
	func createView() {
		
		let contentView = UIView()
		self.view.addSubview(contentView)
		contentView.backgroundColor = Color.whitePrimary
		contentView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view.snp_edges)
		}
		
		contentView.layoutIfNeeded()
		
		let titleLabel = UILabel()
		contentView.addSubview(titleLabel)
		titleLabel.text = "Nelpah"
		titleLabel.textColor = Color.textFieldTextColor
		titleLabel.font = UIFont(name: "Lato-Light", size: 30)
		titleLabel.textAlignment = NSTextAlignment.Center
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(50)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		let goButton =  PrimaryActionButton()
		self.goButton = goButton
		contentView.addSubview(goButton)
		goButton.setTitle("Get Started", forState: .Normal)
		goButton.setTitleColor(Color.whitePrimary, forState: UIControlState.Normal)
		goButton.backgroundColor = Color.redPrimary
		goButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: kTitle17)
		goButton.addTarget(self, action: "goButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		goButton.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(contentView.snp_bottom).offset(-60)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		goButton.transform = CGAffineTransformMakeTranslation(contentView.frame.width, 0)
		goButton.alpha = 0
	}
	
//MARK: Actions
	
	func goButtonTapped(sender: UIButton) {
		
	}
	
}
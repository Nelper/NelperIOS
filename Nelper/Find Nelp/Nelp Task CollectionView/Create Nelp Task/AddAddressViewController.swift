//
//  AddAddressViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-24.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

protocol AddAddressViewControllerDelegate{
	func didClosePopup(vc:AddAddressViewController)
}

class AddAddressViewController:UIViewController, UIGestureRecognizerDelegate{

	var delegate:AddAddressViewControllerDelegate?
	var popupContainer: UIView!
	var tap: UITapGestureRecognizer!
	var blurContainer:UIVisualEffectView!
	
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.createView()
		self.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
		self.definesPresentationContext = true
		self.providesPresentationContextTransitionStyle = true
		
	}
	
	//MARK: View Creation
	
	func createView(){
		
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
		let blurContainer = UIVisualEffectView(effect: blurEffect)
		self.blurContainer = blurContainer
		blurContainer.frame = self.view.bounds
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissPopup")
		self.tap = tap
		self.tap.delegate = self
		blurContainer.addGestureRecognizer(tap)
		
		self.view.backgroundColor = UIColor.clearColor()
		self.view.backgroundColor = UIColor.clearColor()
		self.view.addSubview(blurContainer)
		
		let popupContainer = UIView()
		self.popupContainer = popupContainer
		popupContainer.layer.cornerRadius = 2
		popupContainer.layer.borderColor = nelperRedColor.CGColor
		popupContainer.layer.borderWidth = 3
		popupContainer.backgroundColor = whiteNelpyColor
		blurContainer.addSubview(popupContainer)
		popupContainer.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(500)
			make.left.equalTo(blurContainer.snp_left).offset(8)
			make.right.equalTo(blurContainer.snp_right).offset(-8)
			make.top.equalTo(blurContainer.snp_top).offset(40)
		}
	}
	

	//MARK: View delegate methods
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	//MARK: Gesture recognizer delegate methods
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if touch.view!.isDescendantOfView(self.popupContainer){
			return false
		}
		return true
	}
	
	func dismissPopup(){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	//MARK: Actionss

}


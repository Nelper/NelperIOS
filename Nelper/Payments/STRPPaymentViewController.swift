//
//  STRPPaymentViewController.swift
//  
//
//  Created by Charles Vinette on 2015-09-02.
//
//

import Foundation
import Stripe

protocol STRPPaymentViewControllerDelegate{
	func didClosePopup(vc:STRPPaymentViewController)
}

class STRPPaymentViewController:UIViewController, STPPaymentCardTextFieldDelegate, UIGestureRecognizerDelegate{

	var cardTextField: STPPaymentCardTextField!
	var delegate:STRPPaymentViewControllerDelegate?
	var saveButton:UIButton!
	var popupContainer: UIView!
	var titleLabel: UILabel!
	var tap: UITapGestureRecognizer!
	var blurContainer:UIVisualEffectView!
	
	
	//Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.createView()
		self.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
		self.definesPresentationContext = true
		self.providesPresentationContextTransitionStyle = true
		
	}
	
	
	func createView(){
		
		var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
		var blurContainer = UIVisualEffectView(effect: blurEffect)
		self.blurContainer = blurContainer
		blurContainer.frame = self.view.bounds
		
		var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissPopup")
		self.tap = tap
		self.tap.delegate = self
		blurContainer.addGestureRecognizer(tap)
		
		self.view.backgroundColor = UIColor.clearColor()
		self.view.backgroundColor = UIColor.clearColor()
		self.view.addSubview(blurContainer)
		
		var popupContainer = UIView()
		self.popupContainer = popupContainer
		popupContainer.layer.cornerRadius = 2
		popupContainer.layer.borderColor = blueGrayColor.CGColor
		popupContainer.layer.borderWidth = 3
		popupContainer.backgroundColor = whiteNelpyColor
		blurContainer.addSubview(popupContainer)
		popupContainer.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(blurContainer.snp_height).dividedBy(2)
			make.left.equalTo(blurContainer.snp_left).offset(8)
			make.right.equalTo(blurContainer.snp_right).offset(-8)
			make.top.equalTo(blurContainer.snp_top).offset(40)
		}
		
		var titleLabel = UILabel()
		self.titleLabel = titleLabel
		popupContainer.addSubview(titleLabel)
		titleLabel.text = "Pay your Nelper"
		titleLabel.textColor = blackNelpyColor
		titleLabel.font = UIFont(name: "HelveticaNeue", size: kPopupTitleFontSize)
		titleLabel.textAlignment = NSTextAlignment.Center
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(popupContainer.snp_top).offset(10)
			make.centerX.equalTo(popupContainer.snp_centerX)
			make.left.equalTo(popupContainer.snp_left).offset(8)
			make.right.equalTo(popupContainer.snp_right).offset(-8)
		}
		
		self.cardTextField = STPPaymentCardTextField(frame: CGRectMake(0, 0, 300, 44))
		self.cardTextField.delegate = self
		popupContainer.addSubview(self.cardTextField)
		
		var saveButton = UIButton()
		self.saveButton = saveButton
		popupContainer.addSubview(saveButton)
		self.saveButton.addTarget(self, action: "didTapSaveButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.saveButton.setTitle("Save", forState: UIControlState.Normal)
		self.saveButton.backgroundColor = blueGrayColor.colorWithAlphaComponent(0.5)
		self.saveButton.enabled = false
		saveButton.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(popupContainer.snp_bottom)
			make.centerX.equalTo(popupContainer.snp_centerX)
			make.width.equalTo(120)
			make.height.equalTo(45)
		}
	}
	
	//UI
	
	
	
	// Stripe Delegate Methods
	func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
		
		if textField.valid {
			self.saveButton.enabled = true
			self.saveButton.backgroundColor = blueGrayColor.colorWithAlphaComponent(1.0)
		}else{
			self.saveButton.enabled = false
			self.saveButton.backgroundColor = blueGrayColor.colorWithAlphaComponent(0.5)
		}
	}
	
	//View delegate method
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
				self.cardTextField.snp_makeConstraints { (make) -> Void in
					make.centerX.equalTo(popupContainer.snp_centerX)
					make.centerY.equalTo(popupContainer.snp_centerY)
					make.height.equalTo(50)
					make.left.equalTo(popupContainer.snp_left).offset(2)
					make.right.equalTo(popupContainer.snp_right).offset(-2)
					
				}
	}
	
	//Gesture Recognizer Delegate Methods
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if touch.view.isDescendantOfView(self.popupContainer){
			return false
		}
		return true
	}
	
	func dismissPopup(){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	//Actions
	
	func didTapSaveButton(sender:UIButton){
		var card = STPCard()
		card.number = self.cardTextField.card!.number
		card.expMonth = self.cardTextField.card!.expMonth
		card.expYear = self.cardTextField.card!.expYear
		card.cvc = self.cardTextField.card!.cvc
		
		STPAPIClient.sharedClient().createTokenWithCard(card, completion: { (token, error) -> Void in
			if error == nil {
				if let token = token{
					println("getting token properly: \(token)")
				}
			}else{
				//Fuck
			}
		})
	}
	
	
}
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
	func didSendPayment()
}

class STRPPaymentViewController:UIViewController, STPPaymentCardTextFieldDelegate, UIGestureRecognizerDelegate{

	var cardTextField: STPPaymentCardTextField!
	var nameTextField: UITextField!
	var delegate:STRPPaymentViewControllerDelegate?
	var saveButton:UIButton!
	var popupContainer: UIView!
	var titleLabel: UILabel!
	var tap: UITapGestureRecognizer!
	var blurContainer:UIVisualEffectView!
	var task:FindNelpTask!
	var keyboardShowing:Bool!
	
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.keyboardShowing = false
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow"), name: UIKeyboardDidShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide"), name: UIKeyboardWillHideNotification, object: nil)
		self.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
		self.createView()
	}
	
	//MARK: View Creation

	func createView(){
		
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
		let blurContainer = UIVisualEffectView(effect: blurEffect)
		self.blurContainer = blurContainer
		self.view.addSubview(blurContainer)
		blurContainer.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view.snp_edges)
		}
		
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissPopup")
		self.tap = tap
		self.tap.delegate = self
		self.view.addGestureRecognizer(tap)
		
		self.view.backgroundColor = UIColor.clearColor()
		self.view.backgroundColor = UIColor.clearColor()
		self.view.addSubview(blurContainer)
		
		let popupContainer = UIView()
		self.popupContainer = popupContainer
		
		popupContainer.backgroundColor = whiteBackground
		blurContainer.addSubview(popupContainer)
		popupContainer.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(300)
			make.left.equalTo(blurContainer.snp_left).offset(8)
			make.right.equalTo(blurContainer.snp_right).offset(-8)
			make.top.equalTo(blurContainer.snp_top).offset(50)
		}
		
		let nelperPayLogo = UIImageView()
		nelperPayLogo.image = UIImage(named: "nelperpay")
		popupContainer.addSubview(nelperPayLogo)
		nelperPayLogo.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(popupContainer.snp_top)
			make.centerX.equalTo(popupContainer.snp_centerX)
			make.width.equalTo(60)
			make.height.equalTo(60)
		}
		
		let titleLabel = UILabel()
		self.titleLabel = titleLabel
		popupContainer.addSubview(titleLabel)
		titleLabel.text = "Payment"
		titleLabel.textColor = blackPrimary
		titleLabel.font = UIFont(name: "Lato-Light", size: 32)
		titleLabel.textAlignment = NSTextAlignment.Center
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(nelperPayLogo.snp_bottom)
			make.centerX.equalTo(popupContainer.snp_centerX)
			make.left.equalTo(popupContainer.snp_left).offset(8)
			make.right.equalTo(popupContainer.snp_right).offset(-8)
		}
		
		let whiteContainer = UIView()
		self.popupContainer.addSubview(whiteContainer)
		whiteContainer.backgroundColor = whitePrimary
		whiteContainer.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(220)
			make.left.equalTo(popupContainer.snp_left)
			make.right.equalTo(popupContainer.snp_right)
			make.bottom.equalTo(popupContainer.snp_bottom)
		}
		
		let grayLine = UIView()
		whiteContainer.addSubview(grayLine)
		grayLine.backgroundColor = darkGrayDetails
		grayLine.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(whiteContainer.snp_top)
			make.left.equalTo(whiteContainer.snp_left)
			make.right.equalTo(whiteContainer.snp_right)
			make.height.equalTo(0.5)
		}
		
		let userNameTextField = UITextField()
		self.nameTextField = userNameTextField
		userNameTextField.text = PFUser.currentUser()?.objectForKey("name") as? String
		whiteContainer.addSubview(userNameTextField)
		userNameTextField.layer.borderColor = darkGrayDetails.CGColor
		userNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
		userNameTextField.layer.borderWidth = 0.9
		userNameTextField.attributedPlaceholder = NSAttributedString(string: "Cardholder name", attributes: [NSForegroundColorAttributeName:textFieldPlaceholderColor])
		userNameTextField.textColor = UIColor.blackColor()
		userNameTextField.tintColor = darkGrayDetails
		
		userNameTextField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(whiteContainer.snp_top).offset(20)
			make.centerX.equalTo(popupContainer)
			make.left.equalTo(popupContainer.snp_left).offset(10)
			make.right.equalTo(popupContainer.snp_right).offset(-10)
			make.height.equalTo(50)
		}
		
		self.cardTextField = STPPaymentCardTextField()
		cardTextField.layer.cornerRadius = 0
		self.cardTextField.delegate = self
		self.cardTextField.tintColor = darkGrayDetails
		whiteContainer.addSubview(self.cardTextField)
		self.cardTextField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(userNameTextField.snp_bottom).offset(10)
			make.centerX.equalTo(popupContainer)
			make.height.equalTo(50)
			make.left.equalTo(popupContainer.snp_left).offset(10)
			make.right.equalTo(popupContainer.snp_right).offset(-10)
		}
		
		let saveButton = UIButton()
		self.saveButton = saveButton
		whiteContainer.addSubview(saveButton)
		self.saveButton.addTarget(self, action: "didTapSaveButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.saveButton.setTitle("Pay $\(Int(self.task.priceOffered!))", forState: UIControlState.Normal)
		self.saveButton.backgroundColor = redPrimary.colorWithAlphaComponent(0.5)
		self.saveButton.enabled = false
		saveButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cardTextField.snp_bottom).offset(20)
			make.centerX.equalTo(popupContainer.snp_centerX)
			make.width.equalTo(140)
			make.height.equalTo(40)
		}
	}
	
	//MARK: Stripe Delegate Methods
	
		func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
		
		if textField.valid {
			self.saveButton.enabled = true
			self.saveButton.backgroundColor = redPrimary.colorWithAlphaComponent(1.0)
		}else{
			self.saveButton.enabled = false
			self.saveButton.backgroundColor = redPrimary.colorWithAlphaComponent(0.5)
		}
	}
	
	//MARK: View delegate methods
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	//MARK: Gesture recognizer delegate methods
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if (self.keyboardShowing == true){
			return true
		}
		if touch.view!.isDescendantOfView(self.popupContainer){
			return false
		}
		return true
	}
	
	func keyboardDidShow(){
		self.keyboardShowing = true
	}
	
	func keyboardWillHide(){
		self.keyboardShowing = false
	}
	
	func dismissPopup(){
		if self.keyboardShowing == true{
			self.view.endEditing(true)
		}else{
		self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
	//MARK: Actionss
	
	func didTapSaveButton(sender:UIButton){
		let card = STPCard()
		card.number = self.cardTextField.card!.number
		card.expMonth = self.cardTextField.card!.expMonth
		card.expYear = self.cardTextField.card!.expYear
		card.cvc = self.cardTextField.card!.cvc
		
		STPAPIClient.sharedClient().createTokenWithCard(card, completion: { (token, error) -> Void in
			if error == nil {
				if let token = token{
					print("getting token properly: \(token)")
					GraphQLClient.mutation("SendPayment", input: ["taskId":self.task.id, "token":token.tokenId], block: { (object, error) -> Void in
						if error != nil{
							print(error)
						}else{
							print(object)
							self.dismissViewControllerAnimated(true, completion: nil)
							self.delegate!.didSendPayment()
						}
					})
				}
				
			}else{
				//Fuck
			}
		})
	}
	
	
}
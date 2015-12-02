//
//  GiveFeedbackView.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-27.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

import Foundation

class GiveFeedbackView: UIViewController, UITextViewDelegate {
	
	private var contentView: UIView!
	private var starsContainer: UIView!
	
	private var starImages = [UIButton]()
	var selectedRating = 1
	
	var starWidth = 40
	var starHeight = 40
	var starPadding = 10
	
	var starSelectedAlpha: CGFloat = 1
	var starUnselectedAlpha: CGFloat = 0.2
	
	private var charactersCountLabel: UILabel!
	let maxCharacters = 200
	
	//MARK: Init
	
	override func viewDidLoad() {
		self.createContainer()
		self.createStars()
		self.createFeedback()
	}
	
	//MARK: UI
	
	func createContainer() {
		
		let contentView = UIView()
		self.contentView = contentView
		self.view.addSubview(contentView)
		contentView.backgroundColor = Color.whiteBackground
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
	}
	
	func createStars() {
		
		let nameLabel = UILabel()
		self.contentView.addSubview(nameLabel)
		nameLabel.text = "Rate Charles Vinette"
		nameLabel.textColor = Color.darkGrayDetails
		nameLabel.font = UIFont(name: "Lato-Regular", size: kNavTitle18)
		nameLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.contentView.snp_top).offset(20)
			make.centerX.equalTo(self.contentView.snp_centerX)
		}
		
		let starsContainer = UIView()
		self.starsContainer = starsContainer
		self.contentView.addSubview(starsContainer)
		starsContainer.backgroundColor = Color.whitePrimary
		starsContainer.layer.borderColor = Color.grayDetails.CGColor
		starsContainer.layer.borderWidth = 1
		starsContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(nameLabel.snp_bottom).offset(15)
			make.left.equalTo(self.contentView.snp_left).offset(-1)
			make.right.equalTo(self.contentView.snp_right).offset(1)
		}
		
		let starsContentView = UIView()
		starsContainer.addSubview(starsContentView)
		starsContentView.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(starsContainer.snp_centerX)
			make.top.equalTo(starsContainer.snp_top).offset(20)
			make.height.equalTo(self.starHeight)
			make.width.equalTo((self.starWidth + self.starPadding) * 5 - self.starPadding)
		}
		
		for index in 0...4 {
			let image = UIImage(named: "empty_star")!.imageWithRenderingMode(.AlwaysTemplate)
			
			let starImage = UIButton(frame: CGRect(x: index * (starWidth + starPadding), y: 0, width: starWidth, height: starWidth))
			starImage.setImage(image, forState: .Normal)
			starImage.contentMode = .ScaleAspectFit
			starImage.tag = index
			starImage.tintColor = Color.redPrimary
			starImage.addTarget(self, action: "starTapped:", forControlEvents: UIControlEvents.TouchUpInside)
			
			starsContentView.addSubview(starImage)
			
			starImage.alpha = self.starUnselectedAlpha
			starImage.transform = CGAffineTransformMakeScale(0.9, 0.9)
			
			starImages.append(starImage)
		}
		
		starImages[0].alpha = self.starSelectedAlpha
		starImages[0].transform = CGAffineTransformMakeScale(1, 1)
		
		starsContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(starsContentView.snp_bottom).offset(20)
		}
	}
	
	func createFeedback() {
		
		let feedbackContainer = UIView()
		self.contentView.addSubview(feedbackContainer)
		feedbackContainer.backgroundColor = Color.whitePrimary
		feedbackContainer.layer.borderColor = Color.grayDetails.CGColor
		feedbackContainer.layer.borderWidth = 1
		feedbackContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.starsContainer.snp_bottom).offset(20)
			make.left.equalTo(self.contentView.snp_left).offset(-1)
			make.right.equalTo(self.contentView.snp_right).offset(1)
		}
		
		let feedbackTextView = UITextView()
		feedbackContainer.addSubview(feedbackTextView)
		feedbackTextView.delegate = self
		feedbackTextView.font = UIFont(name: "Lato-Regular", size: kText15)
		feedbackTextView.textColor = Color.textFieldPlaceholderColor
		feedbackTextView.backgroundColor = Color.whitePrimary
		feedbackTextView.textAlignment = NSTextAlignment.Justified
		feedbackTextView.text = "How was your experience with Charles?   "
		feedbackTextView.returnKeyType = .Done
		feedbackTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(feedbackContainer.snp_top).offset(5)
			make.left.equalTo(feedbackContainer.snp_left).offset(10)
			make.right.equalTo(feedbackContainer.snp_right).offset(-10)
			make.height.equalTo(100)
		}
		
		let charactersCountLabel = UILabel()
		self.charactersCountLabel = charactersCountLabel
		feedbackContainer.addSubview(charactersCountLabel)
		charactersCountLabel.text = "\(self.maxCharacters) characters left"
		charactersCountLabel.textColor = Color.darkGrayDetails.colorWithAlphaComponent(0.8)
		charactersCountLabel.font = UIFont(name: "Lato-Regular", size: kText12)
		charactersCountLabel.textAlignment = .Right
		charactersCountLabel.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(feedbackContainer.snp_bottom).offset(-5)
			make.right.equalTo(feedbackContainer.snp_right).offset(-12)
		}
		
		feedbackContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(feedbackTextView.snp_bottom).offset(30)
		}
	}
	
	//MARK: TextView delegate
	
	func textViewDidBeginEditing(textView: UITextView) {
		if textView.text == "How was your experience with Charles?   " {
			textView.text = ""
			textView.textColor = Color.textFieldTextColor
		}
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		if textView.text == "" {
			textView.text = "How was your experience with Charles?   "
			textView.textColor = Color.textFieldPlaceholderColor
		}
	}
	
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		//textViewShouldReturn hack
		let resultRange = text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet(), options: .BackwardsSearch)
		if resultRange != nil {
			textView.resignFirstResponder()
			return false
		}
		
		return textView.text.characters.count + (text.characters.count - range.length) <= self.maxCharacters
	}
	
	func textViewDidChange(textView: UITextView) {
		self.charactersCountLabel.text = "\(self.maxCharacters - textView.text.characters.count) characters left"
		
		if self.maxCharacters - textView.text.characters.count == 0 {
			self.charactersCountLabel.textColor = Color.redPrimary
		} else {
			self.charactersCountLabel.textColor = Color.darkGrayDetails
		}
	}
	
	//MARK: Actions
	
	func starTapped(sender: UIButton) {
		
		if sender.tag > self.selectedRating - 1 {
			for starImage in self.starImages {
				if starImage.tag <= sender.tag {
					UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
						starImage.alpha = self.starSelectedAlpha
						starImage.transform = CGAffineTransformMakeScale(1, 1)
						}, completion: nil )
				}
			}
		} else if sender.tag < self.selectedRating - 1 {
			for starImage in self.starImages {
				if starImage.tag > sender.tag {
					UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
						starImage.alpha = self.starUnselectedAlpha
						starImage.transform = CGAffineTransformMakeScale(0.9, 0.9)
						}, completion: nil )
				}
			}
		}
		
		self.selectedRating = sender.tag + 1
	}
}
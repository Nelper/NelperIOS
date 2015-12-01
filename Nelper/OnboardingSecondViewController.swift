//
//  OnboardingSecondViewController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-29.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class OnboardingSecondViewController: UIViewController {
	
	let categories: [(id: String, name: String)] = [
		(id: "technology", name: "Support informatique et électronique"),
		(id: "business", name: "Affaires et administration"),
		(id: "multimedia", name: "Multimédia"),
		(id: "gardening", name: "Jardinage"),
		(id: "handywork", name: "Travail manuel"),
		(id: "housecleaning", name: "Nettoyage")
	]
	
	var categoryImages = [UIButton]()
	
	let imageSize = 40
	var padding = Int()
	
	var categoryLabel: UILabel!
	var displayedIndex = Int()
	
	var timer: NSTimer!
	
	var firstLoad = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.displayedIndex = 0
		
		self.padding = Int(self.view.frame.width) / 25
		
		self.createView()
	}
	
	override func viewDidAppear(animated: Bool) {
		if self.firstLoad {
			var delay = 0.1
			
			for categoryImage in self.categoryImages {
				UIView.animateWithDuration(delay * 1.5, delay: delay, options: [.CurveEaseOut], animations:  {
					if categoryImage.tag == 0 {
						categoryImage.alpha = 1
						self.categoryLabel.alpha = 1
					} else {
						categoryImage.alpha = 0.3
					}
					}, completion: nil)
				delay += 0.1
			}
			self.firstLoad = false
		}
		
		if self.timer != nil {
			self.timer.invalidate()
		}
		
		let timer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "setCategoryLabel", userInfo: nil, repeats: true)
		self.timer = timer
	}
	
	override func viewDidDisappear(animated: Bool) {
		self.timer.invalidate()
	}
	
	func createView() {
		
		let contentView = UIView()
		self.view.addSubview(contentView)
		contentView.backgroundColor = Color.whitePrimary
		contentView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view.snp_edges)
		}
		
		let titleLabel = UILabel()
		contentView.addSubview(titleLabel)
		titleLabel.text = "Catégories simples,\noptions multiples"
		titleLabel.textColor = Color.textFieldTextColor
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont(name: "Lato-Light", size: 31)
		titleLabel.textAlignment = NSTextAlignment.Center
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(contentView.snp_centerY).offset(-120)
			make.centerX.equalTo(contentView.snp_centerX)
		}
		
		let descLabel = UILabel()
		contentView.addSubview(descLabel)
		descLabel.text = "De la tonte de pelouse à l'installation d'un routeur"
		descLabel.textColor = Color.textFieldTextColor
		descLabel.numberOfLines = 0
		descLabel.font = UIFont(name: "Lato-Light", size: 20)
		descLabel.textAlignment = NSTextAlignment.Center
		descLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom).offset(40)
			make.left.equalTo(contentView.snp_left).offset(25)
			make.right.equalTo(contentView.snp_right).offset(-25)
		}
		
		let categoriesView = UIView()
		contentView.addSubview(categoriesView)
		
		for i in 0...self.categories.count - 1 {
			let xCoord = i * (self.imageSize + self.padding)
			
			let categoryImage = UIButton(frame: CGRect(x: xCoord, y: 0, width: imageSize, height: imageSize))
			categoryImage.setImage(UIImage(named: self.categories[i].id+"-filter"), forState: .Normal)
			categoryImage.contentMode = .ScaleAspectFit
			categoryImage.alpha = 0
			categoryImage.transform = CGAffineTransformMakeScale(0.9, 0.9)
			categoryImage.tag = i
			
			categoryImages.append(categoryImage)
			categoriesView.addSubview(categoryImage)
		}
		
		categoriesView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descLabel.snp_bottom).offset(60)
			make.centerX.equalTo(contentView.snp_centerX)
			make.height.equalTo(self.imageSize)
			make.width.equalTo(self.categoryImages.count * (self.imageSize + self.padding) - self.padding)
		}
		
		let categoryLabel = UILabel()
		self.categoryLabel = categoryLabel
		contentView.addSubview(categoryLabel)
		categoryLabel.text = self.categories[self.displayedIndex].name
		categoryLabel.textColor = Color.textFieldTextColor
		categoryLabel.font = UIFont(name: "Lato-Light", size: 20)
		categoryLabel.numberOfLines = 0
		categoryLabel.alpha = 0
		categoryLabel.textAlignment = NSTextAlignment.Center
		categoryLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(categoriesView.snp_bottom).offset(25)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
		}
	}
	
	func setCategoryLabel() {
		if self.displayedIndex == self.categories.count - 1 {
			self.displayedIndex = 0
		} else {
			self.displayedIndex += 1
		}
		
		UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
			self.categoryLabel.alpha = 0
			for categoryImage in self.categoryImages {
				categoryImage.alpha = 0.3
				categoryImage.transform = CGAffineTransformMakeScale(0.9, 0.9)
			}
			}, completion: { (completed: Bool) in
				self.categoryLabel.text = self.categories[self.displayedIndex].name
		})
		
		UIView.animateWithDuration(0.3, delay: 0.3, options: [.CurveEaseOut], animations:  {
			self.categoryLabel.alpha = 1
			self.categoryImages[self.displayedIndex].alpha = 1
			self.categoryImages[self.displayedIndex].transform = CGAffineTransformMakeScale(1, 1)
			}, completion: nil)
	}
}
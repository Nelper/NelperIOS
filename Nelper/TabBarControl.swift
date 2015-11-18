//
//  TabBarControl.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-17.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarControlDelegate {
	func selectedIndex(index: Int)
}

class TabBarControl: UIControl {

	var backgroundView: UIView!
	
	var lastIndex: Int = 0
	
	var items = [
		(title: "Browse tasks", image: UIImage(named: "browse_default")),
		(title: "Nelp Center", image: UIImage(named: "nelpcenter_default")),
		(title: "Post a task", image: UIImage(named: "post_task")),
		(title: "More", image: UIImage(named: "menu"))
	]
	
	private var itemViews = [UIView]()
	var images = [UIImageView]()
	var labels = [UILabel]()
	
	var delegate: TabBarControlDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.createBackground()
		self.setItems()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func createBackground() {
		
		let backgroundView = UIView()
		self.backgroundView = backgroundView
		self.addSubview(backgroundView)
		backgroundView.userInteractionEnabled = false
		backgroundView.backgroundColor = UIColor.whiteColor()
		backgroundView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.snp_edges)
		}
		
		let topLine = UIView()
		backgroundView.addSubview(topLine)
		topLine.backgroundColor = Color.darkGrayDetails
		topLine.userInteractionEnabled = false
		topLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(backgroundView.snp_top)
			make.width.equalTo(backgroundView.snp_width)
			make.left.equalTo(backgroundView.snp_left)
			make.height.equalTo(0.5)
		}
		
		backgroundView.layoutIfNeeded()
		
	}
	
	func setItems() {
		
		for itemView in self.itemViews {
			itemView.removeFromSuperview()
		}
		
		self.itemViews.removeAll(keepCapacity: true)
		self.images.removeAll(keepCapacity: true)
		self.labels.removeAll(keepCapacity: true)
		
		for i in 0...self.items.count - 1 {
			let itemView = UIView(frame: CGRectZero)
			itemView.backgroundColor = UIColor.clearColor()
			itemView.userInteractionEnabled = false
			self.backgroundView.addSubview(itemView)
			
			self.itemViews.append(itemView)
			
			let imageView = UIImageView(frame: CGRectMake(0, 0, 30, 30))
			imageView.image = items[i].image?.imageWithRenderingMode(.AlwaysTemplate)
			imageView.tintColor = Color.darkGrayDetails
			imageView.contentMode = .ScaleAspectFit
			imageView.userInteractionEnabled = false
			itemView.addSubview(imageView)
			
			self.images.append(imageView)
			
			let label = UILabel()
			label.text = items[i].title
			label.font = UIFont(name: "Lato-Light", size: 11)
			label.textAlignment = .Center
			label.textColor = Color.blackPrimary.colorWithAlphaComponent(0.9)
			label.sizeToFit()
			label.userInteractionEnabled = false
			itemView.addSubview(label)
			
			self.labels.append(label)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if self.itemViews.count == 0 {
			return
		}
		
		var selectFrame = self.backgroundView.bounds
		let newWidth = CGRectGetWidth(selectFrame) / CGFloat(items.count)
		selectFrame.size.width = newWidth
		
		let itemViewHeight = self.backgroundView.bounds.height
		let itemViewWidth = self.bounds.width / CGFloat(self.itemViews.count)
		
		for i in 0...self.itemViews.count - 1 {
			let itemView = self.itemViews[i]
			let image = self.images[i]
			let label = self.labels [i]
			
			let xPosition = CGFloat(i) * itemViewWidth
			itemView.frame = CGRectMake(xPosition, 0, itemViewWidth, itemViewHeight)
			
			image.center = CGPointMake(itemView.frame.width / 2, (itemView.frame.height / 2) - 5)
			label.center = CGPointMake(itemView.frame.width / 2, (itemView.frame.height / 2) + 15)
		}
	}
	
	override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
		let location = touch.locationInView(self)
		
		var calculatedIndex: Int?
		for (index, item) in self.itemViews.enumerate() {
			if item.frame.contains(location) {
				calculatedIndex = index
			}
		}
		
		if calculatedIndex != nil {
			self.didSelectIndex(calculatedIndex!)
			sendActionsForControlEvents(.ValueChanged)
		}
		
		return false
	}
	
	func didSelectIndex(index: Int) {
		if self.lastIndex == index {
			return
		}
		
		self.images[index].tintColor = Color.redPrimary
		self.images[self.lastIndex].tintColor = Color.darkGrayDetails
		
		self.labels[index].textColor = Color.redPrimary
		self.labels[self.lastIndex].textColor = Color.blackPrimary
		
		self.lastIndex = index
		
		self.delegate?.selectedIndex(index)
	}
}
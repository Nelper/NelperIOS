//
//  SegmentController.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-09-25.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol SegmentControllerDelegate {
	func onIndexChange(index: Int)
}

class SegmentController: UIControl {
	
	private var labels = [UILabel]()
	var thumbView = UIView()
	var thumbLine = UIView()

	var delegate: SegmentControllerDelegate?
	
	var items = [String]() {
		didSet {
			setLabels()
		}
	}
	
	var selectedIndex : Int = 0 {
		didSet {
			for label in labels {
				label.textColor = darkGrayDetails
			}
			
			displayNewSelectIndex()
			
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		adjustUI()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		adjustUI()
	}
	
	func adjustUI() {
		layer.borderColor = grayDetails.CGColor
		layer.borderWidth = 1
		backgroundColor = whiteGrayColor
		
		insertSubview(thumbLine, atIndex: 0)
		//insertSubview(thumbView, atIndex: 0)
	}
	
	func setLabels() {
		
		for label in labels {
			label.removeFromSuperview()
		}
		
		labels.removeAll(keepCapacity: true)
		
		for index in 1...items.count {
			let label = UILabel(frame: CGRectZero)
			label.text = items[index - 1]
			label.font = UIFont(name: "Lato-Regular", size: kTitle16)
			label.textAlignment = .Center
			label.textColor = darkGrayDetails
			self.addSubview(label)
			labels.append(label)
		}
		
		labels[0].textColor = nelperRedColor
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if labels.count == 0 {
			return
		}
		
		var selectFrame = self.bounds
		let newWidth = CGRectGetWidth(selectFrame) / CGFloat(items.count)
		selectFrame.size.width = newWidth
		
		thumbLine.frame = CGRect(x: selectFrame.minX, y: selectFrame.maxY - 2, width: selectFrame.width, height: CGFloat(2))
		thumbLine.backgroundColor = nelperRedColor
		thumbLine.layer.zPosition = 1
		
		//thumbView.frame = selectFrame
		//thumbView.backgroundColor = whiteGrayColor
		//thumbView.layer.cornerRadius = thumbView.frame.height / 2

		let labelHeight = self.bounds.height
		let labelWidth = self.bounds.width / CGFloat(labels.count)
		
		for index in 0...labels.count - 1 {
			var label = labels[index]
			
			let xPosition = CGFloat(index) * labelWidth
			label.frame = CGRectMake(xPosition, 0, labelWidth, labelHeight)
		}
	}
	
	override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
		let location = touch.locationInView(self)
		
		var calculatedIndex : Int?
		for(index, item) in labels.enumerate() {
			if item.frame.contains(location) {
				calculatedIndex = index
			}
		}
		
		if calculatedIndex != nil {
			selectedIndex = calculatedIndex!
			sendActionsForControlEvents(.ValueChanged)
		}
		
		return false
	}
	
	func displayNewSelectIndex() {
		var label = labels[selectedIndex]
		label.textColor = nelperRedColor
		
		UIView.animateWithDuration(0.5, animations: {
			self.thumbLine.frame = CGRect(x: label.frame.minX, y: label.frame.maxY - 2, width: label.frame.width, height: CGFloat(2))
			//self.thumbView.frame = label.frame
		})

		self.delegate?.onIndexChange(selectedIndex)
		
	}
	
}
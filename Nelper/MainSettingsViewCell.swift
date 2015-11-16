//
//  MainSettingsViewCell.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-14.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class MainSettingsViewCell: UITableViewCell {
	
	private var cellView: UIView!
	private var sectionLabel: UILabel!
	private var rightArrow: UIImageView!
	private var separatorLine: UIView!
	
	//MARK: INIT
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		createView()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
	}
	
		
	static var reuseIdentifier: String {
		get {
			return "MainSettingsViewCell"
		}
	}
	
	func createView() {
		let cellView = UIView(frame: self.bounds)
		self.cellView = cellView
		self.cellView.layer.borderColor = Color.grayDetails.CGColor
		self.cellView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
		
		let sectionLabel = UILabel()
		self.sectionLabel = sectionLabel
		self.cellView.addSubview(sectionLabel)
		self.sectionLabel.text = "#error loading sections"
		self.sectionLabel.textColor = Color.darkGrayDetails
		self.sectionLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		self.sectionLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(self.cellView.snp_centerY)
			make.left.equalTo(self.cellView.snp_left).offset(20)
		}
		
		let rightArrow = UIImageView()
		self.rightArrow = rightArrow
		self.cellView.addSubview(rightArrow)
		self.rightArrow.image = UIImage(named: "arrow_applicant_cell")
		self.rightArrow.alpha = 0.2
		self.rightArrow.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.cellView.snp_right).offset(-20)
			make.centerY.equalTo(self.cellView.snp_centerY)
			make.height.equalTo(18)
			make.width.equalTo(10)
		}
		
		let separatorLine = UIView()
		self.separatorLine = separatorLine
		self.cellView.addSubview(separatorLine)
		self.separatorLine.backgroundColor = Color.grayDetails
		self.separatorLine.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(self.cellView.snp_right)
			make.left.equalTo(self.cellView.snp_left).offset(20)
			make.bottom.equalTo(self.cellView.snp_bottom)
			make.height.equalTo(0.5)
		}
		
		self.addSubview(self.cellView)
	}
	
	func setSectionTitle(sectionTitle: String) {
		self.sectionLabel.text = sectionTitle
	}

	func setLastSectionLine(isLast: Bool) {
		if (isLast == true) {
			self.separatorLine.snp_updateConstraints { (make) -> Void in
				make.left.equalTo(self.cellView.snp_left)
			}
		}
	}
}
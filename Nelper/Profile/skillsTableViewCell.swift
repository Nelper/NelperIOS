//
//  skillsTableViewCell.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-19.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class skillsTableViewCell: UITableViewCell {
	
	var skillName:UILabel!
	
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let backView = UIView(frame: self.bounds)
		backView.clipsToBounds = true
		backView.backgroundColor = whiteNelpyColor
		backView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
		
		//Check image
		var checkImage = UIImageView()
		backView.addSubview(checkImage)
		checkImage.image = UIImage(named: "check_orange")
		checkImage.contentMode = UIViewContentMode.ScaleAspectFill
		checkImage.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(backView.snp_left).offset(4)
			make.centerY.equalTo(backView.snp_centerY)
			make.height.equalTo(20)
			make.width.equalTo(20)
		}
		
		//Skill name
		var skillName = UILabel()
		self.skillName = skillName
		backView.addSubview(skillName)
		skillName.textColor = blackNelpyColor
		skillName.font = UIFont(name: "ABeeZee-Regular", size: kCellSubtitleFontSize)
		skillName.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(checkImage.snp_right).offset(4)
			make.centerY.equalTo(backView.snp_centerY)
			make.width.equalTo(backView.snp_width).dividedBy(2)
		}
		
		//Trash Can Icon
		var trashImage = UIImageView()
		trashImage.image = UIImage(named: "trashcan")
		backView.addSubview(trashImage)
		trashImage.contentMode = UIViewContentMode.ScaleAspectFill
		trashImage.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(backView.snp_right).offset(-4)
			make.centerY.equalTo(backView.snp_centerY)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
	
		self.addSubview(backView)
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
	}
	
	override func setHighlighted(highlighted: Bool, animated: Bool) {
	}
	
	static var reuseIdentifier: String {
		get {
			return "skillsTableViewCell"
		}
	}
	
	//Sets the property
	
	func sendSkillName(skillName: String){
			self.skillName.text = skillName
	}

}
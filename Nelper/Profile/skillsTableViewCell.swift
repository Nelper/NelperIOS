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

protocol SkillsTableViewCellDelegate{
	func didTapDeleteButton(index:Int, type:String)
}

class SkillsTableViewCell: UITableViewCell {
	
	var skillName:UILabel!
	var trashImage:UIButton!
	var index:Int!
	var delegate: SkillsTableViewCellDelegate?
	var cellType: String!
	
	//MARK: Initialization
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let backView = UIView(frame: self.bounds)
		backView.clipsToBounds = true
		backView.backgroundColor = Color.whitePrimary
		backView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
		
		//Check image
		let checkImage = UIImageView()
		backView.addSubview(checkImage)
		checkImage.image = UIImage(named: "check_gray")
		checkImage.contentMode = UIViewContentMode.ScaleAspectFill
		checkImage.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(backView.snp_left)
			make.centerY.equalTo(backView.snp_centerY)
			make.height.equalTo(16)
			make.width.equalTo(16)
		}
		
		//Trash Can Icon
		let trashImage = UIButton()
		self.trashImage = trashImage
		trashImage.setBackgroundImage(UIImage(named: "trashcan"), forState: UIControlState.Normal)
		backView.addSubview(trashImage)
		trashImage.addTarget(self, action: "didTapDelete:", forControlEvents: UIControlEvents.TouchUpInside)
		trashImage.contentMode = UIViewContentMode.ScaleAspectFill
		trashImage.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(backView.snp_right).offset(-4)
			make.centerY.equalTo(backView.snp_centerY)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		
		//Skill name
		let skillName = UILabel()
		self.skillName = skillName
		backView.addSubview(skillName)
		skillName.textColor = Color.blackPrimary
		skillName.font = UIFont(name: "Lato-Light", size: kText15)
		skillName.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(checkImage.snp_right).offset(10)
			make.centerY.equalTo(backView.snp_centerY).offset(-1)
			make.right.equalTo(trashImage.snp_right).offset(-4)
			
		}
	
		self.addSubview(backView)
	}
	
	required init?(coder aDecoder: NSCoder) {
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
	
	func didTapDelete(sender:UIButton){
		self.delegate!.didTapDeleteButton(self.index, type: self.cellType)
	}
	
	//MARK: Setters
	
	func sendSkillName(skillName: String){
		self.skillName.text = skillName
	}
	
	func hideTrashCanIcon(){
		self.trashImage.hidden = true
	}
	
	func sendCellType(category:String){
		self.cellType = category
	}
	
	func setIndex(index:Int){
		self.index = index
	}

}
//
//  TableViewCell.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-04.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import Alamofire

class NelpTasksTableViewCell: UITableViewCell {
  
	var titleLabel: UILabel!
	var price:UILabel!
	var numberOfApplicants:UILabel!
	var category:UILabel!
	var categoryIcon:UIImageView!
//	var categoryLabel:UILabel!
	var topContainer:UIImageView!
	var desc:UITextView!
	
	var nelpTask:FindNelpTask!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let backView = UIView(frame: self.bounds)
		backView.clipsToBounds = true
		backView.backgroundColor = navBarColor
		backView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
		
		//CellContainer (hackForSpacing)
		let cellView = UIView();
		backView.addSubview(cellView)
		cellView.backgroundColor = whiteNelpyColor
		cellView.layer.cornerRadius = 6
		cellView.layer.borderWidth = 2
		cellView.layer.borderColor = blackNelpyColor.CGColor
		cellView.layer.masksToBounds = true
		cellView.clipsToBounds = true
		cellView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(backView).offset(4)
			make.left.equalTo(backView).offset(4)
			make.right.equalTo(backView).offset(-4)
			make.bottom.equalTo(backView).offset(-4)
		}
		
		
		//Top container
		var topContainer = UIImageView()
		self.topContainer = topContainer
		self.topContainer.clipsToBounds = true
		self.topContainer.layer.masksToBounds = true
		cellView.addSubview(topContainer)
		topContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cellView.snp_top)
			make.right.equalTo(cellView.snp_right)
			make.left.equalTo(cellView.snp_left)
			make.height.equalTo(cellView.snp_height).dividedBy(3)
		}
		
		topContainer.backgroundColor = yellowTechnology
		//Category Icon + label
		
		var categoryIcon = UIImageView()
		self.categoryIcon = categoryIcon
		topContainer.addSubview(categoryIcon)
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(topContainer.snp_bottom).offset(-4)
			make.left.equalTo(topContainer.snp_left).offset(8)
			make.height.equalTo(40)
			make.width.equalTo(40)
		}
		
//		var categoryLabel = UILabel()
//		self.categoryLabel = categoryLabel
//		categoryLabel.textColor = blackNelpyColor
//		categoryLabel.font = UIFont(name: "ABeeZee-Regular", size: kTextFontSize)
//		topContainer.addSubview(categoryLabel)
//		categoryLabel.snp_makeConstraints { (make) -> Void in
//			make.left.equalTo(categoryIcon.snp_right).offset(4)
//			make.centerY.equalTo(categoryIcon.snp_centerY)
//		}
		
		var titleLabel = UILabel()
		self.titleLabel = titleLabel
		titleLabel.textColor = blackNelpyColor
		titleLabel.font = UIFont(name: "ABeeZee-Regular", size: kSubtitleFontSize)
		cellView.addSubview(titleLabel)
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(topContainer.snp_bottom).offset(4)
			make.left.equalTo(cellView.snp_left).offset(12)
			make.height.equalTo(40)
		}
		
		//Price tag
		var price = UILabel()
		self.price = price
		cellView.addSubview(price)
		price.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleLabel.snp_bottom)
			make.right.equalTo(cellView.snp_right).offset(-12)
			make.width.equalTo(70)
			make.height.equalTo(30)
		}
		self.price.backgroundColor = greenPriceButton
		self.price.font = UIFont(name: "ABeeZee-Regular", size: kCellPriceFontSize)
		self.price.textColor = whiteNelpyColor
		self.price.layer.cornerRadius = 6
		self.price.clipsToBounds = true
		self.price.textAlignment = NSTextAlignment.Center
		
		//Description
		var description = UITextView()
		self.desc = description
		desc.font = UIFont(name: "ABeeZee-Regular", size: kCellTextFontSize)
		desc.textColor = blackNelpyColor
		desc.editable = false
		desc.scrollEnabled = false
		desc.backgroundColor = whiteNelpyColor
		cellView.addSubview(desc)
		desc.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(price.snp_bottom).offset(4)
			make.left.equalTo(cellView.snp_left).offset(12)
			make.right.equalTo(cellView.snp_right).offset(-12)
			make.bottom.equalTo(cellView.snp_bottom).offset(-4)
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
			return "NelpViewCell"
		}
	}
	
	func setImages(nelpTask:FindNelpTask){
		self.categoryIcon.layer.cornerRadius = self.categoryIcon.frame.size.width / 2;
		self.categoryIcon.clipsToBounds = true;
		self.categoryIcon.image = UIImage(named: nelpTask.category!)
		if(nelpTask.pictures != nil){
		if(!nelpTask.pictures!.isEmpty){
		getPictures(nelpTask.pictures![0].url! , block: { (imageReturned:UIImage) -> Void in
			self.topContainer.image = imageReturned
		})}}
		self.topContainer.contentMode = .ScaleAspectFill
		self.topContainer.clipsToBounds = true
	}
	
	func getPictures(imageURL: String, block: (UIImage) -> Void) -> Void {
		var image: UIImage!
		request(.GET,imageURL).response(){
			(_, _, data, error) in
			if(error != nil){
				println(error)
			}
			image = UIImage(data: data as NSData!)
			block(image)
		}
	}
	
	func setNelpTask(nelpTask: FindNelpTask) {
//		self.categoryLabel.text = nelpTask.category!.uppercaseString
		self.titleLabel.text = nelpTask.title
		self.price.text = "$\(nelpTask.priceOffered!)"
		self.desc.text = nelpTask.desc

	}
}



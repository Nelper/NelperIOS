//
//  TableViewCell.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-04.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

class NelpTasksTableViewCell: UITableViewCell {
  
	var title: UILabel!
	var distance:UILabel!
	var price:UILabel!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let cellView = UIView(frame: self.bounds)
		cellView.backgroundColor = yellowTechnology
		cellView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
		
		let categoryLogo = UIImageView()
		categoryLogo.image = UIImage(named: "technologyIcon.png")
		cellView.addSubview(categoryLogo)
		
		categoryLogo.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(cellView.snp_left).offset(4)
			make.centerY.equalTo(cellView.snp_centerY)
			make.width.equalTo(100)
			make.height.equalTo(100)
		}
		
		let title = UILabel()
		self.title = title
		cellView.addSubview(title)
		
		title.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cellView.snp_top).offset(4)
			make.centerX.equalTo(cellView.snp_centerX)
			
		}
		
		let distance = UILabel()
		self.distance = distance
		cellView.addSubview(distance)
		
		distance.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(title.snp_bottom).offset(2)
			make.centerX.equalTo(cellView.snp_centerX)
		}
		
		let price = UILabel()
		self.price = price
		cellView.addSubview(price)
		
		price.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(cellView.snp_right).offset(-4)
			make.centerY.equalTo(cellView.snp_centerY)
		}
		
		self.addSubview(cellView)
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
	
	func setNelpTask(nelpTask: FindNelpTask) {
		self.title.text = nelpTask.title
		self.title.font = UIFont(name: "Railway", size: kCellTitleFontSize)
		self.title.textColor = blackNelpyColor
		
		self.distance.text = "Distance: 1.2 km"
		self.distance.font = UIFont(name: "Railway", size: kSubtitleFontSize)
		self.distance.textColor = grayNelpyColor
		
		self.price.text = nelpTask.priceOffered
		self.price.font = UIFont(name: "Railway", size: kCellPriceFontSize)
		self.price.textColor = grayNelpyColor
	}}

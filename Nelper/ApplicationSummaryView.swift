//
//  ApplicationSummaryView.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-26.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

class ApplicationSummaryView: UIView {
	
	var container: UIView!
	
	init(application: TaskApplication) {
		super.init(frame: CGRectZero)
		
		self.createView(application)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func createView(application: TaskApplication) {
		
		//Container
		
		let container = UIView()
		self.container = container
		self.addSubview(container)
		container.layer.borderColor = Color.grayDetails.CGColor
		container.layer.borderWidth = 1
		container.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.snp_top)
			make.left.equalTo(self.snp_left)
			make.right.equalTo(self.snp_right)
		}
		container.backgroundColor = Color.whitePrimary
		
		//Title
		
		let statusTitle = UILabel()
		container.addSubview(statusTitle)
		statusTitle.text = "Status"
		statusTitle.textColor = Color.darkGrayDetails
		statusTitle.font = UIFont(name: "Lato-Regular", size: kText14)
		statusTitle.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(container.snp_top).offset(15)
			make.centerX.equalTo(container.snp_centerX)
		}
		
		//Status label
		
		let statusLabel = UILabel()
		statusLabel.backgroundColor = UIColor.clearColor()
		container.addSubview(statusLabel)
		statusLabel.text = ApiHelper.fetchStatusText(application)
		statusLabel.numberOfLines = 0
		statusLabel.textColor = Color.blackTextColor
		statusLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		statusLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(container.snp_centerX).offset(14)
			make.top.equalTo(statusTitle.snp_bottom).offset(6)
		}
		
		let statusIcon = UIImageView()
		container.addSubview(statusIcon)
		statusIcon.image = ApiHelper.fetchStatusIcon(application)
		statusIcon.contentMode = UIViewContentMode.ScaleAspectFit
		statusIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(26)
			make.width.equalTo(26)
			make.centerY.equalTo(statusLabel.snp_centerY)
			make.right.equalTo(statusLabel.snp_left).offset(-10)
		}
		
		//Date label
		
		let dateTitle = UILabel()
		container.addSubview(dateTitle)
		dateTitle.text = "Applied"
		dateTitle.textColor = Color.darkGrayDetails
		dateTitle.font = UIFont(name: "Lato-Regular", size: kText14)
		dateTitle.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(statusLabel.snp_bottom).offset(22)
			make.centerX.equalTo(container.snp_centerX)
		}
		
		let dateLabel = UILabel()
		dateLabel.backgroundColor = UIColor.clearColor()
		container.addSubview(dateLabel)
		dateLabel.text = "\(DateHelper().timeAgoSinceDate(application.createdAt!, numericDates: true))"
		dateLabel.textColor = Color.blackTextColor
		dateLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		dateLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(dateTitle.snp_bottom).offset(6)
			make.centerX.equalTo(container.snp_centerX).offset(13)
		}
		
		let dateIcon = UIImageView()
		container.addSubview(dateIcon)
		dateIcon.image = UIImage(named: "time")
		dateIcon.contentMode = UIViewContentMode.ScaleAspectFit
		dateIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(25)
			make.width.equalTo(25)
			make.centerY.equalTo(dateLabel.snp_centerY)
			make.right.equalTo(dateLabel.snp_left).offset(-10)
		}
		
		//Price title
		let priceTitle = UILabel()
		container.addSubview(priceTitle)
		priceTitle.text = "My offer"
		priceTitle.textColor = Color.darkGrayDetails
		priceTitle.font = UIFont(name: "Lato-Regular", size: kText14)
		priceTitle.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(dateLabel.snp_bottom).offset(22)
			make.centerX.equalTo(container.snp_centerX)
		}
		
		let moneyContainer = UIView()
		container.addSubview(moneyContainer)
		moneyContainer.backgroundColor = Color.whiteBackground
		moneyContainer.layer.cornerRadius = 3
		moneyContainer.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(container)
			make.top.equalTo(priceTitle.snp_bottom).offset(6)
			make.width.equalTo(55)
			make.height.equalTo(35)
		}
		
		let moneyLabel = UILabel()
		moneyContainer.addSubview(moneyLabel)
		moneyLabel.textAlignment = NSTextAlignment.Center
		moneyLabel.textColor = Color.blackPrimary
		moneyLabel.text = "\(application.price!)$"
		moneyLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyContainer.snp_edges)
		}
		
		container.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(moneyContainer.snp_bottom).offset(15)
		}
		
		self.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(container.snp_bottom)
		}
	}
}
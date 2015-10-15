//
//  DefaultContainer.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-14.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class DefaultContainerView: UIView {
	
	var withTitle = false
	
	var backgroundView: UIView!
	var contentView: UIView!
	var titleView: UIView?
	var titleLabel: UILabel?
	var titleLine: UIView?
	
	var containerTitle: String! {
		didSet {
			self.withTitle = true
			createView()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		createView()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		
		createView()
	}
	
	func createView() {
		for subview in self.subviews {
			subview.removeFromSuperview()
		}
		
		let backgroundView = UIView()
		self.backgroundView = backgroundView
		self.addSubview(self.backgroundView)
		self.backgroundView.layer.borderColor = grayDetails.CGColor
		self.backgroundView.layer.borderWidth = 1
		self.backgroundView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.snp_edges)
		}
		
		if self.withTitle {
			
			let titleView = UIView()
			self.titleView = titleView
			self.backgroundView.addSubview(self.titleView!)
			self.titleView!.backgroundColor = whitePrimary
			self.titleView!.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.backgroundView.snp_top)
				make.left.equalTo(self.backgroundView.snp_left)
				make.right.equalTo(self.backgroundView.snp_right)
				make.height.equalTo(60)
			}
			
			let titleLabel = UILabel()
			self.titleLabel = titleLabel
			self.titleView!.addSubview(self.titleLabel!)
			self.titleLabel!.text = containerTitle
			self.titleLabel!.font = UIFont(name: "Lato-Regular", size: kNavTitle18)
			self.titleLabel!.textColor = blackPrimary
			self.titleLabel!.snp_makeConstraints { (make) -> Void in
				make.centerY.equalTo(self.titleView!.snp_centerY)
				make.left.equalTo(self.titleView!.snp_left).offset(20)
			}
			
			let titleLine = UIView()
			self.titleLine = titleLine
			self.titleView!.addSubview(self.titleLine!)
			self.titleLine!.backgroundColor = grayDetails
			self.titleLine!.snp_makeConstraints { (make) -> Void in
				make.bottom.equalTo(self.titleView!.snp_bottom)
				make.centerX.equalTo(self.titleView!.snp_centerX)
				make.height.equalTo(0.5)
			}
			
			let contentView = UIView()
			self.contentView = contentView
			self.backgroundView.addSubview(self.contentView)
			self.contentView.backgroundColor = whitePrimary
			self.contentView.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.titleView!.snp_top)
				make.left.equalTo(self.backgroundView.snp_left)
				make.right.equalTo(self.backgroundView.snp_right)
				make.bottom.equalTo(self.backgroundView.snp_bottom)
			}
			
		} else {
			
			print("no title set")
			
			let contentView = UIView()
			self.contentView = contentView
			self.backgroundView.addSubview(self.contentView)
			self.contentView.backgroundColor = whitePrimary
			self.contentView.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.backgroundView.snp_top)
				make.left.equalTo(self.backgroundView.snp_left)
				make.right.equalTo(self.backgroundView.snp_right)
				make.bottom.equalTo(self.backgroundView.snp_bottom)
			}
		}
	}
}
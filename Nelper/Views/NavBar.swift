//
//  NavBar.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-08-06.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class NavBar: UINavigationBar {
	
	private var container: UIView!
	private var logoView: UIImageView!
	private var titleView: UILabel!
	private var backButtonView: UIButton?
	private var backArrow:UIImageView!
	
	var backButton: UIButton? {
		didSet {
			if let value = backButton {
				self.backButtonView?.removeFromSuperview()
				self.backButtonView = value
				self.backButtonView?.setTitle("    ", forState: UIControlState.Normal)
				self.backButtonView?.setTitleColor(nelperRedColor, forState: UIControlState.Normal)
				self.backButtonView?.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
				self.backButtonView?.contentEdgeInsets = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 0)
				self.container.addSubview(self.backButtonView!)
				
				var backArrow = UIImageView()
				self.backArrow = backArrow
				backArrow.image = UIImage(named: "left_arrow_red")
				backArrow.contentMode = UIViewContentMode.ScaleAspectFit
				self.backButtonView?.addSubview(backArrow)
				backArrow.snp_makeConstraints { (make) -> Void in
					make.left.equalTo(self.backButtonView!.snp_left).offset(6)
					make.centerY.equalTo(self.backButtonView!.snp_centerY).offset(0)
					make.width.equalTo(30)
					make.height.equalTo(30)
				}
				
				self.backButtonView?.snp_makeConstraints(closure: { (make) -> Void in
					make.left.equalTo(self.container.snp_left).offset(4)
					make.centerY.equalTo(self.container.snp_centerY).offset(8)
				})
			}
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.adjustUI()
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.adjustUI()
	}
	
	func adjustUI() {
		self.translucent = false
		self.shadowImage = UIImage()
		self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
		self.layer.shadowColor = UIColor.blackColor().CGColor
		self.layer.shadowOffset = CGSizeMake(0.0, 3)
		self.layer.shadowOpacity = 0.25
		self.layer.masksToBounds = false
		self.layer.shouldRasterize = true
		
		self.container = UIView()
		self.container.backgroundColor = navBarColor
		self.addSubview(self.container)
		self.container.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self)
		}
		
		/*self.logoView = UIImageView()
		self.logoView.image = UIImage(named: "logo_round_v2")
		self.logoView.contentMode = UIViewContentMode.ScaleAspectFit
		self.container.addSubview(self.logoView)
		self.logoView.snp_makeConstraints { (make) -> Void in
			make.size.equalTo(40)
			make.centerX.equalTo(self.container.snp_centerX).offset(-50)
			make.centerY.equalTo(self.container.snp_centerY).offset(8)
		}*/
		
		self.titleView = UILabel()
		self.titleView.text = "Nelper"
		self.titleView.font = UIFont(name: "HelveticaNeue", size: kNavBarTitleFont)
		self.titleView.textColor = nelperRedColor
		self.titleView.sizeToFit()
		
		self.container.addSubview(self.titleView)
		self.titleView.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(self.container.snp_centerX).offset(0)
			make.centerY.equalTo(self.container.snp_centerY).offset(8)
		}
	}
	
	func setTitle(title:String){
		self.titleView.text = title
	}
	
	func setImage(image:UIImage){
		self.backArrow.image = image
	}
}
//
//  PicturesCollectionViewCell.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-10-01.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

protocol PicturesCollectionViewCellDelegate {
	func didRemovePicture(vc:PicturesCollectionViewCell)
}

class PicturesCollectionViewCell: UICollectionViewCell {
	var imageView: UIImageView!
	var delegate:PicturesCollectionViewCellDelegate?
	
	
	//MARK: Initialization
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let imageView = UIImageView()
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		self.imageView = imageView
		self.addSubview(imageView)
		imageView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self)
		}
		let removeButton = UIButton()
		self.addSubview(removeButton)
		removeButton.setImage(UIImage(named:"denied"), forState: UIControlState.Normal)
		removeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
		removeButton.backgroundColor = UIColor.clearColor()
		removeButton.addTarget(self, action: "didRemovePicture:", forControlEvents: UIControlEvents.TouchUpInside)
		removeButton.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(imageView.snp_left).offset(5)
			make.top.equalTo(imageView.snp_top).offset(5)
			make.width.equalTo(40)
			make.height.equalTo(40)
		}
	}
	
	func didRemovePicture(sender:UIButton) {
		self.delegate?.didRemovePicture(self)
	}

	static var reuseIdentifier: String {
		get {
			return "PicturesCollectionViewCell"
		}
	}

}

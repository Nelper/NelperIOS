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



class PicturesCollectionViewCell: UICollectionViewCell {
	var imageView: UIImageView!
	
	
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
	}

	static var reuseIdentifier: String {
		get {
			return "PicturesCollectionViewCell"
		}
	}

}

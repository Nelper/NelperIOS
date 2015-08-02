//
//  AutocompleteCell.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-02.
//  Copyright (c) 2015 Nelper. All rights reserved.
//


import Foundation
import UIKit
import SnapKit
import Alamofire

class AutocompleteCell: UITableViewCell {
	
	var suggestedAddress: UILabel!
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		
		let cellView = UIView(frame: self.bounds)
		cellView.backgroundColor = UIColor.yellowColor()
		cellView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
		
		let suggestedAddress = UILabel()
		self.suggestedAddress = suggestedAddress
		
		cellView.addSubview(suggestedAddress)
		
		suggestedAddress.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(cellView.snp_left).offset(2)
			make.centerY.equalTo(cellView.snp_centerY)
		}
		
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
			return "AutocompleteCell"
		}
	}

	func setAddress(prediction:GMSAutocompletePrediction){
		var predictionText = prediction.attributedFullText
		self.suggestedAddress.text = predictionText.string
	}


}

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
	var prediction: GMSAutocompletePrediction!
	var suggestedAddress: UILabel!
	
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		self.backgroundColor = whiteNelpyColor
		
		let cellView = UIView(frame: self.bounds)
		self.addSubview(cellView)
		cellView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self).inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
		}
		
		cellView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight;
		
		let suggestedAddress = UILabel()
		suggestedAddress.numberOfLines = 0
		suggestedAddress.textColor = blackNelpyColor
		suggestedAddress.font = UIFont(name: "Railway", size: kTextFontSize)
		self.suggestedAddress = suggestedAddress
		self.suggestedAddress.backgroundColor = whiteNelpyColor.colorWithAlphaComponent(0.2)
		
		cellView.addSubview(suggestedAddress)
		
		suggestedAddress.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(cellView.snp_edges)
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
		self.prediction = prediction
		var predictionText = prediction.attributedFullText
		self.suggestedAddress.text = predictionText.string
	}
	
	
}
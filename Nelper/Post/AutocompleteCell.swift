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
	
	//MARK: Initialization
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		self.clipsToBounds = true
		self.backgroundColor = whitePrimary
		
		let cellView = UIView(frame: self.bounds)
		self.addSubview(cellView)
		
		cellView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight];
		
		let suggestedAddress = UILabel()
		suggestedAddress.numberOfLines = 0
		suggestedAddress.textColor = blackPrimary
		suggestedAddress.font = UIFont(name: "Lato-Regular", size: kText15)
		self.suggestedAddress = suggestedAddress
		self.suggestedAddress.backgroundColor = whitePrimary
		cellView.addSubview(suggestedAddress)
		
		suggestedAddress.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(cellView.snp_top)
			make.right.equalTo(cellView.snp_right).offset(-10)
			make.bottom.equalTo(cellView.snp_bottom)
			make.left.equalTo(cellView.snp_left).offset(10)
		}
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
			return "AutocompleteCell"
		}
	}
	
	func setAddress(prediction:GMSAutocompletePrediction){
		self.prediction = prediction
		let predictionText = prediction.attributedFullText
		self.suggestedAddress.text = predictionText.string
	}
	
	
}

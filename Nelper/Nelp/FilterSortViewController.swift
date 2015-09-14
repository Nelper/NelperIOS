//
//  FilterSortViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

protocol FilterSortViewControllerDelegate{
	func didTapAddFilters(filters:Array<String>?, sort:String?, minPrice:Double?, maxDistance:Double?)
}

class FilterSortViewController: UIViewController{
	
	private var kFilterCategorySize = 65
	private var kFilterCategorySpacing = 12
	var technologyButton: UIButton!
	var businessButton: UIButton!
	var cleaningButton: UIButton!
	var gardeningButton: UIButton!
	var otherButton: UIButton!
	var handyworkButton: UIButton!
	var multimediaButton: UIButton!
	var distanceCheckBox: UIButton!
	var priceCheckBox: UIButton!
	var distanceStepper: UIStepper!
	var priceStepper: UIStepper!
	var priceValueLabel: UILabel!
	var distanceValueLabel: UILabel!
	var delegate: FilterSortViewControllerDelegate!
	var sortBy: String?
	var arrayOfFilters = Array<String>()
	var minPrice:Double?
	var maxDistance:Double?
	var arrayOfFiltersFromPrevious = Array<String>()
	var previousSortBy:String?
	var sortingSegmentControl: UISegmentedControl!
	var previousMinPrice:Double?
	var previousMaxDistance:Double?

	//MARK: Initialization
	
	override func viewDidLoad() {
			super.viewDidLoad()
			self.createView()
			self.checkFilters()
			self.checkSort()
	}
	
	//MARK: View Creation
	
	func createView(){
		
		var navBar = NavBar()
		self.view.addSubview(navBar)
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		navBar.setTitle("Filters")
		let backBtn = UIButton()
		backBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		navBar.backButton = backBtn
		navBar.setImage(UIImage(named: "close_red" )!)
		navBar.setTitle("Filters and Sorting")

		var contentView = UIView()
		self.view.addSubview(contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.width.equalTo(self.view.snp_width)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		contentView.backgroundColor = whiteNelpyColor
		
		
		//Sorting Container
		
		var sortingContainer = UIView()
		contentView.addSubview(sortingContainer)
		sortingContainer.backgroundColor = navBarColor
		sortingContainer.layer.borderColor = darkGrayDetails.CGColor
		sortingContainer.layer.borderWidth = 1
		sortingContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(10)
			make.left.equalTo(contentView.snp_left).offset(10)
			make.right.equalTo(contentView.snp_right).offset(-10)
			make.height.equalTo(90)
		}
		
		var sortingLabel = UILabel()
		sortingContainer.addSubview(sortingLabel)
		sortingLabel.text = "Sort by:"
		sortingLabel.textColor = nelperRedColor
		sortingLabel.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		sortingLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(sortingContainer.snp_left).offset(8)
			make.top.equalTo(sortingContainer.snp_top).offset(8)
			make.right.equalTo(sortingContainer.snp_right).offset(-8)
			make.height.equalTo(20)
		}
		
		var sortingSegmentControl = UISegmentedControl()
		self.sortingSegmentControl = sortingSegmentControl
		sortingContainer.addSubview(sortingSegmentControl)
		sortingSegmentControl.addTarget(self, action: "segmentControlTouched:", forControlEvents: UIControlEvents.ValueChanged)
		sortingSegmentControl.insertSegmentWithTitle("Price", atIndex: 0, animated: false)
		sortingSegmentControl.insertSegmentWithTitle("Distance", atIndex: 1, animated: false)
		sortingSegmentControl.insertSegmentWithTitle("Creation Date", atIndex: 2, animated: false)
		sortingSegmentControl.tintColor = nelperRedColor
		sortingSegmentControl.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(sortingContainer.snp_bottom).offset(-12)
			make.centerX.equalTo(sortingContainer.snp_centerX)
			make.left.equalTo(sortingContainer.snp_left).offset(8)
			make.right.equalTo(sortingContainer.snp_right).offset(-8)
			make.height.equalTo(35)
		}
		
		var addFiltersButton = UIButton()
		contentView.addSubview(addFiltersButton)
		addFiltersButton.addTarget(self, action: "didTapAddFiltersButton:", forControlEvents: UIControlEvents.TouchUpInside)
		addFiltersButton.backgroundColor = grayBlueColor
		addFiltersButton.setTitle("Add Filters", forState: UIControlState.Normal)
		addFiltersButton.setTitleColor(navBarColor, forState: UIControlState.Normal)
		addFiltersButton.layer.cornerRadius = 3
		addFiltersButton.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(contentView.snp_bottom).offset(-10)
			make.centerX.equalTo(contentView.snp_centerX)
			make.height.equalTo(45)
			make.width.equalTo(120)
		}
		
		//Filters Container
		
		var filtersContainer = UIView()
		contentView.addSubview(filtersContainer)
		filtersContainer.backgroundColor = navBarColor
		filtersContainer.layer.borderColor = darkGrayDetails.CGColor
		filtersContainer.layer.borderWidth = 1
		filtersContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(sortingContainer.snp_bottom).offset(10)
			make.left.equalTo(contentView.snp_left).offset(8)
			make.right.equalTo(contentView.snp_right).offset(-8)
			make.bottom.equalTo(addFiltersButton.snp_top).offset(-10)
		}
		
		var filtersLabel = UILabel()
		filtersContainer.addSubview(filtersLabel)
		filtersLabel.text = "Filters:"
		filtersLabel.textColor = nelperRedColor
		filtersLabel.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		filtersLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(filtersContainer.snp_left).offset(8)
			make.top.equalTo(filtersContainer.snp_top).offset(8)
			make.right.equalTo(filtersContainer.snp_right).offset(-8)
			make.height.equalTo(20)
		}
		
		var firstRowOfCategories = UIView()
		filtersContainer.addSubview(firstRowOfCategories)
		firstRowOfCategories.backgroundColor = navBarColor
		firstRowOfCategories.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(kFilterCategorySize * 4 + kFilterCategorySpacing * 3)
			make.height.equalTo(kFilterCategorySize)
			make.centerX.equalTo(filtersContainer.snp_centerX)
			make.top.equalTo(filtersLabel.snp_bottom).offset(20)
		}
		
		var technologyButton = UIButton()
		technologyButton.addTarget(self, action: "didTapTechnology:", forControlEvents: UIControlEvents.TouchUpInside)
		self.technologyButton = technologyButton
		firstRowOfCategories.addSubview(technologyButton)
		technologyButton.alpha = 0.3
		technologyButton.setBackgroundImage(UIImage(named: "technology"), forState: UIControlState.Normal)
		technologyButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(firstRowOfCategories.snp_centerY)
			make.left.equalTo(firstRowOfCategories.snp_left)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		technologyButton.layer.cornerRadius = CGFloat(kFilterCategorySize / 2)
		technologyButton.layer.borderColor = darkGrayDetails.CGColor
		technologyButton.layer.borderWidth = 0
		
		var multimediaButton = UIButton()
		multimediaButton.addTarget(self, action: "didTapMultimedia:", forControlEvents: UIControlEvents.TouchUpInside)
		self.multimediaButton = multimediaButton
		firstRowOfCategories.addSubview(multimediaButton)
		multimediaButton.alpha = 0.3
		multimediaButton.setBackgroundImage(UIImage(named: "multimedia"), forState: UIControlState.Normal)
		multimediaButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(firstRowOfCategories.snp_centerY)
			make.left.equalTo(technologyButton.snp_right).offset(kFilterCategorySpacing)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		
		multimediaButton.layer.cornerRadius = CGFloat(kFilterCategorySize / 2)
		multimediaButton.layer.borderColor = darkGrayDetails.CGColor
		multimediaButton.layer.borderWidth = 0
		
		var handyWorkButton = UIButton()
		handyWorkButton.addTarget(self, action: "didTapHandywork:", forControlEvents: UIControlEvents.TouchUpInside)
		self.handyworkButton = handyWorkButton
		firstRowOfCategories.addSubview(handyWorkButton)
		handyworkButton.alpha = 0.3
		handyWorkButton.setBackgroundImage(UIImage(named: "handywork"), forState: UIControlState.Normal)
		handyWorkButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(firstRowOfCategories.snp_centerY)
			make.left.equalTo(multimediaButton.snp_right).offset(kFilterCategorySpacing)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		
		handyWorkButton.layer.cornerRadius = CGFloat(kFilterCategorySize / 2)
		handyWorkButton.layer.borderColor = darkGrayDetails.CGColor
		handyWorkButton.layer.borderWidth = 0
		
		var gardeningButton = UIButton()
		gardeningButton.addTarget(self, action: "didTapGardening:", forControlEvents: UIControlEvents.TouchUpInside)
		self.gardeningButton = gardeningButton
		firstRowOfCategories.addSubview(gardeningButton)
		gardeningButton.alpha = 0.3
		gardeningButton.setBackgroundImage(UIImage(named: "gardening"), forState: UIControlState.Normal)
		gardeningButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(firstRowOfCategories.snp_centerY)
			make.left.equalTo(handyWorkButton.snp_right).offset(kFilterCategorySpacing)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		
		gardeningButton.layer.cornerRadius = CGFloat(kFilterCategorySize / 2)
		gardeningButton.layer.borderColor = darkGrayDetails.CGColor
		gardeningButton.layer.borderWidth = 0
		
		var secondRowOfCategories = UIView()
		filtersContainer.addSubview(secondRowOfCategories)
		secondRowOfCategories.backgroundColor = navBarColor
		secondRowOfCategories.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(kFilterCategorySize * 3 + kFilterCategorySpacing * 2)
			make.height.equalTo(kFilterCategorySize)
			make.top.equalTo(firstRowOfCategories.snp_bottom).offset(4)
			make.centerX.equalTo(filtersContainer.snp_centerX)
		}
		
		var businessButton = UIButton()
		businessButton.addTarget(self, action: "didTapBusiness:", forControlEvents: UIControlEvents.TouchUpInside)
		self.businessButton = businessButton
		secondRowOfCategories.addSubview(businessButton)
		businessButton.alpha = 0.3
		businessButton.setBackgroundImage(UIImage(named: "business"), forState: UIControlState.Normal)
		businessButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(secondRowOfCategories.snp_centerY)
			make.left.equalTo(secondRowOfCategories.snp_left)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		
		businessButton.layer.cornerRadius = CGFloat(kFilterCategorySize / 2)
		businessButton.layer.borderColor = darkGrayDetails.CGColor
		businessButton.layer.borderWidth = 0
		
		var cleaningButton = UIButton()
		cleaningButton.addTarget(self, action: "didTapCleaning:", forControlEvents: UIControlEvents.TouchUpInside)
		self.cleaningButton = cleaningButton
		secondRowOfCategories.addSubview(cleaningButton)
		cleaningButton.alpha = 0.3
		cleaningButton.setBackgroundImage(UIImage(named: "housecleaning"), forState: UIControlState.Normal)
		cleaningButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(secondRowOfCategories.snp_centerY)
			make.left.equalTo(businessButton.snp_right).offset(kFilterCategorySpacing)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		
		cleaningButton.layer.cornerRadius = CGFloat(kFilterCategorySize / 2)
		cleaningButton.layer.borderColor = darkGrayDetails.CGColor
		cleaningButton.layer.borderWidth = 0
		
		var otherButton = UIButton()
		otherButton.addTarget(self, action: "didTapOther:", forControlEvents: UIControlEvents.TouchUpInside)
		self.otherButton = otherButton
		secondRowOfCategories.addSubview(otherButton)
		otherButton.alpha = 0.3
		otherButton.setBackgroundImage(UIImage(named: "other"), forState: UIControlState.Normal)
		otherButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(secondRowOfCategories.snp_centerY)
			make.left.equalTo(cleaningButton.snp_right).offset(kFilterCategorySpacing)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		
		otherButton.layer.cornerRadius = CGFloat(kFilterCategorySize / 2)
		otherButton.layer.borderColor = darkGrayDetails.CGColor
		otherButton.layer.borderWidth = 0
		
		
		//Distance Filter
		var distanceCheckBox = UIButton()
		distanceCheckBox.addTarget(self, action: "didTapDistanceCheckBox:", forControlEvents: UIControlEvents.TouchUpInside)
		self.distanceCheckBox = distanceCheckBox
		filtersContainer.addSubview(distanceCheckBox)
		distanceCheckBox.setBackgroundImage(UIImage(named: "checkbox_unchecked"), forState: UIControlState.Normal)
		distanceCheckBox.setBackgroundImage(UIImage(named: "checkbox_checked"), forState: UIControlState.Selected)
		distanceCheckBox.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(secondRowOfCategories.snp_bottom).offset(40)
			make.left.equalTo(filtersLabel.snp_left)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		var distanceLabel = UILabel()
		filtersContainer.addSubview(distanceLabel)
		distanceLabel.text = "Distance within:"
		distanceLabel.textColor = blackNelpyColor
		distanceLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		distanceLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(distanceCheckBox.snp_right).offset(4)
			make.centerY.equalTo(distanceCheckBox.snp_centerY)
		}
		
		var distanceStepper = UIStepper()
		self.distanceStepper = distanceStepper
		self.distanceStepper.minimumValue = 1
		self.distanceStepper.maximumValue = 999
		self.distanceStepper.stepValue = 1
		distanceStepper.continuous = true
		distanceStepper.addTarget(self, action: "didTapDistanceStepper:", forControlEvents: UIControlEvents.ValueChanged)
		distanceStepper.enabled = false
		distanceStepper.alpha = 0.3
		filtersContainer.addSubview(distanceStepper)
		distanceStepper.tintColor = nelperRedColor
		distanceStepper.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(30)
			make.width.equalTo(60)
			make.centerX.equalTo(otherButton.snp_centerX).offset(30)
			make.centerY.equalTo(distanceCheckBox.snp_centerY)
		}
		
		var distanceValueLabel = UILabel()
		self.distanceValueLabel = distanceValueLabel
		distanceValueLabel.alpha = 0.3
		filtersContainer.addSubview(distanceValueLabel)
		distanceValueLabel.text = "\(Int(self.distanceStepper.value))km"
		distanceValueLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		distanceValueLabel.textColor = blackNelpyColor
		distanceValueLabel.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(distanceStepper.snp_left).offset(-4)
			make.centerY.equalTo(distanceStepper.snp_centerY)
		}
		
		//Price Filter
		
		var priceCheckBox = UIButton()
		priceCheckBox.addTarget(self, action: "didTapPriceCheckBox:", forControlEvents: UIControlEvents.TouchUpInside)
		self.priceCheckBox = priceCheckBox
		filtersContainer.addSubview(priceCheckBox)
		priceCheckBox.setBackgroundImage(UIImage(named: "checkbox_unchecked"), forState: UIControlState.Normal)
		priceCheckBox.setBackgroundImage(UIImage(named: "checkbox_checked"), forState: UIControlState.Selected)
		priceCheckBox.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(distanceCheckBox.snp_bottom).offset(30)
			make.left.equalTo(filtersLabel.snp_left)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		var priceLabel = UILabel()
		filtersContainer.addSubview(priceLabel)
		priceLabel.text = "Minimum Price:"
		priceLabel.textColor = blackNelpyColor
		priceLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		priceLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(priceCheckBox.snp_right).offset(4)
			make.centerY.equalTo(priceCheckBox.snp_centerY)
		}
		
		var priceStepper = UIStepper()
		self.priceStepper = priceStepper
		priceStepper.minimumValue = 10
		priceStepper.maximumValue = 2000
		priceStepper.addTarget(self, action: "didTapPriceStepper:", forControlEvents: UIControlEvents.ValueChanged)
		priceStepper.continuous = true
		priceStepper.stepValue = 5
		priceStepper.alpha = 0.3
		priceStepper.enabled = false
		filtersContainer.addSubview(priceStepper)
		priceStepper.tintColor = nelperRedColor
		priceStepper.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(30)
			make.width.equalTo(60)
			make.centerX.equalTo(distanceStepper.snp_centerX)
			make.centerY.equalTo(priceCheckBox.snp_centerY)
		}
		
		var priceValueLabel = UILabel()
		self.priceValueLabel = priceValueLabel
		priceValueLabel.alpha = 0.3
		filtersContainer.addSubview(priceValueLabel)
		priceValueLabel.text = "\(Int(self.priceStepper.value))$"
		priceValueLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		priceValueLabel.textColor = blackNelpyColor
		priceValueLabel.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(priceStepper.snp_left).offset(-4)
			make.centerY.equalTo(priceStepper.snp_centerY)
		}
	}
	
	//MARK: UI
	
	/**
	Check previously applied filters
	*/
	func checkFilters(){
		for filter in self.arrayOfFiltersFromPrevious {
			if filter == "technology"{
				self.didTapTechnology(nil)
			}else if filter == "business"{
				self.didTapBusiness(nil)
			}else if filter == "gardening"{
				self.didTapGardening(nil)
			}else if filter == "housecleaning"{
				self.didTapCleaning(nil)
			}else if filter == "multimedia"{
				self.didTapMultimedia(nil)
			}else if filter == "other"{
				self.didTapOther(nil)
			}else if filter == "handywork"{
				self.didTapHandywork(nil)
			}
		}
		
		if self.previousMinPrice != nil {
			self.priceCheckBox.selected = true
			self.priceStepper.value = previousMinPrice!
			self.minPrice = previousMinPrice!
			self.priceStepper.alpha = 1
			self.priceStepper.enabled = true
			self.priceValueLabel.alpha = 1
			self.priceValueLabel.text = "\(Int(self.priceStepper.value))$"
		}
		
		if self.previousMaxDistance != nil{
			self.distanceCheckBox.selected = true
			self.distanceStepper.value = previousMaxDistance!
			self.maxDistance = previousMaxDistance!
			self.distanceStepper.enabled = true
			self.distanceStepper.alpha = 1
			self.distanceValueLabel.alpha = 1
			self.distanceValueLabel.text = "\(Int(self.distanceStepper.value))km"

		}
	}
	
	/**
	check previously applied sorting
	*/
	func checkSort(){
		if self.previousSortBy != nil{
			if previousSortBy == "createdAt"{
				self.sortingSegmentControl.selectedSegmentIndex = 2
			}else if previousSortBy == "location"{
				self.sortingSegmentControl.selectedSegmentIndex = 1
			}else if previousSortBy == "priceOffered"{
				self.sortingSegmentControl.selectedSegmentIndex = 0
			}
		}
	}
	
	//MARK: Actions
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func didTapAddFiltersButton(sender:UIButton){
		print(self.minPrice)
		self.delegate.didTapAddFilters(self.arrayOfFilters, sort: self.sortBy, minPrice: self.minPrice, maxDistance: self.maxDistance)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	/**
	Activates and enable the Maximum Distance Filter
	
	- parameter sender: Button
	*/
	func didTapDistanceCheckBox(sender:UIButton){
		self.distanceCheckBox.selected = !self.distanceCheckBox.selected
		if self.distanceCheckBox.selected {
				self.distanceStepper.enabled = true
			self.maxDistance = distanceStepper.value
			self.distanceStepper.alpha = 1
			self.distanceValueLabel.alpha = 1
		}else{
			self.distanceStepper.enabled = false
			self.maxDistance = nil
			self.distanceStepper.alpha = 0.3
			self.distanceValueLabel.alpha = 0.3
		}
	}
	
	/**
	Activates and enable the Minimum Price
	
	- parameter sender: Button
	*/
	func didTapPriceCheckBox(sender:UIButton!){
		self.priceCheckBox.selected = !self.priceCheckBox.selected
		if self.priceCheckBox.selected{
			self.priceStepper.enabled = true
			self.priceStepper.alpha = 1
			self.minPrice = priceStepper.value
			self.priceValueLabel.alpha = 1
		}else {
			self.priceStepper.enabled = false
			self.priceStepper.alpha = 0.3
			self.minPrice = nil
			self.priceValueLabel.alpha = 0.3
		}
	}
	
	/**
	Distance Stepper Control
	
	- parameter sender: Distance Stepper
	*/
	func didTapDistanceStepper(sender:UIStepper){
		self.distanceValueLabel.text = "\(Int(sender.value))km"
		self.maxDistance = distanceStepper.value
	}
	
	/**
	Price stepper control
	
	- parameter sender: Price Stepper
	*/
	func didTapPriceStepper(sender:UIStepper){
		self.priceValueLabel.text = "\(Int(sender.value))$"
		self.minPrice = priceStepper.value

	}
	
	/**
	Sorting selection
	
	- parameter sender: Sorting Segment Control
	*/
	func segmentControlTouched(sender:UISegmentedControl){
		if sender.selectedSegmentIndex == 0 {
			self.sortBy = "priceOffered"
		}else if sender.selectedSegmentIndex == 1{
			self.sortBy = "distance"
		}else if sender.selectedSegmentIndex == 2{
			self.sortBy = "createdAt"
		}
	}
	
	func didTapTechnology(sender:UIButton?){
		self.technologyButton.selected = !self.technologyButton.selected
		if self.technologyButton.selected == true{
			self.technologyButton.alpha = 1
			self.arrayOfFilters.append("technology")
		}else{
			self.technologyButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++) {
				var filter = self.arrayOfFilters[i]
				if filter == "technology"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapBusiness(sender:UIButton?){
		self.businessButton.selected = !self.businessButton.selected
		if self.businessButton.selected == true{
			self.arrayOfFilters.append("business")
			self.businessButton.alpha = 1

		}else{
			self.businessButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++ ){
				var filter = self.arrayOfFilters[i]
				if filter == "business"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapGardening(sender:UIButton?){
		self.gardeningButton.selected = !self.gardeningButton.selected
		if self.gardeningButton.selected == true{
			self.arrayOfFilters.append("gardening")
			self.gardeningButton.alpha = 1

		}else{
			self.gardeningButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++ ){
				var filter = self.arrayOfFilters[i]
				if filter == "gardening"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapCleaning(sender:UIButton?){
		self.cleaningButton.selected = !self.cleaningButton.selected
		if self.cleaningButton.selected == true{
			self.arrayOfFilters.append("housecleaning")
			self.cleaningButton.alpha = 1

		}else{
			self.cleaningButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++ ){
				var filter = self.arrayOfFilters[i]
				if filter == "housecleaning"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapOther(sender:UIButton?){
		self.otherButton.selected = !self.otherButton.selected
		if self.otherButton.selected == true{
			self.arrayOfFilters.append("other")
			self.otherButton.alpha = 1

		}else{
			self.otherButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++ ){
				var filter = self.arrayOfFilters[i]
				if filter == "other"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapMultimedia(sender:UIButton?){
		self.multimediaButton.selected = !self.multimediaButton.selected
		if self.multimediaButton.selected == true{
				self.multimediaButton.alpha = 1
			self.arrayOfFilters.append("multimedia")
		}else{
			self.multimediaButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++ ){
				var filter = self.arrayOfFilters[i]
				if filter == "multimedia"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapHandywork(sender:UIButton?){
		self.handyworkButton.selected = !self.handyworkButton.selected
		if self.handyworkButton.selected == true{
			self.handyworkButton.alpha = 1
			self.arrayOfFilters.append("handywork")
		}else{
			self.handyworkButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++ ){
				var filter = self.arrayOfFilters[i]
				if filter == "handywork"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}

}
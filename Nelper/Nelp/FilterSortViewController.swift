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
	
	private var kFilterCategorySize = 55
	private var kFilterCategorySpacing = 18
	var technologyButton: UIButton!
	var businessButton: UIButton!
	var cleaningButton: UIButton!
	var gardeningButton: UIButton!
	var otherButton: UIButton!
	var handyworkButton: UIButton!
	var multimediaButton: UIButton!
	var allButton:UIButton!
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
	var scrollView:UIScrollView!
	var contentView:UIView!
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.createView()
		self.checkFilters()
		self.checkSort()
	}
	
	//MARK: View Creation
	
	func createView(){
		
		let navBar = NavBar()
		self.view.addSubview(navBar)
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		navBar.setTitle("Filters and Sorting")
		
		let background = UIView()
		self.view.addSubview(background)
		background.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		background.backgroundColor = whiteNelpyColor
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		background.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(background.snp_edges)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		self.scrollView.addSubview(contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.height.greaterThanOrEqualTo(background.snp_height)
			make.width.equalTo(background.snp_width)
		}
		
		contentView.backgroundColor = whiteNelpyColor
		
		//Filters Container
		
		let filtersContainer = UIView()
		contentView.addSubview(filtersContainer)
		filtersContainer.backgroundColor = whiteGrayColor
		filtersContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
		}
		
		let sortingLabel = UILabel()
		filtersContainer.addSubview(sortingLabel)
		sortingLabel.text = "Sort by"
		sortingLabel.textColor = blackTextColor
		sortingLabel.font = UIFont(name: "Lato-Regular", size: kTitle16)
		sortingLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(filtersContainer.snp_centerX)
			make.top.equalTo(filtersContainer.snp_top).offset(20)
			make.height.equalTo(20)
		}
		
		let sortingSegmentControl = UISegmentedControl()
		self.sortingSegmentControl = sortingSegmentControl
		filtersContainer.addSubview(sortingSegmentControl)
		sortingSegmentControl.addTarget(self, action: "segmentControlTouched:", forControlEvents: UIControlEvents.ValueChanged)
		sortingSegmentControl.insertSegmentWithTitle("Price", atIndex: 0, animated: false)
		sortingSegmentControl.insertSegmentWithTitle("Distance", atIndex: 1, animated: false)
		sortingSegmentControl.insertSegmentWithTitle("Creation Date", atIndex: 2, animated: false)
		sortingSegmentControl.tintColor = nelperRedColor
		sortingSegmentControl.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(sortingLabel.snp_bottom).offset(20)
			make.centerX.equalTo(filtersContainer.snp_centerX)
			make.width.equalTo(300)
			make.height.equalTo(35)
		}
		sortingSegmentControl.layer.cornerRadius = 3
		sortingSegmentControl.layer.borderColor = nelperRedColor.CGColor
		sortingSegmentControl.layer.borderWidth = 1.0
		sortingSegmentControl.layer.masksToBounds = true
		
		let sortingUnderline = UIView()
		filtersContainer.addSubview(sortingUnderline)
		sortingUnderline.backgroundColor = darkGrayDetails
		sortingUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(sortingSegmentControl.snp_bottom).offset(30)
			make.width.equalTo(filtersContainer.snp_width).dividedBy(1.5)
			make.centerX.equalTo(filtersContainer.snp_centerX)
			make.height.equalTo(0.5)
		}
		
		let filtersLabel = UILabel()
		filtersContainer.addSubview(filtersLabel)
		filtersLabel.text = "Filters"
		filtersLabel.textColor = blackTextColor
		filtersLabel.font = UIFont(name: "Lato-Regular", size: kTitle16)
		filtersLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(filtersContainer.snp_centerX)
			make.top.equalTo(sortingUnderline.snp_bottom).offset(25)
			make.height.equalTo(20)
		}
		
		let firstRowOfCategories = UIView()
		filtersContainer.addSubview(firstRowOfCategories)
		firstRowOfCategories.backgroundColor = whiteGrayColor
		firstRowOfCategories.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(kFilterCategorySize * 4 + kFilterCategorySpacing * 3)
			make.height.equalTo(kFilterCategorySize)
			make.centerX.equalTo(filtersContainer.snp_centerX)
			make.top.equalTo(filtersLabel.snp_bottom).offset(20)
		}
		
		let technologyButton = UIButton()
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
		
		let multimediaButton = UIButton()
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
		
		let handyWorkButton = UIButton()
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
		
		let gardeningButton = UIButton()
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
		
		let secondRowOfCategories = UIView()
		filtersContainer.addSubview(secondRowOfCategories)
		secondRowOfCategories.backgroundColor = whiteGrayColor
		secondRowOfCategories.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(kFilterCategorySize * 4 + kFilterCategorySpacing * 3)
			make.height.equalTo(kFilterCategorySize)
			make.top.equalTo(firstRowOfCategories.snp_bottom).offset(4)
			make.centerX.equalTo(filtersContainer.snp_centerX)
		}
		
		let businessButton = UIButton()
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
		
		let cleaningButton = UIButton()
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
		
		let otherButton = UIButton()
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
		
		let allButton = UIButton()
		allButton.addTarget(self, action: "didTapAll:", forControlEvents: UIControlEvents.TouchUpInside)
		self.allButton = allButton
		secondRowOfCategories.addSubview(allButton)
		allButton.alpha = 0.3
		allButton.setBackgroundImage(UIImage(named: "all"), forState: UIControlState.Normal)
		allButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(secondRowOfCategories.snp_centerY)
			make.left.equalTo(otherButton.snp_right).offset(kFilterCategorySpacing)
			make.height.equalTo(kFilterCategorySize + 7)
			make.width.equalTo(kFilterCategorySize + 7)
		}
		
		allButton.layer.cornerRadius = CGFloat(kFilterCategorySize / 2)
		allButton.layer.borderColor = darkGrayDetails.CGColor
		allButton.layer.borderWidth = 0
		
		
		//Distance Filter
		
		let distanceCheckBox = UIButton()
		distanceCheckBox.addTarget(self, action: "didTapDistanceCheckBox:", forControlEvents: UIControlEvents.TouchUpInside)
		self.distanceCheckBox = distanceCheckBox
		filtersContainer.addSubview(distanceCheckBox)
		distanceCheckBox.setBackgroundImage(UIImage(named: "empty_check"), forState: UIControlState.Normal)
		distanceCheckBox.setBackgroundImage(UIImage(named: "checked_box"), forState: UIControlState.Selected)
		distanceCheckBox.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(filtersContainer.snp_left).offset(25)
			make.top.equalTo(allButton.snp_bottom).offset(45)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let distanceLabel = UILabel()
		filtersContainer.addSubview(distanceLabel)
		distanceLabel.text = "Distance within"
		distanceLabel.textColor = blackNelpyColor
		distanceLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		distanceLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(distanceCheckBox.snp_right).offset(15)
			make.centerY.equalTo(distanceCheckBox.snp_centerY)
		}
		
		let distanceStepper = UIStepper()
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
			make.right.equalTo(filtersContainer.snp_right).offset(-55)
			make.centerY.equalTo(distanceLabel.snp_centerY)
		}
		
		let distanceValueLabel = UILabel()
		self.distanceValueLabel = distanceValueLabel
		distanceValueLabel.alpha = 0.3
		filtersContainer.addSubview(distanceValueLabel)
		distanceValueLabel.text = "\(Int(self.distanceStepper.value))km"
		distanceValueLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		distanceValueLabel.textColor = blackNelpyColor
		distanceValueLabel.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(distanceStepper.snp_left).offset(-20)
			make.centerY.equalTo(distanceStepper.snp_centerY)
		}
		
		//Price Filter
		
		let priceCheckBox = UIButton()
		priceCheckBox.addTarget(self, action: "didTapPriceCheckBox:", forControlEvents: UIControlEvents.TouchUpInside)
		self.priceCheckBox = priceCheckBox
		filtersContainer.addSubview(priceCheckBox)
		priceCheckBox.setBackgroundImage(UIImage(named: "empty_check"), forState: UIControlState.Normal)
		priceCheckBox.setBackgroundImage(UIImage(named: "checked_box"), forState: UIControlState.Selected)
		priceCheckBox.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(filtersContainer.snp_left).offset(25)
			make.top.equalTo(distanceCheckBox.snp_bottom).offset(20)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let priceLabel = UILabel()
		filtersContainer.addSubview(priceLabel)
		priceLabel.text = "Minimum Price"
		priceLabel.textColor = blackNelpyColor
		priceLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		priceLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(priceCheckBox.snp_right).offset(15)
			make.centerY.equalTo(priceCheckBox.snp_centerY)
		}
		
		let priceStepper = UIStepper()
		self.priceStepper = priceStepper
		priceStepper.minimumValue = 10
		priceStepper.maximumValue = 200
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
			make.right.equalTo(filtersContainer.snp_right).offset(-55)
			make.centerY.equalTo(priceLabel.snp_centerY)
		}
		
		let priceValueLabel = UILabel()
		self.priceValueLabel = priceValueLabel
		priceValueLabel.alpha = 0.3
		filtersContainer.addSubview(priceValueLabel)
		priceValueLabel.text = "\(Int(self.priceStepper.value))$"
		priceValueLabel.font = UIFont(name: "Lato-Regular", size: kText14)
		priceValueLabel.textColor = blackNelpyColor
		priceValueLabel.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(priceStepper.snp_left).offset(-20)
			make.centerY.equalTo(priceStepper.snp_centerY)
		}
		
		filtersContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(priceValueLabel.snp_bottom).offset(30)
		}
		
		//Add filters Container and button
		
		let addFiltersContainer = UIView()
		contentView.addSubview(addFiltersContainer)
		addFiltersContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(contentView.snp_bottom)
			make.top.equalTo(filtersContainer.snp_bottom)
			make.width.equalTo(contentView.snp_width)
			make.height.equalTo(50)
		}
		
		let cancelButton = UIButton()
		cancelButton.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		addFiltersContainer.addSubview(cancelButton)
		cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
		cancelButton.backgroundColor = darkGrayDetails
		cancelButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		cancelButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: kTitle16)
		cancelButton.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(addFiltersContainer.snp_width).dividedBy(2)
			make.height.equalTo(addFiltersContainer.snp_height)
			make.right.equalTo(addFiltersContainer.snp_centerX)
			make.centerY.equalTo(addFiltersContainer.snp_centerY)
		}
		
		let confirmButton = UIButton()
		confirmButton.addTarget(self, action: "didTapAddFiltersButton:", forControlEvents: UIControlEvents.TouchUpInside)
		addFiltersContainer.addSubview(confirmButton)
		confirmButton.setTitle("Confirm", forState: UIControlState.Normal)
		confirmButton.backgroundColor = nelperRedColor
		confirmButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		confirmButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: kTitle16)
		confirmButton.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(addFiltersContainer.snp_width).dividedBy(2)
			make.height.equalTo(addFiltersContainer.snp_height)
			make.left.equalTo(addFiltersContainer.snp_centerX)
			make.centerY.equalTo(addFiltersContainer.snp_centerY)
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
		}else{
			self.sortingSegmentControl.selectedSegmentIndex = 2
		}
	}
	
	
	//MARK: View Delegate Methods
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	//MARK: Actions
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func didTapAddFiltersButton(sender:UIButton){
		if self.arrayOfFilters.isEmpty == false || self.sortBy != nil || minPrice != nil || self.maxDistance != nil{
			self.delegate.didTapAddFilters(self.arrayOfFilters, sort: self.sortBy, minPrice: self.minPrice, maxDistance: self.maxDistance)
			self.dismissViewControllerAnimated(true, completion: nil)
		}
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
		if sender.selected == true {
			self.sortBy?.removeAll()
			sender.selected = false
		}else{
			if sender.selectedSegmentIndex == 0 {
				self.sortBy = "priceOffered"
			}else if sender.selectedSegmentIndex == 1{
				self.sortBy = "distance"
			}else if sender.selectedSegmentIndex == 2{
				self.sortBy = "createdAt"
			}
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
				let filter = self.arrayOfFilters[i]
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
				let filter = self.arrayOfFilters[i]
				if filter == "business"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapAll(sender:UIButton?){
		self.allButton.selected = !self.allButton.selected
		if self.allButton.selected == true{
			self.arrayOfFilters.removeAll(keepCapacity: false)
			
			self.arrayOfFilters.append("business")
			self.arrayOfFilters.append("technology")
			self.arrayOfFilters.append("gardening")
			self.arrayOfFilters.append("housecleaning")
			self.arrayOfFilters.append("other")
			self.arrayOfFilters.append("multimedia")
			self.arrayOfFilters.append("handywork")
			
			self.allButton.alpha = 1
			
		}else{
			self.allButton.alpha = 0.3
			self.arrayOfFilters.removeAll(keepCapacity: false)
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
				let filter = self.arrayOfFilters[i]
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
				let filter = self.arrayOfFilters[i]
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
				let filter = self.arrayOfFilters[i]
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
				let filter = self.arrayOfFilters[i]
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
				let filter = self.arrayOfFilters[i]
				if filter == "handywork"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
}
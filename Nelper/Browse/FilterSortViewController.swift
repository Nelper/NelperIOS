//
//  FilterSortViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

protocol FilterSortViewControllerDelegate{
	func didTapAddFilters(filters:Array<String>?, sort: String?)
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
	var delegate: FilterSortViewControllerDelegate!
	var sortBy: String?
	var arrayOfFilters = Array<String>()
	var arrayOfFiltersFromPrevious = Array<String>()
	var previousSortBy: String?
	var sortingSegmentControl: UISegmentedControl!
	var scrollView: UIScrollView!
	var contentView: UIView!
	var lastFilterWasAll: Bool = false
	var locationEnabled: Bool!
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setLocationStatus()
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
		background.backgroundColor = whiteBackground
		
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
		
		contentView.backgroundColor = whiteBackground
		
		//Filters Container
		
		let filtersContainer = UIView()
		contentView.addSubview(filtersContainer)
		filtersContainer.backgroundColor = whitePrimary
		filtersContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
		}
		
		let sortingLabel = UILabel()
		filtersContainer.addSubview(sortingLabel)
		sortingLabel.text = "Sort task list by"
		sortingLabel.textColor = blackTextColor
		sortingLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
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
		sortingSegmentControl.insertSegmentWithTitle("Date", atIndex: 2, animated: false)
		sortingSegmentControl.tintColor = redPrimary
		sortingSegmentControl.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(sortingLabel.snp_bottom).offset(20)
			make.centerX.equalTo(filtersContainer.snp_centerX)
			make.width.equalTo(300)
			make.height.equalTo(35)
		}
		sortingSegmentControl.layer.cornerRadius = 3
		sortingSegmentControl.layer.borderColor = redPrimary.CGColor
		sortingSegmentControl.layer.borderWidth = 1.0
		sortingSegmentControl.layer.masksToBounds = true
		
		let sortingUnderline = UIView()
		filtersContainer.addSubview(sortingUnderline)
		sortingUnderline.backgroundColor = grayDetails
		sortingUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(sortingSegmentControl.snp_bottom).offset(30)
			make.width.equalTo(filtersContainer.snp_width).dividedBy(1.5)
			make.centerX.equalTo(filtersContainer.snp_centerX)
			make.height.equalTo(0.5)
		}
		
		let filtersLabel = UILabel()
		filtersContainer.addSubview(filtersLabel)
		filtersLabel.text = "Category filters"
		filtersLabel.textColor = blackTextColor
		filtersLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		filtersLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(filtersContainer.snp_centerX)
			make.top.equalTo(sortingUnderline.snp_bottom).offset(25)
			make.height.equalTo(20)
		}
		
		let firstRowOfCategories = UIView()
		filtersContainer.addSubview(firstRowOfCategories)
		firstRowOfCategories.backgroundColor = whitePrimary
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
		secondRowOfCategories.backgroundColor = whitePrimary
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
		cancelButton.setTitleColor(whiteBackground, forState: UIControlState.Normal)
		cancelButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: kTitle17)
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
		confirmButton.backgroundColor = redPrimary
		confirmButton.setTitleColor(whiteBackground, forState: UIControlState.Normal)
		confirmButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: kTitle17)
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
		print(self.arrayOfFiltersFromPrevious.count)
		if self.arrayOfFiltersFromPrevious.isEmpty {
			self.didTapAll(nil)
			print(self.lastFilterWasAll)
		}
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
	}
	
	/**
	check previously applied sorting
	*/
	func checkSort(){
		if self.previousSortBy != nil{
			if previousSortBy == "createdAt" {
				self.sortingSegmentControl.selectedSegmentIndex = 2
				self.sortBy = "createdAt"
			} else if previousSortBy == "distance" {
				self.sortingSegmentControl.selectedSegmentIndex = 1
				self.sortBy = "distance"
			} else if previousSortBy == "priceOffered" {
				self.sortingSegmentControl.selectedSegmentIndex = 0
				self.sortBy = "priceOffered"
			}
		} else if self.locationEnabled! {
			self.sortingSegmentControl.selectedSegmentIndex = 1
		} else {
			self.sortingSegmentControl.selectedSegmentIndex = 2
		}
	}
	
	//MARK: Setter
	
	func setLocationStatus() {
		if CLLocationManager.locationServicesEnabled() {
			switch (CLLocationManager.authorizationStatus()) {
			case .NotDetermined, .Restricted, .Denied:
				self.locationEnabled = false
			case .AuthorizedAlways, .AuthorizedWhenInUse:
				self.locationEnabled = true
			}
		} else {
			self.locationEnabled = false
		}
	}
	
	//MARK: View Delegate Methods
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	//MARK: Actions
	
	func backButtonTapped(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func didTapAddFiltersButton(sender:UIButton) {
		self.delegate.didTapAddFilters(self.arrayOfFilters, sort: self.sortBy)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	/**
	Sorting selection
	
	- parameter sender: Sorting Segment Control
	*/
	func segmentControlTouched(sender: UISegmentedControl) {
		if sender.selected == true {
			self.sortBy?.removeAll()
			sender.selected = false
		} else {
			if sender.selectedSegmentIndex == 0 {
				self.sortBy = "priceOffered"
			} else if sender.selectedSegmentIndex == 1 {
				
				if !(self.locationEnabled) {
					if self.sortBy == nil {
						self.sortBy = "createdAt"
					}
					
					switch self.sortBy! {
					case "priceOffered":
						sender.selectedSegmentIndex = 0
						self.sortBy = "priceOffered"
					case "createdAt":
						sender.selectedSegmentIndex = 2
						self.sortBy = "createdAt"
					default:
						sender.selectedSegmentIndex = 2
						self.sortBy = "createdAt"
					}
					
					let popup = UIAlertController(title: "Location Services are disabled", message: "In order to sort by Distance, you need to enable Location Services for Nelper. This can be done in your Privacy Settings.", preferredStyle: UIAlertControllerStyle.Alert)
					popup.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
					}))
					self.presentViewController(popup, animated: true, completion: nil)
				} else {
					self.sortBy = "distance"
				}
			} else if sender.selectedSegmentIndex == 2 {
				self.sortBy = "createdAt"
			}
		}
	}
	
	func didTapTechnology(sender: UIButton?) {
		self.technologyButton.selected = !self.technologyButton.selected
		if lastFilterWasAll == true {
			self.arrayOfFilters.removeAll()
			self.didTapAll(nil)
		}
		
		if self.technologyButton.selected == true{
			self.technologyButton.alpha = 1
			self.arrayOfFilters.append("technology")
			self.lastFilterWasAll = false
		} else {
			self.technologyButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++) {
				let filter = self.arrayOfFilters[i]
				if filter == "technology"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapBusiness(sender:UIButton?) {
		self.businessButton.selected = !self.businessButton.selected
		if lastFilterWasAll == true {
			self.allButton.selected = false
			self.arrayOfFilters.removeAll()
			self.didTapAll(nil)
		}
		
		if self.businessButton.selected == true {
			self.arrayOfFilters.append("business")
			self.lastFilterWasAll = false
			self.businessButton.alpha = 1
			
		} else {
			self.businessButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++ ) {
				let filter = self.arrayOfFilters[i]
				if filter == "business"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapAll(sender: UIButton?) {
		self.allButton.selected = !self.allButton.selected
		if self.allButton.selected == true {
			self.deselectAll()
			self.arrayOfFilters.removeAll(keepCapacity: false)
			self.allButton.alpha = 1
			self.lastFilterWasAll = true
		} else {
			self.allButton.alpha = 0.3
			self.arrayOfFilters.removeAll(keepCapacity: false)
		}
	}
	
	func didTapGardening(sender: UIButton?) {
		self.gardeningButton.selected = !self.gardeningButton.selected
		if lastFilterWasAll == true{
			self.arrayOfFilters.removeAll()
			self.didTapAll(nil)
		}
		
		if self.gardeningButton.selected == true {
			self.arrayOfFilters.append("gardening")
			self.gardeningButton.alpha = 1
			self.lastFilterWasAll = false
		}else{
			self.gardeningButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++ ) {
				let filter = self.arrayOfFilters[i]
				if filter == "gardening"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapCleaning(sender: UIButton?) {
		self.cleaningButton.selected = !self.cleaningButton.selected
		if lastFilterWasAll == true{
			self.arrayOfFilters.removeAll()
			self.didTapAll(nil)
		}
		
		if self.cleaningButton.selected == true{
			self.arrayOfFilters.append("housecleaning")
			self.cleaningButton.alpha = 1
			self.lastFilterWasAll = false
		} else {
			self.cleaningButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++ ) {
				let filter = self.arrayOfFilters[i]
				if filter == "housecleaning"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapOther(sender:UIButton?){
		self.otherButton.selected = !self.otherButton.selected
		
		if lastFilterWasAll == true {
			self.arrayOfFilters.removeAll()
			self.didTapAll(nil)
		}
		if self.otherButton.selected == true {
			self.arrayOfFilters.append("other")
			self.otherButton.alpha = 1
			self.lastFilterWasAll = false
			
		} else {
			self.otherButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++) {
				let filter = self.arrayOfFilters[i]
				if filter == "other" {
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapMultimedia(sender: UIButton?) {
		self.multimediaButton.selected = !self.multimediaButton.selected
		if lastFilterWasAll == true {
			self.arrayOfFilters.removeAll()
			self.didTapAll(nil)
		}
		
		if self.multimediaButton.selected == true {
			self.multimediaButton.alpha = 1
			self.arrayOfFilters.append("multimedia")
			self.lastFilterWasAll = false
		} else {
			self.multimediaButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++ ) {
				let filter = self.arrayOfFilters[i]
				if filter == "multimedia" {
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapHandywork(sender: UIButton?) {
		self.handyworkButton.selected = !self.handyworkButton.selected
		if lastFilterWasAll == true {
			self.arrayOfFilters.removeAll()
			self.didTapAll(nil)
		}
		
		if self.handyworkButton.selected == true {
			self.handyworkButton.alpha = 1
			self.arrayOfFilters.append("handywork")
			self.lastFilterWasAll = false
		} else {
			self.handyworkButton.alpha = 0.3
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++ ) {
				let filter = self.arrayOfFilters[i]
				if filter == "handywork"{
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func deselectAll() {
		for filter in self.arrayOfFilters {
			if filter == "technology"{
				self.didTapTechnology(nil)
			} else if filter == "business" {
				self.didTapBusiness(nil)
			} else if filter == "gardening" {
				self.didTapGardening(nil)
			} else if filter == "housecleaning" {
				self.didTapCleaning(nil)
			} else if filter == "multimedia" {
				self.didTapMultimedia(nil)
			} else if filter == "other" {
				self.didTapOther(nil)
			} else if filter == "handywork" {
				self.didTapHandywork(nil)
			}
		}
	}
}
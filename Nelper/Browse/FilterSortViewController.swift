//
//  FilterSortViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

protocol FilterSortViewControllerDelegate {
	func didTapAddFilters(filters: Array<String>?, sort: String?)
}

class FilterSortViewController: UIViewController, CategoryFiltersDelegate {
	
	private var kFilterCategorySize = 55
	private var kFilterCategorySpacing = 18
	
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
	
	var filtersContainer: UIView!
	var filtersLabel: UILabel!
	var categoryFilters: CategoryFilters!
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setLocationStatus()
		self.createView()
		self.checkFilters()
		self.checkSort()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.categoryFilters.layoutIfNeeded()
	}
	
	//MARK: View Creation
	
	func createView() {
		
		let navBar = NavBar()
		self.view.addSubview(navBar)
		navBar.setTitle("Filters and Sorting")
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let background = UIView()
		self.view.addSubview(background)
		background.backgroundColor = Color.whiteBackground
		background.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		
		let scrollView = UIScrollView()
		self.scrollView = scrollView
		background.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(background.snp_edges)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		self.scrollView.addSubview(contentView)
		contentView.backgroundColor = Color.whiteBackground
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.height.greaterThanOrEqualTo(background.snp_height)
			make.width.equalTo(background.snp_width)
		}
		
		//Filters Container
		
		let filtersContainer = UIView()
		self.filtersContainer = filtersContainer
		contentView.addSubview(filtersContainer)
		filtersContainer.backgroundColor = Color.whitePrimary
		filtersContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
		}
		
		let sortingLabel = UILabel()
		filtersContainer.addSubview(sortingLabel)
		sortingLabel.text = "Sort task list by"
		sortingLabel.textColor = Color.blackTextColor
		sortingLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		sortingLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(filtersContainer.snp_centerX)
			make.top.equalTo(filtersContainer.snp_top).offset(50)
			make.height.equalTo(20)
		}
		
		let sortingSegmentControl = UISegmentedControl()
		self.sortingSegmentControl = sortingSegmentControl
		filtersContainer.addSubview(sortingSegmentControl)
		sortingSegmentControl.addTarget(self, action: "segmentControlTouched:", forControlEvents: UIControlEvents.ValueChanged)
		sortingSegmentControl.insertSegmentWithTitle("Price", atIndex: 0, animated: false)
		sortingSegmentControl.insertSegmentWithTitle("Distance", atIndex: 1, animated: false)
		sortingSegmentControl.insertSegmentWithTitle("Date", atIndex: 2, animated: false)
		sortingSegmentControl.tintColor = Color.redPrimary
		sortingSegmentControl.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(sortingLabel.snp_bottom).offset(30)
			make.centerX.equalTo(filtersContainer.snp_centerX)
			make.width.equalTo(300)
			make.height.equalTo(35)
		}
		sortingSegmentControl.layer.cornerRadius = 0
		sortingSegmentControl.layer.borderColor = UIColor.clearColor().CGColor
		sortingSegmentControl.layer.borderWidth = 1
		sortingSegmentControl.layer.masksToBounds = true
		
		let sortingUnderline = UIView()
		filtersContainer.addSubview(sortingUnderline)
		sortingUnderline.backgroundColor = Color.grayDetails
		sortingUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(sortingSegmentControl.snp_bottom).offset(50)
			make.width.equalTo(filtersContainer.snp_width).dividedBy(1.5)
			make.centerX.equalTo(filtersContainer.snp_centerX)
			make.height.equalTo(0.5)
		}
		
		let filtersLabel = UILabel()
		self.filtersLabel = filtersLabel
		filtersContainer.addSubview(filtersLabel)
		filtersLabel.text = "Category filters"
		filtersLabel.textColor = Color.blackTextColor
		filtersLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		filtersLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(filtersContainer.snp_centerX)
			make.top.equalTo(sortingUnderline.snp_bottom).offset(40)
			make.height.equalTo(20)
		}
		
		contentView.layoutIfNeeded()
		
		let categoryFilters = CategoryFilters()
		self.categoryFilters = categoryFilters
		categoryFilters.delegate = self
		filtersContainer.addSubview(categoryFilters)
		categoryFilters.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(categoryFilters.categories.count * (categoryFilters.imageSize + categoryFilters.padding) / 2)
			make.centerX.equalTo(filtersContainer.snp_centerX).offset(categoryFilters.padding / 2)
			make.top.equalTo(filtersLabel.snp_bottom).offset(30)
			make.height.equalTo((2 * categoryFilters.imageSize) + categoryFilters.padding)
		}
		
		categoryFilters.layoutIfNeeded()
		
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
		cancelButton.backgroundColor = Color.darkGrayDetails
		cancelButton.setTitleColor(Color.whiteBackground, forState: UIControlState.Normal)
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
		confirmButton.backgroundColor = Color.redPrimary
		confirmButton.setTitleColor(Color.whiteBackground, forState: UIControlState.Normal)
		confirmButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: kTitle17)
		confirmButton.snp_makeConstraints { (make) -> Void in
			make.width.equalTo(addFiltersContainer.snp_width).dividedBy(2)
			make.height.equalTo(addFiltersContainer.snp_height)
			make.left.equalTo(addFiltersContainer.snp_centerX)
			make.centerY.equalTo(addFiltersContainer.snp_centerY)
		}
	}
	
	//MARK: View Delegate Methods
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	//MARK: Setters
	
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
	
	//MARK: Category Filters
	
	/**
	Check previously applied filters
	*/
	func checkFilters(){
		
		if self.arrayOfFiltersFromPrevious.isEmpty {
			self.didTapAll(self.categoryFilters.categoryImages[0])
		}
		
		self.forceTapCategories(self.arrayOfFiltersFromPrevious)
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
	
	func didTapAddFiltersButton(sender:UIButton) {
		self.delegate.didTapAddFilters(self.arrayOfFilters, sort: self.sortBy)
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func categoryTapped(sender: UIButton, category: String) {
		
		if category == "all" {
			self.didTapAll(sender)
			return
		}
		
		sender.selected = !sender.selected
		let categoryImages = self.categoryFilters.categoryImages
		
		if self.lastFilterWasAll {
			self.arrayOfFilters.removeAll()
			self.didTapAll(categoryImages[0])
		}
		
		if sender.selected {
			UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				sender.alpha = 1
				sender.transform = CGAffineTransformMakeScale(1.05, 1.05)
				}, completion: nil )
			
			self.arrayOfFilters.append(category)
			self.lastFilterWasAll = false
		} else {
			UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				sender.alpha = 0.3
				sender.transform = CGAffineTransformMakeScale(1, 1)
				}, completion: nil )
			
			for (var i = 0 ; i < self.arrayOfFilters.count ; i++) {
				let filter = self.arrayOfFilters[i]
				if filter == category {
					self.arrayOfFilters.removeAtIndex(i)
				}
			}
		}
	}
	
	func didTapAll(sender: UIButton) {
		sender.selected = !sender.selected
		if sender.selected == true {
			self.deselectAll()
			self.arrayOfFilters.removeAll(keepCapacity: false)
			
			UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				sender.alpha = 1
				sender.transform = CGAffineTransformMakeScale(1.05, 1.05)
				}, completion: nil )
			self.lastFilterWasAll = true
		} else {
			UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				sender.alpha = 0.3
				sender.transform = CGAffineTransformMakeScale(1, 1)
				}, completion: nil )
			
			self.arrayOfFilters.removeAll(keepCapacity: false)
		}
	}
	
	func deselectAll() {
		forceTapCategories(self.arrayOfFilters)
	}
	
	func forceTapCategories(array: [AnyObject]) {
		let categoryImages = self.categoryFilters.categoryImages
		
		for filter in array {
			let filter = filter as! String
			
			if filter == "technology" {
				let index = self.categoryFilters.categories.indexOf("technology")!
				self.categoryTapped(categoryImages[index], category: "technology")
			} else if filter == "business" {
				let index = self.categoryFilters.categories.indexOf("business")!
				self.categoryTapped(categoryImages[index], category: "business")
			} else if filter == "multimedia" {
				let index = self.categoryFilters.categories.indexOf("multimedia")!
				self.categoryTapped(categoryImages[index], category: "multimedia")
			} else if filter == "gardening" {
				let index = self.categoryFilters.categories.indexOf("gardening")!
				self.categoryTapped(categoryImages[index], category: "gardening")
			} else if filter == "handywork" {
				let index = self.categoryFilters.categories.indexOf("handywork")!
				self.categoryTapped(categoryImages[index], category: "handywork")
			} else if filter == "housecleaning" {
				let index = self.categoryFilters.categories.indexOf("housecleaning")!
				self.categoryTapped(categoryImages[index], category: "housecleaning")
			} else if filter == "other" {
				let index = self.categoryFilters.categories.indexOf("other")!
				self.categoryTapped(categoryImages[index], category: "other")
			}
		}
	}
	
	
	//MARK: Sorting
	
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
					popup.view.tintColor = Color.redPrimary
				} else {
					self.sortBy = "distance"
				}
			} else if sender.selectedSegmentIndex == 2 {
				self.sortBy = "createdAt"
			}
		}
	}
	
	//MARK: Actions
	
	func backButtonTapped(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}
//
//  FilterSortViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class FilterSortViewController: UIViewController{
	
	private var kFilterCategorySize = 65
	private var kFilterCategorySpacing = 12
	
		//Initialization
	
	override func viewDidLoad() {
			super.viewDidLoad()
			self.createView()
	}

	
	//Create View
	
	func createView(){
		
		var navBar = NavBar()
		self.view.addSubview(navBar)
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
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
		sortingLabel.textColor = blueGrayColor
		sortingLabel.font = UIFont(name: "HelveticaNeue", size: kSubtitleFontSize)
		sortingLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(sortingContainer.snp_left).offset(8)
			make.top.equalTo(sortingContainer.snp_top).offset(8)
			make.right.equalTo(sortingContainer.snp_right).offset(-8)
			make.height.equalTo(20)
		}
		
		var sortingSegmentControl = UISegmentedControl()
		sortingContainer.addSubview(sortingSegmentControl)
		sortingSegmentControl.insertSegmentWithTitle("Price", atIndex: 0, animated: false)
		sortingSegmentControl.insertSegmentWithTitle("Distance", atIndex: 1, animated: false)
		sortingSegmentControl.insertSegmentWithTitle("Creation Date", atIndex: 2, animated: false)
		sortingSegmentControl.tintColor = blueGrayColor
		sortingSegmentControl.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(sortingContainer.snp_bottom).offset(-12)
			make.centerX.equalTo(sortingContainer.snp_centerX)
			make.left.equalTo(sortingContainer.snp_left).offset(8)
			make.right.equalTo(sortingContainer.snp_right).offset(-8)
			make.height.equalTo(35)
		}
		
		var addFiltersButton = UIButton()
		contentView.addSubview(addFiltersButton)
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
		filtersLabel.textColor = blueGrayColor
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
		firstRowOfCategories.addSubview(technologyButton)
		technologyButton.setBackgroundImage(UIImage(named: "technology"), forState: UIControlState.Normal)
		technologyButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(firstRowOfCategories.snp_centerY)
			make.left.equalTo(firstRowOfCategories.snp_left)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		
		var multimediaButton = UIButton()
		firstRowOfCategories.addSubview(multimediaButton)
		multimediaButton.setBackgroundImage(UIImage(named: "multimedia"), forState: UIControlState.Normal)
		multimediaButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(firstRowOfCategories.snp_centerY)
			make.left.equalTo(technologyButton.snp_right).offset(kFilterCategorySpacing)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		
		var handyWorkButton = UIButton()
		firstRowOfCategories.addSubview(handyWorkButton)
		handyWorkButton.setBackgroundImage(UIImage(named: "handywork"), forState: UIControlState.Normal)
		handyWorkButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(firstRowOfCategories.snp_centerY)
			make.left.equalTo(multimediaButton.snp_right).offset(kFilterCategorySpacing)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		
		var gardeningButton = UIButton()
		firstRowOfCategories.addSubview(gardeningButton)
		gardeningButton.setBackgroundImage(UIImage(named: "gardening"), forState: UIControlState.Normal)
		gardeningButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(firstRowOfCategories.snp_centerY)
			make.left.equalTo(handyWorkButton.snp_right).offset(kFilterCategorySpacing)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		
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
		secondRowOfCategories.addSubview(businessButton)
		businessButton.setBackgroundImage(UIImage(named: "business"), forState: UIControlState.Normal)
		businessButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(secondRowOfCategories.snp_centerY)
			make.left.equalTo(secondRowOfCategories.snp_left)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		
		var cleaningButton = UIButton()
		secondRowOfCategories.addSubview(cleaningButton)
		cleaningButton.setBackgroundImage(UIImage(named: "housecleaning"), forState: UIControlState.Normal)
		cleaningButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(secondRowOfCategories.snp_centerY)
			make.left.equalTo(businessButton.snp_right).offset(kFilterCategorySpacing)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		
		var otherButton = UIButton()
		secondRowOfCategories.addSubview(otherButton)
		otherButton.setBackgroundImage(UIImage(named: "other"), forState: UIControlState.Normal)
		otherButton.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(secondRowOfCategories.snp_centerY)
			make.left.equalTo(cleaningButton.snp_right).offset(kFilterCategorySpacing)
			make.height.equalTo(kFilterCategorySize)
			make.width.equalTo(kFilterCategorySize)
		}
		
		
		//Distance Filter
		var distanceCheckBox = UIButton()
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
		distanceLabel.textColor = blueGrayColor
		distanceLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		distanceLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(distanceCheckBox.snp_right).offset(4)
			make.centerY.equalTo(distanceCheckBox.snp_centerY)
		}
		
		var distanceStepper = UIStepper()
		filtersContainer.addSubview(distanceStepper)
		distanceStepper.tintColor = blueGrayColor
		distanceStepper.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(30)
			make.width.equalTo(60)
			make.centerX.equalTo(otherButton.snp_centerX).offset(30)
			make.centerY.equalTo(distanceCheckBox.snp_centerY)
		}
		
		var distanceValueLabel = UILabel()
		filtersContainer.addSubview(distanceValueLabel)
		distanceValueLabel.text = "5km"
		distanceValueLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		distanceValueLabel.textColor = blackNelpyColor
		distanceValueLabel.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(distanceStepper.snp_left).offset(-4)
			make.centerY.equalTo(distanceStepper.snp_centerY)
		}
		
		//Price Filter
		
		var priceCheckBox = UIButton()
		filtersContainer.addSubview(priceCheckBox)
		priceCheckBox.setBackgroundImage(UIImage(named: "checkbox_unchecked"), forState: UIControlState.Normal)
		priceCheckBox.setBackgroundImage(UIImage(named: "checkbox_checked"), forState: UIControlState.Selected)
		priceCheckBox.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(distanceCheckBox.snp_bottom).offset(20)
			make.left.equalTo(filtersLabel.snp_left)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		var priceLabel = UILabel()
		filtersContainer.addSubview(priceLabel)
		priceLabel.text = "Minimum Price:"
		priceLabel.textColor = blueGrayColor
		priceLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		priceLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(priceCheckBox.snp_right).offset(4)
			make.centerY.equalTo(priceCheckBox.snp_centerY)
		}
		
		var priceStepper = UIStepper()
		filtersContainer.addSubview(priceStepper)
		priceStepper.tintColor = blueGrayColor
		priceStepper.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(30)
			make.width.equalTo(60)
			make.centerX.equalTo(distanceStepper.snp_centerX)
			make.centerY.equalTo(priceCheckBox.snp_centerY)
		}
		
		var priceValueLabel = UILabel()
		filtersContainer.addSubview(priceValueLabel)
		priceValueLabel.text = "20$"
		priceValueLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		priceValueLabel.textColor = blackNelpyColor
		priceValueLabel.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(priceStepper.snp_left).offset(-4)
			make.centerY.equalTo(priceStepper.snp_centerY)
		}
		
		
	}
	
	//Actions
	
	func backButtonTapped(sender:UIButton){
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}
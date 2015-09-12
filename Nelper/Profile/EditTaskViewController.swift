//
//  EditTaskViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-09-11.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import iCarousel

class EditTaskViewController:UIViewController,iCarouselDataSource,iCarouselDelegate {
	
	var task:FindNelpTask!
	var titleTextField:UITextField!
	var descriptionTextView:UITextView!
	var deleteTaskButton:UIButton!
	var pictures:NSArray?
	var carousel:iCarousel!
	var taskInformationContainer:UIView!
	var contentView:UIView!
	var scrollView: UIScrollView!
	
	//MARK: Initialization
	override func viewDidLoad() {
		super.viewDidLoad()
		self.pictures = self.task.pictures
		self.createView()
		self.createPicturesContainer()
	}
	
	func createView(){
		
		var navBar = NavBar()
		let backBtn = UIButton()
		backBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(navBar)
		navBar.backButton = backBtn
		navBar.setImage(UIImage(named: "close_red")!)
		navBar.setTitle("Edit Task")
		navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.height.equalTo(64)
		}
		
		var background = UIView()
		self.view.addSubview(background)
		background.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(navBar.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		background.backgroundColor = whiteNelpyColor
		
		var scrollView = UIScrollView()
		self.scrollView = scrollView
		background.addSubview(scrollView)
		scrollView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(background.snp_edges)
		}
		
		var contentView = UIView()
		self.contentView = contentView
		scrollView.addSubview(self.contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(scrollView.snp_top)
			make.left.equalTo(scrollView.snp_left)
			make.right.equalTo(scrollView.snp_right)
			make.height.greaterThanOrEqualTo(background.snp_height)
			make.width.equalTo(background.snp_width)
		}
		
		//Task text informations to edit container
		
		var taskInformationContainer = UIView()
		self.taskInformationContainer = taskInformationContainer
		contentView.addSubview(taskInformationContainer)
		taskInformationContainer.layer.borderColor = darkGrayDetails.CGColor
		taskInformationContainer.layer.borderWidth = 0.5
		taskInformationContainer.backgroundColor = navBarColor
		taskInformationContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right).offset(1)
		}
		
		var categoryIcon = UIImageView()
		taskInformationContainer.addSubview(categoryIcon)
		var iconSize:CGFloat = 60
		categoryIcon.layer.cornerRadius = iconSize / 2
		categoryIcon.contentMode = UIViewContentMode.ScaleAspectFill
		categoryIcon.image = UIImage(named: self.task.category!)
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskInformationContainer.snp_top).offset(16)
			make.centerX.equalTo(taskInformationContainer.snp_centerX)
			make.width.equalTo(iconSize)
			make.height.equalTo(iconSize)
		}
		
		var titleTextField = UITextField()
		self.titleTextField = titleTextField
		taskInformationContainer.addSubview(titleTextField)
		titleTextField.text = self.task.title
		titleTextField.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		titleTextField.textAlignment = NSTextAlignment.Center
		titleTextField.layer.borderWidth = 1
		titleTextField.layer.borderColor = darkGrayDetails.CGColor
		titleTextField.backgroundColor = whiteNelpyColor
		titleTextField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(categoryIcon.snp_bottom).offset(20)
			make.left.equalTo(taskInformationContainer.snp_left).offset(12)
			make.right.equalTo(taskInformationContainer.snp_right).offset(-12)
			make.height.equalTo(40)
		}
		
		var titleUnderline = UIView()
		taskInformationContainer.addSubview(titleUnderline)
		titleUnderline.backgroundColor = darkGrayDetails
		titleUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleTextField.snp_bottom).offset(16)
			make.width.equalTo(taskInformationContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
			make.centerX.equalTo(taskInformationContainer.snp_centerX)

		}
		
		var descriptionTextView = UITextView()
		self.descriptionTextView = descriptionTextView
		taskInformationContainer.addSubview(descriptionTextView)
		descriptionTextView.text = self.task.desc
		descriptionTextView.font = UIFont(name: "HelveticaNeue", size: kProgressBarTextFontSize)
		descriptionTextView.textAlignment = NSTextAlignment.Center
		descriptionTextView.layer.borderWidth = 1
		descriptionTextView.layer.borderColor = darkGrayDetails.CGColor
		descriptionTextView.backgroundColor = whiteNelpyColor
		descriptionTextView.scrollEnabled = false
		descriptionTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleUnderline.snp_bottom).offset(16)
			make.width.equalTo(titleTextField.snp_width)
			make.centerX.equalTo(taskInformationContainer.snp_centerX)
		}
		
		let fixedWidth = descriptionTextView.frame.size.width
		descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		let newSize = descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		var newFrame = descriptionTextView.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		descriptionTextView.frame = newFrame;
		
		var descriptionUnderline = UIView()
		taskInformationContainer.addSubview(descriptionUnderline)
		descriptionUnderline.backgroundColor = darkGrayDetails
		descriptionUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionTextView.snp_bottom).offset(16)
			make.width.equalTo(taskInformationContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
			make.centerX.equalTo(taskInformationContainer.snp_centerX)

		}

		var locationContainer = UIView()
		taskInformationContainer.addSubview(locationContainer)
		locationContainer.backgroundColor = navBarColor
		locationContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(descriptionUnderline.snp_bottom).offset(20)
			make.left.equalTo(descriptionTextView.snp_left).offset(16)
			make.width.equalTo(taskInformationContainer.snp_width).dividedBy(2)
		}
		
		var pinIcon = UIImageView()
		locationContainer.addSubview(pinIcon)
		pinIcon.image = UIImage(named: "pin")
		pinIcon.contentMode = UIViewContentMode.ScaleAspectFill
		pinIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(45)
			make.width.equalTo(45)
			make.centerY.equalTo(locationContainer.snp_centerY)
			make.left.equalTo(locationContainer.snp_left).offset(4)
		}
		
		var locationVerticalLine = UIView()
		locationContainer.addSubview(locationVerticalLine)
		locationVerticalLine.backgroundColor = darkGrayDetails
		locationVerticalLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(locationContainer.snp_top)
			make.bottom.equalTo(locationContainer.snp_bottom)
			make.width.equalTo(1)
			make.left.equalTo(pinIcon.snp_right).offset(4)
		}
		
		var streetAddressLabel = UITextField()
		streetAddressLabel.backgroundColor = navBarColor
		locationContainer.addSubview(streetAddressLabel)
		streetAddressLabel.text = "175 Forbin Janson"
		streetAddressLabel.textColor = blackNelpyColor
		streetAddressLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		streetAddressLabel.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(locationContainer.snp_height).dividedBy(3)
			make.left.equalTo(locationVerticalLine.snp_left).offset(4)
			make.top.equalTo(locationContainer.snp_top)
		}
		
		var cityLabel = UITextField()
		cityLabel.backgroundColor = navBarColor
		locationContainer.addSubview(cityLabel)
		cityLabel.text = "Mont Saint-Hilaire"
		cityLabel.textColor = blackNelpyColor
		cityLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		cityLabel.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(locationContainer.snp_height).dividedBy(3)
			make.left.equalTo(locationVerticalLine.snp_left).offset(4)
			make.top.equalTo(streetAddressLabel.snp_bottom)
		}
		
		var zipcodeLabel = UITextField()
		zipcodeLabel.backgroundColor = navBarColor
		locationContainer.addSubview(zipcodeLabel)
		zipcodeLabel.text = "J3H5E5"
		zipcodeLabel.textColor = blackNelpyColor
		zipcodeLabel.font = UIFont(name: "HelveticaNeue", size: kTextFontSize)
		zipcodeLabel.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(locationContainer.snp_height).dividedBy(3)
			make.left.equalTo(locationVerticalLine.snp_left).offset(4)
			make.top.equalTo(cityLabel.snp_bottom)
		}
		
		var locationUnderline = UIView()
		taskInformationContainer.addSubview(locationUnderline)
		locationUnderline.backgroundColor = darkGrayDetails
		locationUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(locationContainer.snp_bottom).offset(20)
			make.width.equalTo(taskInformationContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
			make.centerX.equalTo(taskInformationContainer.snp_centerX)
		}
		
		var deleteTaskButton = UIButton()
		taskInformationContainer.addSubview(deleteTaskButton)
		self.deleteTaskButton = deleteTaskButton
		deleteTaskButton.setTitle("Delete Task", forState: UIControlState.Normal)
		deleteTaskButton.setTitle("Sure?", forState: UIControlState.Selected)
		deleteTaskButton.setTitleColor(nelperRedColor, forState: UIControlState.Normal)
		deleteTaskButton.setTitleColor(nelperRedColor, forState: UIControlState.Selected)
		self.deleteTaskButton.addTarget(self, action: "didTapDeleteButton:", forControlEvents: UIControlEvents.TouchUpInside)
		deleteTaskButton.layer.borderWidth = 1
		deleteTaskButton.layer.borderColor = nelperRedColor.CGColor
		deleteTaskButton.backgroundColor = navBarColor
		deleteTaskButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(locationUnderline.snp_bottom).offset(20)
			make.centerX.equalTo(taskInformationContainer.snp_centerX)
			make.height.equalTo(45)
			make.width.equalTo(200)
			make.bottom.equalTo(taskInformationContainer.snp_bottom).offset(-20)
		}
		
		taskInformationContainer.sizeToFit()
		
	}
	
	func createPicturesContainer(){
		
		var picturesContainer = UIView()
		contentView.addSubview(picturesContainer)
		picturesContainer.backgroundColor = navBarColor
		picturesContainer.layer.borderColor = darkGrayDetails.CGColor
		picturesContainer.layer.borderWidth = 0.5
		picturesContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskInformationContainer.snp_bottom).offset(10)
			make.left.equalTo(contentView.snp_left).offset(-1)
			make.right.equalTo(contentView.snp_right)
			make.bottom.equalTo(self.contentView.snp_bottom).offset(-10)
		}
		
		var managePicturesLabel = UILabel()
		picturesContainer.addSubview(managePicturesLabel)
		managePicturesLabel.text = "Manage Pictures"
		managePicturesLabel.textColor = blackNelpyColor
		managePicturesLabel.font = UIFont(name: "HelveticaNeue", size: kEditTaskSubtitleFontSize)
		managePicturesLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(picturesContainer.snp_top).offset(10)
			make.left.equalTo(picturesContainer.snp_left).offset(10)
		}
		
		if self.pictures != nil{
			var carousel = iCarousel()
			self.carousel = carousel
			picturesContainer.addSubview(carousel)
			self.carousel.type = .Rotary
			self.carousel.dataSource = self
			self.carousel.delegate = self
			self.carousel.reloadData()
			carousel.snp_makeConstraints { (make) -> Void in
				make.centerX.equalTo(picturesContainer.snp_centerX)
				make.width.equalTo(300)
				make.height.equalTo(300)
				make.top.equalTo(managePicturesLabel.snp_bottom).offset(20)
			}
		}
		
		var addImageButton = UIButton()
		picturesContainer.addSubview(addImageButton)
		addImageButton.setBackgroundImage(UIImage(named: "plus_green"), forState: UIControlState.Normal)
		
		if self.pictures != nil {
			addImageButton.snp_makeConstraints(closure: { (make) -> Void in
				make.top.equalTo(self.carousel.snp_bottom).offset(12)
				make.centerX.equalTo(picturesContainer.snp_centerX)
				make.height.equalTo(60)
				make.width.equalTo(60)
				make.bottom.equalTo(picturesContainer.snp_bottom).offset(-10)
			})
		} else{
			addImageButton.snp_makeConstraints(closure: { (make) -> Void in
				make.top.equalTo(managePicturesLabel.snp_bottom).offset(12)
				make.centerX.equalTo(picturesContainer.snp_centerX)
				make.height.equalTo(60)
				make.width.equalTo(60)
				make.bottom.equalTo(picturesContainer.snp_bottom).offset(-10)
			})
		}
		
		picturesContainer.sizeToFit()
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	//MARK: iCarousel Delegate
	
	func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
		
		if self.task.pictures != nil {
			if self.task.pictures!.count == 1 {
				self.carousel.scrollEnabled = false
			}
			return self.task.pictures!.count
		}
		return 0
	}
	
	
 func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
	
		var picture = UIImageView(frame: self.carousel.frame)
		picture.clipsToBounds = true
		var imageURL = self.task.pictures![index].url!
		ApiHelper.getPictures(imageURL, block: { (imageReturned:UIImage) -> Void in
		picture.image = imageReturned
		})
		picture.contentMode = .ScaleAspectFit
	return picture
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
	
	func didTapDeleteButton(sender:UIButton){
		if sender.selected == false {
			sender.selected = true
			
		}else if sender.selected == true{
			ApiHelper.deleteTask(self.task)
			self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	

}
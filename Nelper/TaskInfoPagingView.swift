//
//  TaskInfoPagingView.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-16.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit

class TaskInfoPagingView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PicturesCollectionViewCellDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
	
	let firstSwipeRecLeft = UISwipeGestureRecognizer()
	let secondSwipeRecLeft = UISwipeGestureRecognizer()
	let secondSwipeRecRight = UISwipeGestureRecognizer()
	let thirdSwipeRecRight = UISwipeGestureRecognizer()
	
	var task: FindNelpTask!
	
	var taskTitle: String!
	var taskDescription: String!
	
	var imagePicker = UIImagePickerController()
	
	var pictures = [PFFile]()
	
	var containerHeight: CGFloat = 270
	
	var firstContainer: UIView!
	var secondContainer: UIView!
	var thirdContainer: UIView!
	var firstO: PageControllerOval!
	var secondO: PageControllerOval!
	var thirdO: PageControllerOval!
	var width:CGFloat!
	var selectedAlpha: CGFloat = 1
	var unselectedAlpha: CGFloat = 0.5
	var selectedSize: CGFloat = 9
	var unselectedSize: CGFloat = 7
	var contentView:UIView!
	var noPicturesLabel: UILabel!
	var picturesCollectionView: UICollectionView!
	var pagingContainer: UIView!
	var categoryIcon: UIImageView!
	var descriptionIsEditing = false
	var images = [UIImage]()
	var picturesChanged = false
	
	var titleTextView: UITextView!
	var descriptionTextView: UITextView!
	
	convenience init(task: FindNelpTask, width:CGFloat) {
		self.init()
		self.width = width
		self.task = task
		
		//self.imagePicker.delegate = self
		
		firstSwipeRecLeft.addTarget(self, action: "swipedFirstView:")
		firstSwipeRecLeft.direction = UISwipeGestureRecognizerDirection.Left
		secondSwipeRecLeft.addTarget(self, action: "swipedSecondView:")
		secondSwipeRecLeft.direction = UISwipeGestureRecognizerDirection.Left
		secondSwipeRecRight.addTarget(self, action: "swipedSecondView:")
		secondSwipeRecRight.direction = UISwipeGestureRecognizerDirection.Right
		thirdSwipeRecRight.addTarget(self, action: "swipedThirdView:")
		thirdSwipeRecRight.direction = UISwipeGestureRecognizerDirection.Right
		
		if self.task.pictures != nil {
			self.pictures = task.pictures!
			self.getImagesFromParse()
		}
		
		self.taskTitle = self.task.title
		self.taskDescription = self.task.desc
		
		self.createView(width)
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		self.firstContainer.addGestureRecognizer(tap)
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		//force description textView to center its content (animated)
		let textView = self.descriptionTextView
		var topCorrect = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale) / 2
		topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect
		UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
			self.descriptionTextView.contentInset.top = topCorrect
			self.descriptionTextView.alpha = 1
			}, completion: nil)
		
		//title textView animation in
		UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
			self.titleTextView.contentInset.top = 0
			self.titleTextView.alpha = 1
			}, completion: nil)
	}
	
	func createView(width:CGFloat) {
		
		let pagingContainerHeight = 50
		let contentView = UIView()
		self.contentView = contentView
		self.view.addSubview(contentView)
		self.contentView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.view)
			make.top.equalTo(self.view)
			make.bottom.equalTo(self.view)
			make.right.equalTo(self.view)
		}
		
		//FIRST CONTAINER
		let firstContainer = UIView()
		self.firstContainer = firstContainer
		contentView.addSubview(firstContainer)
		self.firstContainer.backgroundColor = Color.whitePrimary
		self.firstContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.left.equalTo(self.view.snp_left)
			make.width.equalTo(width)
			make.height.equalTo(containerHeight)
		}
		self.firstContainer.addGestureRecognizer(self.firstSwipeRecLeft)
		
		let titleTextView = UITextView()
		self.titleTextView = titleTextView
		firstContainer.addSubview(titleTextView)
		titleTextView.text = self.taskTitle
		titleTextView.font = UIFont(name: "Lato-Regular", size: kTitle17)
		titleTextView.textColor = Color.blackPrimary
		titleTextView.textAlignment = NSTextAlignment.Center
		titleTextView.delegate = self
		titleTextView.backgroundColor = UIColor.clearColor()
		titleTextView.alpha = 0
		titleTextView.returnKeyType = .Done
		titleTextView.delegate = self
		titleTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(firstContainer.snp_top).offset(17)
			make.left.equalTo(firstContainer.snp_left).offset(12)
			make.right.equalTo(firstContainer.snp_right).offset(-12)
			make.height.equalTo(60)
		}
		titleTextView.contentInset.top = 40
		titleTextView.layoutIfNeeded()
		
		let titleUnderline = UIView()
		firstContainer.addSubview(titleUnderline)
		titleUnderline.backgroundColor = Color.grayDetails
		titleUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleTextView.snp_bottom).offset(20)
			make.width.equalTo(firstContainer.snp_width).dividedBy(1.4)
			make.height.equalTo(0.5)
			make.centerX.equalTo(firstContainer.snp_centerX)
		}
		
		let categoryIcon = UIImageView()
		firstContainer.addSubview(categoryIcon)
		let iconSize: CGFloat = 40
		categoryIcon.layer.cornerRadius = iconSize / 2
		categoryIcon.contentMode = UIViewContentMode.ScaleAspectFill
		categoryIcon.image = UIImage(named: self.task.category!)
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(titleUnderline.snp_centerY)
			make.centerX.equalTo(titleUnderline.snp_centerX)
			make.width.equalTo(iconSize)
			make.height.equalTo(iconSize)
		}
		
		let descriptionTextView = UITextView()
		self.descriptionTextView = descriptionTextView
		firstContainer.addSubview(descriptionTextView)
		descriptionTextView.scrollEnabled = true
		descriptionTextView.text = self.taskDescription
		descriptionTextView.font = UIFont(name: "Lato-Regular", size: kText15)
		descriptionTextView.textColor = Color.textFieldTextColor
		descriptionTextView.textAlignment = NSTextAlignment.Center
		descriptionTextView.backgroundColor = UIColor.clearColor()
		descriptionTextView.autoresizesSubviews = false
		descriptionTextView.alpha = 0
		descriptionTextView.returnKeyType = .Done
		descriptionTextView.delegate = self
		descriptionTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleUnderline.snp_bottom).offset(30)
			make.width.equalTo(titleTextView.snp_width)
			make.centerX.equalTo(firstContainer.snp_centerX)
			make.bottom.equalTo(firstContainer.snp_bottom)
		}
		
		//SECOND CONTAINER
		let secondContainer = UIView()
		self.secondContainer = secondContainer
		contentView.addSubview(secondContainer)
		secondContainer.backgroundColor = Color.whitePrimary
		secondContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.left.equalTo(self.firstContainer.snp_right)
			make.width.equalTo(width)
			make.height.equalTo(self.firstContainer.snp_height)
		}
		self.secondContainer.addGestureRecognizer(self.secondSwipeRecLeft)
		self.secondContainer.addGestureRecognizer(self.secondSwipeRecRight)
		self.secondContainer.alpha = 0
		
		let detailsLabel = UILabel()
		secondContainer.addSubview(detailsLabel)
		detailsLabel.text = "Details"
		detailsLabel.textColor = Color.blackPrimary
		detailsLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		detailsLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(secondContainer.snp_top).offset(20)
			make.centerX.equalTo(secondContainer.snp_centerX)
		}
		
		let streetAddressLabel = UILabel()
		streetAddressLabel.backgroundColor = UIColor.clearColor()
		secondContainer.addSubview(streetAddressLabel)
		streetAddressLabel.text = self.task.exactLocation!.formattedTextLabelNoPostal
		streetAddressLabel.numberOfLines = 0
		streetAddressLabel.textColor = Color.darkGrayDetails
		streetAddressLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		streetAddressLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(secondContainer.snp_centerX).offset(16)
			make.bottom.equalTo(secondContainer.snp_centerY).offset(-30)
		}
		
		let pinIcon = UIImageView()
		secondContainer.addSubview(pinIcon)
		pinIcon.image = UIImage(named: "pin")
		pinIcon.contentMode = UIViewContentMode.ScaleAspectFit
		pinIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(35)
			make.width.equalTo(35)
			make.centerY.equalTo(streetAddressLabel.snp_centerY)
			make.right.equalTo(streetAddressLabel.snp_left).offset(-10)
		}
		
		let dateLabel = UILabel()
		dateLabel.backgroundColor = UIColor.clearColor()
		secondContainer.addSubview(dateLabel)
		dateLabel.text = "3 hours ago"
		dateLabel.textColor = Color.darkGrayDetails
		dateLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		dateLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(secondContainer.snp_centerX).offset(15)
			make.centerY.equalTo(secondContainer.snp_centerY).offset(10)
		}
		
		let dateIcon = UIImageView()
		secondContainer.addSubview(dateIcon)
		dateIcon.image = UIImage(named: "pin")
		dateIcon.contentMode = UIViewContentMode.ScaleAspectFit
		dateIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(35)
			make.width.equalTo(35)
			make.centerY.equalTo(dateLabel.snp_centerY)
			make.right.equalTo(dateLabel.snp_left).offset(-10)
		}
		
		let myOfferLabel = UILabel()
		myOfferLabel.backgroundColor = UIColor.clearColor()
		secondContainer.addSubview(myOfferLabel)
		myOfferLabel.text = "My Offer"
		myOfferLabel.textColor = Color.darkGrayDetails
		myOfferLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		myOfferLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(secondContainer.snp_centerX)
			make.top.equalTo(secondContainer.snp_centerY).offset(50)
		}
		
		let moneyContainer = UIView()
		secondContainer.addSubview(moneyContainer)
		moneyContainer.backgroundColor = Color.whiteBackground
		moneyContainer.layer.cornerRadius = 3
		moneyContainer.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(secondContainer.snp_centerX)
			make.top.equalTo(myOfferLabel.snp_bottom).offset(5)
			make.width.equalTo(55)
			make.height.equalTo(35)
		}
		
		let moneyLabel = UILabel()
		moneyContainer.addSubview(moneyLabel)
		moneyLabel.textAlignment = NSTextAlignment.Center
		moneyLabel.textColor = Color.blackPrimary
		let price = String(format: "%.0f", self.task.priceOffered!)
		moneyLabel.text = price+"$"
		moneyLabel.font = UIFont(name: "Lato-Light", size: kText15)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyContainer.snp_edges)
		}
		
		//THIRD CONTAINER
		let thirdContainer = UIView()
		self.thirdContainer = thirdContainer
		contentView.addSubview(thirdContainer)
		thirdContainer.backgroundColor = Color.whitePrimary
		thirdContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.left.equalTo(secondContainer.snp_right)
			make.width.equalTo(width)
			make.height.equalTo(self.firstContainer.snp_height)
		}
		self.thirdContainer.addGestureRecognizer(self.thirdSwipeRecRight)
		self.thirdContainer.alpha = 0
		
		//Title label
		
		let managePicturesLabel = UILabel()
		thirdContainer.addSubview(managePicturesLabel)
		managePicturesLabel.text = "Manage Pictures"
		managePicturesLabel.textColor = Color.blackPrimary
		managePicturesLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		managePicturesLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(thirdContainer.snp_top).offset(20)
			make.centerX.equalTo(thirdContainer.snp_centerX)
		}
		
		//If no picture label
		
		let noPicturesLabel = UILabel()
		self.noPicturesLabel = noPicturesLabel
		thirdContainer.addSubview(noPicturesLabel)
		noPicturesLabel.text = "You have not added any pictures for this task"
		noPicturesLabel.textColor = Color.darkGrayDetails
		noPicturesLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		noPicturesLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(thirdContainer.snp_centerY).offset(-7)
			make.centerX.equalTo(thirdContainer.snp_centerX)
		}
		
		if self.pictures.isEmpty {
			noPicturesLabel.hidden = false
		} else {
			noPicturesLabel.hidden = true
		}
		
		//Collection View
		
		let collectionViewHeight = 130
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
		let picturesCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
		thirdContainer.addSubview(picturesCollectionView)
		self.picturesCollectionView = picturesCollectionView
		self.picturesCollectionView.delegate = self
		self.picturesCollectionView.backgroundColor = UIColor.clearColor()
		self.picturesCollectionView.dataSource = self
		picturesCollectionView.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(thirdContainer.snp_centerY).offset(-8)
			make.height.equalTo(collectionViewHeight)
			make.left.equalTo(thirdContainer.snp_left)
			make.right.equalTo(thirdContainer.snp_right)
		}
		
		picturesCollectionView.registerClass(PicturesCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: PicturesCollectionViewCell.reuseIdentifier)
		picturesCollectionView.backgroundColor = UIColor.clearColor()
		
		//Add pictures Button
		
		let picturesButton = PrimaryBorderActionButton()
		thirdContainer.addSubview(picturesButton)
		picturesButton.setTitle("Add Pictures", forState: UIControlState.Normal)
		picturesButton.addTarget(self, action: "didTapAddImage:", forControlEvents: UIControlEvents.TouchUpInside)
		picturesButton.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(thirdContainer.snp_centerX)
			make.bottom.equalTo(thirdContainer.snp_bottom).offset(-10)
		}
		
		//PAGING CONTAINER
		let pagingContainer = UIView()
		self.pagingContainer = pagingContainer
		self.view.addSubview(pagingContainer)
		pagingContainer.backgroundColor = Color.whitePrimary
		pagingContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(firstContainer.snp_bottom)
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.height.equalTo(pagingContainerHeight)
		}
		
		let firstO = PageControllerOval()
		self.firstO = firstO
		pagingContainer.addSubview(firstO)
		firstO.backgroundColor = UIColor.clearColor()
		firstO.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(pagingContainer.snp_centerX).offset(-20)
			make.centerY.equalTo(pagingContainer.snp_centerY)
			make.width.equalTo(self.selectedSize)
			make.height.equalTo(self.selectedSize)
		}
		self.firstO.alpha = self.selectedAlpha
		
		let secondO = PageControllerOval()
		self.secondO = secondO
		pagingContainer.addSubview(secondO)
		secondO.backgroundColor = UIColor.clearColor()
		secondO.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(pagingContainer.snp_centerX)
			make.centerY.equalTo(pagingContainer.snp_centerY)
			make.width.equalTo(self.unselectedSize)
			make.height.equalTo(self.unselectedSize)
		}
		self.secondO.alpha = self.unselectedAlpha
		
		let thirdO = PageControllerOval()
		self.thirdO = thirdO
		pagingContainer.addSubview(thirdO)
		thirdO.backgroundColor = UIColor.clearColor()
		thirdO.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(pagingContainer.snp_centerX).offset(20)
			make.centerY.equalTo(pagingContainer.snp_centerY)
			make.width.equalTo(self.unselectedSize)
			make.height.equalTo(self.unselectedSize)
		}
		self.thirdO.alpha = self.unselectedAlpha
		
		//Borders
		
		let topBorder = UIView()
		self.view.addSubview(topBorder)
		topBorder.backgroundColor = Color.grayDetails
		topBorder.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(firstContainer.snp_top)
			make.height.equalTo(1)
			make.width.equalTo(width)
		}
		
		let botBorder = UIView()
		self.view.addSubview(botBorder)
		botBorder.backgroundColor = Color.grayDetails
		botBorder.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(pagingContainer.snp_bottom)
			make.height.equalTo(1)
			make.width.equalTo(width)
		}
		
	}
	
	/**
	Set the category images
	
	- parameter task: the task
	*/
	func setImages(task: FindNelpTask) {
		self.categoryIcon.layer.cornerRadius = self.categoryIcon.frame.size.width / 2
		self.categoryIcon.clipsToBounds = true
		self.categoryIcon.image = UIImage(named: task.category!)
	}
	
	/**
	Moves the view to the next horizontal container
	
	- parameter sender: condition left or right swipe for swipedSecondView
	*/
	func swipedFirstView(sender: UISwipeGestureRecognizer) {
		if self.descriptionIsEditing == true {
			return
		}
		
		self.firstContainer.snp_updateConstraints(closure: { (make) -> Void in
			make.left.equalTo(self.contentView.snp_left).offset(-(width))
		})
		updateActivePage(2)
		dismissKeyboard()
		
		UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
			self.firstContainer.layoutIfNeeded()
			self.secondContainer.layoutIfNeeded()
			self.thirdContainer.layoutIfNeeded()
			}, completion: nil)
	}
	
	func swipedSecondView(sender: UISwipeGestureRecognizer) {
		
		switch sender.direction {
		case UISwipeGestureRecognizerDirection.Left:
			self.firstContainer.snp_updateConstraints(closure: { (make) -> Void in
				make.left.equalTo(self.contentView.snp_left).offset(-2 * (width))
			})
			updateActivePage(3)
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstContainer.layoutIfNeeded()
				self.secondContainer.layoutIfNeeded()
				self.thirdContainer.layoutIfNeeded()
				}, completion: nil)
		case UISwipeGestureRecognizerDirection.Right:
			self.firstContainer.snp_updateConstraints(closure: { (make) -> Void in
				make.left.equalTo(self.contentView.snp_left)
			})
			updateActivePage(1)
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstContainer.layoutIfNeeded()
				self.secondContainer.layoutIfNeeded()
				self.thirdContainer.layoutIfNeeded()
				}, completion: nil)
		default:
			break
		}
	}
	
	func swipedThirdView(sender: UISwipeGestureRecognizer) {
		
		self.firstContainer.snp_updateConstraints(closure: { (make) -> Void in
			make.left.equalTo(self.contentView.snp_left).offset(-(width))
		})
		updateActivePage(2)
		
		UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
			self.firstContainer.layoutIfNeeded()
			self.secondContainer.layoutIfNeeded()
			self.thirdContainer.layoutIfNeeded()
			}, completion: nil)
	}
	
	func updateActivePage(activeView: Int) {
		switch activeView {
		case 1:
			self.firstO.snp_updateConstraints { (make) -> Void in
				make.width.equalTo(self.selectedSize)
				make.height.equalTo(self.selectedSize)
			}
			self.secondO.snp_updateConstraints { (make) -> Void in
				make.width.equalTo(self.unselectedSize)
				make.height.equalTo(self.unselectedSize)
			}
			self.thirdO.snp_updateConstraints { (make) -> Void in
				make.width.equalTo(self.unselectedSize)
				make.height.equalTo(self.unselectedSize)
			}
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstO.layoutIfNeeded()
				self.secondO.layoutIfNeeded()
				self.thirdO.layoutIfNeeded()
				
				self.firstO.alpha = self.selectedAlpha
				self.secondO.alpha = self.unselectedAlpha
				self.thirdO.alpha = self.unselectedAlpha
				
				self.firstContainer.alpha = 1
				self.secondContainer.alpha = 0
				self.thirdContainer.alpha = 0
				}, completion: nil)
		case 2:
			self.firstO.snp_updateConstraints { (make) -> Void in
				make.width.equalTo(self.unselectedSize)
				make.height.equalTo(self.unselectedSize)
			}
			self.secondO.snp_updateConstraints { (make) -> Void in
				make.width.equalTo(self.selectedSize)
				make.height.equalTo(self.selectedSize)
			}
			self.thirdO.snp_updateConstraints { (make) -> Void in
				make.width.equalTo(self.unselectedSize)
				make.height.equalTo(self.unselectedSize)
			}
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstO.layoutIfNeeded()
				self.secondO.layoutIfNeeded()
				self.thirdO.layoutIfNeeded()
				
				self.firstO.alpha = self.unselectedAlpha
				self.secondO.alpha = self.selectedAlpha
				self.thirdO.alpha = self.unselectedAlpha
				
				self.firstContainer.alpha = 0
				self.secondContainer.alpha = 1
				self.thirdContainer.alpha = 0
				}, completion: nil)
		case 3:
			self.firstO.snp_updateConstraints { (make) -> Void in
				make.width.equalTo(self.unselectedSize)
				make.height.equalTo(self.unselectedSize)
			}
			self.secondO.snp_updateConstraints { (make) -> Void in
				make.width.equalTo(self.unselectedSize)
				make.height.equalTo(self.unselectedSize)
			}
			self.thirdO.snp_updateConstraints { (make) -> Void in
				make.width.equalTo(self.selectedSize)
				make.height.equalTo(self.selectedSize)
			}
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
				self.firstO.layoutIfNeeded()
				self.secondO.layoutIfNeeded()
				self.thirdO.layoutIfNeeded()
				
				self.firstO.alpha = self.unselectedAlpha
				self.secondO.alpha = self.unselectedAlpha
				self.thirdO.alpha = self.selectedAlpha
				
				self.firstContainer.alpha = 0
				self.secondContainer.alpha = 0
				self.thirdContainer.alpha = 1
				}, completion: nil)
		default:
			break
		}
	}
	
	//MARK: TextView & TextField delegate
	
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		//textViewShouldReturn hack
		let resultRange = text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet(), options: .BackwardsSearch)
		if resultRange != nil {
			textView.resignFirstResponder()
			return false
		} else if textView == self.descriptionTextView {
			return textView.text.characters.count + (text.characters.count - range.length) <= 600
		} else if textView == self.titleTextView {
			return textView.text.characters.count + (text.characters.count - range.length) <= 80
		}
		
		return true
	}
	
	func textViewShouldBeginEditing(textView: UITextView) -> Bool {
		
		if textView == self.descriptionTextView {
			self.descriptionIsEditing = true
			
			self.firstContainer.snp_updateConstraints { (make) -> Void in
				make.height.equalTo(self.containerHeight + 60)
			}
			
			UIView.animateWithDuration(0.3, animations: { () -> Void in
				self.firstContainer.layoutIfNeeded()
				self.pagingContainer.layoutIfNeeded()
			})
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				self.descriptionTextView.contentInset.top = 0
				}, completion: nil)
			
			
			self.view.layoutIfNeeded()
			
		} else if textView == self.titleTextView {
			
		}
		
		return true
	}
	
	func textViewShouldEndEditing(textView: UITextView) -> Bool {
		
		if textView == self.descriptionTextView {
			self.descriptionIsEditing = false
			
			self.firstContainer.snp_updateConstraints { (make) -> Void in
				make.height.equalTo(self.containerHeight)
			}
			self.firstContainer.layoutIfNeeded()
			self.descriptionTextView.layoutIfNeeded()
			
			var topCorrect = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale) / 2
			topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				self.descriptionTextView.contentInset.top = topCorrect
				}, completion: nil)
			
			self.contentView.layoutIfNeeded()
			//self.parentVC.scrollView.contentSize = self.contentView.frame.size
			
		} else if textView == self.titleTextView {
			
		}
		
		return true
	}
	
	//MARK: Setters
	
	/**
	Fetches the task images in order to edit them
	*/
	func getImagesFromParse(){
		for picture in self.pictures{
			ApiHelper.getPictures(picture.url!, block: { (image) -> Void in
				self.images.append(image)
				print(self.images.count)
				self.picturesCollectionView.reloadData()
			})
		}
	}
	
	//MARK: UICollectionView Delegate and Datasource
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.images.count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PicturesCollectionViewCell.reuseIdentifier, forIndexPath: indexPath) as! PicturesCollectionViewCell
		cell.delegate = self
		cell.tag = indexPath.row
		let image = self.images[indexPath.row]
		cell.imageView.image = image
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		
		return CGSizeMake(self.picturesCollectionView.frame.height, self.picturesCollectionView.frame.height)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
		return 20
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		
		let cellWidth = self.picturesCollectionView.frame.height
		let cellCount = CGFloat(collectionView.numberOfItemsInSection(section))
		let cellSpacing = 20 * (cellCount - 1)
		var inset = (collectionView.bounds.size.width - (cellCount * (cellWidth + (cellSpacing)))) * 0.5
		inset = max(inset, 20)
		
		return UIEdgeInsetsMake(0.0, inset, 0.0, 0.0)
		
	}
	
	func didTapAddImage(sender:UIButton){
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .PhotoLibrary
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func didRemovePicture(vc: PicturesCollectionViewCell) {
		self.images.removeAtIndex(vc.tag)
		self.picturesCollectionView.reloadData()
		
		if self.images.isEmpty {
			self.noPicturesLabel.hidden = false
		} else {
			self.noPicturesLabel.hidden = true
		}
		
		self.picturesChanged = true
	}
	
	//MARK: Image Picker Delegate
	
	/**
	Allows the user to pick pictures in his library
	
	- parameter picker: ImagePicker instance
	- parameter info:   .
	*/
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			self.images.append(pickedImage)
			self.picturesCollectionView.reloadData()
			self.noPicturesLabel.hidden = true
		}
		
		self.picturesChanged = true
		
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
}
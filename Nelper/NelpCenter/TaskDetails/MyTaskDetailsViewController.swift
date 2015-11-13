//
//  MyTaskDetailsViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-17.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import iCarousel
import FXBlurView

protocol MyTaskDetailsViewControllerDelegate{
	func didEditTask(task:FindNelpTask)
}

class MyTaskDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ApplicantCellDelegate, ApplicantProfileViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PicturesCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var container: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var task: FindNelpTask!
	var applications: [TaskApplication]!
	var pendingApplications: [TaskApplication]!
	var deniedApplications: [TaskApplication]!
	
	var delegate:MyTaskDetailsViewControllerDelegate!
	var contentView: UIView!
	var categoryIcon: UIImageView!
	var applicantsTableView: UITableView!
	var activeApplicantsContainer: DefaultContainerView!
	var deniedApplicantsContainer: DefaultContainerView!
	var deniedApplicantsTableView: UITableView!
	var deniedApplicantIcon:UIImageView!
	var deniedApplicantsLabel:UILabel!
	
	var titleTextView: UITextView!
	var descriptionTextView: UITextView!
	var deleteTaskButton: UIButton!
	var pictures = [PFFile]()
	var images = [UIImage]()
	var imagePicker = UIImagePickerController()
	var saveChangesButton: UIButton!
	var picturesCollectionView: UICollectionView!
	
	var firstContainer: UIView!
	var secondContainer: UIView!
	var thirdContainer: UIView!
	var firstO: PageControllerOval!
	var secondO: PageControllerOval!
	var thirdO: PageControllerOval!
	var selectedAlpha: CGFloat = 1
	var unselectedAlpha: CGFloat = 0.5
	var selectedSize: CGFloat = 9
	var unselectedSize: CGFloat = 7
	
	var noPicturesLabel: UILabel!

	let firstSwipeRecLeft = UISwipeGestureRecognizer()
	let secondSwipeRecLeft = UISwipeGestureRecognizer()
	let secondSwipeRecRight = UISwipeGestureRecognizer()
	let thirdSwipeRecRight = UISwipeGestureRecognizer()
	
	var containerHeight: CGFloat!
	var noPendingContainer: UIView!
	var pagingContainer: UIView!
	
	var taskTitle: String!
	var taskDescription: String!
	
	var descriptionIsEditing = false
	
	var picturesChanged = false
	
	convenience init(task:FindNelpTask) {
		self.init(nibName: "MyTaskDetailsViewController", bundle: nil)
		self.task = task
		self.applications = task.applications
		self.pendingApplications = self.applications.filter({ $0.state != .Denied })
		self.deniedApplications = self.applications.filter({ $0.state == .Denied })
	}
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imagePicker.delegate = self
		self.automaticallyAdjustsScrollViewInsets = false
		
		firstSwipeRecLeft.addTarget(self, action: "swipedFirstView:")
		firstSwipeRecLeft.direction = UISwipeGestureRecognizerDirection.Left
		secondSwipeRecLeft.addTarget(self, action: "swipedSecondView:")
		secondSwipeRecLeft.direction = UISwipeGestureRecognizerDirection.Left
		secondSwipeRecRight.addTarget(self, action: "swipedSecondView:")
		secondSwipeRecRight.direction = UISwipeGestureRecognizerDirection.Right
		thirdSwipeRecRight.addTarget(self, action: "swipedThirdView:")
		thirdSwipeRecRight.direction = UISwipeGestureRecognizerDirection.Right
		
		if self.task.pictures != nil {
			self.pictures = self.task.pictures!
			self.getImagesFromParse()
		}
		
		self.taskTitle = self.task.title
		self.taskDescription = self.task.desc
		
		self.createView()
		
		self.adjustUI()
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		self.firstContainer.addGestureRecognizer(tap)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
	
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
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	//MARK: View Creation
	
	func createView() {
		
		self.containerHeight = 270
		let pagingContainerHeight = 50
		
		//NavBar
		
		let previousBtn = UIButton()
		let deleteBtn = UIButton()
		previousBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		deleteBtn.addTarget(self, action: "deleteTaskButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = previousBtn
		self.navBar.deleteButton = deleteBtn
		self.navBar.setTitle("My Task")
		
		//Scroll View
		
		self.scrollView.alwaysBounceVertical = true
		
		//ContentView
		
		let contentView = UIView()
		self.contentView = contentView
		self.scrollView.addSubview(contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.scrollView.snp_top)
			make.left.equalTo(self.scrollView.snp_left)
			make.right.equalTo(self.scrollView.snp_right)
			make.width.equalTo(self.container.snp_width)
		}
		
		let backgroundContainer = UIView()
		self.contentView.addSubview(backgroundContainer)
		backgroundContainer.backgroundColor = whitePrimary
		backgroundContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
			make.height.equalTo(containerHeight)
		}
		
		//FIRST CONTAINER
		let firstContainer = UIView()
		self.firstContainer = firstContainer
		self.contentView.addSubview(firstContainer)
		self.firstContainer.backgroundColor = whitePrimary
		self.firstContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
			make.left.equalTo(contentView.snp_left)
			make.width.equalTo(contentView.snp_width)
			make.height.equalTo(containerHeight)
		}
		self.firstContainer.addGestureRecognizer(self.firstSwipeRecLeft)
		
		let titleTextView = UITextView()
		self.titleTextView = titleTextView
		firstContainer.addSubview(titleTextView)
		titleTextView.text = self.taskTitle
		titleTextView.font = UIFont(name: "Lato-Regular", size: kTitle17)
		titleTextView.textColor = blackPrimary
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
		titleUnderline.backgroundColor = grayDetails
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
		descriptionTextView.textColor = textFieldTextColor
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
		
		/* needed?
		let fixedWidth = descriptionTextView.frame.size.width
		descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		let newSize = descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		var newFrame = descriptionTextView.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		descriptionTextView.frame = newFrame*/
		
		//SECOND CONTAINER
		let secondContainer = UIView()
		self.secondContainer = secondContainer
		self.contentView.addSubview(secondContainer)
		secondContainer.backgroundColor = whitePrimary
		secondContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
			make.left.equalTo(self.firstContainer.snp_right)
			make.width.equalTo(self.contentView.snp_width)
			make.height.equalTo(self.firstContainer.snp_height)
		}
		self.secondContainer.addGestureRecognizer(self.secondSwipeRecLeft)
		self.secondContainer.addGestureRecognizer(self.secondSwipeRecRight)
		self.secondContainer.alpha = 0
		
		let detailsLabel = UILabel()
		secondContainer.addSubview(detailsLabel)
		detailsLabel.text = "Details"
		detailsLabel.textColor = blackPrimary
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
		streetAddressLabel.textColor = darkGrayDetails
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
		dateLabel.textColor = darkGrayDetails
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
		myOfferLabel.textColor = darkGrayDetails
		myOfferLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		myOfferLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(secondContainer.snp_centerX)
			make.top.equalTo(secondContainer.snp_centerY).offset(50)
		}
		
		let moneyContainer = UIView()
		secondContainer.addSubview(moneyContainer)
		moneyContainer.backgroundColor = whiteBackground
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
		moneyLabel.textColor = blackPrimary
		let price = String(format: "%.0f", self.task.priceOffered!)
		moneyLabel.text = price+"$"
		moneyLabel.font = UIFont(name: "Lato-Light", size: kText15)
		moneyLabel.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(moneyContainer.snp_edges)
		}
		
		//THIRD CONTAINER
		let thirdContainer = UIView()
		self.thirdContainer = thirdContainer
		self.contentView.addSubview(thirdContainer)
		thirdContainer.backgroundColor = whitePrimary
		thirdContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
			make.left.equalTo(secondContainer.snp_right)
			make.width.equalTo(self.contentView.snp_width)
			make.height.equalTo(self.firstContainer.snp_height)
		}
		self.thirdContainer.addGestureRecognizer(self.thirdSwipeRecRight)
		self.thirdContainer.alpha = 0
		
		//Title label
		
		let managePicturesLabel = UILabel()
		thirdContainer.addSubview(managePicturesLabel)
		managePicturesLabel.text = "Manage Pictures"
		managePicturesLabel.textColor = blackPrimary
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
		noPicturesLabel.textColor = darkGrayDetails
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
		self.contentView.addSubview(pagingContainer)
		pagingContainer.backgroundColor = whitePrimary
		pagingContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(firstContainer.snp_bottom)
			make.left.equalTo(contentView.snp_left)
			make.right.equalTo(contentView.snp_right)
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
		self.contentView.addSubview(topBorder)
		topBorder.backgroundColor = grayDetails
		topBorder.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(firstContainer.snp_top)
			make.height.equalTo(1)
			make.width.equalTo(self.contentView.snp_width)
		}
		
		let botBorder = UIView()
		self.contentView.addSubview(botBorder)
		botBorder.backgroundColor = grayDetails
		botBorder.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(pagingContainer.snp_bottom)
			make.height.equalTo(1)
			make.width.equalTo(self.contentView.snp_width)
		}
		
		//Active Applicants
		
		self.makeActiveApplicantsContainer(false)
		
		//Denied Applicants
		
		self.makeDeniedApplicantsContainer(false)
	}
	
	func getPictures(imageURL: String, block: (UIImage) -> Void) -> Void {
		var image: UIImage!
		request(.GET,imageURL).response() {
			(_, _, data, error) in
			if(error != nil){
				print(error)
			}
			image = UIImage(data: data as NSData!)
			block(image)
		}
	}
	
	//MARK: UI
	
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
	
	func adjustUI() {
		self.container.backgroundColor = whiteBackground
		self.scrollView.backgroundColor = whiteBackground
	}
	
	/**
	Make the active Applicants (Pending Nelpers) and set its content accordingly
	
	- parameter isUpdate: true if the container has already been created and we only want it to update
	*/
	func makeActiveApplicantsContainer(isUpdate: Bool) {
		
		if isUpdate {
			self.activeApplicantsContainer.removeFromSuperview()
		}
		
		//Container
		
		let activeApplicantsContainer = DefaultContainerView()
		self.activeApplicantsContainer = activeApplicantsContainer
		self.contentView.addSubview(activeApplicantsContainer)
		activeApplicantsContainer.containerTitle = "Nelpers"
		activeApplicantsContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.pagingContainer.snp_bottom).offset(20)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
		}
		
		let pendingApplicantIcon = UIImageView()
		activeApplicantsContainer.titleView.addSubview(pendingApplicantIcon)
		pendingApplicantIcon.image = UIImage(named: "pending.png")
		pendingApplicantIcon.contentMode = UIViewContentMode.ScaleAspectFill
		pendingApplicantIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(activeApplicantsContainer.titleView.snp_centerY)
			make.left.equalTo(activeApplicantsContainer.titleView.snp_left).offset(20)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		self.activeApplicantsContainer.titleLabel.snp_remakeConstraints { (make) -> Void in
			make.centerY.equalTo(pendingApplicantIcon.snp_centerY)
			make.left.equalTo(pendingApplicantIcon.snp_right).offset(12)
		}
		
		//Content
		
		let applicantsTableView = UITableView()
		self.applicantsTableView = applicantsTableView
		self.applicantsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		self.applicantsTableView.registerClass(ApplicantCell.classForCoder(), forCellReuseIdentifier: ApplicantCell.reuseIdentifier)
		self.applicantsTableView.scrollEnabled = false
		self.applicantsTableView.dataSource = self
		self.applicantsTableView.delegate = self
		self.applicantsTableView.backgroundColor = UIColor.clearColor()
		self.activeApplicantsContainer.contentView.addSubview(applicantsTableView)
		self.applicantsTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(activeApplicantsContainer.contentView.snp_top)
			make.left.equalTo(activeApplicantsContainer.contentView.snp_left)
			make.right.equalTo(activeApplicantsContainer.contentView.snp_right)
			make.height.equalTo(self.pendingApplications.count * 100)
		}
		
		if self.pendingApplications.isEmpty {
			
			self.applicantsTableView.hidden = true
			
			let noPendingLabel = UILabel()
			activeApplicantsContainer.contentView.addSubview(noPendingLabel)
			noPendingLabel.text = "No pending applications"
			noPendingLabel.textColor = darkGrayDetails
			noPendingLabel.font = UIFont(name: "Lato-Regular", size: kText15)
			noPendingLabel.snp_makeConstraints { (make) -> Void in
				make.centerX.equalTo(activeApplicantsContainer.contentView.snp_centerX)
				make.top.equalTo(activeApplicantsContainer.contentView.snp_top).offset(20)
			}
			
			self.activeApplicantsContainer.snp_makeConstraints { (make) -> Void in
				make.bottom.equalTo(noPendingLabel.snp_bottom).offset(20)
			}
			
			self.activeApplicantsContainer.layoutIfNeeded()
			
		} else {
			
			self.activeApplicantsContainer.snp_makeConstraints { (make) -> Void in
				make.bottom.equalTo(applicantsTableView.snp_bottom)
			}
			
			self.activeApplicantsContainer.layoutIfNeeded()
		}
	}
	
	/**
	Make the Denied Applicants Container if needed.
	*/
	func makeDeniedApplicantsContainer(isUpdate: Bool) {
		
		if isUpdate {
			self.deniedApplicantsContainer.removeFromSuperview()
		}
		
		//Container
		
		let deniedApplicantsContainer = DefaultContainerView()
		self.deniedApplicantsContainer = deniedApplicantsContainer
		self.contentView.addSubview(deniedApplicantsContainer)
		deniedApplicantsContainer.containerTitle = "Denied Nelpers"
		deniedApplicantsContainer.snp_remakeConstraints { (make) -> Void in
			make.top.equalTo(self.activeApplicantsContainer.snp_bottom).offset(20)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
		}
		
		let deniedApplicantIcon = UIImageView()
		self.deniedApplicantIcon = deniedApplicantIcon
		deniedApplicantsContainer.titleView.addSubview(deniedApplicantIcon)
		deniedApplicantIcon.image = UIImage(named: "denied.png")
		deniedApplicantIcon.contentMode = UIViewContentMode.ScaleAspectFill
		deniedApplicantIcon.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(deniedApplicantsContainer.titleView.snp_centerY)
			make.left.equalTo(deniedApplicantsContainer.titleView.snp_left).offset(20)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		deniedApplicantsContainer.titleLabel.snp_remakeConstraints { (make) -> Void in
			make.centerY.equalTo(deniedApplicantIcon.snp_centerY)
			make.left.equalTo(deniedApplicantIcon.snp_right).offset(12)
		}
		
		deniedApplicantsContainer.layoutIfNeeded()
		
		//Applicants Table View
		
		let deniedApplicantsTableView = UITableView()
		self.deniedApplicantsTableView = deniedApplicantsTableView
		self.deniedApplicantsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		deniedApplicantsTableView.registerClass(ApplicantCell.classForCoder(), forCellReuseIdentifier: ApplicantCell.reuseIdentifier)
		self.deniedApplicantsTableView.scrollEnabled = false
		self.deniedApplicantsTableView.dataSource = self
		self.deniedApplicantsTableView.delegate = self
		self.contentView.addSubview(deniedApplicantsTableView)
		deniedApplicantsTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(deniedApplicantsContainer.contentView.snp_top)
			make.left.equalTo(deniedApplicantsContainer.snp_left)
			make.right.equalTo(deniedApplicantsContainer.snp_right)
			make.height.equalTo(deniedApplications.count * 100)
		}
		
		self.deniedApplicantsContainer.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self.deniedApplicantsTableView.snp_bottom)
		}
		
		if !isUpdate {
			if self.deniedApplications.isEmpty {
				self.deniedApplicantsContainer.hidden = true
				self.contentView.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(self.scrollView.snp_top)
					make.left.equalTo(self.scrollView.snp_left)
					make.right.equalTo(self.scrollView.snp_right)
					make.width.equalTo(self.container.snp_width)
					make.bottom.equalTo(self.activeApplicantsContainer.snp_bottom).offset(20)
				}
			} else {
				self.contentView.snp_makeConstraints { (make) -> Void in
					make.top.equalTo(self.scrollView.snp_top)
					make.left.equalTo(self.scrollView.snp_left)
					make.right.equalTo(self.scrollView.snp_right)
					make.width.equalTo(self.container.snp_width)
					make.bottom.equalTo(self.deniedApplicantsContainer.snp_bottom).offset(20)
				}
			}
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
	Update the frames to new tableViews
	*/
	func updateFrames() {
		
		//TODO: Animate?
		
		self.activeApplicantsContainer.layoutIfNeeded()
		self.deniedApplicantsContainer.layoutIfNeeded()
		
		if self.deniedApplications.isEmpty {
			self.deniedApplicantsContainer.hidden = true
			self.contentView.snp_remakeConstraints { (make) -> Void in
				make.top.equalTo(self.scrollView.snp_top)
				make.left.equalTo(self.scrollView.snp_left)
				make.right.equalTo(self.scrollView.snp_right)
				make.width.equalTo(self.container.snp_width)
				make.bottom.equalTo(self.activeApplicantsContainer.snp_bottom).offset(20)
			}
		} else {
			self.contentView.snp_remakeConstraints { (make) -> Void in
				make.top.equalTo(self.scrollView.snp_top)
				make.left.equalTo(self.scrollView.snp_left)
				make.right.equalTo(self.scrollView.snp_right)
				make.width.equalTo(self.container.snp_width)
				make.bottom.equalTo(self.deniedApplicantsContainer.snp_bottom).offset(20)
			}
		}
		
		self.scrollView.contentSize = self.contentView.frame.size
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
			self.scrollView.contentSize = self.contentView.frame.size
			
		} else if textView == self.titleTextView {
			
		}
		
		return true
	}
	
	//MARK: Tableview Delegate and Datasource
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == self.applicantsTableView {
			return self.pendingApplications.count
		} else if tableView == self.deniedApplicantsTableView {
			return self.deniedApplications.count
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		if tableView == applicantsTableView {
			
			let pendingApplicantCell = tableView.dequeueReusableCellWithIdentifier(ApplicantCell.reuseIdentifier, forIndexPath: indexPath) as! ApplicantCell
			
			let application = self.pendingApplications[indexPath.row]
			pendingApplicantCell.setApplication(application)
			return pendingApplicantCell
			
		} else if tableView == deniedApplicantsTableView {
			
			let deniedApplicantCell = tableView.dequeueReusableCellWithIdentifier(ApplicantCell.reuseIdentifier, forIndexPath: indexPath) as! ApplicantCell
			let deniedApplication = self.deniedApplications[indexPath.row]
			deniedApplicantCell.setApplication(deniedApplication)
			deniedApplicantCell.replaceArrowImage()
			deniedApplicantCell.delegate = self
			
			return deniedApplicantCell
			
		}
		
		return UITableViewCell()
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if tableView == self.applicantsTableView {
			let application = self.pendingApplications[indexPath.row]
			let nextVC = ApplicantProfileViewController(applicant: application.user, application: application)
			nextVC.delegate = self
			dispatch_async(dispatch_get_main_queue()) {
				self.navigationController?.pushViewController(nextVC, animated: true)
			}
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100
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
	
	//MARK: View delegate Methods
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if self.descriptionIsEditing{
			self.scrollView.contentSize.height = UIScreen.mainScreen().bounds.height + 100
		}else{
			self.scrollView.contentSize = self.contentView.frame.size
		}
		
	}
	
	//MARK: Cell delegate methods
	
	func didTapRevertButton(application: TaskApplication) {

		self.deniedApplications.removeAtIndex(self.deniedApplications.indexOf({$0 === application})!)
		self.pendingApplications.append(application)
		
		application.state = .Pending
		ApiHelper.restoreApplication(application, block: nil)
		
		self.makeActiveApplicantsContainer(true)
		self.makeDeniedApplicantsContainer(true)
		self.updateFrames()
		_ = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "scrollToBottom", userInfo: nil, repeats: false)
	}
	
	//MARK: Applications Profile View Controller Delegate
	
	func didTapDenyButton(application: TaskApplication) {
		self.pendingApplications.removeAtIndex(self.pendingApplications.indexOf({$0 === application})!)
		self.deniedApplications.append(application)

		self.makeActiveApplicantsContainer(true)
		self.makeDeniedApplicantsContainer(true)
		self.updateFrames()
		_ = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "scrollToBottom", userInfo: nil, repeats: false)
	}
	
	func dismissVC() {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	//MARK: Utilities
	
	func scrollToBottom() {
		
		self.scrollView.scrollRectToVisible(CGRectMake(self.scrollView.contentSize.width - 1, self.scrollView.contentSize.height - 1, 1, 1), animated: true)
	}
	
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
	
	
	//MARK: Actions
	
	func dismissKeyboard() {
		view.endEditing(true)
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
			make.left.equalTo(self.contentView.snp_left).offset(-(self.contentView.frame.width))
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
				make.left.equalTo(self.contentView.snp_left).offset(-2 * (self.contentView.frame.width))
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
			make.left.equalTo(self.contentView.snp_left).offset(-(self.contentView.frame.width))
		})
		updateActivePage(2)
		
		UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
			self.firstContainer.layoutIfNeeded()
			self.secondContainer.layoutIfNeeded()
			self.thirdContainer.layoutIfNeeded()
			}, completion: nil)
	}
	
	func backButtonTapped(sender: UIButton) {
		
		dismissKeyboard()
		
		if (self.titleTextView.text != self.taskTitle) || (self.descriptionTextView.text != self.taskDescription) || (self.picturesChanged) {
			
			let popup = UIAlertController(title: "Your task was edited", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
			let popupSubview = popup.view.subviews.first! as UIView
			let popupContentView = popupSubview.subviews.first! as UIView
			popupContentView.layer.cornerRadius = 0
			popup.addAction(UIAlertAction(title: "Save changes", style: .Default, handler: { (action) -> Void in
				//Saves info and changes the view
				self.task.title = self.titleTextView.text
				if !self.images.isEmpty {
					self.convertImagesToData()
				}
				self.task.desc = self.descriptionTextView.text
				
				
				print(self.task.desc)
				
				ApiHelper.editTask(self.task)
				self.delegate.didEditTask(self.task)
				self.navigationController?.popViewControllerAnimated(true)
			}))
			popup.addAction(UIAlertAction(title: "Discard changes", style: .Default, handler: { (action) -> Void in
				//Resets info and changes the view
				if self.task.pictures != nil {
					self.pictures = self.task.pictures!
					self.getImagesFromParse()
				} else {
					self.pictures.removeAll()
				}
				self.taskTitle = self.task.title
				self.taskDescription = self.task.desc
				self.navigationController?.popViewControllerAnimated(true)
			}))
			self.presentViewController(popup, animated: true, completion: nil)
		} else {
			self.navigationController?.popViewControllerAnimated(true)
		}
	}
	
	/**
	Converts the attached task pictures to Data in order to save them in parse.
	*/
	func convertImagesToData() {
		self.task.pictures = Array()
		for image in self.images{
			let imageData = UIImageJPEGRepresentation(image , 0.50)
			let imageFile = PFFile(name:"image.png", data:imageData!)
			self.task.pictures!.append(imageFile)
		}
	}
	
	func didTapAddImage(sender:UIButton){
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .PhotoLibrary
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func deleteTaskButtonTapped(sender: UIButton) {
		dismissKeyboard()
		
		let popup = UIAlertController(title: "Delete this task?", message: "This action is permanent.", preferredStyle: UIAlertControllerStyle.Alert)
		popup.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
			//Changes the view and delete the task
			self.navigationController?.popViewControllerAnimated(true)
			ApiHelper.deleteTask(self.task)
		}))
		popup.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
		}))
		
		self.presentViewController(popup, animated: true, completion: nil)
	}
		
	func didTapSaveButton(sender:UIButton){
		self.task.title = self.titleTextView.text
		if !self.images.isEmpty{
			self.task.pictures = ApiHelper.convertImagesToData(self.images)
		}
		self.task.desc = self.descriptionTextView.text
		
		ApiHelper.editTask(self.task)
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func didTapDeleteButton(sender: UIButton) {
		
	}
	
}
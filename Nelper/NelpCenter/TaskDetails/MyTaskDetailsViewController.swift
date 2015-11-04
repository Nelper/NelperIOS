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

class MyTaskDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ApplicantCellDelegate, ApplicantProfileViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PicturesCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate {
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var container: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var task: FindNelpTask!
	var applications: [TaskApplication]!
	var pendingApplications: [TaskApplication]!
	var deniedApplications: [TaskApplication]!
	
	var contentView: UIView!
	var categoryIcon: UIImageView!
	var applicantsTableView: UITableView!
	var activeApplicantsContainer: DefaultContainerView!
	var deniedApplicantsContainer: DefaultContainerView!
	var deniedApplicantsTableView: UITableView!
	var deniedApplicantIcon:UIImageView!
	var deniedApplicantsLabel:UILabel!
	
	var titleTextField: UITextView!
	var descriptionTextView: UITextView!
	var deleteTaskButton: UIButton!
	var pictures = [PFFile]()
	var images = [UIImage]()
	var imagePicker = UIImagePickerController()
	var saveChangesButton: UIButton!
	var picturesCollectionView: UICollectionView!
	
	var taskInfoContainer: UIView!
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
	
	var mapContainer: UIView!
	var mapView: MKMapView!
	
	var noPendingContainer: UIView!
	var pagingContainer: UIView!
	
	var taskTitle: String!
	var taskDescription: String!
	
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
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		self.taskInfoContainer.addGestureRecognizer(tap)
	}
	
	override func viewDidAppear(animated: Bool) {
		
		setMapUI()
	}
	
	//MARK: View Creation
	
	func createView() {
		
		let containerHeight = 270
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
		
		let taskInfoContainer = UIView()
		self.taskInfoContainer = taskInfoContainer
		self.contentView.addSubview(taskInfoContainer)
		taskInfoContainer.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(contentView.snp_left)
			make.top.equalTo(contentView.snp_top).offset(20)
			make.height.equalTo(containerHeight).offset(pagingContainerHeight)
			make.width.equalTo(contentView.snp_width).multipliedBy(3)
		}
		
		//FIRST CONTAINER
		let firstContainer = UIView()
		self.firstContainer = firstContainer
		self.taskInfoContainer.addSubview(firstContainer)
		self.firstContainer.backgroundColor = whitePrimary
		self.firstContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(taskInfoContainer.snp_top)
			make.left.equalTo(taskInfoContainer.snp_left)
			make.width.equalTo(contentView.snp_width)
			make.height.equalTo(containerHeight)
		}
		self.firstContainer.addGestureRecognizer(self.firstSwipeRecLeft)
		
		let titleTextField = UITextView()
		self.titleTextField = titleTextField
		firstContainer.addSubview(titleTextField)
		titleTextField.text = self.taskTitle
		titleTextField.font = UIFont(name: "Lato-Regular", size: kTitle17)
		titleTextField.textColor = blackPrimary
		titleTextField.textAlignment = NSTextAlignment.Center
		//titleTextField.layer.borderWidth = 1
		//titleTextField.layer.borderColor = grayDetails.CGColor
		titleTextField.backgroundColor = UIColor.clearColor()
		//titleTextField.scrollEnabled = true
		//titleTextField.alwaysBounceVertical = true
		//titleTextField.autoresizesSubviews = true
		titleTextField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(firstContainer.snp_top).offset(17)
			make.left.equalTo(firstContainer.snp_left).offset(12)
			make.right.equalTo(firstContainer.snp_right).offset(-12)
			make.height.equalTo(60)
		}
		
		let titleUnderline = UIView()
		firstContainer.addSubview(titleUnderline)
		titleUnderline.backgroundColor = grayDetails
		titleUnderline.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleTextField.snp_bottom).offset(20)
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
		descriptionTextView.text = self.taskDescription
		descriptionTextView.font = UIFont(name: "Lato-Regular", size: kText15)
		descriptionTextView.textColor = textFieldTextColor
		descriptionTextView.textAlignment = NSTextAlignment.Center
		//descriptionTextView.layer.borderWidth = 1
		//descriptionTextView.layer.borderColor = grayDetails.CGColor
		descriptionTextView.backgroundColor = UIColor.clearColor()
		descriptionTextView.scrollEnabled = true
		descriptionTextView.alwaysBounceVertical = true
		descriptionTextView.autoresizesSubviews = false
		descriptionTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleUnderline.snp_bottom).offset(30)
			make.width.equalTo(titleTextField.snp_width)
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
		self.taskInfoContainer.addSubview(secondContainer)
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
		
		let manageLocationsLabel = UILabel()
		secondContainer.addSubview(manageLocationsLabel)
		manageLocationsLabel.text = "Task Location"
		manageLocationsLabel.textColor = blackPrimary
		manageLocationsLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		manageLocationsLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(secondContainer.snp_top).offset(20)
			make.centerX.equalTo(secondContainer.snp_centerX)
		}
		
		//Map Container
		
		let mapContainer = UIView()
		self.mapContainer = mapContainer
		self.secondContainer.addSubview(mapContainer)
		mapContainer.layer.borderColor = grayDetails.CGColor
		mapContainer.layer.borderWidth = 0.5
		mapContainer.backgroundColor = UIColor.clearColor()
		mapContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(manageLocationsLabel.snp_bottom).offset(20)
			make.left.equalTo(self.secondContainer.snp_left)
			make.right.equalTo(self.secondContainer.snp_right)
			make.bottom.equalTo(self.secondContainer.snp_bottom)
		}
		
		let mapView = MKMapView()
		self.mapView = mapView
		mapView.delegate = self
		mapView.scrollEnabled = false
		mapView.zoomEnabled = false
		mapView.userInteractionEnabled = false
		mapView.showsPointsOfInterest = false
		mapContainer.addSubview(mapView)
		mapView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(mapContainer.snp_edges)
		}
		
		let taskLocation = CLLocationCoordinate2DMake(self.task.location!.latitude, self.task.location!.longitude)
		let span: MKCoordinateSpan = MKCoordinateSpanMake(0.025 , 0.025)
		let locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(taskLocation, span)
		mapView.setRegion(locationToZoom, animated: true)
		mapView.setCenterCoordinate(taskLocation, animated: true)
		
		//Label
		
		let blurEffect = UIBlurEffect(style: .ExtraLight)
		let blurView = UIVisualEffectView(effect: blurEffect)
		secondContainer.addSubview(blurView)
		
		let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
		let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
		vibrancyView.layer.borderWidth = 1
		vibrancyView.layer.borderColor = grayDetails.CGColor
		blurView.contentView.addSubview(vibrancyView)
		
		let streetAddressLabel = UILabel()
		streetAddressLabel.backgroundColor = UIColor.clearColor()
		vibrancyView.contentView.addSubview(streetAddressLabel)
		streetAddressLabel.text = self.task.exactLocation!.formattedTextLabel
		streetAddressLabel.numberOfLines = 0
		streetAddressLabel.textColor = blackPrimary
		streetAddressLabel.font = UIFont(name: "Lato-Regular", size: kText15)
		streetAddressLabel.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(secondContainer.snp_centerX).offset(30)
			make.centerY.equalTo(mapContainer.snp_centerY)
		}
		let streetAddressLabel2 = UILabel()
		streetAddressLabel2.backgroundColor = UIColor.clearColor()
		blurView.contentView.addSubview(streetAddressLabel2)
		streetAddressLabel2.text = streetAddressLabel.text
		streetAddressLabel2.numberOfLines = 0
		streetAddressLabel2.alpha = 0.4
		streetAddressLabel2.textColor = blackPrimary
		streetAddressLabel2.font = UIFont(name: "Lato-Regular", size: kText15)
		streetAddressLabel2.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(secondContainer.snp_centerX).offset(30)
			make.centerY.equalTo(mapContainer.snp_centerY)
		}
		
		let pinIcon = UIImageView()
		vibrancyView.contentView.addSubview(pinIcon)
		pinIcon.image = UIImage(named: "pin-MK")
		pinIcon.contentMode = UIViewContentMode.ScaleAspectFill
		pinIcon.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(40)
			make.width.equalTo(40)
			make.centerY.equalTo(streetAddressLabel.snp_centerY)
			make.right.equalTo(streetAddressLabel.snp_left).offset(-30)
		}
		let pinIcon2 = UIImageView()
		blurView.contentView.addSubview(pinIcon2)
		pinIcon2.image = UIImage(named: "pin-MK")
		pinIcon2.alpha = 0.8
		pinIcon2.contentMode = UIViewContentMode.ScaleAspectFill
		pinIcon2.snp_makeConstraints { (make) -> Void in
			make.height.equalTo(40)
			make.width.equalTo(40)
			make.centerY.equalTo(streetAddressLabel.snp_centerY)
			make.right.equalTo(streetAddressLabel.snp_left).offset(-30)
		}
		
		let contentInsets = 15
		blurView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(streetAddressLabel.snp_top).offset(-contentInsets)
			make.bottom.equalTo(streetAddressLabel.snp_bottom).offset(contentInsets)
			make.left.equalTo(pinIcon.snp_left).offset(-contentInsets + 6)
			make.right.equalTo(streetAddressLabel.snp_right).offset(contentInsets)
		}
		vibrancyView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(blurView.snp_edges)
		}
		
		let locationVerticalLine = UIView()
		vibrancyView.contentView.addSubview(locationVerticalLine)
		locationVerticalLine.backgroundColor = darkGrayDetails
		locationVerticalLine.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(streetAddressLabel.snp_top)
			make.bottom.equalTo(streetAddressLabel.snp_bottom)
			make.width.equalTo(0.5)
			make.left.equalTo(pinIcon.snp_right).offset(12)
		}
		let locationVerticalLine2 = UIView()
		blurView.contentView.addSubview(locationVerticalLine2)
		locationVerticalLine2.backgroundColor = grayDetails
		locationVerticalLine2.alpha = 0.5
		locationVerticalLine2.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(streetAddressLabel.snp_top)
			make.bottom.equalTo(streetAddressLabel.snp_bottom)
			make.width.equalTo(0.5)
			make.left.equalTo(pinIcon.snp_right).offset(12)
		}
		
		//THIRD CONTAINER
		let thirdContainer = UIView()
		self.thirdContainer = thirdContainer
		self.taskInfoContainer.addSubview(thirdContainer)
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
		self.taskInfoContainer.addSubview(pagingContainer)
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
	
	func setMapUI() {
		
		let blurContainer = FXBlurView(frame: self.mapView.bounds)
		blurContainer.tintColor = UIColor.clearColor()
		blurContainer.updateInterval = 100
		blurContainer.iterations = 2
		blurContainer.blurRadius = 4
		blurContainer.dynamic = false
		blurContainer.underlyingView = nil
		self.mapView.addSubview(blurContainer)
		blurContainer.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.mapView.snp_edges)
		}
	}
	
	/**
	Make the active Applicants (Pending Nelpers) and set its content accordingly
	
	- parameter isUpdate: true if the container has already been created and we only want it to update
	*/
	func makeActiveApplicantsContainer(isUpdate: Bool) {
		
		if isUpdate {
			for subview in self.activeApplicantsContainer.contentView.subviews {
				subview.removeFromSuperview()
			}
		}
		
		if !isUpdate {
			
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
			
			activeApplicantsContainer.titleLabel.snp_remakeConstraints { (make) -> Void in
				make.centerY.equalTo(pendingApplicantIcon.snp_centerY)
				make.left.equalTo(pendingApplicantIcon.snp_right).offset(12)
			}
			
			activeApplicantsContainer.snp_makeConstraints { (make) -> Void in
				make.bottom.equalTo(activeApplicantsContainer.titleView.snp_bottom).offset(20)
			}
		}
		
		//Content
		
		if self.pendingApplications.isEmpty {
			
			let noPendingLabel = UILabel()
			activeApplicantsContainer.contentView.addSubview(noPendingLabel)
			noPendingLabel.text = "No pending applications"
			noPendingLabel.textColor = darkGrayDetails
			noPendingLabel.font = UIFont(name: "Lato-Regular", size: kText15)
			noPendingLabel.snp_makeConstraints { (make) -> Void in
				make.centerX.equalTo(activeApplicantsContainer.contentView.snp_centerX)
				make.top.equalTo(activeApplicantsContainer.contentView.snp_top).offset(20)
			}
			
			activeApplicantsContainer.snp_updateConstraints(closure: { (make) -> Void in
				make.bottom.equalTo(noPendingLabel.snp_bottom).offset(20)
			})
			
		} else {
			
			activeApplicantsContainer.snp_updateConstraints(closure: { (make) -> Void in
				make.bottom.equalTo(activeApplicantsContainer.titleView.snp_bottom).offset(self.pendingApplications.count * 100)
			})
		}
		
		if !isUpdate {
			
			//Applicants Table View
			
			let applicantsTableView = UITableView()
			self.applicantsTableView = applicantsTableView
			self.applicantsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
			applicantsTableView.registerClass(ApplicantCell.classForCoder(), forCellReuseIdentifier: ApplicantCell.reuseIdentifier)
			self.applicantsTableView.scrollEnabled = false
			self.applicantsTableView.dataSource = self
			self.applicantsTableView.delegate = self
			self.contentView.addSubview(applicantsTableView)
			applicantsTableView.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(activeApplicantsContainer.contentView.snp_top)
				make.left.equalTo(activeApplicantsContainer.contentView.snp_left)
				make.right.equalTo(activeApplicantsContainer.contentView.snp_right)
				make.bottom.equalTo(activeApplicantsContainer.snp_bottom)
			}
		} else {
			self.applicantsTableView.reloadData()
		}
	}
	
	/**
	Make the Denied Applicants Container if needed.
	*/
	func makeDeniedApplicantsContainer(isUpdate: Bool) {
		
		if isUpdate {
			for subview in self.deniedApplicantsContainer.contentView.subviews {
				subview.removeFromSuperview()
			}
		}
		
		if !isUpdate {
			
			//Container
			
			let deniedApplicantsContainer = DefaultContainerView()
			self.deniedApplicantsContainer = deniedApplicantsContainer
			self.contentView.addSubview(deniedApplicantsContainer)
			deniedApplicantsContainer.containerTitle = "Denied Nelpers"
			deniedApplicantsContainer.snp_remakeConstraints { (make) -> Void in
				make.top.equalTo(self.self.applicantsTableView.snp_bottom).offset(20)
				make.left.equalTo(self.contentView.snp_left)
				make.right.equalTo(self.contentView.snp_right)
				make.bottom.equalTo(deniedApplicantsContainer.titleView.snp_bottom).offset(self.deniedApplications.count * 100)
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
			
			//Applicants Table ViewNelperino
			
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
				make.bottom.equalTo(deniedApplicantsContainer.snp_bottom)
			}
			
			if self.deniedApplications.isEmpty {
				self.contentView.snp_makeConstraints(closure: { (make) -> Void in
					make.bottom.equalTo(self.activeApplicantsContainer.snp_bottom).offset(20)
				})
			} else {
				self.contentView.snp_makeConstraints(closure: { (make) -> Void in
					make.bottom.equalTo(self.deniedApplicantsContainer.snp_bottom).offset(20)
				})
			}
			
		} else {
			if self.deniedApplications.isEmpty {
				self.contentView.snp_updateConstraints(closure: { (make) -> Void in
					make.bottom.equalTo(self.activeApplicantsContainer.snp_bottom).offset(20)
				})
			} else {
				self.contentView.snp_updateConstraints(closure: { (make) -> Void in
					make.bottom.equalTo(self.deniedApplicantsContainer.snp_bottom).offset(20)
				})
			}
			
			self.deniedApplicantsTableView.reloadData()
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
		
		//TODO: MAKE ANIMATION AND SET SCROLLVIEW.CONTENT SIZE UPON COMPLETION
		
		//UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
			self.activeApplicantsContainer.layoutIfNeeded()
			self.deniedApplicantsContainer.layoutIfNeeded()
			//}, completion: nil)
		
		self.scrollView.contentSize = self.contentView.frame.size
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
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
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
		
		self.scrollView.contentSize = self.contentView.frame.size
		
	}
	
	//MARK: UIGesture Recognizer
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	
	//MARK: Cell delegate methods
	
	func didTapRevertButton(application: TaskApplication) {

		self.deniedApplications.removeAtIndex(self.deniedApplications.indexOf({$0 === application})!)
		self.pendingApplications.append(application)
		
		application.state = .Pending
		ApiHelper.restoreApplication(application, block: nil)
		
		self.makeActiveApplicantsContainer(true)
	}
	
	
	
	//MARK: Applications Profile View Controller Delegate
	
	func didTapDenyButton(application: TaskApplication) {
		self.pendingApplications.removeAtIndex(self.pendingApplications.indexOf({$0 === application})!)
		self.deniedApplications.append(application)

		self.makeActiveApplicantsContainer(true)
		self.makeDeniedApplicantsContainer(true)
		self.updateFrames()
	}
	
	func dismissVC(){
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	//MARK: Utilities
	
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
	
	func DismissKeyboard() {
		view.endEditing(true)
	}
	
	/**
	Moves the view to the next horizontal container
	
	- parameter sender: condition left or right swipe for swipedSecondView
	*/
	func swipedFirstView(sender: UISwipeGestureRecognizer) {
		self.firstContainer.snp_updateConstraints(closure: { (make) -> Void in
			make.left.equalTo(self.contentView.snp_left).offset(-(self.contentView.frame.width))
		})
		updateActivePage(2)
		DismissKeyboard()
		
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
		
		DismissKeyboard()
		
		if (self.titleTextField.text != self.taskTitle) || (self.descriptionTextView.text != self.taskDescription) || (self.picturesChanged) {
			
			let popup = UIAlertController(title: "Your task was edited", message: "Do you want to save your changes to this task?", preferredStyle: UIAlertControllerStyle.Alert)
			let popupSubview = popup.view.subviews.first! as UIView
			let popupContentView = popupSubview.subviews.first! as UIView
			popupContentView.layer.cornerRadius = 0
			popup.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
				//Saves info and changes the view
				self.task.title = self.titleTextField.text
				if !self.images.isEmpty {
					self.task.pictures = ApiHelper.convertImagesToData(self.images)
				}
				self.task.desc = self.descriptionTextView.text
				
				ApiHelper.editTask(self.task)
				
				self.navigationController?.popViewControllerAnimated(true)
			}))
			popup.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action) -> Void in
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
	
	func didTapAddImage(sender:UIButton){
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .PhotoLibrary
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func deleteTaskButtonTapped(sender: UIButton) {
		DismissKeyboard()
		
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
		self.task.title = self.titleTextField.text
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
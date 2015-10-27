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

class MyTaskDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ApplicantCellDelegate, ApplicantProfileViewControllerDelegate, EditTaskViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PicturesCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var container: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	
	var contentView: UIView!
	var categoryIcon: UIImageView!
	var task: FindNelpTask!
	var applicantsTableView: UITableView!
	var arrayOfApplicants: [User]!
	var activeApplicantsContainer: UIView!
	var deniedApplicantsContainer: UIView!
	var arrayOfDeniedApplicants: [User]!
	var deniedApplicantsTableView: UITableView!
	var arrayOfApplications: [TaskApplication]!
	var arrayOfAllApplicants: [User]!
	var taskSectionContainer: UIView!
	var deniedApplicantIcon:UIImageView!
	var deniedApplicantsLabel:UILabel!
	
	var titleTextField: UITextField!
	var descriptionTextView: UITextView!
	var deleteTaskButton: UIButton!
	var pictures = [PFFile]()
	var images = [UIImage]()
	var imagePicker = UIImagePickerController()
	var fakeView: UIView!
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
	
	var locationManager = CLLocationManager()

	let firstSwipeRecLeft = UISwipeGestureRecognizer()
	let secondSwipeRecLeft = UISwipeGestureRecognizer()
	let secondSwipeRecRight = UISwipeGestureRecognizer()
	let thirdSwipeRecRight = UISwipeGestureRecognizer()
	
	var mapContainer: UIView!
	var mapView: MKMapView!
	
	var noPendingContainer: UIView!
	var pagingContainer: UIView!
	
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
		
		self.createView()
		
		self.adjustUI()
	}
	
	override func viewDidAppear(animated: Bool) {
		
		setMapUI()
	}
	
	convenience init(findNelpTask:FindNelpTask) {
		self.init(nibName: "MyTaskDetailsViewController", bundle: nil)
		self.task = findNelpTask
		let arrayOfApplications = findNelpTask.applications
		self.arrayOfApplications = arrayOfApplications
		var arrayOfApplicants = [User]()
		var arrayOfAllApplicants = [User]()
		var arrayOfDeniedApplicants = [User]()
		for application in arrayOfApplications {
			if application.state == .Pending {
				arrayOfApplicants.append(application.user)
				arrayOfAllApplicants.append(application.user)
			} else if application.state == .Denied {
				arrayOfDeniedApplicants.append(application.user)
				arrayOfAllApplicants.append(application.user)
			}
		}
		self.arrayOfApplicants = arrayOfApplicants
		self.arrayOfDeniedApplicants = arrayOfDeniedApplicants
		self.arrayOfAllApplicants = arrayOfAllApplicants
	}
	
	//MARK: View Creation
	
	func createView() {
		
		let containerHeight = 270
		
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
			make.height.greaterThanOrEqualTo(self.container.snp_height)
			make.width.equalTo(self.container.snp_width)
		}
		
		//FIRST CONTAINER
		let firstContainer = UIView()
		self.firstContainer = firstContainer
		self.contentView.addSubview(firstContainer)
		self.firstContainer.backgroundColor = whitePrimary
		self.firstContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(20)
			make.left.equalTo(contentView.snp_left)
			make.width.equalTo(self.contentView.snp_width)
			make.height.equalTo(containerHeight)
		}
		self.firstContainer.addGestureRecognizer(self.firstSwipeRecLeft)
		
		let categoryIcon = UIImageView()
		firstContainer.addSubview(categoryIcon)
		let iconSize:CGFloat = 60
		categoryIcon.layer.cornerRadius = iconSize / 2
		categoryIcon.contentMode = UIViewContentMode.ScaleAspectFill
		categoryIcon.image = UIImage(named: self.task.category!)
		categoryIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(firstContainer.snp_top).offset(16)
			make.centerX.equalTo(firstContainer.snp_centerX)
			make.width.equalTo(iconSize)
			make.height.equalTo(iconSize)
		}
		
		let titleTextField = UITextField()
		self.titleTextField = titleTextField
		firstContainer.addSubview(titleTextField)
		titleTextField.text = self.task.title
		titleTextField.font = UIFont(name: "Lato-Regular", size: kTitle17)
		titleTextField.textColor = textFieldTextColor
		titleTextField.textAlignment = NSTextAlignment.Center
		//titleTextField.layer.borderWidth = 1
		//titleTextField.layer.borderColor = grayDetails.CGColor
		titleTextField.backgroundColor = UIColor.clearColor()
		titleTextField.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(categoryIcon.snp_bottom).offset(20)
			make.left.equalTo(firstContainer.snp_left).offset(12)
			make.right.equalTo(firstContainer.snp_right).offset(-12)
			make.height.equalTo(40)
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
		
		let descriptionTextView = UITextView()
		self.descriptionTextView = descriptionTextView
		firstContainer.addSubview(descriptionTextView)
		descriptionTextView.text = self.task.desc
		descriptionTextView.font = UIFont(name: "Lato-Regular", size: kText15)
		descriptionTextView.textColor = textFieldTextColor
		descriptionTextView.textAlignment = NSTextAlignment.Center
		//descriptionTextView.layer.borderWidth = 1
		//descriptionTextView.layer.borderColor = grayDetails.CGColor
		descriptionTextView.backgroundColor = UIColor.clearColor()
		descriptionTextView.scrollEnabled = false
		descriptionTextView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(titleUnderline.snp_bottom).offset(20)
			make.width.equalTo(titleTextField.snp_width)
			make.centerX.equalTo(firstContainer.snp_centerX)
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
		
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
		self.locationManager.distanceFilter = 40
		
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
			make.centerY.equalTo(thirdContainer.snp_centerY).offset(-8)
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
		
		let picturesButton = PrimaryActionButton()
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
			make.height.equalTo(50)
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
		
		/*//Save button
		
		let saveChangesButton = UIButton()
		self.saveChangesButton = saveChangesButton
		contentView.addSubview(saveChangesButton)
		saveChangesButton.setTitle("Save", forState: UIControlState.Normal)
		saveChangesButton.setTitleColor(grayBlue, forState: UIControlState.Normal)
		saveChangesButton.addTarget(self, action: "didTapSaveButton:", forControlEvents: UIControlEvents.TouchUpInside)
		saveChangesButton.layer.borderWidth = 1
		saveChangesButton.layer.borderColor = grayBlue.CGColor
		saveChangesButton.backgroundColor = whitePrimary
		saveChangesButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(firstContainer.snp_bottom).offset(10)
			make.centerX.equalTo(firstContainer.snp_centerX)
			make.height.equalTo(45)
			make.width.equalTo(200)
		}*/
		
		
		//Active Applicants
		
		self.makeActiveApplicantsContainer(false)
		
		//Denied Applicants
		
		self.makeDeniedApplicantsContainer()
		
		let fakeView = UIView()
		self.fakeView = fakeView
		self.contentView.addSubview(fakeView)
		fakeView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.deniedApplicantsContainer.snp_bottom)
			make.bottom.equalTo(self.contentView.snp_bottom)
		}
	}
	
	//MARK: Refresh Tableview
	func refreshTableView(){
		self.applicantsTableView.reloadData()
		self.deniedApplicantsTableView.reloadData()
		self.updateFrames()
	}
	
	func getPictures(imageURL: String, block: (UIImage) -> Void) -> Void {
		var image: UIImage!
		request(.GET,imageURL).response(){
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
	
	func adjustUI(){
		self.container.backgroundColor = whiteBackground
		
		self.scrollView.backgroundColor = whiteBackground
	}
	
	func setMapUI() {
		
		self.mapView.alpha = 0.7
		
		let blurContainer = FXBlurView(frame: self.mapView.bounds)
		blurContainer.tintColor = UIColor.clearColor()
		blurContainer.updateInterval = 100
		blurContainer.iterations = 1
		blurContainer.blurRadius = 3
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
			for subview in self.activeApplicantsContainer.subviews {
				subview.removeFromSuperview()
			}
		}
		
		let activeApplicantsContainer = UIView()
		self.activeApplicantsContainer = activeApplicantsContainer
		self.contentView.addSubview(activeApplicantsContainer)
		activeApplicantsContainer.backgroundColor = whitePrimary
		activeApplicantsContainer.layer.borderWidth = 1
		activeApplicantsContainer.layer.borderColor = grayDetails.CGColor
		activeApplicantsContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(pagingContainer.snp_bottom).offset(20)
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo((self.arrayOfApplicants.count*100)+65)
		}
		
		let pendingApplicantIcon = UIImageView()
		activeApplicantsContainer.addSubview(pendingApplicantIcon)
		pendingApplicantIcon.image = UIImage(named: "pending.png")
		pendingApplicantIcon.contentMode = UIViewContentMode.ScaleAspectFill
		pendingApplicantIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(activeApplicantsContainer.snp_top).offset(20)
			make.left.equalTo(activeApplicantsContainer.snp_left).offset(20)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let applicantsLabel = UILabel()
		activeApplicantsContainer.addSubview(applicantsLabel)
		applicantsLabel.textAlignment = NSTextAlignment.Left
		applicantsLabel.text = "Nelpers"
		applicantsLabel.textColor = blackPrimary
		applicantsLabel.font = UIFont(name: "Lato-Regular", size: kNavTitle18)
		applicantsLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(pendingApplicantIcon.snp_centerY)
			make.left.equalTo(pendingApplicantIcon.snp_right).offset(12)
		}
		
		if arrayOfApplicants.isEmpty {
			let noPendingContainer = UIView()
			self.noPendingContainer = noPendingContainer
			self.activeApplicantsContainer.addSubview(noPendingContainer)
			noPendingContainer.layer.borderColor = grayDetails.CGColor
			noPendingContainer.backgroundColor = whitePrimary
			noPendingContainer.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(activeApplicantsContainer.snp_bottom)
				make.left.equalTo(self.contentView.snp_left)
				make.right.equalTo(self.contentView.snp_right)
				make.height.equalTo(65)
			}
			
			let noPendingBottomLine = UIView()
			noPendingBottomLine.backgroundColor = grayDetails
			activeApplicantsContainer.addSubview(noPendingBottomLine)
			noPendingBottomLine.snp_makeConstraints { (make) -> Void in
				make.bottom.equalTo(noPendingContainer.snp_bottom)
				make.centerX.equalTo(activeApplicantsContainer.snp_centerX)
				make.height.equalTo(1)
				make.width.equalTo(noPendingContainer.snp_width)
			}
			
			let noPendingLabel = UILabel()
			noPendingContainer.addSubview(noPendingLabel)
			noPendingLabel.text = "No pending applications"
			noPendingLabel.textColor = darkGrayDetails
			noPendingLabel.font = UIFont(name: "Lato-Regular", size: kText15)
			noPendingLabel.snp_makeConstraints { (make) -> Void in
				make.centerX.equalTo(noPendingContainer.snp_centerX)
				make.top.equalTo(noPendingContainer.snp_top).offset(20)
			}
		} else {
			let pendingBottomLine = UIView()
			pendingBottomLine.backgroundColor = grayDetails
			activeApplicantsContainer.addSubview(pendingBottomLine)
			pendingBottomLine.snp_makeConstraints { (make) -> Void in
				make.bottom.equalTo(activeApplicantsContainer.snp_top).offset(65)
				make.centerX.equalTo(activeApplicantsContainer.snp_centerX)
				make.height.equalTo(1)
				make.width.equalTo(activeApplicantsContainer.snp_width)
			}
		}
		
		//Applicants Table View
		
		let applicantsTableView = UITableView()
		self.applicantsTableView = applicantsTableView
		self.applicantsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		applicantsTableView.registerClass(ApplicantCell.classForCoder(), forCellReuseIdentifier: ApplicantCell.reuseIdentifier)
		self.applicantsTableView.scrollEnabled = false
		self.applicantsTableView.dataSource = self
		self.applicantsTableView.delegate = self
		activeApplicantsContainer.addSubview(applicantsTableView)
		applicantsTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(applicantsLabel.snp_bottom).offset(20)
			make.left.equalTo(activeApplicantsContainer.snp_left)
			make.right.equalTo(activeApplicantsContainer.snp_right)
			make.bottom.equalTo(activeApplicantsContainer.snp_bottom)
		}
		
	}
	
	/**
	Make the Denied Applicants Container if needed.
	*/
	func makeDeniedApplicantsContainer() {
		
		let deniedApplicantsContainer = UIView()
		self.deniedApplicantsContainer = deniedApplicantsContainer
		self.contentView.addSubview(deniedApplicantsContainer)
		deniedApplicantsContainer.backgroundColor = whitePrimary
		deniedApplicantsContainer.layer.borderWidth = 1
		deniedApplicantsContainer.layer.borderColor = grayDetails.CGColor
		deniedApplicantsContainer.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.contentView.snp_left)
			make.right.equalTo(self.contentView.snp_right)
			make.height.equalTo((self.arrayOfDeniedApplicants.count*100)+65)
		}
		
		if self.arrayOfApplicants.isEmpty {
			deniedApplicantsContainer.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.noPendingContainer.snp_bottom).offset(20)
			}
		} else {
			deniedApplicantsContainer.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(self.activeApplicantsContainer.snp_bottom).offset(20)
			}
		}
		
		let deniedApplicantIcon = UIImageView()
		self.deniedApplicantIcon = deniedApplicantIcon
		deniedApplicantsContainer.addSubview(deniedApplicantIcon)
		deniedApplicantIcon.image = UIImage(named: "denied.png")
		deniedApplicantIcon.contentMode = UIViewContentMode.ScaleAspectFill
		deniedApplicantIcon.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(deniedApplicantsContainer.snp_top).offset(20)
			make.left.equalTo(deniedApplicantsContainer.snp_left).offset(20)
			make.height.equalTo(30)
			make.width.equalTo(30)
		}
		
		let deniedApplicantsLabel = UILabel()
		self.deniedApplicantsLabel = deniedApplicantsLabel
		deniedApplicantsContainer.addSubview(deniedApplicantsLabel)
		deniedApplicantsLabel.textAlignment = NSTextAlignment.Left
		deniedApplicantsLabel.text = "Declined Nelpers"
		deniedApplicantsLabel.textColor = blackPrimary
		deniedApplicantsLabel.font = UIFont(name: "Lato-Regular", size: kNavTitle18)
		deniedApplicantsLabel.snp_makeConstraints { (make) -> Void in
			make.centerY.equalTo(deniedApplicantIcon.snp_centerY)
			make.left.equalTo(deniedApplicantIcon.snp_right).offset(12)
		}
		
		//Applicants Table View
		
		let deniedApplicantsTableView = UITableView()
		self.deniedApplicantsTableView = deniedApplicantsTableView
		self.deniedApplicantsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
		deniedApplicantsTableView.registerClass(ApplicantCell.classForCoder(), forCellReuseIdentifier: ApplicantCell.reuseIdentifier)
		self.deniedApplicantsTableView.scrollEnabled = false
		self.deniedApplicantsTableView.dataSource = self
		self.deniedApplicantsTableView.delegate = self
		deniedApplicantsContainer.addSubview(deniedApplicantsTableView)
		deniedApplicantsTableView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(deniedApplicantsLabel.snp_bottom).offset(20)
			make.left.equalTo(deniedApplicantsContainer.snp_left)
			make.right.equalTo(deniedApplicantsContainer.snp_right)
			make.bottom.equalTo(deniedApplicantsContainer.snp_bottom)
		}
		
		let deniedBottomLine = UIView()
		deniedBottomLine.backgroundColor = grayDetails
		deniedApplicantsContainer.addSubview(deniedBottomLine)
		deniedBottomLine.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(deniedApplicantsTableView.snp_top)
			make.centerX.equalTo(deniedApplicantsContainer.snp_centerX)
			make.height.equalTo(1)
			make.width.equalTo(deniedApplicantsContainer.snp_width)
		}
		if self.fakeView != nil{
			self.fakeView.snp_remakeConstraints { (make) -> Void in
				make.top.equalTo(self.deniedApplicantsContainer.snp_bottom)
				make.bottom.equalTo(self.contentView.snp_bottom)
			}}
	}
	
	/**
	Set the category images
	
	- parameter task: the task
	*/
	func setImages(task:FindNelpTask){
		self.categoryIcon.layer.cornerRadius = self.categoryIcon.frame.size.width / 2;
		self.categoryIcon.clipsToBounds = true
		self.categoryIcon.image = UIImage(named: task.category!)
	}
	
	
	/**
	Redraws the tableviess
	*/
	func drawTableViewsSize(){
		self.activeApplicantsContainer.snp_updateConstraints { (make) -> Void in
			make.height.equalTo((self.arrayOfApplicants.count * 100)+70)
		}
		self.deniedApplicantsContainer.snp_updateConstraints { (make) -> Void in
			make.height.equalTo((self.arrayOfDeniedApplicants.count * 100)+70)
		}
		
		let numbersToMultiplyBy = self.arrayOfApplicants.count + self.arrayOfDeniedApplicants.count
		let numbersToAdd:CGFloat = CGFloat(numbersToMultiplyBy * 100)
		self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height + numbersToAdd)
		self.contentView.snp_updateConstraints { (make) -> Void in
			make.height.equalTo(self.scrollView.contentSize.height)
		}
	}
	
	/**
	Update the frame sizes
	*/
	func updateFrames() {
		
		//TODO: MAKE ANIMATION AND SET SCROLLVIEW.CONTENT SIZE UPPON COMPLETION
		
		//UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
			self.activeApplicantsContainer.layoutIfNeeded()
			self.deniedApplicantsContainer.layoutIfNeeded()
			//}, completion: nil)
		
		self.scrollView.contentSize = self.contentView.frame.size
	}
	
	//MARK: CLLocation Delegate Methods
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		
	}
	
	//MARK: Tableview Delegate and Datasource
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == self.applicantsTableView {
			return self.arrayOfApplicants.count
		} else if tableView == self.deniedApplicantsTableView {
			return self.arrayOfDeniedApplicants.count
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if tableView == applicantsTableView {
			
			let pendingApplicantCell = tableView.dequeueReusableCellWithIdentifier(ApplicantCell.reuseIdentifier, forIndexPath: indexPath) as! ApplicantCell
			let application = self.arrayOfApplicants[indexPath.row]
			pendingApplicantCell.setApplicant(application)
			let applicant = self.arrayOfApplications[indexPath.row]
			pendingApplicantCell.setApplication(applicant)
			return pendingApplicantCell
			
		} else if tableView == deniedApplicantsTableView {
			
			let deniedApplicantCell = tableView.dequeueReusableCellWithIdentifier(ApplicantCell.reuseIdentifier, forIndexPath: indexPath) as! ApplicantCell
			let deniedApplicant = self.arrayOfDeniedApplicants[indexPath.row]
			deniedApplicantCell.setApplicant(deniedApplicant)
			for application in self.arrayOfApplications{
				if application.user.objectId == deniedApplicant.objectId{
					deniedApplicantCell.setApplication(application)
				}
			}
			deniedApplicantCell.replaceArrowImage()
			deniedApplicantCell.delegate = self
			
			return deniedApplicantCell
			
		}
		
		return UITableViewCell()
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if tableView == self.applicantsTableView {
			let applicant = self.arrayOfAllApplicants[indexPath.row]
			let application = self.arrayOfApplications[indexPath.row]
			let nextVC = ApplicantProfileViewController(applicant: applicant, application: application)
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
		
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	//MARK: View delegate Methods
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		if self.arrayOfDeniedApplicants.isEmpty{
			self.deniedApplicantsContainer.removeFromSuperview()
			self.fakeView.snp_remakeConstraints(closure: { (make) -> Void in
				make.top.equalTo(self.activeApplicantsContainer.snp_bottom)
				make.bottom.equalTo(self.contentView.snp_bottom)
			})
		}
		let contentsize = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)
		self.scrollView.contentSize = contentsize.size
		
	}
	
	//MARK: UIGesture Recognizer
	
	func dismissKeyboard(){
		view.endEditing(true)
	}
	
	
	//MARK: Cell delegate methods
	
	func didTapRevertButton(applicant:User) {
		var applicationToRevert: TaskApplication!
		
		for application in self.arrayOfApplications {
			print(application.user.objectId)
			print(applicant.objectId)
			if application.user.objectId == applicant.objectId{
				applicationToRevert = application
				for (var i = 0 ; i < self.arrayOfDeniedApplicants.count ; i++) {
					let applicantToChange = self.arrayOfDeniedApplicants[i]
					if applicantToChange.objectId == applicant.objectId {
						self.arrayOfDeniedApplicants.removeAtIndex(i)
						self.arrayOfApplicants.append(applicantToChange)
					}
				}
			}
		}
		
		applicationToRevert.state = .Pending
		let query = PFQuery(className: "TaskApplication")
		query.getObjectInBackgroundWithId(applicationToRevert.objectId, block: { (application, error) -> Void in
			if error != nil{
				print(error)
			} else if let application = application{
				application["state"] = applicationToRevert.state.rawValue
				application.saveInBackground()
			}
		})
		
		self.makeActiveApplicantsContainer(true)
		self.refreshTableView()
		if self.arrayOfDeniedApplicants.isEmpty{
			self.fakeView.snp_remakeConstraints(closure: { (make) -> Void in
				make.top.equalTo(self.activeApplicantsContainer.snp_bottom)
				make.bottom.equalTo(self.contentView.snp_bottom)
			})
			self.deniedApplicantsContainer.removeFromSuperview()
		}
	}
	
	
	
	//MARK: Applications Profile View Controller Delegate
	
	func didTapDenyButton(applicant:User){
		var applicationToDeny:TaskApplication?
		self.makeDeniedApplicantsContainer()
		self.deniedApplicantsContainer.layoutIfNeeded()
		for application in self.arrayOfApplications{
			print(application.user.objectId)
			print(applicant.objectId)
			if application.user.objectId == applicant.objectId{
				applicationToDeny = application
				for (var i = 0 ; i < self.arrayOfApplicants.count ; i++) {
					let applicantToChange = self.arrayOfApplicants[i]
					if applicantToChange.objectId == applicant.objectId{
						self.arrayOfApplicants.removeAtIndex(i)
						self.arrayOfDeniedApplicants.append(applicantToChange)
					}
				}
			}
		}
		self.updateFrames()
		self.refreshTableView()
	}
	
	func dismissVC(){
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	//MARK: Edit Task Delegate
	
	func didEditTask(task: FindNelpTask) {
		self.task = task
		self.createView()
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
	
	/**
	Moves the view to the next horizontal container
	
	- parameter sender: condition left or right swipe for swipedSecondView
	*/
	func swipedFirstView(sender: UISwipeGestureRecognizer) {
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
	
	func editButtonTapped(sender: UIButton) {
		let nextVC = EditTaskViewController()
		nextVC.task = self.task
		nextVC.delegate = self
		dispatch_async(dispatch_get_main_queue()) {
			self.presentViewController(nextVC, animated: true, completion: nil)
		}
	}
	
	func backButtonTapped(sender: UIButton) {
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func didTapAddImage(sender:UIButton){
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .PhotoLibrary
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	func deleteTaskButtonTapped(sender: UIButton) {
	}
		
	func didTapSaveButton(sender:UIButton){
		self.task.title = self.titleTextField.text
		print(self.task.title, terminator: "")
		if !self.images.isEmpty{
			self.task.pictures = ApiHelper.convertImagesToData(self.images)
		}
		self.task.desc = self.descriptionTextView.text
		
		ApiHelper.editTask(self.task)
		self.didEditTask(self.task)
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func didTapDeleteButton(sender: UIButton) {
		if sender.selected == false {
			sender.selected = true
			
		}else if sender.selected == true{
			ApiHelper.deleteTask(self.task)
			self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
			self.dismissViewControllerAnimated(true, completion: nil)
		}
	}
	
}
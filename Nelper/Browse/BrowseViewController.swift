//
//  BrowseViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-21.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import Stripe
import Alamofire
import SVProgressHUD
import SDWebImage

class BrowseViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate, FilterSortViewControllerDelegate, MKMapViewDelegate {
	
	var navBar: NavBar!
	
	var backgroundView: UIView!
	var contentView: UIView!
	var mapContainer: UIView!
	var tableViewContainer: UIView!
	
	var tableView: UITableView!
	var refreshView: UIRefreshControl!
	var filtersButton:UIButton!
	
	var tasks = [Task]()
	var findNelpTasks = [Task]()
	
	var mapView: MKMapView!
	var currentLocation: CLLocation?
	var placesClient: GMSPlacesClient?
	let locationManager = CLLocationManager()
	var target: CLLocationCoordinate2D?
	
	var arrayOfFilters = [String]()
	var sortBy: String?
	var minPrice: Double?
	var maxDistance: Double?
	
	var tap: UITapGestureRecognizer!
	
	var mapExpanded: Bool = false
	var defaultMapHeight: CGFloat!
	var expandedMapHeight: CGFloat!
	var annotationIsSelected = false
	var mapInfoBlurView: UIVisualEffectView!
	var isFirstExpandExec: Bool = true
	
	var selectedCell: BrowseTaskViewCell?
	
	var tabBarViewController: TabBarViewController!
	var tabBarFakeView: UIImageView!
	
	var noTaskToShowLabel: UILabel!
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Print all fonts to test installation
		/*for family: String in UIFont.familyNames() {
			print("\(family)")
			for names: String in UIFont.fontNamesForFamilyName(family) {
				print("== \(names)")
			}
		}*/
		
		self.tabBarViewController = UIApplication.sharedApplication().delegate!.window!?.rootViewController as! TabBarViewController
		
		placesClient = GMSPlacesClient()
		
		self.createView()
		
		self.initializeMapview()
		self.createTaskTableView()
		self.loadData()
		self.extendedLayoutIncludesOpaqueBars = true
		
		//Checks for Localization Permission
		PermissionHelper.sharedInstance.checkLocationStatus()
	}
	
	override func viewWillAppear(animated: Bool) {
		self.tabBarViewController.tabBarWillHide(false)
	}
	
	override func viewDidAppear(animated: Bool) {
		if self.arrayOfFilters.isEmpty && self.sortBy == nil && self.minPrice == nil && self.maxDistance == nil {
			self.loadData()
		}
		
		SVProgressHUD.dismiss()
	}
	
	//MARK: Creating the View
	
	/**
	Creates the view
	*/
	
	func createView() {
		
		//NAV BAR
		
		let navBar = NavBar()
		self.navBar = navBar
		self.view.addSubview(self.navBar)
		
		/*let filtersBtn = UIButton()
		filtersBtn.addTarget(self, action: "didTapFiltersButton:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.filtersButton = filtersBtn
		self.navBar.setTitle("Browse Tasks")*/
		self.navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(Helper.statusBarHeight)
		}
		
		self.navBar.layoutIfNeeded()
		
		//CONTAINERS
		
		let backgroundView = UIView()
		self.backgroundView = backgroundView
		self.view.addSubview(backgroundView)
		backgroundView.backgroundColor = UIColor.clearColor()
		backgroundView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.navBar.snp_bottom)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.bottom.equalTo(self.view.snp_bottom)
		}
		
		let contentView = UIView()
		self.contentView = contentView
		backgroundView.addSubview(contentView)
		contentView.backgroundColor = Color.whiteBackground
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(backgroundView.snp_top)
			make.left.equalTo(backgroundView.snp_left)
			make.right.equalTo(backgroundView.snp_right)
			make.bottom.equalTo(backgroundView.snp_bottom)
		}
		
		self.defaultMapHeight = 257
		self.expandedMapHeight = self.view.frame.height + 2 - Helper.statusBarHeight - 49
		
		let mapContainer = UIView()
		self.mapContainer = mapContainer
		contentView.addSubview(mapContainer)
		mapContainer.backgroundColor = UIColor.clearColor()
		mapContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top)
			make.right.equalTo(contentView.snp_right)
			make.left.equalTo(contentView.snp_left)
			make.bottom.equalTo(contentView.snp_top).offset(defaultMapHeight)
		}
		
		let buttonSize: CGFloat = 50
		
		let mapButton = UIButton()
		mapButton.setBackgroundImage(UIImage(named: "buttonBackground"), forState: .Normal)
		mapButton.setImage(UIImage(named: "fullMap"), forState: .Normal)
		mapButton.setImage(UIImage(named: "list"), forState: .Selected)
		mapButton.contentMode = .ScaleAspectFill
		mapButton.addTarget(self, action: "mapButtonTapped:", forControlEvents: .TouchUpInside)
		mapButton.selected = false
		contentView.addSubview(mapButton)
		mapButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(10)
			make.left.equalTo(contentView.snp_left).offset(20)
			make.width.equalTo(buttonSize)
			make.height.equalTo(buttonSize)
		}
		
		let filtersButton = UIButton()
		filtersButton.setBackgroundImage(UIImage(named: "buttonBackground"), forState: .Normal)
		filtersButton.setImage(UIImage(named: "filters"), forState: .Normal)
		mapButton.contentMode = .ScaleAspectFit
		filtersButton.addTarget(self, action: "filtersButtonTapped:", forControlEvents: .TouchUpInside)
		contentView.addSubview(filtersButton)
		filtersButton.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top).offset(10)
			make.right.equalTo(contentView.snp_right).offset(-20)
			make.width.equalTo(buttonSize)
			make.height.equalTo(buttonSize)
		}
		
		let tableViewContainer = UIView()
		self.tableViewContainer = tableViewContainer
		contentView.addSubview(tableViewContainer)
		tableViewContainer.backgroundColor = Color.whitePrimary
		tableViewContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(mapContainer.snp_bottom).offset(2)
			make.right.equalTo(contentView.snp_right)
			make.left.equalTo(contentView.snp_left)
			make.bottom.equalTo(contentView.snp_bottom).offset(-49)
		}
		
		let noTaskToShowLabel = UILabel()
		self.noTaskToShowLabel = noTaskToShowLabel
		tableViewContainer.addSubview(noTaskToShowLabel)
		noTaskToShowLabel.font = UIFont(name: "Lato-Regular", size: kTitle17)
		noTaskToShowLabel.textColor = Color.darkGrayDetails
		noTaskToShowLabel.text = "No task found"
		noTaskToShowLabel.textAlignment = .Center
		noTaskToShowLabel.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.tableViewContainer.snp_top).offset(60)
			make.centerX.equalTo(self.tableViewContainer.snp_centerX)
		}
		noTaskToShowLabel.layer.zPosition = 5
		noTaskToShowLabel.userInteractionEnabled = false
		noTaskToShowLabel.hidden = true
		noTaskToShowLabel.alpha = 0
		noTaskToShowLabel.transform = CGAffineTransformMakeTranslation(0, 30)
		
		let tabBarFakeView = UIImageView()
		self.tabBarFakeView = tabBarFakeView
		self.view.addSubview(tabBarFakeView)
		tabBarFakeView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.view.snp_left)
			make.right.equalTo(self.view.snp_right)
			make.bottom.equalTo(self.view.snp_bottom)
			make.height.equalTo(49)
		}
	}
	
	/**
	Creates task tableView
	*/
	func createTaskTableView() {
		
		let tableView = UITableView()
		self.tableView = tableView
		self.tableView.delegate = self
		self.tableView.dataSource = self
		tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
		tableView.registerClass(BrowseTaskViewCell.classForCoder(), forCellReuseIdentifier: BrowseTaskViewCell.reuseIdentifier)
		self.tableView.backgroundColor = UIColor.clearColor()
		self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
		
		self.tableViewContainer.addSubview(tableView)
		
		let refreshView = UIRefreshControl()
		refreshView.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
		tableView.addSubview(refreshView)
		
		tableView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.tableViewContainer.snp_edges)
		}
		
		tableView.transform = CGAffineTransformMakeTranslation(0, 30)
		tableView.alpha = 0
		
		self.refreshView = refreshView
	}
	
	/**
	Creates and sets the MapView
	
	- returns: void
	*/
	
	func initializeMapview() {
		
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.requestWhenInUseAuthorization()
		
		self.locationManager.distanceFilter = 40
		
		let mapView = MKMapView()
		self.mapView = mapView
		self.mapView.showsPointsOfInterest = false
		self.mapContainer.addSubview(mapView)
		self.mapView.showsUserLocation = true
		self.mapView.rotateEnabled = false
		
		if ((self.locationManager.location) != nil) {
			let userLocation: CLLocation = self.locationManager.location!
			self.currentLocation = userLocation
			LocationHelper.sharedInstance.currentLocation = PFGeoPoint(latitude:userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude)
			
			LocationHelper.sharedInstance.currentCLLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
			
			let userLocationForCenter = userLocation.coordinate
			let span: MKCoordinateSpan = MKCoordinateSpanMake(0.015 , 0.015)
			let locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(userLocationForCenter, span)
			self.mapView.setRegion(locationToZoom, animated: true)
			self.mapView.setCenterCoordinate(userLocationForCenter, animated: true)
		}
		
		self.mapView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.mapContainer.snp_edges)
		}
		
		/*let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "mapTapped:")
		self.tap = tap
		self.tap.delegate = self
		self.tap.numberOfTapsRequired = 1
		self.mapView.addGestureRecognizer(tap)*/
		
	}
	
	//MARK: UI
	
	func createPins() {
		self.mapView.delegate = self
		
		for task in self.tasks {
			
			if (task.location != nil) {
				let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(task.location!.latitude, task.location!.longitude)
				
				//TODO: FIX PROFILE PIC
				var pinImage: UIImage?
				if (task.user.profilePictureURL != nil) {
					let fbProfilePicture = task.user.profilePictureURL
					request(.GET,fbProfilePicture!).response(){
						(_, _, data, _) in
						let image = UIImage(data: data as NSData!)
						pinImage = image
					}
				}
				
				let image = UIImage(named: "noProfilePicture")
				pinImage = image
				
				let taskPin: BrowseMKAnnotation = BrowseMKAnnotation(coordinate: location, task: task, image: pinImage!, title: task.title, category: task.category!, price: task.priceOffered!, poster: task.user.name, date: task.createdAt, tag: 0)
				self.mapView.addAnnotation(taskPin)
			}
		}
	}
	
	//MARK: MapView Delegate
	
	/**
	Replace the default pin with custom
	
	- parameter mapView:    mapView
	- parameter annotation: annotation
	
	- returns: pinView
	*/
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		
		if annotation is MKUserLocation {
			return nil
		} else if annotation is BrowseMKAnnotation {
			
			let reuseId = "taskPin"
			var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
			
			if pinView == nil {
				
				pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
				let customPinAnnotation = pinView!.annotation as? BrowseMKAnnotation
				
				pinView!.canShowCallout = false
				
				//print("\(customPinAnnotation!.title!) of category \(customPinAnnotation!.category!) created")
				let pinCategory = customPinAnnotation!.category
				pinView!.image = UIImage(named: "\(pinCategory!)-pin")
				pinView!.layer.zPosition = -1
				pinView!.centerOffset = CGPointMake(0, -25)
				
			} else {
				pinView!.annotation = annotation
			}
			
			return pinView
		}
		return nil
	}
	
	func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
		//Might cause perfomance issue, TBD
		for view in views {
			if view.annotation is BrowseMKAnnotation {
				let customPinAnnotation = view.annotation as? BrowseMKAnnotation
				let pinCategory = customPinAnnotation!.category
				view.image = UIImage(named: "\(pinCategory!)-pin")
			}
		}
	}
	
	func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
		
		if view.isKindOfClass(MKAnnotationView) && !(view.annotation!.isKindOfClass(MKUserLocation)) {
			self.annotationIsSelected = true
			view.layer.zPosition = 0
			
			let pinViewAnnotation = view.annotation as? BrowseMKAnnotation
			let pinCategory = pinViewAnnotation!.category
			
			if pinViewAnnotation!.tag == 1 {
				return
			}
			pinViewAnnotation!.tag = 1
			
			view.image = UIImage(named: "\(pinCategory!)-pin-sel")
			
			let center = view.annotation!.coordinate
			
			/*if self.mapExpanded {
				center.latitude -= mapView.region.span.latitudeDelta * 0.10
			}
			mapView.setCenterCoordinate(center, animated: true)*/
			
			let zoomSpan = MKCoordinateSpanMake(0.014, 0.014)
			let zoomedRegion = MKCoordinateRegionMake(center, zoomSpan)
			let currentSpan = mapView.region.span
			
			if mapView.region.span.longitudeDelta > zoomSpan.longitudeDelta {
				mapView.setRegion(zoomedRegion, animated: true)
			} else {
				mapView.setRegion(MKCoordinateRegionMake(center, currentSpan), animated: true)
			}
			
			if !(self.mapExpanded) {
				
				/*let cells = NSMutableArray()
				for var j = 0; j < self.tableView.numberOfSections; ++j {
					for var i = 0; i < self.tableView.numberOfRowsInSection(j); ++i {
						cells.addObject(self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: j))!)
					}
				}*/
				
				for view in self.tableView.subviews {
					for tableViewCell in view.subviews {
						if tableViewCell is BrowseTaskViewCell {
							let selectedCell = tableViewCell as? BrowseTaskViewCell
							
							if selectedCell!.task.objectId == pinViewAnnotation!.task.objectId {
								let index = selectedCell!.cellIndexPath
								selectedCell!.cellSelected()
								self.selectedCell = selectedCell
								self.tableView.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
								
							}
						}
					}
				}
			}
			
			setAnnotationInfo(view)
		}
	}
	
	func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
		if view.isKindOfClass(MKAnnotationView) && !(view.annotation!.isKindOfClass(MKUserLocation)) {
			self.annotationIsSelected = false
			view.layer.zPosition = -1
			
			let pinViewAnnotation = view.annotation as? BrowseMKAnnotation
			let pinCategory = pinViewAnnotation!.category
			
			pinViewAnnotation!.tag = 0
			
			view.image = UIImage(named: "\(pinCategory!)-pin")
			
			if self.mapExpanded {
				removeAnnotationInfo(view)
			} else {
				self.selectedCell?.cellDeselected()
			}
		}
	}
	
	func setAnnotationInfo(view: MKAnnotationView) {
		
		let pinViewAnnotation = view.annotation as? BrowseMKAnnotation
		
		if self.mapExpanded {
			
			let blurEffect = UIBlurEffect(style: .ExtraLight)
			let mapInfoBlurView = UIVisualEffectView(effect: blurEffect)
			self.mapInfoBlurView = mapInfoBlurView
			self.mapView.addSubview(mapInfoBlurView)
			mapInfoBlurView.backgroundColor = Color.whitePrimary.colorWithAlphaComponent(0)
			mapInfoBlurView.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(self.mapView.snp_left).offset(10)
				make.bottom.equalTo(self.mapView.snp_bottom).offset(200)
				make.right.equalTo(self.mapView.snp_right).offset(-10)
			}
			
			mapInfoBlurView.layoutIfNeeded()
			
			let infoButton = mapTaskButton()
			infoButton.layer.borderColor = Color.grayDetails.CGColor
			infoButton.layer.borderWidth = 1
			infoButton.setBackgroundColor(Color.grayDetails.colorWithAlphaComponent(0.4), forState: UIControlState.Highlighted)
			infoButton.addTarget(self, action: "infoButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
			infoButton.selectedTask = pinViewAnnotation!.task
			mapInfoBlurView.addSubview(infoButton)
			infoButton.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(mapInfoBlurView.snp_edges)
			}
			infoButton.layoutIfNeeded()
			
			let pictureSize: CGFloat = 70
			let userPicture = UIImageView()
			userPicture.image = pinViewAnnotation!.image
			userPicture.layer.cornerRadius = pictureSize / 2
			userPicture.layer.masksToBounds = true
			userPicture.clipsToBounds = true
			userPicture.contentMode = UIViewContentMode.ScaleAspectFill
			infoButton.addSubview(userPicture)
			userPicture.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(infoButton.snp_left).offset(10)
				make.centerY.equalTo(infoButton.snp_centerY)
				make.width.equalTo(pictureSize)
				make.height.equalTo(pictureSize)
			}
			
			let taskCategoryImage = UIImageView()
			taskCategoryImage.layer.cornerRadius = taskCategoryImage.frame.size.width / 2
			taskCategoryImage.clipsToBounds = true
			taskCategoryImage.image = UIImage(named: pinViewAnnotation!.category!)
			infoButton.addSubview(taskCategoryImage)
			taskCategoryImage.snp_makeConstraints { (make) -> Void in
				make.bottom.equalTo(userPicture.snp_bottom)
				make.left.equalTo(userPicture.snp_right).offset(-25)
				make.width.equalTo(30)
				make.height.equalTo(30)
			}
			
			let taskTitleLabel = UILabel()
			infoButton.addSubview(taskTitleLabel)
			taskTitleLabel.textAlignment = NSTextAlignment.Left
			taskTitleLabel.numberOfLines = 1
			taskTitleLabel.text = pinViewAnnotation?.title
			taskTitleLabel.textColor = Color.blackPrimary
			taskTitleLabel.font = UIFont(name: "Lato-Regular", size: kText15)
			taskTitleLabel.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(userPicture.snp_top).offset(2)
				make.left.equalTo(userPicture.snp_right).offset(18)
				make.right.equalTo(infoButton.snp_right).offset(-10)
			}
			
			let author = UILabel()
			infoButton.addSubview(author)
			author.font = UIFont(name: "Lato-Light", size: kText13)
			author.textColor = Color.blackTextColor
			author.text = pinViewAnnotation!.poster

			let dateHelper = DateHelper()
			
			let creationDate = UILabel()
			creationDate.adjustsFontSizeToFitWidth = true
			infoButton.addSubview(creationDate)
			creationDate.text = "Posted \(dateHelper.timeAgoSinceDate(pinViewAnnotation!.date!, numericDates: true))"
			creationDate.font = UIFont(name: "Lato-Light", size: kText13)
			creationDate.textColor = Color.blackTextColor
			
			let moneyContainer = UIView()
			infoButton.addSubview(moneyContainer)
			moneyContainer.backgroundColor = Color.whiteBackground
			moneyContainer.layer.cornerRadius = 3
			moneyContainer.snp_makeConstraints { (make) -> Void in
				make.right.equalTo(mapInfoBlurView.snp_right).offset(-20)
				make.centerY.equalTo(userPicture.snp_centerY).offset(pictureSize / 5)
				make.width.equalTo(55)
				make.height.equalTo(35)
			}
			
			creationDate.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(author.snp_bottom).offset(4)
				make.left.equalTo(author.snp_left)
				make.right.equalTo(moneyContainer.snp_left).offset(6)
			}
			
			author.snp_makeConstraints { (make) -> Void in
				make.top.equalTo(taskTitleLabel.snp_bottom).offset(8)
				make.left.equalTo(taskTitleLabel)
				make.right.equalTo(moneyContainer.snp_left).offset(6)
			}
			
			let price = String(format: "%.0f", pinViewAnnotation!.price!)
			
			let moneyLabel = UILabel()
			moneyContainer.addSubview(moneyLabel)
			moneyLabel.textAlignment = NSTextAlignment.Center
			moneyLabel.textColor = Color.blackPrimary
			moneyLabel.text = price+"$"
			moneyLabel.font = UIFont(name: "Lato-Regular", size: kText15)
			moneyLabel.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(moneyContainer.snp_edges)
			}
			
			let appliedNotice = UILabel()
			infoButton.addSubview(appliedNotice)
			appliedNotice.text = "Applied"
			appliedNotice.font = UIFont(name: "Lato-Regular", size: kText15)
			appliedNotice.textColor = Color.redPrimary
			appliedNotice.snp_makeConstraints { (make) -> Void in
				make.centerX.equalTo(moneyContainer.snp_centerX)
				make.centerY.equalTo(taskTitleLabel.snp_centerY)
			}
			
			let task = pinViewAnnotation!.task
			
			if task.application != nil && task.application!.state != .Canceled {
				appliedNotice.hidden = false
				taskTitleLabel.snp_remakeConstraints(closure: { (make) -> Void in
					make.top.equalTo(userPicture.snp_top).offset(2)
					make.left.equalTo(userPicture.snp_right).offset(18)
					make.right.equalTo(appliedNotice.snp_left).offset(-10)
				})
			} else {
				appliedNotice.hidden = true
			}
			
			mapInfoBlurView.snp_makeConstraints { (make) -> Void in
				make.height.equalTo(95)
			}
			mapInfoBlurView.layoutIfNeeded()
			
			//Animate In
			
			mapInfoBlurView.snp_updateConstraints { (make) -> Void in
				make.bottom.equalTo(self.mapView.snp_bottom).offset(-40)
			}
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
				mapInfoBlurView.layoutIfNeeded()
				}, completion: nil)
			
		} else {
			//TODO NOT EXPANDED MAP, TASK INFO
		}
	}
	
	func removeAnnotationInfo(view: MKAnnotationView) {
		if self.mapInfoBlurView != nil {
			
			if self.mapExpanded {
				
				let reuseableView = self.mapInfoBlurView
				
				UIView.animateWithDuration(0.4, delay: 0.0, options: [.CurveEaseOut], animations: {
					reuseableView.transform = CGAffineTransformMakeTranslation(0, self.mapInfoBlurView.frame.height * 1.5)
					reuseableView.alpha = 0
					}, completion: { (finished: Bool) in
						reuseableView.removeFromSuperview()
				})
			} else {
				//TODO NOT EXPANDED MAP, TASK INFO
			}
		}
	}
	
	//MARK: Filters
	
	func checkFilters() {
		if self.arrayOfFilters.isEmpty {
			//filters off
		} else {
			//filters on
		}
	}
	
	//MARK: DATA
	
	/**
	Reload Data on pullToRefresh
	*/
	
	func onPullToRefresh() {
		if self.arrayOfFilters.isEmpty && self.sortBy == nil {
			self.loadData()
		} else {
			self.loadDataWithFilters(self.arrayOfFilters, sort: self.sortBy)
		}
	}
	
	/**
	Fetches the required date from Backend
	*/
	func loadData() {
		var distance: String?
		
		if CLLocationManager.locationServicesEnabled() {
			switch (CLLocationManager.authorizationStatus()) {
			case .NotDetermined, .Restricted, .Denied:
				distance = nil
			case .AuthorizedAlways, .AuthorizedWhenInUse:
				distance = "distance"
			}
		} else {
			distance = nil
		}
		
		ApiHelper.listNelpTasksWithBlock(nil, sortBy: distance, block: {(tasks: [Task]?, error: NSError?) -> Void in
			if error != nil {
				
			} else {
				self.tasks = tasks!
				self.createPins()
				self.refreshView?.endRefreshing()
				self.tableView?.reloadData()
				self.sortBy = "distance"
			}
		})
	}
	
	/**
	Loads Data matching the applied filters
	
	- parameter filters:     The Applied Filters
	- parameter sort:        The Sorting method
	- parameter minPrice:    Minimum Price Filter Value
	- parameter maxDistance: Maximum Distance Filter Value
	*/
	
	func loadDataWithFilters(filters:Array<String>?, sort:String?) {
		ApiHelper.listNelpTasksWithBlock(filters, sortBy: sort, block: {(tasks: [Task]?, error: NSError?) -> Void in
			if error != nil {
				print(error)
			} else {
				self.tasks = tasks!
				self.createPins()
				self.refreshView?.endRefreshing()
				self.tableView?.reloadData()
			}
		})
	}
	
	//MARK: Table View Data Source and Delegate
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = self.tasks.count
		
		if count == 0 {
			self.noTaskToShowLabel.hidden = false
			
			UIView.animateWithDuration(0.3, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				self.noTaskToShowLabel.transform = CGAffineTransformMakeTranslation(0, 0)
				self.noTaskToShowLabel.alpha = 1
				}, completion: nil)
		} else {
			self.noTaskToShowLabel.hidden = true
			self.noTaskToShowLabel.alpha = 0
			self.noTaskToShowLabel.transform = CGAffineTransformMakeTranslation(0, 30)
		}
		
		return count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = self.tableView.dequeueReusableCellWithIdentifier(BrowseTaskViewCell.reuseIdentifier, forIndexPath: indexPath) as! BrowseTaskViewCell
		
		if self.sortBy == "priceOffered" {
			cell.moneyContainer.backgroundColor = Color.redPrimary
			cell.price.textColor = Color.whitePrimary
		} else {
			cell.moneyContainer.backgroundColor = Color.whiteBackground
			cell.price.textColor = Color.blackPrimary
		}
		
		let task = self.tasks[indexPath.item]
		cell.setNelpTask(task)
		
		if (self.sortBy == "distance" || self.sortBy == "priceOffered") && LocationHelper.sharedInstance.currentCLLocation != nil {
			cell.setLocation()
		}
		
		if task.user.profilePictureURL != nil {
			cell.picture.sd_setImageWithURL(NSURL(string: task.user.profilePictureURL!), placeholderImage: UIImage(named: "noProfilePicture"))
		} else {
			cell.picture.image = UIImage(named:"noProfilePicture")
		}
		
		cell.cellIndexPath = indexPath
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let selectedTask = self.tasks[indexPath.row]
		
		if selectedTask.application != nil && selectedTask.application!.state != .Canceled {
			let nextVC = MyApplicationDetailsView(poster: selectedTask.application!.task.user, application: selectedTask.application!)
			self.hideTabBar()
			dispatch_async(dispatch_get_main_queue()) {
				self.navigationController?.pushViewController(nextVC, animated: true)
			}
		} else {
			let vc = BrowseDetailsViewController()
			vc.task = selectedTask
			self.hideTabBar()
			dispatch_async(dispatch_get_main_queue()) {
				self.navigationController?.pushViewController(vc, animated: true)
			}
		}
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		if (indexPath.row == tableView.indexPathsForVisibleRows!.last!.row) {
			SVProgressHUD.dismiss()
			
			UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations:  {
				self.tableView.alpha = 1
				self.tableView.transform = CGAffineTransformMakeTranslation(0, 0)
				}, completion: nil)
		}
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 85
	}
	
	//MARK: Location Delegate
	
	func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
		CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error) -> Void in
			if error != nil {
				print("Error:" + error!.localizedDescription)
				return
				//fuck
				//shit
			} else {
				print("worked")
			}
		})
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		if self.currentLocation != nil{
			LocationHelper.sharedInstance.currentLocation = PFGeoPoint(latitude:self.currentLocation!.coordinate.latitude, longitude:self.currentLocation!.coordinate.longitude)
			LocationHelper.sharedInstance.currentCLLocation = CLLocationCoordinate2D(latitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude)
		}
		
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Error:" + error.localizedDescription)
	}
	
	
	//MARK: Filters Delegate
	
	/**
	Called when Filters are added by users
	
	- parameter filters:     Filters to apply
	- parameter sort:        Sorting to apply
	*/
	
	func didTapAddFilters(filters: Array<String>?, sort: String?) {
		self.arrayOfFilters = filters!
		self.sortBy = sort
		self.loadDataWithFilters(filters, sort: sort)
		self.checkFilters()
	}
	
	//MARK: Utilities
	
	func hideTabBar() {
		self.tabBarViewController!.tabBarWillHide(true)
		self.tabBarFakeView.image = self.tabBarViewController.tabBarImage
		self.tabBarViewController!.tabBar.hidden = true
	}
	
	//MARK: Actions
	
	@IBAction func centerMapOnUser(sender: AnyObject) {
		
	}
	
	func filtersButtonTapped(sender: UIButton) {
		let nextVC =  FilterSortViewController()
		nextVC.arrayOfFiltersFromPrevious = self.arrayOfFilters
		nextVC.previousSortBy = self.sortBy
		nextVC.delegate = self
		self.tabBarViewController.presentViewController(nextVC, animated: true, completion: nil)
	}
	
	func mapButtonTapped(sender: UIButton) {
		
		sender.selected = !sender.selected
		
		/*let touchPoint = sender.locationInView(self.mapView)
		let touchView = self.mapView.hitTest(touchPoint, withEvent: nil)!
		
		if !touchView.isKindOfClass(MKAnnotationView) && self.annotationIsSelected == false {*/
			if self.mapExpanded == false {
				
				self.mapContainer.snp_updateConstraints { (make) -> Void in
					make.bottom.equalTo(self.contentView.snp_top).offset(self.expandedMapHeight)
				}
				
				self.tableViewContainer.snp_remakeConstraints { (make) -> Void in
					make.top.equalTo(mapContainer.snp_bottom).offset(2)
					make.right.equalTo(contentView.snp_right)
					make.left.equalTo(contentView.snp_left)
					make.bottom.equalTo(contentView.snp_bottom)
				}
				
				UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
					self.contentView.layoutIfNeeded()
					}, completion: nil)
				
				self.mapExpanded = true
			} else {
				
				self.mapContainer.snp_updateConstraints { (make) -> Void in
					make.bottom.equalTo(contentView.snp_top).offset(defaultMapHeight)
				}
				
				self.tableViewContainer.snp_remakeConstraints { (make) -> Void in
					make.top.equalTo(mapContainer.snp_bottom).offset(2)
					make.right.equalTo(contentView.snp_right)
					make.left.equalTo(contentView.snp_left)
					make.bottom.equalTo(contentView.snp_bottom).offset(-49)
				}
				
				UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
					self.contentView.layoutIfNeeded()
					}, completion: nil)
				
				self.mapExpanded = false
			}
		//}
	}
	
	/**
	infoButton is the view that is displayed in fullMap when the user taps on a pin (displaying task informations)
	
	- parameter sender: the view displaying task informations
	*/
	func infoButtonTapped(sender: mapTaskButton) {
		let selectedTask = sender.selectedTask
		let vc = BrowseDetailsViewController()
		vc.hidesBottomBarWhenPushed = true
		vc.task = selectedTask
		
		self.hideTabBar()
		dispatch_async(dispatch_get_main_queue()) {
			self.navigationController?.pushViewController(vc, animated: true)
		}
	}
}


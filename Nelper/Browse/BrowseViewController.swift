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

class BrowseViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate, FilterSortViewControllerDelegate, MKMapViewDelegate {
	
	var navBar: NavBar!
	
	var backgroundView: UIView!
	var contentView: UIView!
	var mapContainer: UIView!
	var tableViewContainer: UIView!
	
	var tableView: UITableView!
	var refreshView: UIRefreshControl!
	var filtersButton:UIButton!
	
	var nelpTasks = [Task]()
	var findNelpTasks = [FindNelpTask]()
	
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
	
	//MARK: Initialization
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		placesClient = GMSPlacesClient()
		
		self.createView()
		
		self.initializeMapview()
		self.createTaskTableView()
		self.loadData()
		self.extendedLayoutIncludesOpaqueBars = true
		
		self.adjustUI()
	}
	
	override func viewDidAppear(animated: Bool) {
		if self.arrayOfFilters.isEmpty && self.sortBy == nil && self.minPrice == nil && self.maxDistance == nil {
			self.loadData()
		}
		
		let rootvc: TabBarCustom = UIApplication.sharedApplication().delegate!.window!?.rootViewController as! TabBarCustom
		rootvc.presentedVC = self
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
		self.navBar.setTitle("Browse Tasks")
		self.navBar.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self.view.snp_top)
			make.right.equalTo(self.view.snp_right)
			make.left.equalTo(self.view.snp_left)
			make.height.equalTo(64)
		}
		
		let filtersButton = UIButton()
		self.navBar.addSubview(filtersButton)
		self.filtersButton = filtersButton
		filtersButton.setImage(UIImage(named: "filters-inactive"), forState: UIControlState.Normal)
		filtersButton.imageEdgeInsets = UIEdgeInsetsMake(13, 16, 8, 18)
		filtersButton.addTarget(self, action: "didTapFiltersButton:", forControlEvents: UIControlEvents.TouchUpInside)
		filtersButton.snp_makeConstraints { (make) -> Void in
			make.right.equalTo(navBar.snp_right)
			make.bottom.equalTo(navBar.snp_bottom)
			make.height.equalTo(50)
			make.width.equalTo(60)
		}
		
		self.navBar.layoutIfNeeded()
		self.tabBarController!.tabBar.layoutIfNeeded()
		
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
		contentView.backgroundColor = whiteBackground
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(backgroundView.snp_top)
			make.left.equalTo(backgroundView.snp_left)
			make.right.equalTo(backgroundView.snp_right)
			make.bottom.greaterThanOrEqualTo(backgroundView)
		}
		
		self.defaultMapHeight = 250
		self.expandedMapHeight = self.view.frame.height - self.navBar.frame.height - self.tabBarController!.tabBar.frame.height
		
		let mapContainer = UIView()
		self.mapContainer = mapContainer
		contentView.addSubview(mapContainer)
		mapContainer.backgroundColor = UIColor.clearColor()
		mapContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(contentView.snp_top)
			make.right.equalTo(contentView.snp_right)
			make.left.equalTo(contentView.snp_left)
			make.height.equalTo(defaultMapHeight)
		}
		
		let tableViewContainer = UIView()
		self.tableViewContainer = tableViewContainer
		contentView.addSubview(tableViewContainer)
		tableViewContainer.backgroundColor = UIColor.clearColor()
		tableViewContainer.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(mapContainer.snp_bottom).offset(2)
			make.right.equalTo(contentView.snp_right)
			make.left.equalTo(contentView.snp_left)
			make.height.equalTo(backgroundView.snp_height).offset(-defaultMapHeight)
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
		self.tableView.backgroundColor = whiteBackground
		self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
		
		self.tableViewContainer.addSubview(tableView)
		
		let refreshView = UIRefreshControl()
		refreshView.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
		tableView.addSubview(refreshView)
		
		tableView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.tableViewContainer.snp_edges)
		}
		
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
		self.locationManager.startUpdatingLocation()
		self.locationManager.distanceFilter = 40
		
		let mapView = MKMapView()
		self.mapView = mapView
		self.mapContainer.addSubview(mapView)
		self.mapView.showsUserLocation = true
		
		if ((self.locationManager.location) != nil) {
			let userLocation: CLLocation = self.locationManager.location!
			self.currentLocation = userLocation
			LocationHelper.sharedInstance.currentLocation = PFGeoPoint(latitude:userLocation.coordinate.latitude, longitude:userLocation.coordinate.longitude)
			let userLocationForCenter = userLocation.coordinate
			let span: MKCoordinateSpan = MKCoordinateSpanMake(0.015 , 0.015)
			let locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(userLocationForCenter, span)
			self.mapView.setRegion(locationToZoom, animated: true)
			self.mapView.setCenterCoordinate(userLocationForCenter, animated: true)
		}
		
		self.mapView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.mapContainer.snp_edges)
		}
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "mapTapped:")
		self.tap = tap
		self.tap.delegate = self
		self.tap.numberOfTapsRequired = 1
		self.mapView.addGestureRecognizer(tap)
		
	}
	
	//MARK: UI
	
	func adjustUI() {
		
	}
	
	func createPins() {
		self.mapView.delegate = self
		
		for task in self.nelpTasks {
			let taskPin = MKPointAnnotation()
			if(task.location != nil) {
				let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(task.location!.latitude, task.location!.longitude)
				taskPin.coordinate = location
				taskPin.title = task.category
				//taskPin.taskTitle = task.title
				//taskPin.category = task.category!
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
		}
		
		let reuseId = "taskPin"
		
		var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
		if pinView == nil {
			pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = true
			let image = UIImage(named: "pin-MK")
			var resizeRect = CGRect()
			resizeRect.size.height = 40
			resizeRect.size.width = 40
			
			UIGraphicsBeginImageContextWithOptions(resizeRect.size, false, 0.0)
			image?.drawInRect(resizeRect)
			let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			pinView!.image = resizedImage
			pinView!.layer.zPosition = -1
			pinView!.centerOffset = CGPointMake(0, -20)
			
			
			
		} else {
			pinView!.annotation = annotation
		}
		
		return pinView
	}
	
	func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
		
		if view.isKindOfClass(MKAnnotationView) {
			self.annotationIsSelected = true
			view.layer.zPosition = 0
			
			setAnnotationInfo(view)
		}
	}
	
	func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
		if view.isKindOfClass(MKAnnotationView) {
			self.annotationIsSelected = false
			view.layer.zPosition = -1
			
			if self.mapExpanded {
				removeAnnotationInfo(view)
			}
		}
	}
	
	func setAnnotationInfo(annotation: MKAnnotationView) {
		if self.mapExpanded {
			
			let blurEffect = UIBlurEffect(style: .ExtraLight)
			let mapInfoBlurView = UIVisualEffectView(effect: blurEffect)
			self.mapInfoBlurView = mapInfoBlurView
			self.mapView.addSubview(mapInfoBlurView)
			mapInfoBlurView.snp_makeConstraints { (make) -> Void in
				make.left.equalTo(self.mapView.snp_left).offset(20)
				make.bottom.equalTo(self.mapView.snp_bottom).offset(200)
				make.right.equalTo(self.mapView.snp_right).offset(-20)
			}
			
			mapInfoBlurView.layoutIfNeeded()
			
			let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
			let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
			vibrancyView.layer.borderWidth = 1
			vibrancyView.layer.borderColor = grayDetails.CGColor
			mapInfoBlurView.contentView.addSubview(vibrancyView)
			vibrancyView.snp_makeConstraints { (make) -> Void in
				make.edges.equalTo(mapInfoBlurView.snp_edges)
			}
			
			/*TODO...
			let applicantsLabel = UILabel()
			vibrancyView.contentView.addSubview(applicantsLabel)
			applicantsLabel.textAlignment = NSTextAlignment.Left
			applicantsLabel.text = annotation.task
			applicantsLabel.textColor = blackPrimary
			applicantsLabel.font = UIFont(name: "Lato-Regular", size: kNavTitle18)
			applicantsLabel.snp_makeConstraints { (make) -> Void in
				make.centerY.equalTo(pendingApplicantIcon.snp_centerY)
				make.left.equalTo(pendingApplicantIcon.snp_right).offset(12)
			}*/
			
			//content
			
			mapInfoBlurView.snp_makeConstraints { (make) -> Void in
				make.height.equalTo(100)
			}
			
			//Animate In
			
			mapInfoBlurView.snp_updateConstraints { (make) -> Void in
				make.bottom.equalTo(self.mapView.snp_bottom).offset(-20)
			}
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
				mapInfoBlurView.layoutIfNeeded()
				}, completion: nil)
			
		} else {
			//TODO NOT EXPANDED MAP, TASK INFO
		}
	}
	
	//TODO: FIX CRASH WHEN SELECTING FROM ONE TO ANOTHER
	func removeAnnotationInfo(annotation: MKAnnotationView) {
		if self.mapInfoBlurView != nil {
			
			if self.mapExpanded {
				self.mapInfoBlurView.snp_updateConstraints { (make) -> Void in
					make.bottom.equalTo(self.mapView.snp_bottom).offset(200)
				}
				self.mapInfoBlurView.setNeedsLayout()
				
				UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
					self.mapInfoBlurView.layoutIfNeeded()
					}, completion: { finished in
						self.mapInfoBlurView.removeFromSuperview()
				})
			} else {
				//TODO NOT EXPANDED MAP, TASK INFO
			}
		}
	}
	
	//MARK: Filters
	
	func checkFilters() {
		if self.arrayOfFilters.isEmpty && self.minPrice == nil && self.maxDistance == nil {
			self.filtersButton.setImage(UIImage(named: "filters-inactive"), forState: UIControlState.Normal)
			
			self.filtersButton.imageEdgeInsets = UIEdgeInsetsMake(13, 16, 8, 18)
		} else {
			self.filtersButton.setImage(UIImage(named: "filters-active"), forState: UIControlState.Normal)
		}
	}
	
	//MARK: DATA
	
	/**
	Reload Data on pullToRefresh
	*/
	
	func onPullToRefresh() {
		if self.arrayOfFilters.isEmpty && self.sortBy == nil && self.minPrice == nil && self.maxDistance == nil {
			self.loadData()
		} else {
			self.loadDataWithFilters(self.arrayOfFilters, sort: self.sortBy, minPrice: self.minPrice, maxDistance: self.maxDistance)
		}
	}
	
	/**
	Fetches the required date from Backend
	*/
	func loadData() {
		ApiHelper.listNelpTasksWithBlock(nil, sortBy: nil, minPrice: nil, maxDistance: nil, block: {(nelpTasks: [Task]?, error: NSError?) -> Void in
			if error != nil {
				
			} else {
				self.nelpTasks = nelpTasks!
				self.createPins()
				self.refreshView?.endRefreshing()
				self.tableView?.reloadData()
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
	
	func loadDataWithFilters(filters:Array<String>?, sort:String?, minPrice:Double?, maxDistance:Double?){
		ApiHelper.listNelpTasksWithBlock(filters, sortBy: sort,minPrice:minPrice, maxDistance:maxDistance, block: {(nelpTasks: [Task]?, error: NSError?) -> Void in
			if error != nil {
				print(error)
			} else {
				print(nelpTasks!.count)
				self.nelpTasks = nelpTasks!
				self.createPins()
				self.refreshView?.endRefreshing()
				self.tableView?.reloadData()
			}
		})
	}
	
	//MARK: Table View Data Source and Delegate
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.nelpTasks.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = self.tableView.dequeueReusableCellWithIdentifier(BrowseTaskViewCell.reuseIdentifier, forIndexPath: indexPath) as! BrowseTaskViewCell
		
		let task = self.nelpTasks[indexPath.item]
		cell.setNelpTask(task)
		cell.setImages(task)
		
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let selectedTask = self.nelpTasks[indexPath.row]
		let vc = BrowseDetailsViewController()
		vc.hidesBottomBarWhenPushed = true
		vc.task = selectedTask
		self.navigationController?.pushViewController(vc, animated: true)
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
		
		//		var userLocation: CLLocation = self.locationManager.location
		//		self.currentLocation = userLocation
		//		var userLocationForCenter = userLocation.coordinate
		//		var span :MKCoordinateSpan = MKCoordinateSpanMake(0.015 , 0.015)
		//		var locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(userLocationForCenter, span)
		//		self.mapView.setRegion(locationToZoom, animated: true)
		//		self.mapView.setCenterCoordinate(userLocationForCenter, animated: true)
		
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
	- parameter minPrice:    Minimum Price Filter Value
	- parameter maxDistance: Maximum Distance filter value
	*/
	
	func didTapAddFilters(filters: Array<String>?, sort: String?, minPrice:Double?, maxDistance:Double?){
		self.arrayOfFilters = filters!
		self.sortBy = sort
		print(filters!, terminator: "")
		self.minPrice = minPrice
		self.maxDistance = maxDistance
		self.loadDataWithFilters(filters, sort: sort, minPrice: minPrice, maxDistance: maxDistance)
		self.checkFilters()
	}
	
	//MARK: Actions
	
	@IBAction func centerMapOnUser(sender: AnyObject) {
		
	}
	
	func didTapFiltersButton(sender:UIButton){
		let nextVC =  FilterSortViewController()
		nextVC.arrayOfFiltersFromPrevious = self.arrayOfFilters
		nextVC.previousSortBy = self.sortBy
		nextVC.delegate = self
		nextVC.previousMinPrice = self.minPrice
		nextVC.previousMaxDistance = self.maxDistance
		self.presentViewController(nextVC, animated: true, completion: nil)
	}
	
	func mapTapped(sender: UITapGestureRecognizer) {
		
		let touchPoint = sender.locationInView(self.mapView)
		let touchView = self.mapView.hitTest(touchPoint, withEvent: nil)!
		
		if !touchView.isKindOfClass(MKAnnotationView) && self.annotationIsSelected == false {
			if self.mapExpanded == false {
				
				self.mapContainer.snp_updateConstraints { (make) -> Void in
					make.height.equalTo(self.expandedMapHeight)
				}
				
				UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
					self.mapContainer.layoutIfNeeded()
					self.tableViewContainer.layoutIfNeeded()
					}, completion: nil)
				
				self.mapExpanded = true
			} else {
				self.mapContainer.snp_updateConstraints { (make) -> Void in
					make.height.equalTo(self.defaultMapHeight)
				}
				
				UIView.animateWithDuration(0.3, delay: 0.0, options: [.CurveEaseOut], animations:  {
					self.mapContainer.layoutIfNeeded()
					self.tableViewContainer.layoutIfNeeded()
					}, completion: nil)
				
				self.mapExpanded = false
				print("map not exp")
			}
		}
	}
}


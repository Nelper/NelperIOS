//
//  NelpViewController.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-21.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import SCLAlertView
import Stripe

class NelpViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate, STRPPaymentViewControllerDelegate{
	
	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var nelperTitle: UILabel!
	
	@IBOutlet weak var entireContainer: UIView!
	@IBOutlet weak var container: UIView!
	@IBOutlet weak var mapViewContainer: UIView!
	
	
	@IBOutlet weak var tableViewContainer: UIView!
	
	@IBOutlet weak var centerButton: UIButton!
	
	@IBOutlet weak var tabView: UIView!
	@IBOutlet weak var nelpTabBarImage: UIButton!
	@IBOutlet weak var findNelpTabBarImage: UIButton!
	@IBOutlet weak var profileTabBarImage: UIButton!
	
	var tableView: UITableView!
	var refreshView: UIRefreshControl!
	
	var nelpTasks = [NelpTask]()
	var findNelpTasks = [FindNelpTask]()
	
	var mapView: MKMapView!
	var currentLocation: CLLocation?
	var placesClient: GMSPlacesClient?
	let locationManager = CLLocationManager()
	var target: CLLocationCoordinate2D?
	
	//Initialization
	
	convenience init() {
		self.init(nibName: "NelpViewController", bundle: nil)
	}
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		placesClient = GMSPlacesClient()
		self.adjustUI()
		self.initializeMapview()
		self.createTaskTableView()
		self.loadData()
		self.extendedLayoutIncludesOpaqueBars = true

		
	}
	
	func createTaskTableView(){
		let tableView = UITableView()
		self.tableView = tableView
		self.tableView.delegate = self
		self.tableView.dataSource = self
		tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
		tableView.registerClass(NelpViewCell.classForCoder(), forCellReuseIdentifier: NelpViewCell.reuseIdentifier)
		self.tableView.backgroundColor = whiteNelpyColor

		let refreshView = UIRefreshControl()
		refreshView.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
		tableView.addSubview(refreshView)
		
		self.tableViewContainer.addSubview(tableView)
		
		tableView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.tableViewContainer.snp_edges)
		}
		self.refreshView = refreshView
		
		//TEST PURPOSE BUTTON- STRIPE
		
		var stripeButton = UIButton()
		self.navBar.addSubview(stripeButton)
		stripeButton.setTitle("Stripe", forState: UIControlState.Normal)
		stripeButton.addTarget(self, action: "stripeButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		stripeButton.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(navBar.snp_bottom)
			make.right.equalTo(navBar.snp_right)
		}
		
		//Filters
		
		var filtersButton = UIButton()
		self.navBar.addSubview(filtersButton)
		filtersButton.setTitle("Filters", forState: UIControlState.Normal)
		filtersButton.setTitleColor(blueGrayColor, forState: UIControlState.Normal)
		filtersButton.addTarget(self, action: "didTapFiltersButton:", forControlEvents: UIControlEvents.TouchUpInside)
		filtersButton.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(navBar.snp_bottom)
			make.left.equalTo(navBar.snp_left)
		}
	}
	
	func initializeMapview(){
		
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
		self.locationManager.distanceFilter = 20
		
		var mapview = MKMapView()
		
		self.mapView = mapview;
		
		self.mapViewContainer.addSubview(mapview)
		self.mapView.showsUserLocation = true
		
		if((self.locationManager.location) != nil){
			var userLocation: CLLocation = self.locationManager.location
			self.currentLocation = userLocation
			var userLocationForCenter = userLocation.coordinate
			var span :MKCoordinateSpan = MKCoordinateSpanMake(0.015 , 0.015)
			var locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(userLocationForCenter, span)
			self.mapView.setRegion(locationToZoom, animated: true)
			self.mapView.setCenterCoordinate(userLocationForCenter, animated: true)
		}
		mapview.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(mapViewContainer.snp_edges)
		}
		
	}
	
	//UI
	
	func adjustUI(){
		self.entireContainer.backgroundColor = blueGrayColor
		self.container.backgroundColor = blueGrayColor
		self.navBar.setTitle("Browse Tasks")
	}
	
	func createPins(){
		
		for task in self.nelpTasks {
			var taskPin = MKPointAnnotation()
			if(task.location != nil) {
				var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(task.location!.latitude, task.location!.longitude)
				taskPin.coordinate = location
				self.mapView.addAnnotation(taskPin)
				
			}
		}
	}
	
	/** Pin image code???
	
	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
	if (annotation is MKUserLocation) {
	//if annotation is not an MKPointAnnotation (eg. MKUserLocation),
	//return nil so map draws default view for it (eg. blue dot)...
	return nil
	}
	
	let reuseId = "test"
	
	var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
	if anView == nil {
	anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
	anView.image = UIImage(named:"logo_round_v2")
	anView.canShowCallout = true
	}
	else {
	//we are re-using a view, update its annotation reference...
	anView.annotation = annotation
	}
	
	return anView
	}
	*/
	
	
	//DATAFetching
	
	func onPullToRefresh() {
		loadData()
	}
	
	func loadData() {
		ApiHelper.listNelpTasksWithBlock { (nelpTasks: [NelpTask]?, error: NSError?) -> Void in
			if error != nil {
				
			} else {
				self.nelpTasks = nelpTasks!
				self.createPins()
				self.refreshView?.endRefreshing()
				self.tableView?.reloadData()
			}
		}
		
	}
	
	//TableView Delegate/Datasource methods
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.nelpTasks.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = self.tableView.dequeueReusableCellWithIdentifier(NelpViewCell.reuseIdentifier, forIndexPath: indexPath) as! NelpViewCell
		
		let nelpTask = self.nelpTasks[indexPath.item]
		
		
		cell.setNelpTask(nelpTask)
		if(self.currentLocation != nil){
			cell.setLocation(self.currentLocation!)
		}
		cell.setImages(nelpTask)
		
		return cell
		
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var selectedTask = self.nelpTasks[indexPath.row]
		var vc = NelpTasksDetailsViewController(nelpTask: selectedTask)
		self.presentViewController(vc, animated: false, completion: nil)
		
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 80
	}
	
	
	
	//Location delegate methods
	
	func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
		CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
			if error != nil{
				println("Error:" + error.localizedDescription)
				return
				//fuck
			}
			
		})
	}
	
	func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
		
		var userLocation: CLLocation = self.locationManager.location
		self.currentLocation = userLocation
		var userLocationForCenter = userLocation.coordinate
		var span :MKCoordinateSpan = MKCoordinateSpanMake(0.015 , 0.015)
		var locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(userLocationForCenter, span)
		self.mapView.setRegion(locationToZoom, animated: true)
		self.mapView.setCenterCoordinate(userLocationForCenter, animated: true)
		
	}
	
	func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
		println("Error:" + error.localizedDescription)
	}
	
	func zoomToUserLocation (userLocation: CLLocation){
		var userLocationForCenter = userLocation.coordinate
		var span :MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
		var locationToZoom: CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
		var region:MKCoordinateRegion = MKCoordinateRegionMake(locationToZoom, span)
		
	}
	
	//Popup Delegate
	
	func didClosePopup(vc:STRPPaymentViewController){
		
		
	}
	
	//IBActions
	
	@IBAction func centerMapOnUser(sender: AnyObject) {
		
	}
	
	func stripeButtonTapped(sender:UIButton){
		var nextVC = STRPPaymentViewController()
		nextVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
		self.presentViewController(nextVC, animated: true, completion: nil)
	}
	
	func didTapFiltersButton(sender:UIButton){
		var nextVC =  FilterSortViewController()
		self.presentViewController(nextVC, animated: true, completion: nil)
	}
	
	
	
	
}


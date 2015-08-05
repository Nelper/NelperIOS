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

class NelpViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate {
	
	@IBOutlet weak var navBar: UIView!
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
	var placesClient: GMSPlacesClient?
	let locationManager = CLLocationManager()
	var target: CLLocationCoordinate2D?
    
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
		
  }
	
	func createTaskTableView(){
		let tableView = UITableView()
		self.tableView = tableView
		self.tableView.delegate = self
		self.tableView.dataSource = self
		tableView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
		tableView.registerClass(NelpViewCell.classForCoder(), forCellReuseIdentifier: NelpViewCell.reuseIdentifier)
		
		let refreshView = UIRefreshControl()
		refreshView.addTarget(self, action: "onPullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
		tableView.addSubview(refreshView)
		
		self.tableViewContainer.addSubview(tableView)
		
		tableView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.tableViewContainer.snp_edges)
		}
		self.refreshView = refreshView
		
	
	}

	func initializeMapview(){
		
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
		self.locationManager.distanceFilter = 20

		
		var camera = GMSCameraPosition.cameraWithLatitude(77.0167, longitude:38.8833 , zoom: 6)
		
		var mapview = MKMapView()
		
		self.mapView = mapview;
		
		
		self.mapViewContainer.addSubview(mapview)
		
		self.mapView.addGestureRecognizer(touchesDetector)
		self.mapView.showsUserLocation = true
		
		mapview.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(mapViewContainer.snp_edges)
		}
		
	}
	
	func adjustUI(){

		self.navBar.backgroundColor = navBarColor
		self.entireContainer.backgroundColor = blueGrayColor
		self.nelperTitle.text = "Nelper"
		self.nelperTitle.font = UIFont(name: "Railway", size: kNavBarTitleFont)
		self.nelperTitle.textColor = orangeTextColor
		self.logoImage.image = UIImage(named: "logo_round_v2")
		self.logoImage.contentMode = UIViewContentMode.ScaleAspectFit
		self.container.backgroundColor = blueGrayColor
		self.tabView.backgroundColor = navBarColor
		self.nelpTabBarImage.setBackgroundImage(UIImage(named: "help_orange.png"), forState: UIControlState.Normal)
		self.findNelpTabBarImage.setBackgroundImage(UIImage(named: "search_dark.png"), forState: UIControlState.Normal)
		self.profileTabBarImage.setBackgroundImage(UIImage(named: "profile_dark.png"), forState: UIControlState.Normal)
	
	}
	
	
//DATAFetching
	
	func onPullToRefresh() {
		loadData()
	}
	
	func loadData() {
		ApiHelper.listNelpTasksWithBlock { (nelpTasks: [NelpTask]?, error: NSError?) -> Void in
			if error != nil {
				
			} else {
				self.nelpTasks = nelpTasks!
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
		cell.setImages(nelpTask)
		
		return cell
		
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 80
	}
	

//UIGesture delegate methods
	
	func didTouchMap(sender:UIPanGestureRecognizer){
		navBarHide()
		if(sender.state == UIGestureRecognizerState.Ended){
			println("drag over")
			navBarShow()
		}
	}
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
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
		self.zoomToUserLocation(userLocation)

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
	
	
//NavBar animation functions
	
	func navBarHide(){
		UIView.animateWithDuration(0.3, animations:{self.navBar.alpha = 0}, completion: nil)
	}
	
	func navBarShow(){
		UIView.animateWithDuration(0.5, animations:{self.navBar.alpha = 1}, completion: nil)
	}
	

//IBActions
	
	@IBAction func centerMapOnUser(sender: AnyObject) {

	}
	
	@IBAction func findNelpTabButtonTouched(sender: AnyObject) {
		var nextVC = NelpTasksListViewController()
		self.presentViewController(nextVC, animated: false, completion: nil)
	}
	
	@IBAction func profileTabButtonTouched(sender: AnyObject) {
		var nextVC = ProfileViewController()
		self.presentViewController(nextVC, animated: false, completion: nil)
	}



}


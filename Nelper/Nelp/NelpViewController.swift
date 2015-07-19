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

class NelpViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
	
	@IBOutlet weak var navBar: UIView!
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var container: UIView!
	
	
	@IBOutlet weak var taskTableView: UITableView!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var centerButton: UIButton!
	
	@IBOutlet weak var tabView: UIView!
	@IBOutlet weak var nelpTabBarImage: UIButton!
	@IBOutlet weak var findNelpTabBarImage: UIButton!
	@IBOutlet weak var profileTabBarImage: UIButton!

	
	
	let locationManager = CLLocationManager()
    
    convenience init() {
        self.init(nibName: "NelpViewController", bundle: nil)
	
    }

    
  override func viewDidLoad() {
    
    super.viewDidLoad()
		self.initializeMapview()
		self.adjustUI()
		
  }

	func initializeMapview(){
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
		
		var touchesDetector = UIPanGestureRecognizer(target: self, action:Selector("didTouchMap:"))
		touchesDetector.delegate = self
		self.mapView.addGestureRecognizer(touchesDetector)
		
		self.mapView.showsUserLocation = true
		var userLocation: CLLocation = self.locationManager.location
		var userLocationForCenter = userLocation.coordinate
		var span :MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
		var locationToZoom: MKCoordinateRegion = MKCoordinateRegionMake(userLocationForCenter, span)
		self.mapView.setRegion(locationToZoom, animated: true)
		self.mapView.setCenterCoordinate(userLocationForCenter, animated: true)
		
	}
	
	func adjustUI(){
		self.navBar.backgroundColor = orangeMainColor
		self.logoImage.image = UIImage(named: "logo_nobackground_v2")
		self.logoImage.contentMode = UIViewContentMode.ScaleAspectFit
		self.centerButton.setBackgroundImage(UIImage(named: "centerMap.png"), forState: UIControlState.Normal)
		self.container.backgroundColor = orangeMainColor
		self.tabView.backgroundColor = orangeMainColor
		self.nelpTabBarImage.setBackgroundImage(UIImage(named: "help_black.png"), forState: UIControlState.Normal)
		self.findNelpTabBarImage.setBackgroundImage(UIImage(named: "search_white.png"), forState: UIControlState.Normal)
		self.profileTabBarImage.setBackgroundImage(UIImage(named: "profile_white.png"), forState: UIControlState.Normal)
	
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
	
	func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
		println("Error:" + error.localizedDescription)
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
		self.mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
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


//
//  AppDelegate.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-06-21.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LoginViewControllerDelegate {
	
	var window: UIWindow?
	
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		Parse.enableLocalDatastore()
		
		Parse.setApplicationId("w6MsLIhprn1GaHllI4WYa8zcLghnPUQi5jwe7FxN", clientKey: "NRdzngSkWnGsHTMdcYumEuoXX1N8tt0ZN0o48fZV")
		
		PFUser.enableAutomaticUser()
		PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
		
		PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
		
		GMSServices.provideAPIKey("AIzaSyC4IkGUD1uY53E1aihYxDvav3SbdCDfzq8")
		
		self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
		self.window!.rootViewController = UIViewController()
		self.window!.makeKeyAndVisible()
		
		UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
		
		
		let user = PFUser.currentUser()
		
		if(PFUser.currentUser()?.username == nil) {
			// If the user is not logged show the login page.
			self.showLogin(false)
		} else {
			// Show the main app.
			let tabVC = initAppViewController()
			self.window?.rootViewController = tabVC
		}
		
		return true
	}
	
	func showLogin(animated: Bool) {
		let loginVC = LoginViewController()
		loginVC.delegate = self
		if animated && false {
			self.window?.rootViewController?.presentViewController(loginVC, animated: true, completion: nil)
		} else {
			self.window!.rootViewController = loginVC
		}
		
	}
	
	// LoginViewControllerDelegate
	func onLogin() {
		let tabVC = initAppViewController()
		self.window?.rootViewController?.presentViewController(tabVC, animated: true, completion: nil)
	}
	
	// Init the main app tab view controller
	func initAppViewController() -> UITabBarController {
		var nelpVC = NelpViewController()
		var nelpVCItem = UITabBarItem(title: "Nelp", image: UIImage(named: "nelp_dark"), selectedImage: UIImage(named: "nelp_dark"))
		nelpVC.tabBarItem = nelpVCItem
		
		var nelpCenterVC = ProfileViewController()
		var nelpCenterVCItem = UITabBarItem(title: "Nelp Center", image: UIImage(named: "nelpcenter_dark"), selectedImage: UIImage(named: "nelpcenter_dark"))
		nelpCenterVC.tabBarItem = nelpCenterVCItem
		
		var findNelpVC = NelpTaskCreateViewController()
		var findNelpVCItem = UITabBarItem(title: "Find Nelp", image: UIImage(named: "find_nelp_dark"), selectedImage: UIImage(named: "search_orange"))
		var controllersArray = [nelpVC, nelpCenterVC, findNelpVC]
		findNelpVC.tabBarItem = findNelpVCItem
		
		var tabs = UITabBarController()
		tabs.viewControllers = controllersArray
		tabs.tabBar.tintColor = orangeTextColor
		
		return tabs
	}
	
	func application(application: UIApplication,
		openURL url: NSURL,
		sourceApplication: String?,
		annotation: AnyObject?) -> Bool {
			return FBSDKApplicationDelegate.sharedInstance()!.application(application,
				openURL: url,
				sourceApplication: sourceApplication,
				annotation: annotation)
	}
	
	func applicationDidBecomeActive(application: UIApplication) {
		FBSDKAppEvents.activateApp()
	}
	
	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	
	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
}


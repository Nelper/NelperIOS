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
import Stripe
import ParseCrashReporting
import SVProgressHUD

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, LoginViewControllerDelegate {
	
	var window: UIWindow?
	var layerClient: LYRClient!
	
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		

		//Stripe
		
		Stripe.setDefaultPublishableKey("pk_test_gYIk5RNw7X2LCS4501jd4HpE")
		
		//Parse
		
		Parse.enableLocalDatastore()
		ParseCrashReporting.enable()
		
		Parse.setApplicationId("w6MsLIhprn1GaHllI4WYa8zcLghnPUQi5jwe7FxN", clientKey: "NRdzngSkWnGsHTMdcYumEuoXX1N8tt0ZN0o48fZV")
		
		PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
		
		PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
		
		//Layer
		
		let LayerAppIDString: NSURL! = NSURL(string: "layer:///apps/staging/33a90a5e-5006-11e5-a708-7f0c79166812")
		
		
		layerClient = LYRClient(appID: LayerAppIDString)
		LayerManager.sharedInstance.layerClient = layerClient
		
		
		//Google
		GMSServices.provideAPIKey("AIzaSyC4IkGUD1uY53E1aihYxDvav3SbdCDfzq8")
		
		self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
		self.window!.rootViewController = UIViewController()
		self.window!.makeKeyAndVisible()
		
		
		if PFUser.currentUser() == nil {
			// If the user is not logged show the login page.
			
			self.showOnboarding()
			//self.showLogin(false)
		} else {
			GraphQLClient.userId = PFUser.currentUser()?.objectId
			GraphQLClient.sessionToken = PFUser.currentUser()?.sessionToken
			// Show the main app.
			self.loginLayer()
			self.loginSupportKit()
			ApiHelper.getCurrentUserPrivateInfo()
			let tabVC = initAppViewController(BrowseViewController())
			self.window?.rootViewController = tabVC
		}
		
		//NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveLayerObjectsDidChangeNotification:", name: LYRClientObjectsDidChangeNotification, object: layerClient)
		
		return true
	}
	
	func showOnboarding() {
		let onboardingVC = OnboardingPageViewController()
		UIView.transitionWithView(self.window!, duration: 0.3, options: .TransitionCrossDissolve, animations: { () -> Void in
			self.window!.rootViewController = onboardingVC
			}, completion: nil)
	}
	
	func showLogin(animated: Bool) {
		let loginVC = LoginViewController()
		loginVC.delegate = self
		if animated {
			UIView.transitionWithView(self.window!, duration: 0.3, options: .TransitionCrossDissolve, animations: { () -> Void in
				self.window!.rootViewController = loginVC
				}, completion: nil)
			
		} else {
			self.window!.rootViewController = loginVC
		}
		
	}
	
	// LoginViewControllerDelegate
	func onLogin() {
		
		let tabVC = self.initAppViewController(BrowseViewController())
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
			
			self.loginLayer()
			self.loginSupportKit()
			self.window?.rootViewController = tabVC
			
			dispatch_async(dispatch_get_main_queue(), {
				SVProgressHUD.dismiss()
			})
		})
		
		//self.window?.rootViewController?.presentViewController(tabVC, animated: true, completion: nil)
		UIView.transitionWithView(self.window!, duration: 0.2, options: .TransitionCrossDissolve, animations: { () -> Void in
			self.window!.rootViewController = tabVC
			}, completion: nil)
	}
	
	// Init the main app tab view controller
	func initAppViewController(vc: UIViewController?) -> UIViewController {
		
		let tabBar = TabBarViewController(vc: vc)
		
		return tabBar
	}
	
	func application(application: UIApplication,
		openURL url: NSURL,
		sourceApplication: String?,
		annotation: AnyObject) -> Bool {
			return FBSDKApplicationDelegate.sharedInstance()!.application(application,
				openURL: url,
				sourceApplication: sourceApplication,
				annotation: annotation)
	}
	
	func loginSupportKit(){
		let supportKitSettings = (SKTSettings(appToken: "9x5o1paxgfpjzzsgodj80yti3"))
		supportKitSettings.conversationAccentColor = Color.redPrimary
		SKTUser.currentUser().firstName = PFUser.currentUser()?.objectForKey("name") as? String
		SupportKit.initWithSettings(supportKitSettings)
		SupportKit.login(PFUser.currentUser()!.objectId, jwt: nil)
	}
	
	func loginLayer() {
		// Connect to Layer
		// See "Quick Start - Connect" for more details
		// https://developer.layer.com/docs/quick-start/ios#connect
		self.layerClient.connectWithCompletion { success, error in
			if (!success) {
				print("Failed to connect to Layer: \(error)")
			} else {
				let userID: String = PFUser.currentUser()!.objectId!
				// Once connected, authenticate user.
				// Check Authenticate step for authenticateLayerWithUserID source
				self.authenticateLayerWithUserID(userID, completion: { success, error in
					if (!success) {
						print("Failed Authenticating Layer Client with error:\(error)")
					} else {
						print("Authenticated with Layers and Parse")
					}
				})
			}
		}
	}
	
	func authenticateLayerWithUserID(userID: NSString, completion: ((success: Bool , error: NSError!) -> Void)!) {
		// Check to see if the layerClient is already authenticated.
		if self.layerClient.authenticatedUserID != nil {
			// If the layerClient is authenticated with the requested userID, complete the authentication process.
			if self.layerClient.authenticatedUserID == userID {
				print("Layer Authenticated as User \(self.layerClient.authenticatedUserID)")
				if completion != nil {
					completion(success: true, error: nil)
				}
				return
			} else {
				//If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
				self.layerClient.deauthenticateWithCompletion { (success: Bool, error: NSError!) in
					if error != nil {
						self.authenticationTokenWithUserId(userID, completion: { (success: Bool, error: NSError?) in
							if (completion != nil) {
								completion(success: success, error: error)
							}
						})
					} else {
						if completion != nil {
							completion(success: true, error: error)
						}
					}
				}
			}
		} else {
			// If the layerClient isn't already authenticated, then authenticate.
			self.authenticationTokenWithUserId(userID, completion: { (success: Bool, error: NSError!) in
				if completion != nil {
					completion(success: success, error: error)
				}
			})
		}
	}
	
	func authenticationTokenWithUserId(userID: NSString, completion:((success: Bool, error: NSError!) -> Void)!) {
		/*
		* 1. Request an authentication Nonce from Layer
		*/
		self.layerClient.requestAuthenticationNonceWithCompletion { (nonce: String!, error: NSError!) in
			if (nonce.isEmpty) {
				if (completion != nil) {
					completion(success: false, error: error)
				}
				return
			}
			
			/*
			* 2. Acquire identity Token from Layer Identity Service
			*/
			PFCloud.callFunctionInBackground("generateToken", withParameters: ["nonce": nonce, "userID": userID]) { (object:AnyObject?, error: NSError?) -> Void in
				if error == nil {
					let identityToken = object as! String
					self.layerClient.authenticateWithIdentityToken(identityToken) { authenticatedUserID, error in
						if (!authenticatedUserID.isEmpty) {
							if (completion != nil) {
								completion(success: true, error: nil)
							}
							print("Layer Authenticated as User: \(authenticatedUserID)")
						} else {
							completion(success: false, error: error)
						}
					}
				} else {
					print("Parse Cloud function failed to be called to generate token with error: \(error)")
				}
			}
		}
	}
	
	func didReceiveLayerObjectsDidChangeNotification(notification:NSNotification){
		
		var changes:Array<AnyObject>
		if let notif: AnyObject = notification.userInfo?[LYRClientObjectChangesUserInfoKey]{
			changes = notif as! Array<AnyObject>
			
			for change in changes{
				let changeClass = change.object
				let updateKey: LYRObjectChangeType = change.type
				if changeClass is LYRConversation {
					var conversation = changeClass
					
					switch(updateKey){
						
					case LYRObjectChangeType.Create:
						print("a")
						
					case LYRObjectChangeType.Update:
						print("b")
						
					case LYRObjectChangeType.Delete:
						print("c")
						
					default:
						print("d")
					}
				}
				if changeClass is LYRMessage {
					
				}
			}
		}
	}
	
	
	/*func didReceiveTypingIndicator(notification:NSNotification){
		
		var participantID : AnyObject = notification.userInfo![LYRTypingIndicatorParticipantUserInfoKey]!
		notification.userInfo![LYRTypingIndicatorParticipantUserInfoKey]! = "Your neighbor" as AnyObject
		
		if notification.userInfo![LYRTypingIndicatorValueUserInfoKey] != nil{
			var typingIndicator: UInt = notification.userInfo![LYRTypingIndicatorValueUserInfoKey] as! UInt
			if typingIndicator == 0{
				notification.object!.sendTypingIndicator(LYRTypingIndicator.DidBegin)
			}else if typingIndicator == 1 {
				notification.object!.sendTypingIndicator(LYRTypingIndicator.DidFinish)
				
			}else if typingIndicator == 2{
				notification.object!.sendTypingIndicator(LYRTypingIndicator.DidPause)
			}
		}
	}*/
	
	func applicationDidFinishLaunching(application: UIApplication) {
		UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
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


//
//  ParseHelper.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-07-26.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire
private let kParseTask = "NelpTask"
private let kParseTaskApplication = "NelpTaskApplication"

class ApiHelper {
	
	//Login with Email

	static func loginWithEmail(email: String, password: String, block: (User?, NSError?) -> Void) {
		PFUser.logInWithUsernameInBackground(email, password: password) { (user, error) -> Void in
			if(error != nil) {
				block(nil, error)
				return
			}
			
			block(User(parseUser: user!), nil)
		}
	}
	
	//Register with Email
	
	static func registerWithEmail(email: String, password: String, name: String, block: (User?, NSError?) -> Void) {
		let user = PFUser()
		user.username = email
		user.email = email
		user.password = password
		user["name"] = name
		user.signUpInBackgroundWithBlock { (ok, error) -> Void in
			if error != nil {
				block(nil, error)
			}
			
			if ok {
				block(User(parseUser: user), nil)
			} else {
				//TODO(janic): Handle this case if it can happen.
			}
		}
	}
	
	
	//Login using Facebook
	
	static func loginWithFacebook(block: (User?, NSError?) -> Void) {
		PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile"]) { (user: PFUser?, error: NSError?) -> Void in
			if error != nil {
				block(nil, error)
				return
			}
			
			self.getUserInfoFromFacebookWithBlock({ (fbUser, error) -> Void in
				if error != nil {
					block(nil, error)
					return
				}
				
				let fbID = user!["id"] as! String
				let profilePictureURL = "https://graph.facebook.com/\(fbID)/picture?type=large&return_ssl_resources=1"
				user!.setValue(profilePictureURL, forKey: "pictureURL")
				user!.setValue(user!.valueForKey("name"), forKey: "name")
				
			})
		}
	}
	
	//Logout
	static func logout() {
		PFUser.logOut()
	}
	
	
	//Get Facebook Informations
	static func getUserInfoFromFacebookWithBlock(block: (AnyObject?, NSError?) -> Void) {
		let request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
		request.startWithCompletionHandler { (conn:FBSDKGraphRequestConnection!, user:AnyObject!, error:NSError!) -> Void in
			if error != nil {
				block(nil, error)
			} else {
				block(user, nil)
			}
		}
	}
	
	//Sets the user location
	static func setUserLocation(loc: GeoPoint) {
		let user = PFUser.currentUser()!
		user["location"] = PFGeoPoint(latitude: loc.latitude, longitude: loc.longitude)
		user.save()
	}
	
	//List all the Nelp Tasks
	static func listNelpTasksWithBlock(arrayOfFilters:Array<String>?, sortBy: String?,minPrice: Double?, maxDistance: Double?,block: ([NelpTask]?, NSError?) -> Void) {
		let taskQuery = PFQuery(className: kParseTask)
		if let arrayOfFilters = arrayOfFilters{
			print(arrayOfFilters.count)
			for filter in arrayOfFilters{
				taskQuery.whereKey("category", equalTo:filter)
				print(filter)
			}
		}
		
		if let minPrice = minPrice {
		 taskQuery.whereKey("priceOffered", greaterThanOrEqualTo: minPrice)
		}
		
		if let maxDistance = maxDistance {
			print(LocationHelper.sharedInstance.currentLocation!)
			print(maxDistance)
			var distance:Double = maxDistance
			taskQuery.whereKey("location", nearGeoPoint: LocationHelper.sharedInstance.currentLocation!, withinKilometers: distance)
		}
		
		if let sortBy = sortBy{
			if sortBy == "location" && maxDistance == nil{
					taskQuery.whereKey("location", nearGeoPoint: LocationHelper.sharedInstance.currentLocation)
			}else if sortBy == "priceOffered"{
			taskQuery.orderByDescending(sortBy)
			}
		}else{
			taskQuery.orderByDescending("createdAt")
		}
		taskQuery.includeKey("user")
		taskQuery.whereKey("state", equalTo: NelpTask.State.Pending.rawValue)
		taskQuery.limit = 20
		taskQuery.findObjectsInBackgroundWithBlock { (pfTasks, error) -> Void in
			if error != nil {
				block(nil, error)
				return
			}
			if let user = PFUser.currentUser() {
				let applicationQuery = PFQuery(className: kParseTaskApplication)
				applicationQuery.whereKey("user", equalTo: PFUser.currentUser()!)
				applicationQuery.whereKey("state", equalTo: NelpTaskApplication.State.Pending.rawValue)
				applicationQuery.whereKey("task", containedIn: pfTasks!)
				applicationQuery.findObjectsInBackgroundWithBlock({ (pfApplications, error) -> Void in
					if error != nil {
						block(nil, error)
						return
					}
					
					let tasks = pfTasks!.map({ (pfTask) -> NelpTask in
						let task = NelpTask(parseTask: pfTask as! PFObject)
						let index = find(pfApplications!.map({($0["task"] as! PFObject).objectId!}), task.objectId)
						if let index = index {
							task.application = NelpTaskApplication(parseApplication: pfApplications![index] as! PFObject)
						}
						
						return task
					})
					
					block(tasks, nil)
				})
			} else {
				block(pfTasks!.map({ NelpTask(parseTask: $0 as! PFObject) }), nil)
			}
		}
	}
	
	//List the user's tasks
	static func listMyNelpTasksWithBlock(block: ([FindNelpTask]?, NSError?) -> Void) {
		let taskQuery = PFQuery(className: kParseTask)
		taskQuery.whereKey("user", equalTo: PFUser.currentUser()!)
		taskQuery.whereKey("state", containedIn: [NelpTask.State.Pending.rawValue, NelpTask.State.Accepted.rawValue ])
		taskQuery.orderByDescending("createdAt")
		taskQuery.limit = 20
		taskQuery.findObjectsInBackgroundWithBlock { (pfTasks, error) -> Void in
			if error != nil {
				block(nil, error)
				return
			}
			
			let applicationQuery = PFQuery(className: kParseTaskApplication)
			applicationQuery.includeKey("user")
			applicationQuery.whereKey("task", containedIn: pfTasks!)
			applicationQuery.whereKey("state", notEqualTo: NelpTaskApplication.State.Canceled.rawValue)
			applicationQuery.findObjectsInBackgroundWithBlock({ (pfApplications, error) -> Void in
				if error != nil {
					block(nil, error)
					return
				}
				
				let tasks = pfTasks!.map({ (pfTask) -> FindNelpTask in
					let task = FindNelpTask(parseTask: pfTask as! PFObject)
					let applications = pfApplications!
						.filter({ ($0["task"] as! PFObject).objectId == task.objectId })
						.map({ NelpTaskApplication(parseApplication: $0 as! PFObject) })
					
					task.applications = applications
					
					return task
				})
				
				block(tasks, nil)
			})
		}
		
	}
	
	//List the user's application
	static func listMyNelpApplicationsWithBlock(block: ([NelpTaskApplication]?, NSError?) -> Void) {
		let taskQuery = PFQuery(className: kParseTaskApplication)
		taskQuery.includeKey("task.user")
		taskQuery.whereKey("user", equalTo: PFUser.currentUser()!)
		taskQuery.whereKey("state", notEqualTo: NelpTaskApplication.State.Canceled.rawValue)
		taskQuery.orderByDescending("createdAt")
		taskQuery.limit = 20
		taskQuery.findObjectsInBackgroundWithBlock { (pfTaskApplications, error) -> Void in
			if error != nil {
				block(nil, error)
				return
			}
			let applications = pfTaskApplications!.map({ (pfTaskApplication) -> NelpTaskApplication in
			let application = NelpTaskApplication(parseApplication: pfTaskApplication as! PFObject)
			return application
			})
			block(applications, nil)
		}
	}
	
	
	//Create a new task
	static func addTask(task: FindNelpTask, block: (FindNelpTask?, NSError?) -> Void) {
		let user = PFUser.currentUser()!
		
		let parseTask = PFObject(className: kParseTask)
		parseTask["title"] = task.title
		parseTask["desc"] = task.desc
		parseTask["user"] = PFUser.currentUser()!
		parseTask["state"] = task.state.rawValue
		parseTask["priceOffered"] = task.priceOffered
		parseTask["category"] = task.category
		var lat = task.location?.latitude
		var lng = task.location?.longitude
		if lat != nil && lng != nil {
			let location = PFGeoPoint(latitude: lat!, longitude: lng!)
			parseTask["location"] = location
		}
		parseTask["city"] = task.city
		if task.pictures == nil {
			parseTask["pictures"] = []
		} else {
			parseTask["pictures"] = task.pictures
		}
		
		let acl = PFACL(user: user)
		acl.setPublicReadAccess(true)
		acl.setPublicWriteAccess(false)
		parseTask.ACL = acl
		
		parseTask.saveInBackgroundWithBlock { (ok, error) -> Void in
			if error != nil {
				block(nil, error)
				return
			}
			if ok {
				task.objectId = parseTask.objectId!
				block(task, nil)
			} else {
				//TODO(janic): Handle this.
			}
		}
	}
	
	//Edit the task
	
	static func editTask(task: FindNelpTask) {
		let parseTask = PFObject(className: kParseTask)
		
		var query = PFQuery(className: "NelpTask")
		query.getObjectInBackgroundWithId(task.objectId, block: { (taskFetched , error) -> Void in
			if error != nil{
				println(error)
			}else if let taskFetched = taskFetched{
				
				taskFetched["title"] = task.title
				taskFetched["description"] = task.desc
				let location = PFGeoPoint(latitude: task.location!.latitude, longitude: task.location!.longitude)
				taskFetched["location"] = location
				if task.pictures == nil {
					taskFetched["pictures"] = []
				} else {
					taskFetched["pictures"] = task.pictures
				}
				taskFetched.saveInBackground()
			}
		})
	}
	
	//Delete the task
	static func deleteTask(task: FindNelpTask) {
		let parseTask = PFObject(className: kParseTask)
		parseTask.objectId = task.objectId
		parseTask["state"] = FindNelpTask.State.Deleted.rawValue
		parseTask.saveEventually()
	}
	
	//Apply for a task
	
	static func applyForTask(task: NelpTask, price:Int) {
		let parseTask = PFObject(withoutDataWithClassName: kParseTask, objectId: task.objectId)
		let parseApplication = PFObject(className: kParseTaskApplication)
		parseApplication["state"] = NelpTaskApplication.State.Pending.rawValue
		parseApplication["user"] = PFUser.currentUser()!
		parseApplication["task"] = parseTask
		parseApplication["isNew"] = true
		parseApplication["price"] = task.priceOffered
		task.application = NelpTaskApplication(parseApplication: parseApplication)
		parseApplication.saveInBackgroundWithBlock { (ok, error) -> Void in
			task.application?.objectId = parseApplication.objectId
		}
	}
	
	//Cancel application on a task
	
	static func cancelApplyForTask(task: NelpTask) {
		let parseApplication = PFObject(withoutDataWithClassName:kParseTaskApplication, objectId:task.application!.objectId)
		parseApplication["state"] = NelpTaskApplication.State.Canceled.rawValue
		parseApplication.saveEventually()
	}
	
	static func cancelApplyForTaskWithApplication(application: NelpTaskApplication) {
		print(application.objectId)
		let parseApplication = PFObject(withoutDataWithClassName:kParseTaskApplication, objectId:application.objectId)
		parseApplication["state"] = NelpTaskApplication.State.Canceled.rawValue
		parseApplication.saveEventually()
	}
		
	//Accept applicant
	
	static func acceptApplication(application: NelpTaskApplication) {
		let parseApplication = PFObject(withoutDataWithClassName: kParseTaskApplication, objectId: application.objectId)
		parseApplication.setValue(NelpTaskApplication.State.Accepted.rawValue, forKey: "state:")
		let parseTask = PFObject(className: kParseTask)
		parseTask.objectId = application.task.objectId
		parseTask.setValue(FindNelpTask.State.Accepted.rawValue, forKey: "state")
		
		PFObject.saveAllInBackground([parseApplication, parseTask])
	}
	
	//Deny an applicant
	
	static func denyApplication(application: NelpTaskApplication) {
		let parseApplication = PFObject(withoutDataWithClassName: kParseTaskApplication, objectId: application.objectId)
		parseApplication.setValue(NelpTaskApplication.State.Denied.rawValue, forKey: "state:")
		parseApplication.saveEventually()
	}
	
	//Set task as view
	static func setTaskViewed(task: FindNelpTask) {
		let parseApplications = task.applications
			.filter({ $0.isNew })
			.map({ (a: NelpTaskApplication) -> PFObject in
				let parseApplication = PFObject(withoutDataWithClassName: kParseTaskApplication, objectId: a.objectId)
				parseApplication.setValue(false, forKey: "isNew")
				return parseApplication
			})
		
		PFObject.saveAllInBackground(parseApplications)
	}
	
	//Retrieve Task pictures
	
	static func getPictures(imageURL: String, block: (UIImage) -> Void) -> Void {
		var image: UIImage!
		request(.GET,imageURL).response(){
			(_, _, data, error) in
			if(error != nil){
				println(error)
			}
			image = UIImage(data: data as NSData!)
			block(image)
		}
	}
	
	//Convert uploaded pictures to PFFile
	
	static func convertImagesToData(images:Array<UIImage>) -> Array<PFFile>{
		var imagesInData = Array<PFFile>()
		for image in images{
			var imageData = UIImageJPEGRepresentation(image as UIImage, 0.50)
			var imageFile = PFFile(name:"image.png", data:imageData)
			imagesInData.append(imageFile)
		}
		return imagesInData
	}
}
//
//  ParseHelper.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-07-26.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire
private let kParseTask = "Task"
private let kParseTaskPrivate = "TaskPrivate"
private let kParseTaskApplication = "TaskApplication"


class ApiHelper {
	
	//Login with Email
	
	/**
	Allows the user to login with email
	
	- parameter email:    Email
	- parameter password: Password
	- parameter block:    Block
	*/
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
	
	/**
	Allows the user to register with email
	
	- parameter email:    Email
	- parameter password: Password
	- parameter name:     Name of the user
	- parameter block:    Block
	*/
	static func registerWithEmail(email: String, password: String, firstName: String, lastName: String, block: (User?, NSError?) -> Void) {
		let user = PFUser()
		user.username = email
		user.email = email
		user.password = password
		user["firstName"] = firstName
		user["lastName"] = lastName
		user["name"] = "\(firstName) \(lastName)"
		user["skills"] = []
		user["experience"] = []
		user["education"] = []
		let userPrivate = PFObject(className: "UserPrivateData")
		userPrivate["email"] = email
		userPrivate["locations"] = []
		user["privateData"] = userPrivate
		
		user.signUpInBackgroundWithBlock { (ok, error) -> Void in
			if error != nil {
				block(nil, error)
			}
			
			if ok {
				block(User(parseUser: user), nil)
			} else {
			}
		}
	}
	
	
	//Login using Facebook
	
	/**
	Allows the user to login with facebook
	
	- parameter block: Block
	*/
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
		SupportKit.logout()
		PFUser.logOut()
	}
	
	
	//Get Facebook Informations
	/**
	Get user info from facebook
	
	- parameter block: block
	*/
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
		user.saveInBackground()
	}
	
	static func getCurrentUserPrivateInfo(){
		
		PFUser.currentUser()!.fetch()
		PFUser.currentUser()!["privateData"]!.fetchIfNeeded()
	}
	
	/**
	List the task according to the associate filters
	
	- parameter arrayOfFilters: Filters applied
	- parameter sortBy:         Sorting method
	- parameter minPrice:       Minimum price filter
	- parameter maxDistance:    maximum distance filter
	- parameter block:          block
	*/
	static func listNelpTasksWithBlock(arrayOfFilters:Array<String>?, sortBy: String?,minPrice: Double?, maxDistance: Double?,block: ([Task]?, NSError?) -> Void) {
		let taskQuery = PFQuery(className: kParseTask)
		if let arrayOfFilters = arrayOfFilters{
			if arrayOfFilters.count != 0{
			print(arrayOfFilters.count, terminator: "")
			var filters = Array<String>()
			for filter in arrayOfFilters{
				filters.append(filter)
				print(filter, terminator: "")
			}
			taskQuery.whereKey("category", containedIn:filters)
			}}
		
		if let minPrice = minPrice {
		 taskQuery.whereKey("priceOffered", greaterThanOrEqualTo: minPrice)
		}
		
		if let maxDistance = maxDistance {
			print(LocationHelper.sharedInstance.currentLocation!, terminator: "")
			print(maxDistance, terminator: "")
			let distance:Double = maxDistance
			taskQuery.whereKey("location", nearGeoPoint: LocationHelper.sharedInstance.currentLocation!, withinKilometers: distance)
		}
		print(sortBy)
		if let sortBy = sortBy{
			if sortBy == "distance" && maxDistance == nil{
					taskQuery.whereKey("location", nearGeoPoint: LocationHelper.sharedInstance.currentLocation)
			}else if sortBy == "priceOffered"{
			taskQuery.orderByDescending(sortBy)
			}
		}else{
			taskQuery.orderByDescending("createdAt")
		}
		taskQuery.includeKey("user")
		taskQuery.whereKey("state", equalTo: Task.State.Pending.rawValue)
		taskQuery.limit = 20
		taskQuery.findObjectsInBackgroundWithBlock { (pfTasks, error) -> Void in
			if error != nil {
				block(nil, error)
				return
			}
			if (PFUser.currentUser() != nil) {
				let applicationQuery = PFQuery(className: kParseTaskApplication)
				applicationQuery.whereKey("user", equalTo: PFUser.currentUser()!)
				applicationQuery.whereKey("state", equalTo: TaskApplication.State.Pending.rawValue)
				applicationQuery.whereKey("task", containedIn: pfTasks!)
				applicationQuery.findObjectsInBackgroundWithBlock({ (pfApplications, error) -> Void in
					if error != nil {
						block(nil, error)
						return
					}
					
					let tasks = pfTasks!.map({ (pfTask) -> Task in
						let task = Task(parseTask: pfTask as! PFObject)
						let index = pfApplications!.map({($0["task"] as! PFObject).objectId!}).indexOf(task.objectId)
						if let index = index {
							task.application = TaskApplication(parseApplication: pfApplications![index] as! PFObject)
						}
						
						return task
					})
					
					block(tasks, nil)
				})
			} else {
				print(pfTasks!.count)
				block(pfTasks!.map({ Task(parseTask: $0 as! PFObject) }), nil)
			}
		}
	}
	
	/**
	Lists the user's task
	
	- parameter block: block
	*/
	static func listMyNelpTasksWithBlock(block: ([FindNelpTask]?, NSError?) -> Void) {
		let taskQuery = PFQuery(className: kParseTask)
		taskQuery.whereKey("user", equalTo: PFUser.currentUser()!)
		taskQuery.whereKey("state", containedIn: [Task.State.Pending.rawValue, Task.State.Accepted.rawValue ])
		taskQuery.orderByDescending("createdAt")
		taskQuery.includeKey("privateData")
		taskQuery.limit = 20
		taskQuery.findObjectsInBackgroundWithBlock { (pfTasks, error) -> Void in
			if error != nil {
				block(nil, error)
				return
			}
			
			let applicationQuery = PFQuery(className: kParseTaskApplication)
			applicationQuery.includeKey("user")
			applicationQuery.whereKey("task", containedIn: pfTasks!)
			applicationQuery.whereKey("state", notEqualTo: TaskApplication.State.Canceled.rawValue)
			applicationQuery.findObjectsInBackgroundWithBlock({ (pfApplications, error) -> Void in
				if error != nil {
					block(nil, error)
					return
				}
				
				let tasks = pfTasks!.map({ (pfTask) -> FindNelpTask in
					let task = FindNelpTask(parseTask: pfTask as! PFObject)
					let applications = pfApplications!
						.filter({ ($0["task"] as! PFObject).objectId == task.objectId })
						.map({ TaskApplication(parseApplication: $0 as! PFObject) })
					
					task.applications = applications
					
					return task
				})
				
				block(tasks, nil)
			})
		}
		
	}
	
	/**
	List my Nelp Application
	
	- parameter block: block
	*/
	static func listMyNelpApplicationsWithBlock(block: ([TaskApplication]?, NSError?) -> Void) {
		let taskQuery = PFQuery(className: kParseTaskApplication)
		taskQuery.includeKey("task.user")
		taskQuery.whereKey("user", equalTo: PFUser.currentUser()!)
		taskQuery.whereKey("state", notEqualTo: TaskApplication.State.Canceled.rawValue)
		taskQuery.orderByDescending("createdAt")
		taskQuery.limit = 20
		taskQuery.findObjectsInBackgroundWithBlock { (pfTaskApplications, error) -> Void in
			if error != nil {
				block(nil, error)
				return
			}
			let applications = pfTaskApplications!.map({ (pfTaskApplication) -> TaskApplication in
			let application = TaskApplication(parseApplication: pfTaskApplication as! PFObject)
			return application
			})
			block(applications, nil)
		}
	}
	
	static func getTaskPrivateDataWithId(taskId: String, block: (TaskPrivate) -> Void) {
		GraphQLClient.query(
			"{ node(id: \"\(taskId)\") {" +
				"... on Task {" +
					"userPrivate {" +
						"phone," +
						"email," +
						"exactLocation {" +
							"streetNumber," +
							"route," +
							"city," +
							"province," +
							"country," +
							"postalCode," +
							"coords {latitude, longitude}" +
						"}" +
					"}" +
				"}" +
			"}}",
			variables: nil
		) { (data, error) -> Void in
			if let data = data {
				let dataTaskPrivate = data["node"]!!["userPrivate"]!!
				let taskPrivate = TaskPrivate()
				taskPrivate.email = dataTaskPrivate["email"] as? String
				taskPrivate.phone = dataTaskPrivate["phone"] as? String
				if let exactLocation = dataTaskPrivate["exactLocation"]! {
					taskPrivate.location = Location(parseLocation: exactLocation)
				}
				block(taskPrivate);
			}
		}
	}
	
	static func getApplicantPrivateDataWithBlock(block: () -> Void, taskId: String) {
		
	}
	
	
	/**
	Create a new task and store it in parse
	
	- parameter task:  task
	- parameter block: block
	*/
	
	static func addTask(task: FindNelpTask, block: (FindNelpTask?, NSError?) -> Void) {
		let user = PFUser.currentUser()!
		
		let parseTask = PFObject(className: kParseTask)
		parseTask["title"] = task.title
		parseTask["desc"] = task.desc
		parseTask["user"] = PFUser.currentUser()!
		parseTask["state"] = task.state.rawValue
		parseTask["completionState"] = task.completionState.rawValue
		parseTask["priceOffered"] = task.priceOffered
		parseTask["category"] = task.category
		let lat = task.location?.latitude
		let lng = task.location?.longitude
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
		
		let taskPrivate = PFObject(className: kParseTaskPrivate)
		if let exactLocation = task.exactLocation {
			var locationDict = exactLocation.createDictionary()
			// Remove the keys we dont care about.
			locationDict.removeValueForKey("name")
			locationDict.removeValueForKey("formattedAddress")
			taskPrivate["location"] = locationDict
		}
		let privateACL = PFACL(user: user)
		taskPrivate.ACL = privateACL
		
		parseTask["privateData"] = taskPrivate
		
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
	
 /**
	Sends the task modifications to the back end
	
	- parameter task: task
	*/
	
	static func editTask(task: FindNelpTask) {
		
		let query = PFQuery(className: "Task")
		query.getObjectInBackgroundWithId(task.objectId, block: { (taskFetched , error) -> Void in
			if error != nil{
				print(error)
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
	
	static func applyForTask(task: Task, price:Int) {
		let parseTask = PFObject(withoutDataWithClassName: kParseTask, objectId: task.objectId)
		let parseApplication = PFObject(className: kParseTaskApplication)
		parseApplication["state"] = TaskApplication.State.Pending.rawValue
		parseApplication["user"] = PFUser.currentUser()!
		parseApplication["task"] = parseTask
		parseApplication["isNew"] = true
		parseApplication["price"] = price
		task.application = TaskApplication(parseApplication: parseApplication)
		parseApplication.saveInBackgroundWithBlock { (ok, error) -> Void in
			task.application?.objectId = parseApplication.objectId
		}
	}
	
	//Cancel application on a task
	
	static func cancelApplyForTask(task: Task) {
		let parseApplication = PFObject(withoutDataWithClassName:kParseTaskApplication, objectId:task.application!.objectId)
		parseApplication["state"] = TaskApplication.State.Canceled.rawValue
		parseApplication.saveEventually()
	}
	
	static func cancelApplyForTaskWithApplication(application: TaskApplication) {
		print(application.objectId, terminator: "")
		let parseApplication = PFObject(withoutDataWithClassName:kParseTaskApplication, objectId:application.objectId)
		parseApplication["state"] = TaskApplication.State.Canceled.rawValue
		parseApplication.saveEventually()
	}
		
	//Accept applicant
	
	static func acceptApplication(application: TaskApplication, block: () -> Void) {
		GraphQLClient.mutation(
			"SetApplicationState",
			input: [
				"taskId": application.task.id,
				"applicationId": application.id,
				"state": "ACCEPTED",
			],
			block: {(data) -> Void in
				print(data)
				block()
			}
		)
	}
	
	//Deny an applicant
	
	static func denyApplication(application: TaskApplication, block: () -> Void) {
		GraphQLClient.mutation(
			"SetApplicationState",
			input: [
				"taskId": application.task.id,
				"applicationId": application.id,
				"state": "DENIED",
			],
			block: {(data) -> Void in
				block()
			}
		)
	}
	
	//Set task as viewed
	static func setTaskViewed(task: FindNelpTask) {
		let parseApplications = task.applications
			.filter({ $0.isNew })
			.map({ (a: TaskApplication) -> PFObject in
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
				print(error)
			}
			image = UIImage(data: data as NSData!)
			block(image)
		}
	}
	
	//Convert uploaded pictures to PFFile
	
	static func convertImagesToData(images:Array<UIImage>) -> Array<PFFile> {
		var imagesInData = Array<PFFile>()
		for image in images{
			let imageData = UIImageJPEGRepresentation(image as UIImage, 0.50)
			let imageFile = PFFile(name:"image.png", data:imageData!)
			imagesInData.append(imageFile)
		}
		return imagesInData
	}
	
	//Get privateData
	
	static func getUserPrivateData() -> UserPrivateData	{
		let userPrivateData = PFUser.currentUser()!["privateData"] as! PFObject
		
		return UserPrivateData(parsePrivateData: userPrivateData)
	}
	
	//Update notification settings
	
	static func updateNotificationSettings(notification: NotificationSettings) {
		let userPrivateData = PFUser.currentUser()!["privateData"] as! PFObject
		let notificationDict = [
			"posterApplication": ["email":notification.posterApplication.email],
			"posterRequestPayment": ["email":notification.posterRequestPayment.email],
			"nelperApplicationStatus": ["email":notification.nelperApplicationStatus.email],
			"nelperReceivedPayment": ["email":notification.nelperReceivedPayment.email],
			"newsletter": ["email":notification.newsletter.email]
		]
		
		
		userPrivateData["notifications"] = notificationDict
		userPrivateData.saveEventually()
	}
	
	//Update user locations
	
	static func updateUserLocations(locations: [Location]) {
		let userPrivateData = PFUser.currentUser()!["privateData"] as! PFObject
		let locationDict = locations.map { (location: Location) -> Dictionary<String,AnyObject> in
			return [
				"formattedAddress": location.formattedAddress!,
				"name": location.name!,
				"city": location.city!,
				"province": location.province!,
				"route": location.route!,
				"streetNumber": location.streetNumber!,
				"postalCode": location.postalCode!,
				"country": location.country!,
				"coords": location.coords!
			]
		}
		
		userPrivateData["locations"] = locationDict
		userPrivateData.saveEventually()
	}
	
	//Update account settings
	
	static func updateUserAccountSettings(email: String, phone: String?) {
		let userPrivateData = PFUser.currentUser()!["privateData"] as! PFObject
		
		userPrivateData["email"] = email
		userPrivateData["phone"] = phone
		userPrivateData.saveEventually()
	}
}
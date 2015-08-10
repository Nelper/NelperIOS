//
//  ParseHelper.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-07-26.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

private let kParseTask = "NelpTask"
private let kParseTaskApplication = "NelpTaskApplication"

class ApiHelper {
	
  static func loginWithEmail(email: String, password: String, block: (User?, NSError?) -> Void) {
    PFUser.logInWithUsernameInBackground(email, password: password) { (user, error) -> Void in
      if(error != nil) {
        block(nil, error)
        return
      }
      
      block(User(parseUser: user!), nil)
    }
  }
  
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
  
  static func logout() {
    PFUser.logOut()
  }
  
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
  
  static func setUserLocation(loc: GeoPoint) {
    let user = PFUser.currentUser()!
    user["location"] = PFGeoPoint(latitude: loc.latitude, longitude: loc.longitude)
    user.save()
  }
  
  static func listNelpTasksWithBlock(block: ([NelpTask]?, NSError?) -> Void) {
    let taskQuery = PFQuery(className: kParseTask)
		taskQuery.includeKey("user")
    taskQuery.orderByDescending("createdAt")
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
  
  static func listMyNelpTasksWithBlock(block: ([FindNelpTask]?, NSError?) -> Void) {
    let taskQuery = PFQuery(className: kParseTask)
    taskQuery.whereKey("user", equalTo: PFUser.currentUser()!)
    taskQuery.whereKey("state", containedIn: [NelpTask.State.Active.rawValue, NelpTask.State.Accepted.rawValue ])
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
		parseTask["pictures"] = [] //TODO: set this.
    
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
  
  static func deleteTask(task: FindNelpTask) {
    let parseTask = PFObject(className: kParseTask)
    parseTask.objectId = task.objectId
		parseTask["state"] = FindNelpTask.State.Deleted.rawValue
    parseTask.saveEventually()
  }
  
  static func applyForTask(task: NelpTask) {
    let parseTask = PFObject(className: kParseTask)
    parseTask.objectId = task.objectId
    let parseApplication = PFObject(className: kParseTaskApplication)
    parseApplication["state"] = NelpTaskApplication.State.Pending.rawValue
		parseApplication["user"] = PFUser.currentUser()!
    parseApplication["task"] = parseTask
    parseApplication["isNew"] = true
    task.application = NelpTaskApplication(parseApplication: parseApplication)
    parseApplication.saveEventually()
  }
  
  static func cancelApplyForTask(task: NelpTask) {
    let parseApplication = PFObject(className: kParseTaskApplication)
    parseApplication.objectId = task.objectId
    parseApplication.setValue(NelpTaskApplication.State.Canceled.rawValue, forKey: "state")
    parseApplication.saveEventually()
  }
  
  static func acceptApplication(application: NelpTaskApplication) {
    let parseApplication = PFObject(className: kParseTaskApplication)
    parseApplication.objectId = application.objectId
    parseApplication.setValue(NelpTaskApplication.State.Accepted.rawValue, forKey: "state:")
    let parseTask = PFObject(className: kParseTask)
    parseTask.objectId = application.task.objectId
    parseTask.setValue(FindNelpTask.State.Accepted.rawValue, forKey: "state")
    
    PFObject.saveAllInBackground([parseApplication, parseTask])
  }
  
  static func denyApplication(application: NelpTaskApplication) {
    let parseApplication = PFObject(className: kParseTaskApplication)
    parseApplication.objectId = application.objectId
    parseApplication.setValue(NelpTaskApplication.State.Denied.rawValue, forKey: "state:")
    parseApplication.saveEventually()
  }
  
  static func setTaskViewed(task: FindNelpTask) {
    let parseApplications = task.applications
      .filter({ $0.isNew })
      .map({ (a: NelpTaskApplication) -> PFObject in
        let parseApplication = PFObject(className: kParseTaskApplication)
        parseApplication.objectId = a.objectId
        parseApplication.setValue(false, forKey: "isNew")
        return parseApplication
      })
    
    PFObject.saveAllInBackground(parseApplications)
  }
}
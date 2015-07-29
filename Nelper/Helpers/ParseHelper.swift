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

class ParseHelper {
  
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
  
  static func createWithTitle(title: String, description: String, priceOffered:String) -> FindNelpTask {
    let user = PFUser.currentUser()!
    
    let parseTask = PFObject(className: kParseTask)
    parseTask["title"] = title
    parseTask["desc"] = description
    parseTask["user"] = user
    parseTask["state"] = 0
    parseTask["priceOffered"] = priceOffered
    
    let acl = PFACL(user: user)
    acl.setPublicReadAccess(true)
    acl.setPublicWriteAccess(false)
    parseTask.ACL = acl
    
    parseTask.saveEventually()
    
    return FindNelpTask(parseTask: parseTask)
  }
  
  static func listMyOffers(block: ([NelpTask]?, NSError?) -> Void) {
    let query = PFQuery(className: kParseTask)
    query.whereKey("user", equalTo: PFUser.currentUser()!)
    query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
      if error != nil {
        block(nil, error)
      } else {
        let tasks = objects as! [NelpTask]
        block(tasks, nil)
      }
    }
  }
}
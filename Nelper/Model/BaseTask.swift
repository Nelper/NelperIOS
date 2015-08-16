//
//  BaseTask.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-28.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire

class BaseTask: BaseModel {
  
  enum State: Int {
    case Active = 0
    case Accepted
    case Deleted
  }
  
  var title: String!
  var desc: String!
  var user: User!
  var location : GeoPoint?
	var city: String?
  var priceOffered: String?
	var category: String?
  var pictures: Array<PFFile>?
  var state: State = .Active
	var createdAt: NSDate!
  
  override init() {
    super.init()
  }
  
  convenience init(parseTask: PFObject) {
    self.init()
    
    objectId = parseTask.objectId!
    title = parseTask["title"] as! String
    desc = parseTask["desc"] as! String
		category = parseTask["category"] as? String
		createdAt = parseTask.createdAt
		if(parseTask["user"] != nil){
    user = User(parseUser: parseTask["user"] as! PFUser)
		}
    let pfLoc = parseTask["location"] as? PFGeoPoint
    if let pfLoc = pfLoc {
      location = GeoPoint(
        latitude: pfLoc.latitude,
        longitude: pfLoc.longitude
      )
    }
    priceOffered = parseTask["priceOffered"] as? String
		
		if(parseTask["pictures"] != nil){
    var picturesPF = parseTask["pictures"] as! [PFFile]
			if(!picturesPF.isEmpty){
		pictures = picturesPF
			}
		}
    state = State(rawValue: parseTask["state"] as! Int)!
  }
	
	func getArrayOfPictures(arrayOfPictures: Array<PFFile>) -> Array<UIImage> {
		var arrayOfImages: Array = Array<UIImage>()
		
		for picture in arrayOfPictures{
			request(.GET,picture.url!).response(){
				(_, _, data, error) in
				if(error != nil){
					println(error)
				}
				var image = UIImage(data: data as NSData!)
				arrayOfImages.append(image!)
			}
		}
		return arrayOfImages
	}
}
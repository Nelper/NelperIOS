//
//  Nelp.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-03.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire


class Task: BaseModel {
	
	var applications = [TaskApplication]()
	var application:TaskApplication?
	var title: String!
	var desc: String!
	var user: User!
	var location : GeoPoint?
	var exactLocation: Location?
	var city: String?
	var priceOffered: Double?
	var category: String?
	var pictures: Array<PFFile>?
	var state: State = .Pending
	var completionState: CompletionState = .Accepted
	var createdAt: NSDate!
	
	enum State: Int {
		case Pending = 0
		case Accepted
		case Deleted
		case Completed
	}
	
	enum CompletionState: Int{
		case Accepted = 0
		case PaymentSent
		case Completed
		case PaymentRequested
		case Rated
	}
	var id: String {
		get {
			return GraphQLClient.toGlobalId("Task", id: self.objectId)
		}
	}
	
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
		if (parseTask["user"] != nil) {
			user = User(parseUser: parseTask["user"] as! PFUser)
		}
		let pfLoc = parseTask["location"] as? PFGeoPoint
		if let pfLoc = pfLoc {
			location = GeoPoint(
				latitude: pfLoc.latitude,
				longitude: pfLoc.longitude
			)
		}
		city = parseTask["city"] as? String
		if let taskPrivateData = parseTask["privateData"] as? PFObject {
			if taskPrivateData.isDataAvailable() {
				exactLocation = Location(parseLocation: taskPrivateData["location"]!)
			}
		}
		priceOffered = parseTask["priceOffered"] as? Double
		if(parseTask["pictures"] != nil) {
			let picturesPF = parseTask["pictures"] as! [PFFile]
			if(!picturesPF.isEmpty){
				pictures = picturesPF
			}
		}
		state = State(rawValue: parseTask["state"] as! Int)!
		completionState = CompletionState(rawValue: parseTask["completionState"] as! Int)!
	}
	
	func getArrayOfPictures(arrayOfPictures: Array<PFFile>) -> Array<UIImage> {
		var arrayOfImages: Array = Array<UIImage>()
		
		for picture in arrayOfPictures{
			request(.GET,picture.url!).response(){
				(_, _, data, error) in
				if(error != nil){
					print(error)
				}
				let image = UIImage(data: data as NSData!)
				arrayOfImages.append(image!)
			}
		}
		return arrayOfImages
	}
}
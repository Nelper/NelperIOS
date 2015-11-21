//
//  BrowseMKAnnotation.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-10-27.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import MapKit

class BrowseMKAnnotation: NSObject, MKAnnotation {
	
	var coordinate: CLLocationCoordinate2D
	var task: Task
	var image: UIImage?
	var title: String?
	var category: String?
	var price: Double?
	var poster: String?
	var date: NSDate?
	var tag: Int?
	
	init(coordinate: CLLocationCoordinate2D, task: Task, image: UIImage, title: String, category: String, price: Double, poster: String, date: NSDate, tag: Int) {
		self.coordinate = coordinate
		self.task = task
		self.image = image
		self.title = title
		self.category = category
		self.price = price
		self.poster = poster
		self.date = date
		self.tag = tag
	}
}

class mapTaskButton: UIButton {
	var selectedTask: Task?
}
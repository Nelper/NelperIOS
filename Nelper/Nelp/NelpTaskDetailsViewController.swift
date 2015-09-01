//
//  NelpTaskDetailsViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-06.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import iCarousel

class NelpTasksDetailsViewController: UIViewController,iCarouselDataSource,iCarouselDelegate{
	

	@IBOutlet weak var navBar: NavBar!
	@IBOutlet weak var container: UIView!
	
	@IBOutlet weak var carousel: iCarousel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var profilePicture: UIImageView!
	@IBOutlet weak var categoryPicture: UIImageView!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var creationDateLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var applyButton: UIButton!
	
	var task: NelpTask!
	//	var carousel:iCarousel!
	var pageViewController: UIPageViewController?
	var pictures:NSArray?
	
	
	
	//Initialization
	
	convenience init(nelpTask:NelpTask) {
		self.init(nibName: "NelpTaskDetailsViewController", bundle: nil)
		self.task = nelpTask;
		self.pictures = self.task.pictures
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.adjustUI()
		if(self.task.pictures != nil){
			self.createCarousel()
		}
		self.startButtonConfig()
	}
	
	//UI
	
	func adjustUI(){
		self.navBar.backgroundColor = navBarColor
		self.container.backgroundColor = whiteNelpyColor
		self.navBar.setTitle("Task Details")

		let backBtn = UIButton()
		backBtn.addTarget(self, action: "backButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
		self.navBar.backButton = backBtn
		
		self.titleLabel.text = self.task.title
		self.titleLabel.textColor = blackNelpyColor
		self.titleLabel.font = UIFont(name: "HelveticaNeue", size: kDetailsViewTitleFontSize)
		
		self.authorLabel.text = "By \(self.task.user.name)"
		self.authorLabel.textColor = blackNelpyColor
		self.authorLabel.font = UIFont(name: "HelveticaNeue", size: kDetailsViewTextFontSize)
		
		if(self.task.createdAt != nil){
			self.creationDateLabel.text = "Created \(timeAgoSinceDate(self.task.createdAt!, numericDates: true))"
			self.creationDateLabel.textColor = blackNelpyColor
			self.creationDateLabel.font = UIFont(name: "HelveticaNeue", size: kDetailsViewTextFontSize)
		}else{
			self.creationDateLabel.text = "Unknown creation date"
			self.creationDateLabel.textColor = blackNelpyColor
			self.creationDateLabel.font = UIFont(name: "HelveticaNeue", size: kDetailsViewTextFontSize)
		}
		
		self.priceLabel.backgroundColor = greenPriceButton
		self.priceLabel.layer.cornerRadius = 6
		self.priceLabel.font = UIFont(name: "HelveticaNeue", size: kCellPriceFontSize)
		self.priceLabel.textColor = whiteNelpyColor
		self.priceLabel.clipsToBounds = true
		self.priceLabel.textAlignment = NSTextAlignment.Center
		var price = String(format: "%.0f", self.task.priceOffered!)
		self.priceLabel.text = "$"+price

		
		self.profilePicture.layer.masksToBounds = true
		self.setProfilePicture(self.task)
		
		self.descriptionTextView.backgroundColor = whiteNelpyColor
		self.descriptionTextView.text = self.task.desc
		self.descriptionTextView.font = UIFont(name: "HelveticaNeue", size: kDetailsViewTextFontSize)
		self.descriptionTextView.textColor = blackNelpyColor
		self.descriptionTextView.editable = false
		
		let fixedWidth = self.descriptionTextView.frame.size.width
		self.descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		let newSize = self.descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
		var newFrame = self.descriptionTextView.frame
		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		self.descriptionTextView.frame = newFrame;
		
		self.carousel.backgroundColor = whiteNelpyColor
		
		self.applyButton.setTitle("Apply", forState: UIControlState.Normal)
		self.applyButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: kButtonFontSize)
		self.applyButton.setTitleColor(whiteNelpyColor, forState: UIControlState.Normal)
		self.applyButton.backgroundColor = greenPriceButton
		
	}
	
	func createCarousel(){
		//		var carousel = iCarousel()
		self.carousel.type = .Rotary
		self.carousel.dataSource = self
		self.carousel.delegate = self
		self.carousel.reloadData()
	}
	
	
	//iCarousel Delegate
	
	func numberOfItemsInCarousel(carousel: iCarousel!) -> Int {
		
		if self.task.pictures != nil {
			if self.task.pictures!.count == 1 {
				self.carousel.scrollEnabled = false
			}
			
			return self.task.pictures!.count
		}
		
		return 0
	}
	
	
 func carousel(carousel: iCarousel!, viewForItemAtIndex index: Int, reusingView view: UIView!) -> UIView! {
		var picture = UIImageView(frame: self.carousel.frame)
		picture.clipsToBounds = true
		var imageURL = self.task.pictures![index].url!
		getPictures(imageURL, block: { (imageReturned:UIImage) -> Void in
			picture.image = imageReturned
		})
		picture.contentMode = .ScaleAspectFit
		return picture
	}
	
	//IBActions
	
	@IBAction func applyButtonTapped(sender: AnyObject) {
		if(!self.applyButton.selected){
			ApiHelper.applyForTask(self.task)
			self.applyButton.selected = true
			self.updateButton()
		}else{
			ApiHelper.cancelApplyForTask(self.task)
			self.applyButton.selected = false
			self.task.application!.state = .Canceled
			self.updateButton()
		}
	}
	
	//Actions
	
	func backButtonTapped(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
		view.endEditing(true) // dissmiss keyboard without delay
	}
	
	//Utilities
	
	func startButtonConfig(){
		if self.task.application != nil && self.task.application!.state != .Canceled {
			self.applyButton.selected = true
			self.updateButton()
		} else {
			self.applyButton.selected = false
			self.updateButton()
		}
	}
	
	func updateButton(){
		if self.applyButton.selected {
			self.applyButton.setTitle("Applied", forState: UIControlState.Selected)
			self.applyButton.backgroundColor = blueGrayColor
		} else {
			self.applyButton.setTitle("Apply", forState: UIControlState.Normal)
			self.applyButton.backgroundColor = greenPriceButton
		}
	}
	
	
	func setProfilePicture(nelpTask:NelpTask){
		if(nelpTask.user.profilePictureURL != nil){
			var fbProfilePicture = nelpTask.user.profilePictureURL
			request(.GET,fbProfilePicture!).response(){
				(_, _, data, _) in
				var image = UIImage(data: data as NSData!)
				self.profilePicture.image = image
				self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
				self.profilePicture.clipsToBounds = true;
				self.profilePicture.layer.borderWidth = 3;
				self.profilePicture.layer.borderColor = blackNelpyColor.CGColor
				self.profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
				
				self.categoryPicture.layer.cornerRadius = self.categoryPicture.frame.size.width / 2;
				self.categoryPicture.clipsToBounds = true;
				self.categoryPicture.image = UIImage(named: nelpTask.category!)
			}
		}
		var image = UIImage(named: "noProfilePicture")
		self.profilePicture.image = image
		self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
		self.profilePicture.clipsToBounds = true;
		self.profilePicture.layer.masksToBounds = true
		self.profilePicture.layer.borderWidth = 3;
		self.profilePicture.layer.borderColor = blackNelpyColor.CGColor
		self.profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
		
		self.categoryPicture.layer.cornerRadius = self.categoryPicture.frame.size.width / 2;
		self.categoryPicture.clipsToBounds = true;
		self.categoryPicture.image = UIImage(named: nelpTask.category!)
	}
	
	
	func getPictures(imageURL: String, block: (UIImage) -> Void) -> Void {
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
	
	func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
		let calendar = NSCalendar.currentCalendar()
		let unitFlags = NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitWeekOfYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitSecond
		let now = NSDate()
		let earliest = now.earlierDate(date)
		let latest = (earliest == now) ? date : now
		let components:NSDateComponents = calendar.components(unitFlags, fromDate: earliest, toDate: latest, options: nil)
		if (components.year >= 2) {
			return "\(components.year) years ago"
		} else if (components.year >= 1){
			if (numericDates){
				return "1 year ago"
			} else {
				return "Last year"
			}
		} else if (components.month >= 2) {
			return "\(components.month) months ago"
		} else if (components.month >= 1){
			if (numericDates){
				return "1 month ago"
			} else {
				return "Last month"
			}
		} else if (components.weekOfYear >= 2) {
			return "\(components.weekOfYear) weeks ago"
		} else if (components.weekOfYear >= 1){
			if (numericDates){
				return "1 week ago"
			} else {
				return "Last week"
			}
		} else if (components.day >= 2) {
			return "\(components.day) days ago"
		} else if(components.day >= 1){
			if (numericDates){
				return "1 day ago"
			} else {
				return "Yesterday"
			}
		} else if (components.hour >= 2) {
			return "\(components.hour) hours ago"
		} else if (components.hour >= 1){
			if (numericDates){
				return "1 hour ago"
			} else {
				return "An hour ago"
			}
		} else if (components.minute >= 2) {
			return "\(components.minute) minutes ago"
		} else if (components.minute >= 1){
			if (numericDates){
				return "1 minute ago"
			} else {
				return "A minute ago"
			}
		} else if (components.second >= 3) {
			return "\(components.second) seconds ago"
		} else {
			return "Just now"
		}
	}
	
	
}
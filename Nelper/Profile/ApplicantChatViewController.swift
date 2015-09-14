//
//  ApplicantChatViewController.swift
//  Nelper
//
//  Created by Charles Vinette on 2015-08-31.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import UIKit

class ApplicantChatViewController : ATLConversationViewController, ATLConversationViewControllerDataSource, ATLConversationViewControllerDelegate {
	
	var dateFormatter: NSDateFormatter = NSDateFormatter()
	var usersArray: NSArray!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.dataSource = self
		self.delegate = self
		self.configureUI()
	}
	
	// MARK - UI
	func configureUI(){
		ATLOutgoingMessageCollectionViewCell.appearance().bubbleViewColor = nelperRedColor
//		self.conversation.sendTypingIndicator(LYRTypingIndicator.DidBegin)
	}
	
	// MARK - ATLConversationViewControllerDelegate Methods
	
	func conversationViewController(viewController: ATLConversationViewController, didSendMessage message: LYRMessage) {
		println("Message sent!")
	}
	
	func conversationViewController(viewController: ATLConversationViewController, didFailSendingMessage message: LYRMessage, error: NSError?) {
		println("Message failed to sent with error: \(error)")
	}
	
	func conversationViewController(viewController: ATLConversationViewController, didSelectMessage message: LYRMessage) {
		println("Message selected")
	}

	
	
	// MARK - ATLConversationViewControllerDataSource methods
	
	func conversationViewController(conversationViewController: ATLConversationViewController, participantForIdentifier participantIdentifier: String) -> ATLParticipant? {
			return PFUser.currentUser()!
		}
	
	func conversationViewController(conversationViewController: ATLConversationViewController, attributedStringForDisplayOfDate date: NSDate) -> NSAttributedString? {
		let attributes: NSDictionary = [ NSFontAttributeName : UIFont.systemFontOfSize(14), NSForegroundColorAttributeName : UIColor.grayColor() ]
		return NSAttributedString(string: self.dateFormatter.stringFromDate(date), attributes: attributes as? [String : AnyObject])
	}
	
	
	/**
	Allow us to change the Chat View Controller Appearance
	
	- parameter conversationViewController: The VC to change
	- parameter recipientStatus:            recipient status
	
	- returns: Description
	*/
	func conversationViewController(conversationViewController: ATLConversationViewController, attributedStringForDisplayOfRecipientStatus recipientStatus: [NSObject:AnyObject]) -> NSAttributedString? {
		if (recipientStatus.count == 0) {
			return nil
		}
		let mergedStatuses: NSMutableAttributedString = NSMutableAttributedString()
		
		let recipientStatusDict = recipientStatus as NSDictionary
		let allKeys = recipientStatusDict.allKeys as NSArray
		allKeys.enumerateObjectsUsingBlock { participant, _, _ in
			let participantAsString = participant as! String
			if (participantAsString == self.layerClient.authenticatedUserID) {
				return
			}
			
			let checkmark: String = "✔︎"
			var textColor: UIColor = UIColor.lightGrayColor()
			let status: LYRRecipientStatus! = LYRRecipientStatus(rawValue: recipientStatusDict[participantAsString]!.unsignedIntegerValue)
			switch status! {
			case .Sent:
				textColor = UIColor.lightGrayColor()
			case .Delivered:
				textColor = UIColor.orangeColor()
			case .Read:
				textColor = greenPriceButton
			default:
				textColor = UIColor.lightGrayColor()
			}
			let statusString: NSAttributedString = NSAttributedString(string: checkmark, attributes: [NSForegroundColorAttributeName: textColor])
			mergedStatuses.appendAttributedString(statusString)
		}
		return mergedStatuses;
	}
}
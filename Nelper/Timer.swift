//
//  Timer.swift
//  Nelper
//
//  Created by Pierre-Luc Benoit on 2015-11-15.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation

public class Timer {
	private var handler: (timer: NSTimer) -> () = { (timer: NSTimer) in }
	
	public class func start(duration: NSTimeInterval, repeats: Bool, handler:(timer: NSTimer) -> ()) {
		let t = Timer()
		t.handler = handler
		NSTimer.scheduledTimerWithTimeInterval(duration, target: t, selector: "processHandler:", userInfo: nil, repeats: repeats)
	}
	
	@objc private func processHandler(timer: NSTimer) {
		self.handler(timer: timer)
	}
}
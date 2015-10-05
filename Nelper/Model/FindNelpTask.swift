//
//  FindNelpTask.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-07-28.
//  Copyright (c) 2015 Nelper. All rights reserved.
//

import Foundation

class FindNelpTask: BaseTask {
	
	enum CompletionState: Int {
		case Accepted = 0
		case PaymentState
		case Completed
		case Rated
	}
  
  var applications = [TaskApplication]()
	var completionState: CompletionState = .Accepted
  
}
//
//  GraphQLClient.swift
//  Nelper
//
//  Created by Janic Duplessis on 2015-10-11.
//  Copyright © 2015 Nelper. All rights reserved.
//

import Foundation
import Alamofire

class GraphQLClient {
	static private let endpoint = "https://www.nelper.ca/graphql"
	static private var headers = [
		"Authorization": "",
		"Content-Type": "application/json",
		"Accept": "*/*",
	]
	static private var clientMutationId = 0
	
	static var userId: String? {
		didSet {
			self.updateAuthHeader()
		}
	}
	static var sessionToken: String? {
		didSet {
			self.updateAuthHeader()
		}
	}
	
	static func query(query: String, variables: Dictionary<String, AnyObject>?, block: ((AnyObject?, ErrorType?) -> Void)?) {
		sendRequest(query, variables: variables, block: block)
	}
	

	static func mutation(name: String, var input: Dictionary<String, AnyObject>, block: ((AnyObject?, ErrorType?) -> Void)?) {
		// The mutation is the name of the mutation with the first letter as lowercase.
		var mutation = String(name)
		mutation.replaceRange(name.startIndex...name.startIndex, with: String(name[name.startIndex]).lowercaseString)
		// Build the mutation query string.
		let query = "mutation \(name)($input: \(name)Input!){\(mutation)(input:$input){clientMutationId}}"
		// Add the clientMutationId.
		input["clientMutationId"] = self.getClientMutationId()
		let variables = ["input": input]
		sendRequest(query, variables: variables, block: block)
	}
	
	static func toGlobalId(type: String, id: String) -> String {
		let str = "\(type):\(id)"
		let utf8str = str.dataUsingEncoding(NSUTF8StringEncoding)
		return utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
	}
	
	private static func sendRequest(query: String, variables: Dictionary<String, AnyObject>?, block: ((AnyObject?, ErrorType?) -> Void)?) {
		
		var parameters: Dictionary<String, AnyObject>
		if let variables = variables {
			parameters = [
				"query": query,
				"variables": variables,
			]
		} else {
			parameters = [
				"query": query,
			]
		}
		
		request(.POST, self.endpoint, parameters: parameters, encoding: .JSON, headers: self.headers)
			.responseJSON { response in
				if let block = block {
					block(response.result.value, response.result.error)
				}
		}
	}
	
	private static func updateAuthHeader() {
		if self.userId != nil && self.sessionToken != nil {
			self.headers["Authorization"] = "\(self.userId!)-\(self.sessionToken!)"
		}
	}
	
	private static func getClientMutationId()-> String {
		let id = self.clientMutationId
		self.clientMutationId++
		return "\(id)"
	}
}
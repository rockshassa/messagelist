//
//  API.swift
//  messagelist
//
//  Created by Nicholas Galasso on 7/9/19.
//  Copyright © 2019 Rockshassa. All rights reserved.
//

import Foundation

enum ResponseCode {
    case success(data:Response)
    case failure(error:Error?)
}

typealias RequestCompletion = (ResponseCode) -> Void

class API {
    
    static let baseUrl = URL(string: "https://message-list.appspot.com")!
    fileprivate static let messagesEndpoint = baseUrl.appendingPathComponent("messages")
    
    private static func messageUrl(_ pageToken:String?)-> URL? {
        var components = URLComponents(url: messagesEndpoint, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "pageToken", value: pageToken)]
        return components?.url
    }
    
    static func fetchMessages(_ pageToken:String? = nil, completion: @escaping RequestCompletion){
        
        guard let url = messageUrl(pageToken) else {
            abort() //TODO: better handling in this case
        }
        
        URLSession.shared.dataTask(with: url) { (data, resp, error) in
            
            var response:Response?
            var reportedError = error
            
            do {
                if let d = data {
                    response = try JSONDecoder().decode(Response.self, from: d)
                }
            } catch let parseError {
                print("parse error; \(parseError)")
                reportedError = parseError
            }
            
            DispatchQueue.main.async {
                if reportedError != nil {
                    completion(.failure(error: reportedError))
                } else if response != nil {
                    completion(.success(data: response!))
                }
            }
            
        }.resume()
    }
}


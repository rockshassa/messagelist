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
            completion(.failure(error: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
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
            
            if let r = response, reportedError == nil {
                completion(.success(data: r))
            } else {
                completion(.failure(error: reportedError))
            }
            
        }.resume()
    }
}


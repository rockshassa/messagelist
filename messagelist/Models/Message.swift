//
//  Message.swift
//  messagelist
//
//  Created by Nicholas Galasso on 7/9/19.
//  Copyright © 2019 Rockshassa. All rights reserved.
//

import Foundation
import CoreData

class Message : Decodable {
    var id:Int
    var author:Author
    var updated:String
    var content:String
}

class Author : Decodable {
    var name:String
    var photoUrl:String
}

//use this to model the API response
class Response : Decodable {
    var count:Int
    var messages:[Message]
    var pageToken:String
}

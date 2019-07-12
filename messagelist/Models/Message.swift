//
//  Message.swift
//  messagelist
//
//  Created by Nicholas Galasso on 7/9/19.
//  Copyright © 2019 Rockshassa. All rights reserved.
//

import Foundation
import CoreData

/*
 {
 'count': number of messages,
 'messages': {
     'id': integer message ID
     'author': {
         'name': name of the message author,
         'photoUrl': photo of the message author,
        },
     'updated': UTC timestamp of the messages creation time,
     'content': message content,
 },
 'pageToken': a continuation token for the next page of messages
 }
 */

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

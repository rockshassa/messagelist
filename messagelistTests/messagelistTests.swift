//
//  messagelistTests.swift
//  messagelistTests
//
//  Created by Nicholas Galasso on 7/12/19.
//  Copyright © 2019 Rockshassa. All rights reserved.
//

import XCTest

class messagelistTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeserialization(){
        let bundle = Bundle(for: messagelistTests.self)
        let path = bundle.path(forResource: "sample", ofType: "json")
        
        var response:Response!
        do {
            let data = try Data.init(contentsOf: URL(fileURLWithPath: path!))
            response = try JSONDecoder().decode(Response.self, from: data)
        } catch let err {
            print(err.localizedDescription)
            XCTFail()
        }
        
        XCTAssert(response != nil)
        XCTAssert(response.count == 10)
        XCTAssert(response.pageToken == "Cj4KEAoKbWVzc2FnZV9pZBICCAoSJmoOc35tZXNzYWdlLWxpc3RyFAsSB01lc3NhZ2UYgICAgOvJkQoMGAAgAA==")
        
        let first:Message! = response.messages.first
        XCTAssert(first != nil)
        
        XCTAssert(first.author.name == "William Shakespeare")
        XCTAssert(first.author.photoUrl == "/photos/william-shakespeare.jpg")
        
        XCTAssert(first.id == 1)
        XCTAssert(first.updated == "2015-02-01T07:46:23Z")
        XCTAssert(first.content == "Her pretty looks have been mine enemies, And therefore have I invoked thee for her seal, and meant thereby Thou shouldst print more, not let that pine to aggravate thy store Buy terms divine in selling hours of dross Within be fed, without be rich no more So shalt thou feed on Death, that feeds on men, And Death once dead, there's no more to shame nor me nor you.")
        
    }

}

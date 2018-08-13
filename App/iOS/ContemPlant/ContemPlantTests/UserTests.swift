//
//  UserTests.swift
//  ContemPlantTests
//
//  Created by Gero Embser on 17.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import XCTest

@testable import ContemPlant
import SwiftyUserDefaults

class UserTests: XCTestCase {

    var dummyUser: User! = nil
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //setup dummy user
        dummyUser = User.login(with: "best", email: "test@me.com", accessToken: "MeMeMe")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        //remove dummy user
        dummyUser = nil
        
        //clear defaults
        Defaults.removeAll()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testLoginUserSavedToDefaults() {
        // WHY IS IT REQUIRED TO HAVE EXPLICITLY ": User!" to let newUser be also an implicitly unwrapped optional -> does type inference not work here?
        let newUser: User! = dummyUser
        
        //test properties
        XCTAssertEqual(newUser.username, "best")
        XCTAssertEqual(newUser.email, "test@me.com")
        XCTAssertEqual(newUser.jwt, "MeMeMe")
        XCTAssertEqual(newUser.loggedIn, true)
        
        XCTAssertNotNil(Defaults[.loggedInUser])
        XCTAssertEqual(Defaults[.loggedInUser]?.username, newUser.username)
        XCTAssertEqual(Defaults[.loggedInUser]?.email, newUser.email)
        XCTAssertEqual(Defaults[.loggedInUser]?.jwt, newUser.jwt)
        XCTAssertEqual(Defaults[.loggedInUser]?.loggedIn, newUser.loggedIn)
    }
    
    func testLogoutUserSavedToDefaults() {
        let loggedInUser: User! = dummyUser
        
        XCTAssertTrue(loggedInUser.loggedIn)
        
        loggedInUser.logout()
        
        XCTAssertFalse(loggedInUser.loggedIn)
        
        XCTAssertNil(Defaults[.loggedInUser])
    }
    
    

}

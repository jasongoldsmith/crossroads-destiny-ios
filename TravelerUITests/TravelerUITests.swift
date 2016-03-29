//
//  TravelerUITests.swift
//  TravelerUITests
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import XCTest

class TravelerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        if #available(iOS 9.0, *) {
            XCUIApplication().launch()
        } else {
            // Fallback on earlier versions
        }

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testSignIn() {
        if #available(iOS 9.0, *) {
            XCUIDevice.sharedDevice().orientation = .FaceUp
            XCUIDevice.sharedDevice().orientation = .FaceUp
            
            let app = XCUIApplication()
            app.buttons["SIGN IN"].tap()
            app.textFields["Enter username"].tap()
            app.typeText("bender")
            sleep(2)
            app.secureTextFields["Enter password"].tap()
            app.typeText("password")
            app.buttons["TrImgLoginBtn"].tap()
            
            sleep(5)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func testSignUp() {
        if #available(iOS 9.0, *) {
            let app = XCUIApplication()
            app.buttons["CREATE ACCOUNT"].tap()
            app.textFields["Enter username"].tap()
            app.textFields["Enter username"]
            app.secureTextFields["Enter password"].tap()
            app.secureTextFields["Enter password"]
            app.textFields["Enter PSN ID"].tap()
            app.textFields["Enter PSN ID"]
            app.buttons["TrImgLoginBtn"].tap()
        } else {
            // Fallback on earlier versions
        }
    }
}

//
//  RoutingTest.swift
//  WorkGroupTests
//
//  Created by Aybatu KERKUKLUOGLU on 21/06/2023.
//

import XCTest

final class RoutingTest: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoginAndDisplayManagerMenu() {
        // 1. Tap on the login button to go to the login screen
        app.buttons["Login"].tap()

        // 2. Enter the login credentials
        let usernameTextField = app.textFields["Username"]
        let passwordTextField = app.secureTextFields["Password"]

        usernameTextField.tap()
        usernameTextField.typeText("manager")
        passwordTextField.tap()
        passwordTextField.typeText("manager")

        // 3. Tap on the login button
        app.buttons["Login"].tap()

        // 4. Wait for the manager menu screen to appear
        let managerMenuScreen = app.navigationBars["Manager Menu"]
        XCTAssertTrue(managerMenuScreen.waitForExistence(timeout: 5), "Manager menu screen did not appear")

        // 5. Verify that the manager menu screen is displayed
        XCTAssertTrue(managerMenuScreen.exists, "Manager menu screen not displayed")
    }
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}


//
//  Eat_the_AlphabetUITests.swift
//  Eat the AlphabetUITests
//
//  Created by Kenny Beaverson on 6/1/25.
//

import XCTest

final class Eat_the_AlphabetUITests: XCTestCase {
    let app = XCUIApplication()

    // Put setup code here. This method is called before the invocation of each test method in the class.
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false    // Stop if failure occurs

        // Set up initial application state
        XCUIDevice.shared.orientation = .portrait   // Set device orientation to portrait
        
        app.launch()    // Launch application
    }

    // Put teardown code here. This method is called after the invocation of each test method in the class.
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    @MainActor
    func testExample() throws {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(true, "Test test passed")
    }
    
    @MainActor
    func testFriendsViewLoadsAllElements() throws {
        let app = XCUIApplication()
        app.activate()
        
        // Given
        let friendsButton = app/*@START_MENU_TOKEN@*/.images["person.3.fill"]/*[[".buttons[\"Friends\"].images.firstMatch",".buttons.images[\"person.3.fill\"]",".images[\"person.3.fill\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        // When
        friendsButton.tap()
        
        // Then
        let element = app.otherElements/*@START_MENU_TOKEN@*/.containing(.staticText, identifier: "Friends View").firstMatch/*[[".element(boundBy: 14)",".containing(.staticText, identifier: \"Friends View\").firstMatch"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(element.exists)
    }
    
    @MainActor
    func testChallengesViewLoadsAllButtons() throws {
        let app = XCUIApplication()
        app.activate()
        
        // Given
        let challengesButton = app/*@START_MENU_TOKEN@*/.images["tray.and.arrow.up.fill"]/*[[".buttons[\"Challenges\"].images.firstMatch",".buttons",".images[\"outbox\"]",".images[\"tray.and.arrow.up.fill\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/
        
        // When
        challengesButton.tap()
        
        // Then
        let createChallengeButton = app/*@START_MENU_TOKEN@*/.buttons["plus"]/*[[".otherElements[\"plus\"].buttons.firstMatch",".otherElements",".buttons[\"Add\"]",".buttons[\"plus\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(createChallengeButton.exists)
        
        let selectAllButton = app/*@START_MENU_TOKEN@*/.buttons["Select All"]/*[[".otherElements[\"Select All\"].buttons.firstMatch",".otherElements.buttons[\"Select All\"]",".buttons[\"Select All\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(selectAllButton.exists)
        
        let searchButton = app/*@START_MENU_TOKEN@*/.buttons["magnifyingglass"]/*[[".otherElements[\"magnifyingglass\"].buttons.firstMatch",".otherElements",".buttons[\"Search\"]",".buttons[\"magnifyingglass\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(searchButton.exists)
    }
    
    @MainActor
    func testAccountViewLoadsAllElements() throws {
        let app = XCUIApplication()
        app.activate()
        
        // Given
        let accountButton = app/*@START_MENU_TOKEN@*/.images["person.crop.circle.fill"]/*[[".buttons[\"Account\"].images.firstMatch",".buttons",".images[\"account\"]",".images[\"person.crop.circle.fill\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/
        
        // When
        accountButton.tap()
        
        // Then
        let helloUserStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Hello, User"]/*[[".otherElements.staticTexts[\"Hello, User\"]",".staticTexts[\"Hello, User\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(helloUserStaticText.exists)
        
        let restaurantRatingsStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Restaurant Ratings"]/*[[".otherElements.staticTexts[\"Restaurant Ratings\"]",".staticTexts[\"Restaurant Ratings\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(restaurantRatingsStaticText.exists)

        let experiencesByDayStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Experiences by Day"]/*[[".otherElements.staticTexts[\"Experiences by Day\"]",".staticTexts[\"Experiences by Day\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(experiencesByDayStaticText.exists)
        
        let cuisinesVisitedStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Cuisines Visited"]/*[[".otherElements.staticTexts[\"Cuisines Visited\"]",".staticTexts[\"Cuisines Visited\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(cuisinesVisitedStaticText.exists)

        let logoutButton = app/*@START_MENU_TOKEN@*/.buttons["Logout"]/*[[".otherElements.buttons[\"Logout\"]",".buttons[\"Logout\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(logoutButton.exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}

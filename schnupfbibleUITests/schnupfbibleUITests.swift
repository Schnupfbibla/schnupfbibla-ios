//
//  schnupfbibleUITests.swift
//  schnupfbibleUITests
//
//  Created by Jesse Born on 26.01.23.
//

import XCTest

final class schnupfbibleUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()

        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--screenshots")
    }

    override func tearDownWithError() throws {
        app.uninstall()
    }

    func testMakeScreenshots() {
        app.launch()
        
        app.buttons["Priis!"].waitForExistence(timeout: 5.0)
        app.buttons["Priis!"].tap()
        
        app.buttons["settingsButton"].tap()
        
        let expliziteInhalteErlaubenSwitch = app.collectionViews/*@START_MENU_TOKEN@*/.switches["Explizite Inhalte erlauben"]/*[[".cells.switches[\"Explizite Inhalte erlauben\"]",".switches[\"Explizite Inhalte erlauben\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        expliziteInhalteErlaubenSwitch.tap()
        expliziteInhalteErlaubenSwitch.tap()
        app.buttons.containing(.image, identifier:"Schließen").element.tap()
        app.buttons["likeButton"].tap()
        app.buttons["randomButton"].tap()
                

        
                
    }
    
    func takeScreenshot(named name: String) {
        // Take the screenshot
        let fullScreenshot = XCUIScreen.main.screenshot()
        
        // Create a new attachment to save our screenshot
        // and give it a name consisting of the "named"
        // parameter and the device name, so we can find
        // it later.
        let screenshotAttachment = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: "Screenshot-\(UIDevice.current.name)-\(name).png",
            payload: fullScreenshot.pngRepresentation,
            userInfo: nil)
            
        // Usually Xcode will delete attachments after
        // the test has run; we don't want that!
        screenshotAttachment.lifetime = .keepAlways
        
        // Add the attachment to the test log,
        // so we can retrieve it later
        add(screenshotAttachment)
    }
}

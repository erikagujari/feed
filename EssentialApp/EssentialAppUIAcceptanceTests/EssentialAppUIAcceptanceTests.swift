//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Erik Agujari on 11/4/21.
//

import XCTest
import Feed
import FeediOS

class EssentialAppUIAcceptanceTests: XCTestCase {
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {        
        let app = XCUIApplication()
        app.launch()
        XCTAssertEqual(app.cells.count, 22)
        XCTAssertEqual(app.cells.firstMatch.images.count, 1)
    }
}

//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by Erik Agujari on 16/4/21.
//

import XCTest
import FeediOS
@testable import EssentialApp

class SceneDelegateTests: XCTestCase {
    func test_sceneWillConnectToSession_configureRootViewController() {
        let sut = SceneDelegate()
        
        sut.window = UIWindow()
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is FeedViewController, "Expected a feed controller as top view controller, got \(String(describing: topController)) instead")
    }
}

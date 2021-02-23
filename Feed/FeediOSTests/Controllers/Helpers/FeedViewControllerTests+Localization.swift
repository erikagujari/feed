//
//  FeedViewControllerTests+Localization.swift
//  FeediOSTests
//
//  Created by Erik Agujari on 20/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

import Foundation
import Feed
import XCTest

extension FeedUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}

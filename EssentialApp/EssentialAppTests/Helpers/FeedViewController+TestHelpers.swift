//
//  FeedViewController+TestHelpers.swift
//  FeediOSTests
//
//  Created by Erik Agujari on 26/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

import FeediOS

extension FeedViewController {
    func simulateTapOnErrorMessage() {
        errorView?.button.simulateTap()
    }
    
    var errorMessage: String? {
        return errorView?.message
    }
}

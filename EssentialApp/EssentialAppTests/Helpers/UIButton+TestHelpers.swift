//
//  UIButton+TestHelpers.swift
//  FeediOSTests
//
//  Created by Erik Agujari on 26/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

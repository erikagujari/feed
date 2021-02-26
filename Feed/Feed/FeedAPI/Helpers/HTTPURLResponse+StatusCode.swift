//
//  HTTPURLResponse+StatusCode.swift
//  Feed
//
//  Created by Erik Agujari on 26/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

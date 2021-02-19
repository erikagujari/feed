//
//  UIImageView+Animation.swift
//  FeediOS
//
//  Created by Erik Agujari on 19/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage
        
        guard newImage != nil else { return }
        
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}

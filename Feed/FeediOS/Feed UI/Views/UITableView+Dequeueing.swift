//
//  UITableView+Dequeueing.swift
//  FeediOS
//
//  Created by Erik Agujari on 19/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//
import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}

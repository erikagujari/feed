//
//  FeedImageCell.swift
//  FeediOS
//
//  Created by Erik Agujari on 5/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//
import UIKit

public final class FeedImageCell: UITableViewCell {
    @IBOutlet public private(set) var locationContainer: UIView!
    @IBOutlet public private(set) var locationLabel: UILabel!
    @IBOutlet public private(set) var descriptionLabel: UILabel!
    @IBOutlet public private(set) var feedImageContainer: UIView!
    @IBOutlet public private(set) var feedImageView: UIImageView!
    @IBOutlet public private(set) var feedImageRetryButton: UIButton!
    
    var onRetry: (() -> Void)?
    
    @IBAction private func retryButtonTapped() {
        onRetry?()
    }
}

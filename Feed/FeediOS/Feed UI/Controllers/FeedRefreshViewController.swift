//
//  FeedRefreshViewController.swift
//  FeediOS
//
//  Created by Erik Agujari on 13/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

import UIKit

final class FeedRefreshViewController: NSObject {
    private let viewModel: FeedViewModel
    private(set) lazy var view = binded(UIRefreshControl())    
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
            
    @objc func refresh() {
        viewModel.loadFeed()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onChange = { [weak self] viewModel in
            if viewModel.isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return view
    }
}
//
//  FeedPresenterTests.swift
//  FeedTests
//
//  Created by Erik Agujari on 23/2/21.
//  Copyright © 2021 Erik Agujari. All rights reserved.
//

import XCTest

struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
}

struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

final class FeedPresenter {
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    
    init(errorView: FeedErrorView, loadingView: FeedLoadingView) {
        self.errorView = errorView
        self.loadingView = loadingView
    }
    
    func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
}

class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingFeed_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingFeed()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(errorView: view, loadingView: view)
        trackForMemoryLeaks(instance: sut)
        trackForMemoryLeaks(instance: view)
        return (sut, view)
    }
    
    private class ViewSpy: FeedErrorView, FeedLoadingView {
        func display(_ viewModel: FeedErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: FeedLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
        }
        
        var messages = Set<Message>()
    }
}

//
//  DogLikeTests.swift
//  DogLikeTests
//
//  Created by Markus Wirtz on 04.11.24.
//

import XCTest
@testable import DogLike

@MainActor
final class DogLikeTests: XCTestCase {
    private var viewModel: DogViewModel?
    private var greetingName: String?

    override func setUpWithError() throws {
        viewModel = DogViewModel()
        greetingName = "Jürgen"
    }
    override func tearDownWithError() throws {
        viewModel = nil
        greetingName = nil
    }
    
    func testExample() {}

    func greetingsTest() {
        XCTAssertEqual(viewModel?.greeting(name: greetingName!), "Welcome to DogLike, Jürgen!")
    }
    
    func testPerformanceExample() throws {
        measure {
            XCTAssertEqual(viewModel?.greeting(name: greetingName!), "Welcome to DogLike, Jürgen!")
        }
    } 
} // End Class

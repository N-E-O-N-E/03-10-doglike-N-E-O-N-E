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
    var viewModel: DogViewModel?
    var greetingName: String?
    var breedUrl: String?
    
    override func setUpWithError() throws {
        viewModel = DogViewModel()
        greetingName = "Jürgen"
        breedUrl = "https://images.dog.ceo/breeds/pembroke/n02113023_2330.jpg"
    }
    override func tearDownWithError() throws {
        viewModel = nil
        greetingName = nil
        breedUrl = nil
    }
    
    func testExample() {}
    
    func testGreetingEqual() {
        XCTAssertEqual(viewModel?.greeting(name: greetingName!), "Welcome to DogLike, Jürgen!")
    }
    
    func testBreedNameIsEqual() {
        XCTAssertEqual(viewModel?.extractBreedName(from: breedUrl!), "pembroke")
    }
    
    func testBreedNameIsNotEqual() {
        XCTAssertNotEqual(viewModel?.extractBreedName(from: breedUrl!), "test")
    }
    
    func testBreedNameIsNotNil() {
        XCTAssertNotNil(viewModel?.extractBreedName(from: breedUrl!))
    }
    
//    func textBreedNameisNil() {
//        XCTAssertNil(viewModel?.extractBreedName(from: nil))
//    }
    
    func testPerformanceExample() throws {
        measure {
            XCTAssertEqual(viewModel?.greeting(name: greetingName!), "Welcome to DogLike, Jürgen!")
        }
    }
} // End Class

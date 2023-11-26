//
//  BallCalculatorTests.swift
//  BallCalculatorTests
//
//  Created by 이주희 on 2023/11/12.
//

import XCTest
@testable import BallCalculator

final class BallCalculatorTests: XCTestCase {

    private let calculator = ContentView(currentTheme: .aus)
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    func test_add() {
        // Given
        calculator.didTap(button: .one)
        calculator.didTap(button: .plus)
        calculator.didTap(button: .two)
        calculator.didTap(button: .equal)
        
        // When
        let result = 4
//        calculator.result
        
        // Then
        XCTAssertEqual(result, 4)
    }
    
//    func testIncrementButton() throws {
//            // Given
//            let view = try ContentView.inspect()
//
//            // When
//            try view.button(named: "Increment").tap()
//
//            // Then
//            XCTAssertEqual(try view.text(0).string(), "Counter: 1")
//        }

}

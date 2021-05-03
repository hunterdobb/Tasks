//
//  PerformanceTests.swift
//  TasksTests
//
//  Created by Hunter Dobbelmann on 3/9/21.
//

import XCTest
@testable import Tasks

class PerformanceTests: BaseTestCase {
	func testAwardCalculationPerformance() throws {
		// Create a significant amount of test data
		for _ in 1...100 {
			try dataController.createSampleData()
		}
		// Simulate lots of awards to check
		let awards = Array(repeating: Award.allAwards, count: 25).joined()
		XCTAssertEqual(awards.count, 500, "This checks the number of awards is constant. Change this if you add new awards.")

		measure {
			_ = awards.filter(dataController.hasEarned)
		}
	}
}

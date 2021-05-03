//
//  AssetTests.swift
//  TasksTests
//
//  Created by Hunter Dobbelmann on 1/18/21.
//

import XCTest
@testable import Tasks

class AssetTests: XCTestCase {
	func testColorsExist() {
		for color in Project.colors {
			XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
		}
	}

	func testJSONLoadsCorrectly() {
		XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON")
	}
}

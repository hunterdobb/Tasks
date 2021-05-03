//
//  TasksTests.swift
//  TasksTests
//
//  Created by Hunter Dobbelmann on 1/18/21.
//

import CoreData
import XCTest
@testable import Tasks

class BaseTestCase: XCTestCase {
	var dataController: DataController!
	var managedObjectContext: NSManagedObjectContext!

	override func setUpWithError() throws {
		dataController = DataController(inMemory: true)
		managedObjectContext = dataController.container.viewContext
	}
}

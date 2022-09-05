//
//  DataController-Awards.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 5/12/21.
//

import CoreData
import Foundation

extension DataController {
	func hasEarned(award: Award) -> Bool {
		switch award.criterion {
		case "items":
			// returns true if they've added a certain number of items
			let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
			let awardCount = count(for: fetchRequest)
			return awardCount >= award.value

		case "complete":
			// returns true if they completed a certain number of items
			let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
			fetchRequest.predicate = NSPredicate(format: "completed = true")
			let awardCount = count(for: fetchRequest)
			return awardCount >= award.value

        case "chat": // swiftlint:disable:this switch_case_alignment
            // returns true if they posted a certain number of chat messages
            return UserDefaults.standard.integer(forKey: "chatCount") >= award.value

		default:
			// Unknown award criterion; this should never be allowed
//            fatalError("Unknown award criterion: \(award.criterion)")
			return false
		}
	}
}

//
//  Projects-CoreDataHelpers.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 11/15/20.
//

import CloudKit
import SwiftUI

extension Project {
    static let colors = [
		"Pink",
		"Purple",
		"Red",
		"Orange",
		"Gold",
		"Green",
		"Teal",
		"Light Blue",
		"Dark Blue",
		"Midnight",
		"Dark Gray",
		"Gray"
	]

    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new project")
    }

    var projectDetail: String {
        detail ?? ""
    }

    var projectColor: String {
        color ?? "Light Blue"
    }

    var projectItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }

    var projectItemsDefaultSorted: [Item] {
        projectItems.sorted { first, second in
            if first.completed == false {
                if second.completed == true {
                    return true // first should come before second
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false // second should come before first
                }
            }

            if first.priority > second.priority {
                return true // first comes first
            } else if first.priority < second.priority {
                return false // second comes first
            }

            return first.itemCreationDate < second.itemCreationDate
        }
    }

    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard originalItems.isEmpty == false else { return 0 }

        let completedItems = originalItems.filter(\.completed) // { $0.completed == true }
        return Double(completedItems.count) / Double(originalItems.count)
    }

    var label: LocalizedStringKey {
		// swiftlint:disable:next line_length
        LocalizedStringKey("\(projectTitle), \(projectItems.count) items, \(completionAmount * 100, specifier: "%g")% complete.")
    }

    static var example: Project {
		let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.closed = true
        project.creationDate = Date()

        return project
    }

    func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .title:
            return projectItems.sorted { $0.itemTitle < $1.itemTitle }
        case .creationDate:
            return projectItems.sorted { $0.itemCreationDate < $1.itemCreationDate }
        case .optimized:
            return projectItemsDefaultSorted
        }
    }

	func prepareCloudRecords(owner: String) -> [CKRecord] {
		let parentName = objectID.uriRepresentation().absoluteString
		let parentID = CKRecord.ID(recordName: parentName)
		let parent = CKRecord(recordType: "Project", recordID: parentID)
		parent["title"] = projectTitle
		parent["detail"] = projectDetail
		parent["owner"] = owner
		parent["closed"] = closed

		var records = projectItemsDefaultSorted.map { item -> CKRecord in
			let childName = item.objectID.uriRepresentation().absoluteString
			let childID = CKRecord.ID(recordName: childName)
			let child = CKRecord(recordType: "Item", recordID: childID)
			child["title"] = item.itemTitle
			child["detail"] = item.itemDetail
			child["completed"] = item.completed
			child["project"] = CKRecord.Reference(recordID: parentID, action: .deleteSelf)
			return child
		}

		records.append(parent)
		return records
	}

	func checkCloudStatus(_ completion: @escaping (Bool) -> Void) {
		let name = objectID.uriRepresentation().absoluteString
		let id = CKRecord.ID(recordName: name)
		let operation = CKFetchRecordsOperation(recordIDs: [id])
		operation.desiredKeys = ["recordID"]
		var foundCount = 0

		operation.perRecordResultBlock = { recordID, result in
			switch result {
			case .success(_):
				foundCount += 1
			case .failure(_):
				break
			}
		}

		operation.fetchRecordsResultBlock = { result in
			switch result {
			case .success:
				completion(foundCount == 1)
			case .failure(let error):
				print(error.localizedDescription)
				completion(false)
			}
		}

		CKContainer.default().publicCloudDatabase.add(operation)
	}
}

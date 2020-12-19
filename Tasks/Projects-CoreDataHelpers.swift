//
//  Projects-CoreDataHelpers.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 11/15/20.
//

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
        let controller = DataController(inMemory: true)
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
}

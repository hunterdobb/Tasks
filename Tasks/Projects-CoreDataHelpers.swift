//
//  Projects-CoreDataHelpers.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 11/15/20.
//

import Foundation

extension Project {
    var projectTitle: String {
        title ?? "New Project"
    }
    
    var projectDetail: String {
        detail ?? ""
    }
    
    var projectColor: String {
        color ?? "Light Blue"
    }
    
    var projectItems: [Item] {
        let itemsArray = items?.allObjects as? [Item] ?? []
        
        return itemsArray.sorted { first, second in
            if first.completed == false {
                if second.completed == true {
                    // first should come before second
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    // second should come before first
                    return false
                }
            }
            
            if first.priority > second.priority {
                // first comes first
                return true
            } else if first.priority < second.priority {
                // second comes first
                return false
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
}

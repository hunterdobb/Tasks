//
//  Item-CoreDataHelpers.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 11/15/20.
//

import Foundation
 
extension Item {
    enum SortOrder {
        case optimized, title, creationDate
    }
    
    var itemTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new item")
    }
    
    var itemDetail: String {
        detail ?? ""
    }
    
    var itemCreationDate: Date {
        creationDate ?? Date()
    }
    
    static var example: Item {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let item = Item(context: viewContext)
        item.title = "Example Item"
        item.detail = "This is an example item"
        item.priority = 3
        item.creationDate = Date()
        
        return item
    }
}

//
//  ProjectsViewModel.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 3/9/21.
//

import CoreData
import Foundation
import SwiftUI

extension ProjectsView {
	class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
		let dataController: DataController

		var sortOrder = Item.SortOrder.optimized
		let showClosedProjects: Bool

		private let projectsController: NSFetchedResultsController<Project>
		@Published var projects = [Project]()
        @Published var selectedItem: Item?

		@Published var showingUnlockView = false

		init(dataController: DataController, showClosedProjects: Bool) {
			self.dataController = dataController
			self.showClosedProjects = showClosedProjects

			let request: NSFetchRequest<Project> = Project.fetchRequest()
			request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)]
			request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)

			projectsController = NSFetchedResultsController(
				fetchRequest: request,
				managedObjectContext: dataController.container.viewContext,
				sectionNameKeyPath: nil,
				cacheName: nil
			)

			super.init()
			projectsController.delegate = self

			do {
				try projectsController.performFetch()
				projects = projectsController.fetchedObjects ?? []
			} catch {
				print("Failed to fetch our projects!")
			}
		}

		func addProject() {
			if dataController.addProject() == false {
				showingUnlockView.toggle()
			}
		}

		func addItem(to project: Project) {
			let item = Item(context: dataController.container.viewContext)
			item.project = project
			item.priority = 2
			item.completed = false
			item.creationDate = Date()
			dataController.save()
		}

		func delete(_ offsets: IndexSet, from project: Project) {
			let allItems = project.projectItems(using: sortOrder)

			for offset in offsets {
				let item = allItems[offset]
				dataController.delete(item)
			}

			dataController.save()
		}

        func delete(_ item: Item) {
            dataController.delete(item)
            dataController.save()
        }

		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			if let newProjects = controller.fetchedObjects as? [Project] {
				projects = newProjects
			}
		}
	}
}

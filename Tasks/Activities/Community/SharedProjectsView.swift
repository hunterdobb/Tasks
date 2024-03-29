//
//  SharedProjectsView.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 7/19/21.
//

import CloudKit
import SwiftUI

struct SharedProjectsView: View {
	static let tag: String? = "Community"

	@State private var projects = [SharedProject]()
	@State private var loadState = LoadState.inactive
	@State private var cloudError: CloudError?

	var body: some View {
		NavigationView {
			Group {
				switch loadState {
				case .inactive, .loading:
					ProgressView()
				case .noResults:
					Text("No Results")
				case .success:
					List(projects) { project in
						NavigationLink(destination: SharedItemsView(project: project)) {
							VStack(alignment: .leading) {
								Text(project.title)
									.font(.headline)

								Text(project.owner)
							}
						}
					}
					.listStyle(InsetGroupedListStyle())
				}
			}
			.navigationTitle("Shared Projects")
		}
		.onAppear(perform: fetchSharedProjects)
	}

	func fetchSharedProjects() {
		guard loadState == .inactive else { return }
		loadState = .loading

		let pred = NSPredicate(value: true)
		let sort = NSSortDescriptor(key: "creationDate", ascending: false)
		let query = CKQuery(recordType: "Project", predicate: pred)
		query.sortDescriptors = [sort]

		let operation = CKQueryOperation(query: query)
		operation.desiredKeys = ["title", "detail", "owner", "closed"]
		operation.resultsLimit = 50

		operation.recordMatchedBlock = { recordID, result in
			switch result {
			case .success(let record):
				let id = record.recordID.recordName
				let title = record["title"] as? String ?? "No title"
				let detail = record["detail"] as? String ?? ""
				let owner = record["owner"] as? String ?? "No owner"
				let closed = record["closed"] as? Bool ?? false

				let sharedProject = SharedProject(id: id, title: title, detail: detail, owner: owner, closed: closed)
				projects.append(sharedProject)
				loadState = .success
			case .failure(let error):
				cloudError = error.getCloudKitError()
			}
		}

		operation.queryResultBlock = { _ in
			if projects.isEmpty {
				loadState = .noResults
			}
		}

		CKContainer.default().publicCloudDatabase.add(operation)
	}
}

struct SharedProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        SharedProjectsView()
    }
}

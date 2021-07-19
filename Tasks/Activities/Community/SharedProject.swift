//
//  SharedProject.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 7/16/21.
//

import Foundation

struct SharedProject: Identifiable {
	let id: String
	let title: String
	let detail: String
	let owner: String
	let closed: Bool

	static let example = SharedProject(id: "1", title: "Example", detail: "Detail", owner: "Hunter", closed: false)
}

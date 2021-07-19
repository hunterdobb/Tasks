//
//  SharedItem.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 7/16/21.
//

import Foundation

struct SharedItem: Identifiable {
	let id: String
	let title: String
	let detail: String
	let completed: Bool
}

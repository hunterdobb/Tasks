//
//  EditItemView.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 11/16/20.
//

import SwiftUI

struct EditItemView: View {
    let item: Item

    @EnvironmentObject var dataController: DataController

    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool

    init(item: Item) {
        self.item = item

        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completed = State(wrappedValue: item.completed)
    }

    var body: some View {
        Form {
            Section(header: Text("Basic Settings")) {
                TextField("Item Name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }

            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority.onChange(update)) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Toggle("Mark Completed", isOn: $completed.onChange(update))
            }

            MacOnlySpacer()
        }
        .navigationTitle("Edit Item")
        .onDisappear(perform: save)
        .macOnlyPadding()
    }

    func update() {
        item.project?.objectWillChange.send()

        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = completed
    }

	func save() {
		dataController.update(item)
	}
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
    }
}

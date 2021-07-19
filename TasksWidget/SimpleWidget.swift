//
//  SimpleWidget.swift
//  TasksWidgetExtension
//
//  Created by Hunter Dobbelmann on 5/23/21.
//

import SwiftUI
import WidgetKit

struct TasksWidgetEntryView: View {
	var entry: Provider.Entry

	var body: some View {
		VStack(alignment: .leading) {
			Text("Up Next…")
				.font(.title)

			if let item = entry.items.first {
				Text(item.itemTitle)
			} else {
				Text("Nothing!")
			}
		}
	}
}

struct SimpleTasksWidget: Widget {
	let kind: String = "SimpleTasksWidget"

	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			TasksWidgetEntryView(entry: entry)
		}
		.configurationDisplayName("Up Next…")
		.description("Your #1 top-priority item.")
		.supportedFamilies([.systemSmall])
	}
}

struct TasksWidget_Previews: PreviewProvider {
	static var previews: some View {
		TasksWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
			.previewContext(WidgetPreviewContext(family: .systemSmall))
	}
}

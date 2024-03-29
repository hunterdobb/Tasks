//
//  ComplexWidget.swift
//  TasksWidgetExtension
//
//  Created by Hunter Dobbelmann on 5/23/21.
//

import SwiftUI
import WidgetKit

struct TasksWidgetMultipleEntryView: View {
	@Environment(\.widgetFamily) var widgetFamily
	@Environment(\.sizeCategory) var sizeCategory

	var entry: Provider.Entry

	var items: ArraySlice<Item> {
		let itemCount: Int

		switch widgetFamily {
		case .systemSmall:
			itemCount = 1
		case .systemLarge:
			if sizeCategory < .extraExtraLarge {
				itemCount = 5
			} else {
				itemCount = 4
			}
		default:
			if sizeCategory < .extraLarge {
				itemCount = 3
			} else {
				itemCount = 2
			}
		}

		return entry.items.prefix(itemCount)
	}

	var body: some View {
		VStack(spacing: 5) {
			ForEach(items) { item in
				HStack {
					Color(item.project?.color ?? "Light Blue")
						.frame(width: 5)
						.clipShape(Capsule())

					VStack(alignment: .leading) {
						Text(item.itemTitle)
							.font(.headline)
							.layoutPriority(1)

						if let projectTitle = item.project?.title {
							Text(projectTitle)
								.foregroundColor(.secondary)
						}
					}

					Spacer()
				}
			}
		}
		.padding(20)
	}
}

struct ComplexTasksWidget: Widget {
	let kind: String = "ComplexTasksWidget"

	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			TasksWidgetMultipleEntryView(entry: entry)
		}
		.configurationDisplayName("Up Next…")
		.description("Your most important items.")
	}
}

struct ComplexTasksWidget_Previews: PreviewProvider {
	static var previews: some View {
		TasksWidgetMultipleEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
			.previewContext(WidgetPreviewContext(family: .systemMedium))
	}
}

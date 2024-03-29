//
//  ItemListView.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 12/16/20.
//

import SwiftUI

struct ItemListView: View {
    let title: LocalizedStringKey
    @Binding var items: ArraySlice<Item>

    #if os(macOS)
    let circleSize = 16.0
    let circleStrokeWidth = 2.0
    let horizontalSpacing = 10.0
    #else
    let circleSize = 44.0
    let circleStrokeWidth = 3.0
    let horizontalSpacing = 20.0
    #endif

    var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)

            ForEach(items) { item in
                NavigationLink(destination: EditItemView(item: item)) {
                    HStack(spacing: horizontalSpacing) {
                        Circle()
                            .strokeBorder(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: circleStrokeWidth)
                            .frame(width: circleSize, height: circleSize)

                        ItemDetailRowView(item: item)
                    }
                    #if os(iOS)
                    .padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                    #endif
                }
            }
        }
    }
}

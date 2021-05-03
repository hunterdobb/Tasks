//
//  ItemListView.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 12/16/20.
//

import SwiftUI

struct ItemListView: View {
    let title: LocalizedStringKey
    let items: ArraySlice<Item>

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
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 44, height: 44)

                        ItemDetailRowView(item: item)
                    }
                    .padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                }
            }
        }
    }
}

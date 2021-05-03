//
//  ItemDetailView.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 12/16/20.
//

import SwiftUI

 struct ItemDetailRowView: View {
    let item: Item

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.itemTitle)
                .font(.title2)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if item.itemDetail.isEmpty == false {
                Text(item.itemDetail)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailRowView(item: Item.example)
    }
}

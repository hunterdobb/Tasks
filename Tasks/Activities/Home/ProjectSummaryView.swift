//
//  ProjectSummaryView.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 12/16/20.
//

import SwiftUI

struct ProjectSummaryView: View {
    @ObservedObject var project: Project

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.projectTitle)
                .font(.title2)

            Text("\(project.projectItems.count) items")
                .font(.caption)
                .foregroundColor(.secondary)

            ProgressView(value: project.completionAmount)
                .accentColor(Color(project.projectColor))
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(project.label)
//        .shadow(color: Color.black.opacity(0.2), radius: 5)
    }
}

struct ProjectSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectSummaryView(project: Project.example)
    }
}

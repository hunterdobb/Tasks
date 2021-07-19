//
//  TasksWidget.swift
//  TasksWidget
//
//  Created by Hunter Dobbelmann on 5/12/21.
//

import WidgetKit
import SwiftUI

@main
struct PortfolioWidgets: WidgetBundle {
	var body: some Widget {
		SimpleTasksWidget()
		ComplexTasksWidget()
	}
}

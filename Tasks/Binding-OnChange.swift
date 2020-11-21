//
//  Binding-OnChange.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 11/20/20.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                wrappedValue = newValue
                handler()
            }
        )
    }
}

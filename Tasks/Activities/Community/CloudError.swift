//
//  CloudError.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 2/26/22.
//

import SwiftUI

// CloudError is a type of String that we created that is Identifiable
// so we can use them as an item in an alert
struct CloudError: Identifiable, ExpressibleByStringInterpolation {
    var id: String { message }
    var message: String

    var localizedMessage: LocalizedStringKey {
        LocalizedStringKey(message)
    }

    init(stringLiteral value: String) {
        self.message = value
    }
}

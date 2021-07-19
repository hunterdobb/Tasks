//
//  SKProduct-LocalizedPrice.swift
//  Tasks
//
//  Created by Hunter Dobbelmann on 5/10/21.
//

import StoreKit

extension SKProduct {
	var localizedPrice: String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = priceLocale
		return formatter.string(from: price)!
	}
}

//
//  Ingredient.swift
//  Crafter
//
//  Created by Dave Ruest on 2024-07-24.
//

import Foundation

final class Ingredient {
	let item: Item
	let count: Int
	var cost: Int {
		self.item.buy * self.count
	}
	var value: Int {
		self.item.sell * self.count
	}

	init?(data: Ingredient.Data, itemData: [Int: Item.Data], tradeData: [Int: TradeData]) {
		guard let itemData = itemData[data.item_id] else {
			return nil
		}
		let tradeData = tradeData[data.item_id]
		self.item = Item(itemData: itemData, tradeData: tradeData)
		self.count = data.count
	}
	
	struct Data: Decodable {
		let item_id: Int
		let count: Int
	}
}

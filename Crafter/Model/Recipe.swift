//
//  Recipe.swift
//  Crafter
//
//  Created by Dave Ruest on 2024-07-24.
//

import Foundation

final class Recipe: Identifiable {
	let data: Recipe.Data
	let output: Item
	let ingredients: [Ingredient]
	
	var name: String {
		self.output.name
	}
	var vendor: Int {
		self.output.vendor
	}
	var url: URL? {
		self.output.url
	}
	var cost: Int {
		self.ingredients.reduce(0, { $0 + $1.cost })
	}
	var value: Int {
		self.ingredients.reduce(0, { $0 + $1.value })
	}
	var profit: Int? {
		guard self.output.canTrade else { return nil }
		let listingFee = max(1, Int(Double(self.value) * 0.05))
		let exchangeFee = max(1, Int(Double(self.value) * 0.1))
		return self.value - listingFee - exchangeFee
	}
	
	static func url() -> URL? {
		URL(string: "https://api.guildwars2.com/v2/recipes")
	}
	
	static func url(ids: [Int]) -> URL? {
		let idString = ids.map { String($0) }.joined(separator: ",")
		return URL(string: "https://api.guildwars2.com/v2/recipes?ids=\(idString)")
	}

	init?(recipeData: Recipe.Data, itemData: [Int: Item.Data], tradeData: [Int: TradeData]) {
		guard let item = itemData[recipeData.output_item_id] else {
			return nil
		}
		
		self.data = recipeData
		let trade = tradeData[recipeData.output_item_id]
		self.output = Item(itemData: item, tradeData: trade)
		
		var ingredients = [Ingredient]()
		for data in recipeData.ingredients {
			guard let ingredient = Ingredient(data: data, itemData: itemData, tradeData: tradeData) else {
				return nil
			}
			ingredients.append(ingredient)
		}
		self.ingredients = ingredients
	}

	struct Data: Decodable {
		let id: Int
		let output_item_id: Int
		let output_item_count: Int
		let ingredients: [Ingredient.Data]
		let type: String
		let min_rating: Int
		let disciplines: [String]

		func itemIds() -> [Int] {
			var ids = [self.output_item_id]
			ids.append(contentsOf: self.ingredients.map { $0.item_id } )
			return ids
		}
	}
}

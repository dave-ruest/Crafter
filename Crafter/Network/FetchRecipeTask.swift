//
//  FetchRecipeTask.swift
//  Crafter
//
//  Created by Dave Ruest on 2024-07-25.
//

import Combine
import Foundation

final class FetchRecipeTask {
	let ids: [Int]
	var completion: ((Result) -> Void)!
	private var cancellables: [AnyCancellable] = []
	private var recipeData: [Recipe.Data] = []
	private var itemData = [Int: Item.Data]()
	private var tradeData = [Int: TradeData]()
	
	public init(ids: [Int]) {
		self.ids = ids
	}
	
	enum Result {
		case found([Recipe])
		case failed(Error)
	}

	func start(completion: @escaping ((Result) -> Void)) {
		self.completion = completion
		self.fetch(recipeIds: self.ids)
	}
	
	private func fetch(recipeIds: [Int]) {
		guard let url = Recipe.url(ids: self.ids) else { return }
		
		let task = FetchTask<Recipe.Data>(url: url).start { result in
			switch result {
			case .found(let recipeData):
				self.fetchItems(for: recipeData)
			case .failed(let error):
				print(error)
				self.completion(.failed(error))
			}
		}
		self.cancellables.append(task)
	}
	
	private func fetchItems(for recipeData: [Recipe.Data]) {
		self.recipeData = recipeData
		let duplicates = recipeData.flatMap { $0.itemIds() }
		let itemIds = Array(Set(duplicates))
		
		guard let url = Item.url(ids: itemIds) else { return }
		
		let task = FetchTask<Item.Data>(url: url).start { result in
			switch result {
			case .found(let itemData):
				self.itemData = itemData.reduce(into: self.itemData) {
					$0[$1.id] = $1
				}
				self.fetch(prices: itemIds)
			case .failed(let error):
				print(error)
				self.completion(.failed(error))
			}
		}
		self.cancellables.append(task)
	}
	
	private func fetch(prices: [Int]) {
		guard let url = TradeData.url(ids: prices) else { return }
		
		let task = FetchTask<TradeData>(url: url).start { result in
			switch result {
			case .found(let tradeData):
				self.tradeData = tradeData.reduce(into: self.tradeData) {
					$0[$1.id] = $1
				}
				self.buildRecipes()
			case .failed(let error):
				print(error)
				self.completion(.failed(error))
			}
		}
		self.cancellables.append(task)
	}
	
	private func buildRecipes() {
		let recipes = self.recipeData.compactMap { Recipe(recipeData: $0, itemData: self.itemData, tradeData: self.tradeData) }
		self.completion(.found(recipes))
	}
}

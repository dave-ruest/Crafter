//
//  CraftModel.swift
//  Crafter
//
//  Created by Dave Ruest on 2024-07-24.
//

import Combine
import Foundation

final class CraftModel: ObservableObject {
	@Published var recipes: [Recipe] = []
	private let ids = [2861, 2845, 2917, 6470, 2850, 2853, 2880, 2890, 2911]
	private var fetchTask: FetchRecipeTask?
	
	func fetchRecipes() {
		let task = FetchRecipeTask(ids: self.ids)
		task.start(completion: { result in
			switch result {
			case .found(let recipes):
				self.recipes = recipes
			case .failed(let error):
				print(error)
			}
		})
		self.fetchTask = task
	}
}

//
//  RecipeListView.swift
//  Crafter
//
//  Created by Dave Ruest on 2024-07-24.
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
	@ObservedObject var model = CraftModel()
	
    var body: some View {
		List {
			ForEach(model.recipes, id: \.id) { recipe in
				RecipeListRow(recipe: recipe)
			}
		}
		.onAppear(perform: {
			self.model.fetchRecipes()
		})
    }
}

#Preview {
    RecipeListView()
}

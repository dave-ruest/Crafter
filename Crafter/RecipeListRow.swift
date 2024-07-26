//
//  RecipeListRow.swift
//  Crafter
//
//  Created by Dave Ruest on 2024-07-25.
//

import SwiftUI

struct RecipeListRow: View {
	let recipe: Recipe
	
	var body: some View {
		HStack {
			if let url = recipe.url {
				AsyncImage(url: url) { image in
					image.resizable()
						.cornerRadius(8.0)
				} placeholder: {
					ProgressView()
				}
				.frame(width: 48, height: 48)
				VStack(alignment: .leading) {
					Text(recipe.name)
						.fontWeight(.bold)
						.multilineTextAlignment(.leading)
					HStack {
						if let profit = recipe.profit {
							Text("Profit")
							Spacer()
							CoinView(coins: profit)
						} else {
							Text("Cost")
							Spacer()
							CoinView(coins: recipe.cost)
						}

					}
				}
			}
		}
	}
}

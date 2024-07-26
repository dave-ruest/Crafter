//
//  CoinView.swift
//  Crafter
//
//  Created by Dave Ruest on 2024-07-25.
//

import SwiftUI

struct CoinView: View {
	let coins: Int
	var copper: String {
		String(self.coins % 100)
	}
	var silver: String? {
		guard self.coins >= 100  || self.coins <= -100 else {
			return nil
		}
		return String(self.coins / 100 % 100)
	}
	var gold: String? {
		guard self.coins >= 10000 || self.coins <= -10000 else {
			return nil
		}
		return String(self.coins / 10000)
	}

	var body: some View {
		HStack(spacing: 4) {
			if let gold = self.gold {
				Text(gold)
				Image(.goldCoin)
			}
			if let silver = self.silver {
				Text(silver)
				Image(.silverCoin)
			}
			Text(self.copper)
			Image(.copperCoin)
		}
		.fontWeight(.bold)
	}
}

#Preview {
	VStack {
		CoinView(coins: -12345)
		CoinView(coins: -1234)
		CoinView(coins: -123)
		CoinView(coins: -12)
		CoinView(coins: -1)
		CoinView(coins: 0)
		CoinView(coins: 1)
		CoinView(coins: 12)
		CoinView(coins: 123)
		CoinView(coins: 1234)
		CoinView(coins: 12345)
		CoinView(coins: 123456)
	}
}

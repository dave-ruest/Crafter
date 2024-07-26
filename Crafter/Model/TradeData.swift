//
//  TradeData.swift
//  Crafter
//
//  Created by Dave Ruest on 2024-07-25.
//

import Foundation

struct TradeData: Decodable {
	let id: Int
	let whitelisted: Bool
	let buys: Price
	let sells: Price
	
	static func url(ids: [Int]) -> URL? {
		let idString = ids.map { String($0) }.joined(separator: ",")
		return URL(string: "https://api.guildwars2.com/v2/commerce/prices?ids=\(idString)")
	}

	struct Price: Decodable {
		let quantity: Int
		let unit_price: Int
	}
}

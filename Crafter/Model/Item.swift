//
//  Item.swift
//  Crafter
//
//  Created by Dave Ruest on 2024-07-24.
//

import Foundation

final class Item: Identifiable {
	var name: String {
		data.name
	}
	var vendor: Int {
		self.data.vendor_value
	}
	var buy: Int {
		self.tradeData?.buys.unit_price ?? -1
	}
	var sell: Int {
		self.tradeData?.sells.unit_price ?? -1
	}
	var url: URL? {
		URL(string: self.data.icon)
	}
	var canSell: Bool {
		!self.data.flags.contains("NoSell")
	}
	var canTrade: Bool {
		!self.data.flags.contains("SoulbindOnAcquire")
	}

	private let data: Item.Data
	private let tradeData: TradeData?
	
	static func url(ids: [Int]) -> URL? {
		let idString = ids.map { String($0) }.joined(separator: ",")
		return URL(string: "https://api.guildwars2.com/v2/items?ids=\(idString)")
	}
	
	init(itemData: Item.Data, tradeData: TradeData?) {
		self.data = itemData
		self.tradeData = tradeData
	}
	
	struct Data: Decodable {
		let id: Int
		let name: String
		let icon: String
		let rarity: String
		let type: String
		let vendor_value: Int
		let flags: [String]
		let restrictions: [String]
		let description: String?
		// details
	}
}

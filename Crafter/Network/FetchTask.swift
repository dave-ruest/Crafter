//
//  FetchTask.swift
//  Crafter
//
//  Created by Dave Ruest on 2024-07-25.
//

import Combine
import Foundation

struct FetchTask<Item: Decodable> {
	let url: URL

	func start(_ finished: @escaping ((Result) -> Void)) -> AnyCancellable {
		URLSession.shared.dataTaskPublisher(for: url)
			.subscribe(on: DispatchQueue.global(qos: .userInitiated))
			.map { $0.data }
			.decode(type: [Item].self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.sink { completion in
				if case .failure(let error) = completion {
					finished(.failed(error))
				}
			} receiveValue: { items in
				finished(.found(items))
			}
	}
	
	enum Result {
		case found([Item])
		case failed(Error)
	}
}

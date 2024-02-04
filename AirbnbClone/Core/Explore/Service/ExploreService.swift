//
//  ExploreService.swift
//  AirbnbClone
//
//  Created by 영현 on 2024/02/05.
//

import Foundation

class ExploreService {
    func fetchListings() async throws -> [Listing] {
        return DeveloperPreview.shared.listing
    }
}

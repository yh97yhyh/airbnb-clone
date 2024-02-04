//
//  ExploreViewModel.swift
//  AirbnbClone
//
//  Created by 영현 on 2024/02/05.
//

import Foundation

class ExploreViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    private let service: ExploreService
    
    init(service: ExploreService) {
        self.service = service
        
        Task { await fetchListings() }
    }
    
    func fetchListings() async {
        do {
            self.listings = try await service.fetchListings()
        } catch {
            print("DEBUG: Failed to fetch listng with error: \(error.localizedDescription)")
        }
    }
}

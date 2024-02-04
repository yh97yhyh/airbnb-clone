//
//  CustomMapView.swift
//  AirbnbClone
//
//  Created by 영현 on 2024/02/05.
//

import SwiftUI
import MapKit

struct CustomMapView: View {
    
    let listing: Listing
    let defaultMapRect = MKMapRect(x: 0, y: 0, width: 100000, height: 100000)
    
    var body: some View {
        Map(mapRect: .constant(defaultMapRect))
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct CustomMapView_Previews: PreviewProvider {
    static var previews: some View {
        CustomMapView(listing: DeveloperPreview.shared.listing[0])
    }
}

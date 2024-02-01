//
//  ListingItemView.swift
//  AirbnbClone
//
//  Created by 영현 on 2024/02/01.
//

import SwiftUI

struct ListingView: View {
    
    var images = [
        "listing-1",
        "listing-2",
        "listing-3",
        "listing-4",
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            // images
            TabView {
                ForEach(images, id: \.self) { image in
                    Image(image)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(height: 320)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .tabViewStyle(.page)
            
            // listing details
            HStack(alignment: .top) {
                // details
                VStack(alignment: .leading) {
                    Text("Miami, Florida")
                        .fontWeight(.semibold)
                    
                    Text("12 min away")
                        .foregroundColor(.gray)
                    
                    Text("Nov 3 - 10")
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 4) {
                        Text("$567")
                            .fontWeight(.semibold)
                        Text("night")
                        
                    }
                }
                
                Spacer()
                
                // rating
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                    Text("4.86")
                }
            }
            .font(.footnote)
        }
        .padding()
    }
}

struct ListingView_Previews: PreviewProvider {
    static var previews: some View {
        ListingView()
    }
}

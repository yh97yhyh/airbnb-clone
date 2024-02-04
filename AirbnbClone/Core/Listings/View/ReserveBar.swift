//
//  ReserveBar.swift
//  AirbnbClone
//
//  Created by 영현 on 2024/02/02.
//

import SwiftUI

struct ReserveBar: View {
    let listing: Listing
    
    var body: some View {
        VStack {
            Divider()
                .padding(.bottom)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("$\(listing.pricePerNight)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("Total before taxes")
                        .font(.footnote)

                    Text("Oct 15 - 20")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .underline()
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Reserve")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 140, height: 40)
                        .background(.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(.horizontal, 32)
        }
        .background(.white)
    }
}

struct ReserveBar_Previews: PreviewProvider {
    static var previews: some View {
        ReserveBar(listing: DeveloperPreview.shared.listing[0])
    }
}

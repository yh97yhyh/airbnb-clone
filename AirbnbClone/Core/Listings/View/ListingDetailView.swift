//
//  ListingDetailView.swift
//  AirbnbClone
//
//  Created by 영현 on 2024/02/01.
//

import SwiftUI
import MapKit

struct ListingDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    let listing: Listing
    @State private var cameraPosition: MapCameraPosition
    
    init(listing: Listing) {
        self.listing = listing
        
        let region = MKCoordinateRegion(
            center: listing.city == "San Jose" ? .sanjose : .nugegoda,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self._cameraPosition = State(initialValue: .region(region))
    }
    
    var body: some View {
        ScrollView {
            Group {
                ZStack(alignment: .topLeading) {
                    ListingImageCarouselView(listing: listing)
                        .frame(height: 320)
                    
                    Button {
                        dismiss()
                    } label : {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 32, height: 32)
                            }
                            .padding(32)
                    }
                    .padding(.top, 16)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(listing.title)")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                            
                            Text("\(String(format: "%.2f", listing.rating))")

                            Text(" - ")
                            
                            Text("28 reviews")
                                .underline()
                                .fontWeight(.semibold)
                        }
                        .font(.caption)
                        .foregroundStyle(.black)
                        
                        Text("\(listing.city), \(listing.state)")
                    }
                    .font(.caption)
                }
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                // host info view
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Entire \(listing.type.description) hosted by \(listing.ownerName)")
                            .font(.headline)
                            .frame(width: 250, alignment: .leading)
                        
                        HStack(spacing: 2) {
                            Text("\(listing.numberOfGuests) guests -")
                            Text("\(listing.numberOfBedrooms) bedrooms -")
                            Text("\(listing.numberOfBeds) beds -")
                            Text("\(listing.numberOfBathrooms) baths")
                        }
                        .font(.caption2)
                    }
                    .frame(width: 300, alignment: .leading)
                    
                    Spacer()
                    
                    Image("profile-photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                    
                }
                .padding()
                
                Divider()
                
                // listing features
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(listing.features) { feature in
                        HStack(spacing: 12) {
                            Image(systemName: feature.imageName)
                            
                            VStack(alignment: .leading) {
                                Text(feature.title)
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                
                                Text(feature.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding()
                
                Divider()
                
                // bedroom views
                VStack(alignment: .leading, spacing: 16) {
                    Text("Where you'll sleep")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(1...listing.numberOfBedrooms, id: \.self) { bedroom in
                                VStack {
                                    Image(systemName: "bed.double")
                                    
                                    Text("Bedroom \(bedroom)")
                                }
                                .frame(width: 132, height: 100)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                    //                .scrollTargetBehavior(.paging)
                }
                .padding()
                
                Divider()
            }
            
            Group {
                // lisiting amenities
                VStack(alignment: .leading, spacing: 16) {
                    Text("What this place offers")
                        .font(.headline)
                    
                    ForEach(listing.amenities) { amenity in
                        HStack {
                            Image(systemName: amenity.imageName)
                                .frame(width: 32)
                            
                            Text(amenity.title)
                                .font(.footnote)
                            
                            Spacer()
                        }
                    }
                }
                .padding()
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Where you'll be")
                        .font(.headline)
                    
                    Map(position: $cameraPosition)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } 
                .padding()
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea()
        .padding(.bottom, 64)
        .overlay(alignment: .bottom) {
            ReserveBar(listing: listing)
        }
    }
}

struct ListingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListingDetailView(listing: DeveloperPreview.shared.listing[0])
    }
}

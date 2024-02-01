//
//  ProfileOptionRowView.swift
//  AirbnbClone
//
//  Created by 영현 on 2024/02/02.
//

import SwiftUI

struct ProfileOptionRowView: View {
    let imageName: String
    let title: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageName)
                
                Text(title)
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            
            Divider()
        }
    }
}

struct ProfileOptionRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileOptionRowView(imageName: "gear", title: "Settings")
    }
}

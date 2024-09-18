//
//  SCPhoneInfoView.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 12.09.24.
//

import SwiftUI

struct SCPhoneInfoView: View {
    
    let image: ImageResource
    let status: String
    let isLoading: Bool
    
    init(
        image: ImageResource,
        status: String,
        isLoading: Bool
    ) {
        self.image = image
        self.status = status
        self.isLoading = isLoading
    }
    
    var body: some View {
        
        HStack(spacing: 8) {
            
            Image(image)
                .resizable()
                .frame(.extraSmall)
                .foregroundStyle(.iconPrimary)
            
            if isLoading {
                
                ProgressView()
                    .progressViewStyle(.circular)
                
            } else {
                
                Text(status)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.textPrimary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            SCRectangle()
                .fill(.backgroundSecondary)
                .shadow(radius: .shadowRadius)
        )
        .padding()
    }
}

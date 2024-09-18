//
//  SCOptimizerButtonView.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 12.09.24.
//

import SwiftUI

struct SCStorageUsageView: View {
    
    @State private var storageUsedPercentage: CGFloat = 0.0
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Background circles
            ForEach(1..<4) { i in
                Circle()
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.3 / Double(i)),
                                Color.blue.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: CGFloat(i * 20)
                    )
                    .frame(width: CGFloat(180 + i * 15), height: CGFloat(180 + i * 15))
                    .scaleEffect(isAnimating ? 1 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
            
            // Percentage and Storage Details
            VStack {
                Text("\(Int(storageUsedPercentage))%")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Storage Used")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.textButton)
                
                Text("54.9 GB of 63.9 GB")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.textButton)
            }
            .frame(width: 200, height: 200)
            .background(Circle().fill(Color.buttonPrimary))
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 8)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    SCStorageUsageView()
}

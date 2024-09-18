//
//  SCInfoView.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 16.09.24.
//

import SwiftUI

struct SCInfoView: View {
    
    @Binding var isShowing: Bool
    
    var body: some View {
        
        if isShowing {
            
            ZStack {
                
                Color.black.opacity(0.5).ignoresSafeArea()
                
                ZStack(alignment: .topTrailing) {
                    
                    VStack(spacing: 16) {
                        
                        ScrollView {
                            
                            VStack(alignment: .leading, spacing: 16) {
                                
                                // Header
                                Text("Introducing SwiftClean")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal)
                                
                                // Subheader
                                Text("Why SwiftClean is the best tool for your phone")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal)
                                
                                // Body Text
                                Text("""
                    SwiftClean is a simple yet powerful tool designed to help you manage and optimize your phone's storage. Whether you're looking to clear out unwanted files, organize your photos, or free up space for your important apps, SwiftClean has got you covered.
                    
                    With its intuitive interface, you can easily identify large files, redundant images, or duplicate contacts that take up space and slow down your device. And, the best part? SwiftClean works seamlessly in the background, ensuring that your device is always running at peak performance.
                    
                    Features include:
                    - Automatic storage analysis
                    - File categorization and recommendations
                    - One-click clean-up
                    - Duplicate file detection
                    - Cloud backup options
                    
                    Our app is built with your privacy in mind, ensuring that none of your personal data is stored without your permission. Plus, it's regularly updated to ensure it stays compatible with the latest devices and operating systems.
                    
                    If you're serious about keeping your phone in top shape, SwiftClean is the solution you’ve been waiting for. We’re dedicated to providing a fast, clean, and efficient mobile experience.
                    """)
                                .font(.body)
                                .padding(.horizontal)
                                
                                // Subsection with Emphasis
                                Text("The Future of Phone Optimization")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                Text("""
                    As mobile devices evolve, SwiftClean evolves with them. Our development team is constantly working to ensure that the app is not only up-to-date but also anticipates the needs of future technology. From cloud integration to AI-based recommendations, we're planning exciting new features that will continue to enhance your user experience.
                    
                    Thank you for choosing SwiftClean! We’re dedicated to helping you keep your phone fast, organized, and efficient, so you can focus on what matters most.
                    """)
                                .font(.body)
                                .padding(.horizontal)
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(radius: 10)
                        )
                        .padding(.horizontal)
                    }
                    
                    Button(action: {
                        
                        withAnimation {
                            isShowing = false
                        }
                    }) {
                        
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                    .padding(16)
                }
            }
        }
    }
}

//
//  SCDetailedDuplicatePhotosView.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 17.09.24.
//

import SwiftUI

struct SCDetailedDuplicatePhotosView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var detailedVM = SCDetailedDuplicatePhotosViewModel()
    @Binding var duplicatePhoto: SCDuplicatePhoto
    
    // Create grid layout with two columns
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        ZStack {
            
            Color.backgroundPrimary.ignoresSafeArea()
            
            VStack {
                
                ScrollView {
                    
                    LazyVGrid(columns: gridItems, spacing: 16) {
                        
                        ForEach(duplicatePhoto.photos) { photo in
                            
                            if let image = photo.imageData {
                                
                                // Selection logic: Highlight selected photos
                                ZStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 140) // Adjust height to fit grid
                                        .cornerRadius(20)
                                        .shadow(radius: 5)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(detailedVM.selectedPhotos.contains(photo.imageName) ? Color.blue : Color.clear, lineWidth: 4)
                                        ) // Blue border if selected
                                    
                                    // Show a checkmark when selected
                                    if detailedVM.selectedPhotos.contains(photo.imageName) {
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.blue)
                                                    .padding([.top, .trailing], 10)
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                                .onTapGesture {
                                    detailedVM.toggleSelection(of: photo.imageName)
                                }
                                .padding()
                                .background(Color.backgroundSecondary)
                                .cornerRadius(20)
                                .shadow(radius: 4)
                                
                                Text(photo.imageName)
                                    .font(.subheadline)
                                    .foregroundColor(.textPrimary)
                                    .padding(.top, 8)
                                
                            } else {
                                Text("Image not available")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                
                // Show delete button if photos are selected
                if !detailedVM.selectedPhotos.isEmpty {
                    deleteButton
                        .padding(.bottom, 10)
                }
            }
            
            // Show a loading indicator while deleting
            if detailedVM.isDeleting {
                ProgressView("Deleting photos...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5).ignoresSafeArea())
            }
        }
        .navigationTitle(duplicatePhoto.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Delete Button
    var deleteButton: some View {
        
        Button(action: {
            
            detailedVM.deleteSelectedPhotos(
                from: [duplicatePhoto]
            ) { deletedPhotos in
                duplicatePhoto.photos = deletedPhotos
                dismiss()
            }
            
        }) {
            Text("Delete Selected")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(12)
                .shadow(radius: 5)
        }
        .padding(.horizontal)
    }
}

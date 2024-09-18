//
//  SCDuplicatePhotosView.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 16.09.24.
//

import SwiftUI

struct SCDuplicatePhotosView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var duplicatePhotosVM = SCDuplicatedPhotosViewModel()
    
    var body: some View {
        
        ZStack {
            
            Color.backgroundPrimary.ignoresSafeArea()
            
            VStack {
                
                ScrollView {
                    
                    VStack(spacing: 16) {
                        
                        ForEach(duplicatePhotosVM.duplicatePhotos) { photoGroup in
                            NavigationLink {
                                SCDetailedDuplicatePhotosView(duplicatePhoto: Binding(
                                    get: { photoGroup },
                                    set: { newValue in
                                        duplicatePhotosVM.updateAfterDeletion(newValue: newValue)
                                    }
                                ))
                            } label: {
                                DuplicatePhotoRow(photo: photoGroup)
                            }
                        }


                    }
                    .padding()
                }
                
                if !duplicatePhotosVM.duplicatePhotos.isEmpty {
                    if duplicatePhotosVM.isDeleting {
                        ProgressView("Deleting...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .red))
                            .padding()
                    } else {
                        SCButton(buttonType: .text("Clear All", color: .textButton)) {
                            duplicatePhotosVM.deleteOneDuplicatePhotoPerGroup()
                            dismiss()
                        }
                        .disabled(duplicatePhotosVM.isDeleting)
                        .padding()
                    }}
            }
        }
        .toolbar {
            
            ToolbarItem(placement: .principal) {
                Text("Files to Clean Up")
                    .font(.title2.bold())
                    .foregroundColor(.textPrimary)
            }
        }
    }
}

struct DuplicatePhotoRow: View {
    
    let photo: SCDuplicatePhoto
    
    var body: some View {
        
        HStack {
            
            // Circle Indicator
            Circle()
                .fill(Color.base)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading) {
                
                Text(photo.name)
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Text("Photos: \(photo.photoCount)")
                    .font(.caption)
                    .foregroundColor(.textHelper)
            }
            
            Spacer()
            
            Text("\(String(format: "%.1f", photo.size)) MB")
                .font(.headline)
                .foregroundColor(.textPrimary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundSecondary)
                .shadow(radius: 4)
        )
    }
}

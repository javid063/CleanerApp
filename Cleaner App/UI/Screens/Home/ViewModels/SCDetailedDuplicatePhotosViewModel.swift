//
//  SCDetailedDuplicatePhotosViewModel.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 17.09.24.
//

import SwiftUI
import Photos

class SCDetailedDuplicatePhotosViewModel: ObservableObject {
    
    @Published var selectedPhotos: Set<String> = []
    @Published var isDeleting: Bool = false
    
    func deleteSelectedPhotos(from photoGroups: [SCDuplicatePhoto], completion: @escaping ([SCPhoto]) -> Void ) {
        isDeleting = true
        
        var selectedAssets = photoGroups.flatMap { group in
            group.photos.filter { selectedPhotos.contains($0.imageName) }
        }
        
        let assetIdentifiers = selectedAssets.map { $0.imageName }
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assets)
        }) { [weak self] success, error in
            guard let self else {return}
            
            DispatchQueue.main.async {
                if success {
                    print("Selected photos deleted [\(assets)]")
                    completion(self.removeDeletedPhotos(from: photoGroups, for: selectedAssets))
                } else if let error = error {
                    print("Error deleting photos: \(error.localizedDescription)")
                }
                self.isDeleting = false
            }
        }
    }
    
    private func removeDeletedPhotos(from photoGroups: [SCDuplicatePhoto], for deletedPhotos: [SCPhoto]) -> [SCPhoto] {
        selectedPhotos.removeAll()
        
        guard var photoGroup = photoGroups.first else { return [] }
        var photos: [SCPhoto] = []
        
        for deletedPhoto in deletedPhotos {
            photoGroup.photos.removeAll(where: {$0.id == deletedPhoto.id})
        }
        
        photos = photoGroup.photos
        return photos
    }
    
    func toggleSelection(of photoID: String) {
        if selectedPhotos.contains(photoID) {
            selectedPhotos.remove(photoID)
        } else {
            selectedPhotos.insert(photoID)
        }
    }
}

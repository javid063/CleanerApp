//
//  SCDuplicatedPhotosViewModel.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 18.09.24.
//

import SwiftUI
import Photos
import Combine

class SCDuplicatedPhotosViewModel: ObservableObject {
    
    @Published var duplicatePhotosCount: Int = 0
    @Published var duplicatePhotos: [SCDuplicatePhoto] = []
    @Published var selectedPhotos: Set<String> = []
    @Published var isDeleting: Bool = false
    
    init() {
        findDuplicatePhotos()
    }
    
    // MARK: - Duplicate Photos Detection
    
    func findDuplicatePhotos() {

        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self else { return }
            
            var photos: [SCPhoto] = []
            
            if status == .authorized {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                var duplicates: [SCDuplicatePhoto] = []
                var assetHashes: [String: [PHAsset]] = [:] // Dictionary to group assets by image hash
                
                // Step 1: Group assets based on image hashes
                assets.enumerateObjects { asset, _, _ in
                    
                    // Fetch the image
                    let options = PHImageRequestOptions()
                    options.isSynchronous = true
                    var image: UIImage?
                    
                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: options) { result, _ in
                        image = result
                    }
                    
                    // If image is available, calculate its hash
                    if let image = image, let hash = self.averageHash(for: image) {
                        if assetHashes[hash] != nil {
                            assetHashes[hash]?.append(asset)
                        } else {
                            assetHashes[hash] = [asset]
                        }
                        
                        // Here, we store the `localIdentifier` of the asset in `imageName`
                        let photo = SCPhoto(imageName: asset.localIdentifier, imageData: image)
                        photos.append(photo)
                    }
                }
                
                // Step 2: Find groups with more than one asset (indicating duplicates)
                for (hash, assets) in assetHashes {
                    if assets.count > 1 {
                        // Fetch image data for each asset
                        let duplicatePhotos = assets.compactMap { asset -> SCPhoto? in
                            var image: UIImage?
                            let options = PHImageRequestOptions()
                            options.isSynchronous = true
                            
                            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: options) { result, _ in
                                image = result
                            }
                            
                            if let image = image {
                                return SCPhoto(imageName: asset.localIdentifier, imageData: image) // Store UIImage
                            }
                            return nil
                        }
                        
                        let groupName = self.generateDuplicateGroupName(from: assets)
                        
                        let totalSizeMB = assets.reduce(0) { (accumulatedSize, asset) -> Double in
                            accumulatedSize + asset.fileSizeInMB()
                        }
                        
                        let duplicatePhotoGroup = SCDuplicatePhoto(
                            name: groupName,
                            photoCount: duplicatePhotos.count,
                            size: totalSizeMB,
                            photos: duplicatePhotos
                        )
                        duplicates.append(duplicatePhotoGroup)
                    }
                }
                
                DispatchQueue.main.async {
                    self.duplicatePhotos = duplicates
                }
            } else {
                print("Access to photos is denied.")
            }
        }
    }
    
    // Helper function to compare pixel data of images
    func findVisuallyIdenticalPhotos(from assets: [PHAsset]) -> [SCPhoto] {
        var photos: [SCPhoto] = []
        var identicalGroups: [[PHAsset]] = []
        
        for i in 0..<assets.count {
            guard let image1 = fetchUIImage(from: assets[i]) else { continue }
            
            for j in (i+1)..<assets.count {
                guard let image2 = fetchUIImage(from: assets[j]) else { continue }
                
                if imagesAreVisuallyIdentical(image1, image2) {
                    identicalGroups.append([assets[i], assets[j]]) // Group identical photos
                }
            }
        }
        
        for group in identicalGroups {
            let groupPhotos = group.compactMap { asset -> SCPhoto? in
                if let image = fetchUIImage(from: asset) {
                    return SCPhoto(imageName: asset.localIdentifier, imageData: image)
                }
                return nil
            }
            photos.append(contentsOf: groupPhotos)
        }
        
        return photos
    }
    
    // Fetch the UIImage from the PHAsset
    func fetchUIImage(from asset: PHAsset) -> UIImage? {
        var image: UIImage?
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: options) { result, _ in
            image = result
        }
        return image
    }
    
    
    // Compare the pixel data of two UIImages
    func imagesAreVisuallyIdentical(_ image1: UIImage, _ image2: UIImage) -> Bool {
        guard let data1 = image1.pngData(), let data2 = image2.pngData() else {
            return false
        }
        return data1 == data2 // Compare the pixel data of both images
    }
    
    
    func deleteOneDuplicatePhotoPerGroup() {
        PHPhotoLibrary.shared().performChanges({ [weak self] in
            guard let self = self else { return }
            
            for photoGroup in self.duplicatePhotos {
                
                if let firstPhotoIdentifier = photoGroup.photos.first?.imageName {
                    let assets = PHAsset.fetchAssets(withLocalIdentifiers: [firstPhotoIdentifier], options: nil)
                    
                    PHAssetChangeRequest.deleteAssets(assets)
                    self.isDeleting = true
                }
            }
        }) { [weak self] success, error in
            guard let self = self else { return }
            
            if success {
                print("One photo from each duplicate group has been deleted.")
                self.updateAfterDeletion()
            } else if let error = error {
                print("Failed to delete photos: \(error.localizedDescription)")
            }
            self.isDeleting = false
        }
    }
    
    func deleteSelectedPhotos(from photoGroups: [SCDuplicatePhoto]) {
        isDeleting = true
        
        let selectedAssets = photoGroups.flatMap { group in
            group.photos.filter { selectedPhotos.contains($0.imageName) }
        }
        
        let assetIdentifiers = selectedAssets.map { $0.imageName }
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: assetIdentifiers, options: nil)
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assets) // Request to delete the assets
        }) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    print("Selected photos deleted.")
                    // Update the UI after deletion
                    self?.removeDeletedPhotos(from: selectedAssets)
                } else if let error = error {
                    print("Error deleting photos: \(error.localizedDescription)")
                }
                self?.isDeleting = false // Stop showing loading indicator
            }
        }
    }
    
    
    private func removeDeletedPhotos(from deletedPhotos: [SCPhoto]) {
        
        selectedPhotos.removeAll()
        
        for i in 0..<duplicatePhotos.count {
            duplicatePhotos[i].photos.removeAll { photo in
                deletedPhotos.contains { $0.imageName == photo.imageName }
            }
        }
        
        duplicatePhotos.removeAll { $0.photos.isEmpty }
        
        self.objectWillChange.send()
    }
    
    func updateAfterDeletion() {
        
        for (index, photoGroup) in duplicatePhotos.enumerated() {
            if !photoGroup.photos.isEmpty {
                duplicatePhotos[index].photos.removeFirst()
            }
        }
        
        duplicatePhotos.removeAll { $0.photos.isEmpty }
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func updateAfterDeletion(newValue: SCDuplicatePhoto) {
        guard let index = duplicatePhotos.firstIndex(where: {$0.name == newValue.name}) else {return}
        duplicatePhotos.remove(at: index)
    }
}

extension SCDuplicatedPhotosViewModel {
    
    // Convert UIImage to an 8x8 grayscale image and calculate its average hash
    // Helper function to generate a group name based on the date or other metadata
    func generateDuplicateGroupName(from assets: [PHAsset]) -> String {
        // Example: Use the creation date of the first asset to generate the group name
        if let firstAsset = assets.first, let creationDate = firstAsset.creationDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return "Duplicate Group - \(formatter.string(from: creationDate))"
        }
        return "Duplicate Group"
    }

    // Helper function to compute an average hash for an image (simplified example)
    func averageHash(for image: UIImage) -> String? {
        guard let cgImage = image.cgImage else { return nil }
        
        // Resize the image to 8x8 pixels
        let size = CGSize(width: 8, height: 8)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Get the grayscale pixel data from the resized image
        guard let grayCgImage = resizedImage?.cgImage else { return nil }
        guard let context = CGContext(data: nil,
                                      width: 8,
                                      height: 8,
                                      bitsPerComponent: 8,
                                      bytesPerRow: 8,
                                      space: CGColorSpaceCreateDeviceGray(),
                                      bitmapInfo: CGImageAlphaInfo.none.rawValue) else { return nil }
        
        context.draw(grayCgImage, in: CGRect(x: 0, y: 0, width: 8, height: 8))
        guard let pixelData = context.makeImage()?.dataProvider?.data else { return nil }
        
        let data = CFDataGetBytePtr(pixelData)
        
        // Calculate the average brightness
        var totalBrightness: UInt64 = 0
        for i in 0..<64 {
            totalBrightness += UInt64(data![i])
        }
        let averageBrightness = totalBrightness / 64
        
        // Create the hash based on brightness
        var hash = ""
        for i in 0..<64 {
            hash += data![i] >= averageBrightness ? "1" : "0"
        }
        
        return hash
    }
}

//
//  Photos + Extension.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 17.09.24.
//

import Photos

extension PHAsset {
    
    // Fetches the file size of the asset
    func fileSize() -> Int {
        var fileSize: Int = 0
        let resources = PHAssetResource.assetResources(for: self)
        if let resource = resources.first {
            if let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong {
                fileSize = Int(unsignedInt64)
            }
        }
        return fileSize
    }
    
    // Converts the file size to MB
    func fileSizeInMB() -> Double {
        return Double(self.fileSize()) / (1024.0 * 1024.0) // Convert to MB
    }
}

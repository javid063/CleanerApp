//
//  SCPhoto.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 17.09.24.
//

import SwiftUI
import Photos

struct SCPhoto: Identifiable {
    var id: String { imageName }
    let imageName: String
    var imageData: UIImage?
}

//
//  SCDuplicatePhoto.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 16.09.24.
//

import SwiftUI

struct SCDuplicatePhoto: Identifiable {
    let id = UUID()
    let name: String
    let photoCount: Int
    let size: Double // in MB
    var photos: [SCPhoto]
}

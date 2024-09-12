//
//  Frame + Extension.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 12.09.24.
//

import SwiftUI

extension View {
    
    func frame(_ size: SCIconSize = .regular) -> some View {
        frame(width: size.size.width, height: size.size.height)
    }
}

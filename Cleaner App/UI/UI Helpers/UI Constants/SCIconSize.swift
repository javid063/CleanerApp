//
//  SCIconSize.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 12.09.24.
//

import SwiftUI

enum SCIconSize {
    case tiny
    case extraSmall
    case small
    case regular
    case medium
    case large
    case extraLarge
    case custom(width: CGFloat, height: CGFloat)

    var size: (width: CGFloat, height: CGFloat) {
        switch self {
        case .tiny:
            return (14, 14)
        case .extraSmall:
            return (16, 16)
        case .small:
            return (20, 20)
        case .regular:
            return (24, 24)
        case .medium:
            return (32, 32)
        case .large:
            return (40, 40)
        case .extraLarge:
            return (64, 64)
        case .custom(let width, let height):
            return (width, height)
        }
    }
}

//
//  SCButton.swift
//  Cleaner App
//
//  Created by Vusal Nuriyev 2 on 12.09.24.
//

import SwiftUI

enum SCButtonType {
    case text(String, color: Color = .textButton)
    case icon(ImageResource, color: Color = .iconPrimary)
}

struct SCButton: View {
    
    let completion: () -> Void
    
    // - UI Customizations
    var buttonType: SCButtonType
    var cornerStyle: SCCornerStyle
    var textFont: Font
    var buttonHeight: CGFloat
    var iconSize: SCIconSize
    var backgroundColor: LinearGradient
    
    // - Private
    private let shadowRadius: CGFloat = 3
    
    init(
        buttonType: SCButtonType,
        cornerStyle: SCCornerStyle = .rounded(),
        textFont: Font = .system(size: 20, weight: .semibold),
        buttonHeight: CGFloat = .buttonHeight,
        iconSize: SCIconSize = .regular,
        backgroundColor: LinearGradient = .init(colors: [.buttonPrimary, .blue], startPoint: .bottom, endPoint: .top),
        completion: @escaping () -> Void
    ) {
        
        self.completion = completion
        self.buttonType = buttonType
        self.cornerStyle = cornerStyle
        self.textFont = textFont
        self.buttonHeight = buttonHeight
        self.iconSize = iconSize
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        
        Button {
            completion()
        } label: {
            customView
        }
    }
    
    // MARK: - CustomView
    
    @ViewBuilder
    var customView: some View {
        
        switch buttonType {
            
        case .text(let string, let color):
            
            backgroundView {
                
                Text(string)
                    .font(textFont)
                    .foregroundStyle(color)
            }
            
        case .icon(let imageResource, let color):
            
            Image(imageResource)
                .resizable()
                .foregroundStyle(color)
                .frame(iconSize)
                .padding()
                .background(
                    SCRectangle()
                        .fill(.backgroundSecondary)
                        .shadow(radius: shadowRadius)
                )
        }
    }
    
    // MARK: - BackgroundView
    
    @ViewBuilder
    func backgroundView<V: View>(_ content: @escaping () -> V) -> some View {
        
        switch cornerStyle {
            
        case .rounded(let radius):
            
            ZStack {
                
                SCRectangle(radius: radius)
                    .fill(backgroundColor)
                    .shadow(radius: shadowRadius)
                
                content()
            }
            .frame(height: buttonHeight)
            
        case .capsule:
            
            ZStack {
                
                Capsule()
                    .fill(backgroundColor)
                    .shadow(radius: shadowRadius)
                
                content()
            }
            .frame(height: buttonHeight)
        }
    }
    
}

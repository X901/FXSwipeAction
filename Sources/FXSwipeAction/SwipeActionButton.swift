////
//FXSwipeActionButton.swift
//FXSwipeActionDemo
//
//Created by Basel Baragabah on 12/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
public struct SwipeActionButton: View, Identifiable {
    @Environment(\.SwipeActionsStyle) private var theme

    static let width: CGFloat = 40
    
    public let id = UUID()
    let type: Edge
    let text: Text?
    var iconType: IconType?
    let action: () -> Void
    let tint: Color
    
    public init(text: Text? = nil,
         iconType: IconType? = nil,
         type: Edge,
         action: @escaping () -> Void,
         tint: Color = .gray) {
        self.text = text
        self.iconType = iconType
        self.action = action
        self.tint = tint
        self.type = type
    }
    
    public var icon: Image? {
        switch iconType {
        case .custom(let image):
            return image
        case .system(let systemName):
            return Image(systemName: systemName)
        case .none:
            return nil
        }
    }
    
    public var body: some View {
        GeometryReader { geo in
            RoundedRectangle(cornerRadius: theme.main.cornerRadius ?? 0)
                .frame(width: UIScreen.main.bounds.width - SwipeActionButton.width)
                .frame(height: geo.size.height + (theme.main.padding ?? 10))
                .offset(y: -((theme.main.padding ?? 10)/2))
                .foregroundColor(tint)
        }.overlay(alignment: (type == .leading) ? .leading : .trailing) {
            HStack {
                if type == .leading {
                    icon?.foregroundColor(theme.style.iconColor)
                        .font(.system(size: theme.style.fontSize ?? 20))
                    
                    text?.foregroundColor(theme.style.fontColor)
                        .font(.system(size: theme.style.fontSize ?? 20))
                }
                
                Spacer()
                
                if type == .trailing {
                    text?.foregroundColor(theme.style.fontColor)
                        .font(.system(size: theme.style.fontSize ?? 20))
                    
                    icon?.foregroundColor(theme.style.iconColor)
                        .font(.system(size: theme.style.fontSize ?? 20))

                }
            }
            .padding(15 + (theme.main.swipeSpacing ?? 0) / 2 )
        }
    }
}

@available(iOS 15.0, *)
public enum IconType {
    case custom(Image)
    case system(String)
}

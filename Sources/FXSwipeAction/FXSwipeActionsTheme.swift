////
//SwipeActionsStyle.swift
//FXSwipeActionDemo
//
//Created by Basel Baragabah on 12/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
public struct FXSwipeActionsStyleKey: EnvironmentKey {
    public static var defaultValue: FXSwipeActionsTheme = FXSwipeActionsTheme()
    
}

@available(iOS 15.0, *)
public extension EnvironmentValues {
    var fxSwipeActionsStyle: FXSwipeActionsTheme {
        get { self[FXSwipeActionsStyleKey.self] }
        set { self[FXSwipeActionsStyleKey.self] = newValue }
    }
}

@available(iOS 15.0, *)
public extension View {
    func fxSwipeActionsStyle(_ style: FXSwipeActionsTheme) -> some View {
        self.environment(\.fxSwipeActionsStyle, style)
    }
    
    func fxSwipeActionsStyle(
        main: FXSwipeActionsTheme.Main = .init(),
        shadow: FXSwipeActionsTheme.Shadow = .init(),
        style: FXSwipeActionsTheme.Style = .init()
    ) -> some View {
        self.environment(\.fxSwipeActionsStyle, FXSwipeActionsTheme(main: main, shadow: shadow, style: style))
    }
}

@available(iOS 15.0, *)
public struct FXSwipeActionsTheme {
    public let main: Main
    public let shadow: Shadow
    public let style: Style

    public init(main: FXSwipeActionsTheme.Main = .init(), shadow: FXSwipeActionsTheme.Shadow = .init(), style: FXSwipeActionsTheme.Style = .init()) {
        self.main = main
        self.shadow = shadow
        self.style = style
    }
}

@available(iOS 15.0, *)
public extension FXSwipeActionsTheme {
    struct Main {
        public let cornerRadius: CGFloat?
        public let swipeSpacing: CGFloat?
        public let padding: CGFloat?

        public init(cornerRadius: CGFloat? = 30,
                    swipeSpacing: CGFloat? = 0,
                    padding: CGFloat? = 10
                    ) {

            self.cornerRadius = cornerRadius
            self.swipeSpacing = swipeSpacing
            self.padding = padding

        }
    }

    @available(iOS 15.0, *)
    struct Shadow {
        public let shadowColor: Color?
        public let shadowRadius: CGFloat?
        public let shadowOffset: CGSize?

        public init(shadowColor: Color? = Color.black.opacity(0.1),
                    shadowRadius: CGFloat? = 3,
                    shadowOffset: CGSize? = CGSize(width: 2, height: 2)
                    ) {

            self.shadowColor = shadowColor
            self.shadowRadius = shadowRadius
            self.shadowOffset = shadowOffset

        }
    }
    
    @available(iOS 15.0, *)
    struct Style {
        public let fontColor: Color?
        public let fontSize: CGFloat?
        public let iconColor: Color?
        public let backgroundColor: Color?

        public init(fontColor: Color? = Color.white,
                    fontSize: CGFloat? = 22,
                    iconColor: Color? = Color.white,
                    backgroundColor: Color? = Color.white
                    ) {

            self.fontColor = fontColor
            self.fontSize = fontSize
            self.iconColor = iconColor
            self.backgroundColor = backgroundColor
        }
    }

}

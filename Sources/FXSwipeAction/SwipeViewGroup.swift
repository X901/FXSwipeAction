////
//FXSwipeViewGroup.swift
//FXSwipeActionDemo
//
//Created by Basel Baragabah on 12/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
public struct SwipeViewGroupSelectionKey: EnvironmentKey {
    public static let defaultValue: Binding<UUID?> = .constant(nil)
}

@available(iOS 15.0, *)
public extension EnvironmentValues {
    var SwipeViewGroupSelection: Binding<UUID?> {
        get { self[SwipeViewGroupSelectionKey.self] }
        set { self[SwipeViewGroupSelectionKey.self] = newValue }
    }
}

@available(iOS 15.0, *)
public struct SwipeViewGroup<Content: View>: View {
    @ViewBuilder var content: () -> Content

    @State var selection: UUID?

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        content()
            .environment(\.SwipeViewGroupSelection, $selection)
    }
}

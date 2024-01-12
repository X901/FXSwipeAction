////
//FXSwipeViewGroup.swift
//FXSwipeActionDemo
//
//Created by Basel Baragabah on 12/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

public struct FXSwipeViewGroupSelectionKey: EnvironmentKey {
    public static let defaultValue: Binding<UUID?> = .constant(nil)
}

public extension EnvironmentValues {
    var fxSwipeViewGroupSelection: Binding<UUID?> {
        get { self[FXSwipeViewGroupSelectionKey.self] }
        set { self[FXSwipeViewGroupSelectionKey.self] = newValue }
    }
}

public struct FXSwipeViewGroup<Content: View>: View {
    @ViewBuilder var content: () -> Content

    @State var selection: UUID?

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        content()
            .environment(\.fxSwipeViewGroupSelection, $selection)
    }
}
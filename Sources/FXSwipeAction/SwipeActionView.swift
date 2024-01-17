////
//FXSwipeActionView.swift
//FXSwipeActionDemo
//
//Created by Basel Baragabah on 12/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

@available(iOS 15.0, *)
public struct SwipeActionView: ViewModifier {
    @Environment(\.SwipeActionsStyle) private var theme
    @Environment(\.SwipeViewGroupSelection) var fxswipeViewGroupSelection
    
    private static let minSwipeableWidth = (UIScreen.main.bounds.width * 0.1)
    @State private var swipeSpacing: CGFloat = 0
    let leading: SwipeActionButton?
    let trailing: SwipeActionButton?
    
    @GestureState private var dragGestureActive: Bool = false
    
    @State private var offset: CGFloat = 0
    @State private var prevOffset: CGFloat = 0
    @State private var id: UUID =  UUID()
    
    @State private var visibleButton: VisibleButton = .none
    
    @Environment(\.layoutDirection) private var layoutDirection
    
    init(leading: SwipeActionButton? = nil,
         trailing: SwipeActionButton? = nil) {
        self.leading = leading
        self.trailing = trailing
    }
    
    public func body(content: Content) -> some View {
        GeometryReader { geo in
            Group {
                
                HStack {
                    
                    if offset > 0 {
                        leadingButtonsView(geo: geo)
                    }
                    
                    
                    if offset < 0 {
                        trailingButtonsView(geo: geo)
                    }
                    
                    
                    content
                        .frame(width: geo.size.width, alignment: .center)
                        .frame(height: geo.size.height, alignment: .center)
                        .background(theme.style.backgroundColor)
                        .cornerRadius(theme.main.cornerRadius ?? 0)
                        .clipped()
                        .shadow(color: theme.shadow.shadowColor ?? .clear,
                                radius: theme.shadow.shadowRadius ?? 0,
                                x: theme.shadow.shadowOffset?.width ?? 0,
                                y: theme.shadow.shadowOffset?.height ?? 0)
                        .offset(x: calculateContentOffset(geo: geo))
                    
                }
                
            }
            .id(id)
            .animation(.spring, value: offset)
            .contentShape(Rectangle())
            .gesture(DragGesture(minimumDistance: 15,
                                 coordinateSpace: .local)
                .updating($dragGestureActive) { value, state, transaction in
                    state = true
                }
                .onChanged { gesture in
                    
                    var total: CGFloat = 0
                    
                    if layoutDirection == .rightToLeft {

                        if trailing != nil && gesture.translation.width < SwipeActionView.minSwipeableWidth {
                            
                            total = -gesture.translation.width + prevOffset
                            
                            if visibleButton == .leading || visibleButton == .trailing   {
                                offset = 0
                                
                            } else {
                                if (total > 0 && leading != nil) {
                                    offset = total + SwipeActionView.minSwipeableWidth
                                } else if  (total < 0 && trailing != nil) {
                                    offset = total - SwipeActionView.minSwipeableWidth
                                }
                            }
                        }
                        
                    } else {
                        let total = gesture.translation.width + prevOffset
                        
                        if (total > 0 && leading != nil) || (total < 0 && trailing != nil) {
                            offset = total
                        }
                        
                    }
                }
                     
                .onEnded { _ in
                    
                    if offset > SwipeActionView.minSwipeableWidth {
                        visibleButton = .leading
                        offset = SwipeActionButton.width
                        
                        if layoutDirection == .rightToLeft {
                            prevOffset = -offset
                        } else {
                            prevOffset = offset
                        }
                        
                    } else if offset < -SwipeActionView.minSwipeableWidth {
                        visibleButton = .trailing
                        offset = -SwipeActionButton.width
                        prevOffset = offset
                        
                    } else {
                        reset()
                    }
                    
                }
                     
            )
            .onChange(of: dragGestureActive) { newValue in
                if newValue == true {
                    fxswipeViewGroupSelection.wrappedValue = id
                }
                
            }
            
            .onChange(of: fxswipeViewGroupSelection.wrappedValue) { newValue in
                
                if newValue != id,
                   visibleButton != .none {
                    withAnimation(.linear(duration: 0.3)) {
                        reset()
                    }
                    fxswipeViewGroupSelection.wrappedValue = nil
                }
                
            }
            
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .onAppear {
            swipeSpacing = theme.main.swipeSpacing ?? 0
        }
        
    }
    
    @ViewBuilder private func leadingButtonsView(geo: GeometryProxy) -> some View {
        if let leadingButton = leading {
            button(for: leadingButton)
                .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    @ViewBuilder private func trailingButtonsView(geo: GeometryProxy) -> some View {
        if let trailingButton = trailing {
            button(for: trailingButton)
                .frame(width: geo.size.width, height: geo.size.height)
        }
    }
    
    private func calculateContentOffset(geo: GeometryProxy) -> CGFloat {
        if offset > 0 { // Leading swipe
            return -geo.size.width + SwipeActionButton.width + swipeSpacing
        } else if offset < 0 { // Trailing swipe
            return (-geo.size.width - SwipeActionButton.width - 15) - swipeSpacing
        } else {
            return 0
        }
    }
    
    private func reset() {
        offset = 0
        prevOffset = 0
        visibleButton = .none
    }
    
    private func button(for button: SwipeActionButton?) -> some View {
        button?
            .onTapGesture {
                button?.action()
                reset()
            }
    }
    
}

public enum SwipeState: Equatable {
    case untouched
    case swiped(UUID)
}

public enum Edge {
    case leading, trailing
}

enum VisibleButton {
    case none
    case leading
    case trailing
}

@available(iOS 15.0, *)
public extension View {
    func fxSwipeActions(
        leading: SwipeActionButton? = nil,
        trailing: SwipeActionButton? = nil) -> some View {
            modifier(SwipeActionView(leading: leading,
                                       trailing: trailing))
        }
}



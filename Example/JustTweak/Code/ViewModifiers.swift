//
//  ViewModifiers.swift
//  Copyright © 2021 Just Eat. All rights reserved.
//

import SwiftUI

fileprivate struct NavigationViewStyleStack: ViewModifier {
    func body(content: Content) -> some View {
        #if os(iOS)
        content
            .navigationViewStyle(StackNavigationViewStyle())
        #else
        content
        #endif
    }
}

extension View {
    func stackNavigationViewStyle() -> some View {
        modifier(NavigationViewStyleStack())
    }
}

fileprivate struct InlineNavigationBarTitle: ViewModifier {
    let title: String
    func body(content: Content) -> some View {
        #if os(iOS)
        content
            .navigationBarTitle(title, displayMode: .inline)
        #else
        content
        #endif
    }
}

extension View {
    func inlineNavigationBarTitle(_ title: String) -> some View {
        modifier(InlineNavigationBarTitle(title: title))
    }
}

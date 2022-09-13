//
//  View+Navigation.swift
//  Network
//
//  Created by Dylan Elliott on 13/9/2022.
//

import SwiftUI

extension View {
    func navigation<C: View, V: Hashable>(value: V, binding: Binding<V?>, @ViewBuilder linked: () -> C) -> some View {
        self
            .background(NavigationLink(destination: linked(), tag: value, selection: binding, label: { EmptyView() }).hidden())
    }
}

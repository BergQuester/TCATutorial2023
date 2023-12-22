//
//  EssentialsApp.swift
//  Essentials
//
//  Created by Daniel Bergquist on 12/7/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct EssentialsApp: App {
    static let store = Store(initialState: CounterFeature.State(), reducer: CounterFeature.init)

    var body: some Scene {
        WindowGroup {
            CounterView(store: EssentialsApp.store)
        }
    }
}

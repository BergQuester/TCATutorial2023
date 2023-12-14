//
//  TCATutorial2023App.swift
//  TCATutorial2023
//
//  Created by Daniel Bergquist on 12/7/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCATutorial2023App: App {
    static let store = Store(initialState: CounterFeature.State(), reducer: CounterFeature.init)

    var body: some Scene {
        WindowGroup {
            CounterView(store: TCATutorial2023App.store)
        }
    }
}

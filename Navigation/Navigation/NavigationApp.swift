//
//  NavigationApp.swift
//  Navigation
//
//  Created by Daniel Bergquist on 12/14/23.
//

import SwiftUI
import ComposableArchitecture

import Models
import ContactsFeature

@main
struct NavigationApp: App {
    var body: some Scene {
        WindowGroup {
            ContactsView(store:
                            Store(initialState: ContactsFeature.State()) {
                ContactsFeature()
            }
            )
        }
    }
}

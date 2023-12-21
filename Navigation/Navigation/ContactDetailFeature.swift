//
//  ContactDetailFeature.swift
//  Navigation
//
//  Created by Daniel Bergquist on 12/21/23.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct ContactDetailFeature {
    struct State: Equatable {
        let contact: Contact
    }

    enum Action {

    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {

            }
        }
    }
}

struct ContactDetailView: View {
    let store: StoreOf<ContactDetailFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Form {

            }
            .navigationBarTitle(Text(viewStore.contact.name))
        }
    }
}

#Preview {
    NavigationStack {
        ContactDetailView(
            store: Store(
                initialState: ContactDetailFeature.State(
                    contact: Contact(id: UUID(), name: "Blob")
                )
            ) {
                ContactDetailFeature()
            }
        )
    }
}

//
//  ContactDetailFeature.swift
//  Navigation
//
//  Created by Daniel Bergquist on 12/21/23.
//

import ComposableArchitecture
import SwiftUI
import Models

@Reducer
public struct ContactDetailFeature {
    @ObservableState
    public struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        public let contact: Contact

        public init(alert: AlertState<Action.Alert>? = nil, contact: Contact) {
            self.alert = alert
            self.contact = contact
        }
    }

    public enum Action: Equatable {
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        case deleteButtonTapped
        public enum Alert {
            case confirmDeletion
        }
        public enum Delegate {
            case confirmDeletion
        }
    }
    
    @Dependency(\.dismiss) var dismiss

    public init() { }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .alert(.presented(.confirmDeletion)):
                return .run { send in
                    await send(.delegate(.confirmDeletion))
                    await self.dismiss()
                }
            case .alert:
                return .none
            case .delegate:
                return .none
            case .deleteButtonTapped:
                state.alert = .confirmDeletion
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension AlertState where Action == ContactDetailFeature.Action.Alert {
    static var confirmDeletion: Self {
        Self {
            TextState("Are you sure?")
        } actions: {
            ButtonState(role: .destructive, action: .confirmDeletion) {
                TextState("Delete")
            }
        }
    }
}

public struct ContactDetailView: View {
    let store: StoreOf<ContactDetailFeature>

    public init(store: StoreOf<ContactDetailFeature>) {
        self.store = store
    }

    public var body: some View {
        Form {
            Button("Delete") {
                store.send(.deleteButtonTapped)
            }
        }
        .navigationBarTitle(Text(store.contact.name))
        .alert(store: store.scope(state: \.$alert, action: \.alert))
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

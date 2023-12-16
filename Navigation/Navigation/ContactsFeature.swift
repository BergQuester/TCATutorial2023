//
//  ContactsFeature.swift
//  Navigation
//
//  Created by Daniel Bergquist on 12/14/23.
//

import SwiftUI
import ComposableArchitecture

struct Contact: Equatable, Identifiable {
    let id: UUID
    var name: String
}

@Reducer
struct ContactsFeature {
    struct State: Equatable {
        @PresentationState var addContact: AddContactFeature.State?
        @PresentationState var alert: AlertState<Action.Alert>?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactFeature.Action>)
        case alert(PresentationAction<Alert>)
        case deleteButtonTapped(id: Contact.ID)
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddContactFeature.State(
                    contact: Contact(id: UUID(), name: "")
                )
                return .none

            case let .addContact(.presented(.delegate(.saveContact(contact)))):
                state.contacts.append(contact)
                return .none

            case .addContact:
                return .none

            case let .alert(.presented(.confirmDeletion(id: id))):
                state.contacts.remove(id: id)
                return .none

            case .alert:
                return .none

            case let .deleteButtonTapped(id: id):
                state.alert = AlertState {
                    TextState("Are you sure?")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                        TextState("Delete")
                    }
                }
                return .none
            }
        }.ifLet(\.$addContact, action: \.addContact) {
            AddContactFeature()
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

struct ContactsView: View {
    let store: StoreOf<ContactsFeature>

    var body: some View {
        NavigationStack {
            WithViewStore(store, observe: \.contacts) { viewStore in
                List {
                    ForEach(viewStore.state) { contact in
                        HStack {
                            Text(contact.name)
                            Spacer()
                            Button {
                                viewStore.send(.deleteButtonTapped(id: contact.id))
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem {
                        Button {
                            viewStore.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        .sheet(
            store: store.scope(
                state: \.$addContact,
                action: \.addContact
            )
        ) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
       .alert(
            store: store.scope(
                state: \.$alert,
                action: \.alert
            )
        )
    }
}

#Preview {
    ContactsView(store:
                    Store(initialState: ContactsFeature.State(
                        contacts: [
                            Contact(id: UUID(), name: "Blob"),
                            Contact(id: UUID(), name: "Blob Jr"),
                            Contact(id: UUID(), name: "Blob Sr"),
                        ]
                    )) {
                        ContactsFeature()
                    }
                )
}

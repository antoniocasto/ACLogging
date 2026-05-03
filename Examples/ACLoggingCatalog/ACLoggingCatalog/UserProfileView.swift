import ACLogging
import SwiftUI

struct UserProfileView: View {
    let store: CatalogLogStore

    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("User ID", text: Bindable(store).currentUserID)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Name", text: Bindable(store).currentUserName)
                    TextField("Email", text: Bindable(store).currentUserEmail)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()

                    Button {
                        store.logManager.identifyUser(
                            userId: store.currentUserID,
                            name: store.currentUserName,
                            email: store.currentUserEmail
                        )
                    } label: {
                        Label("Identify user", systemImage: "person.badge.key")
                    }
                }

                Section("Properties") {
                    TextField("Plan", text: Bindable(store).plan)
                    Toggle("Beta tester", isOn: Bindable(store).isBetaTester)

                    Button {
                        store.logManager.addUserProperties(
                            [
                                "plan": .string(store.plan),
                                "isBetaTester": .bool(store.isBetaTester),
                                "updatedAt": .date(Date())
                            ],
                            isHighPriority: true
                        )
                    } label: {
                        Label("Add user properties", systemImage: "tag")
                    }
                }

                Section("Reset") {
                    Button(role: .destructive) {
                        store.logManager.deleteUserProfile()
                    } label: {
                        Label("Delete profile", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("User")
        }
    }
}

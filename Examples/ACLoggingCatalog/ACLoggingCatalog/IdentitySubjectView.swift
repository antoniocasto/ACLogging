import ACLogging
import SwiftUI

struct IdentitySubjectView: View {
    let store: CatalogLogStore

    var body: some View {
        NavigationStack {
            Form {
                Section("Subject") {
                    TextField("Subject ID", text: Bindable(store).subjectID)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Kind", text: Bindable(store).subjectKind)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Email", text: Bindable(store).subjectEmail)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                    TextField("Role", text: Bindable(store).subjectRole)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section("Properties") {
                    TextField("Plan", text: Bindable(store).plan)
                    Toggle("Beta tester", isOn: Bindable(store).isBetaTester)
                    Button {
                        store.logManager.identify(
                            LogSubject(
                                id: store.subjectID,
                                kind: store.subjectKind,
                                properties: [
                                    "email": .string(store.subjectEmail),
                                    "role": .string(store.subjectRole),
                                    "plan": .string(store.plan),
                                    "isBetaTester": .bool(store.isBetaTester),
                                    "updatedAt": .date(Date())
                                ]
                            )
                        )
                    } label: {
                        Label("Identify subject", systemImage: "person.badge.key")
                    }
                }

                Section("Reset") {
                    Button(role: .destructive) {
                        store.logManager.clearIdentity()
                    } label: {
                        Label("Clear identity", systemImage: "trash")
                    }
                }
            }
            .navigationTitle("Identity")
        }
    }
}

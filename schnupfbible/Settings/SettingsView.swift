//
//  SettingsView.swift
//  schnupfbible
//
//  Created by Jesse Born on 19.01.23.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("vulgarContentAllowed") private var vulgarContentAllowed: Bool = false
    
    @ObservedObject private var viewModel: SubmissionViewModel
    @EnvironmentObject var firestoreManager: SBDataModel
    
    @State private var showThankYouSheet: Bool = false
    
    init(viewModel: SubmissionViewModel = SubmissionViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
            List {
                Section() {
                    Toggle("Explizite Inhalte erlauben", isOn: $vulgarContentAllowed)
                }
                Section(header: Text("SPRUCH EINREICHEN"), footer: Text("Sprüche werden in der Regel innerhalb von 2-5 Tagen gesichtet und sind anschliessend für alle Nutzer verfügbar.\nRassistische Inhalte werden nicht akzeptiert!")) {
                    TextField("Spitzname", text: $viewModel.name)
                    TextField("E-Mail", text: $viewModel.email).keyboardType(.emailAddress)
                    TextField("Titel", text: $viewModel.titel)
                    TextField("Spruch", text: $viewModel.bodytext,  axis: .vertical)
                        .lineLimit(10...20)
                    Button("Spruch Einreichen", action: {
                        firestoreManager.addSubmission(submission: Submission(title: viewModel.titel, content: viewModel.bodytext, email: viewModel.email, name: viewModel.name))
                        viewModel.clear()
                        showThankYouSheet.toggle()
                    }).disabled(!viewModel.formIsValid)
                        .welcomeSheet(isPresented: $showThankYouSheet, pages: SubmissionThankYouPages)
                }
            }.navigationTitle(Text("Einstellungen"))
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}

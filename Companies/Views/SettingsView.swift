//
//  SettingsView.swift
//  Companies
//
//  Created by ETAY LUZ - Vendor on 11/26/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var sortOrder: String
    var onUpdate: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Picker("Sort Order", selection: $sortOrder) {
                    Text("Name").tag("name")
                    Text("Market Cap").tag("marketCap")
                }
                .pickerStyle(.menu)
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onUpdate()  // Re-sort companies
                        dismiss()   // Dismiss the sheet
                    }
                }
            }
        }
    }
}

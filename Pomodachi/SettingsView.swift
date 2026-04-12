import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var studyStore: StudyStore
    @EnvironmentObject var appSettings: AppSettingsStore

    @State private var newSubject = ""

    let themes = ["System", "Light", "Dark"]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("Add a new subject", text: $newSubject)

                        Button("Add") {
                            let added = studyStore.addSubject(newSubject)
                            if added {
                                newSubject = ""
                            }
                        }
                        .fontWeight(.semibold)
                    }

                    ForEach(studyStore.subjects, id: \.self) { subject in
                        HStack {
                            Text(subject)

                            Spacer()

                            if subject == studyStore.selectedSubject {
                                Text("Current")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppTheme.primary)
                            }
                        }
                    }
                } header: {
                    Text("Subjects")
                }

                Section {
                    settingsRow(title: "Focus Duration", value: "Session-based")
                    settingsRow(title: "Short Break", value: "5 minutes")
                    settingsRow(title: "Long Break", value: "15 minutes")
                } header: {
                    Text("Timer")
                }

                Section {
                    Toggle("Auto-start Breaks", isOn: $appSettings.autoStartBreaks)
                    Toggle("Keep Screen Awake", isOn: $appSettings.keepScreenAwake)
                } header: {
                    Text("General")
                } footer: {
                    Text("Auto-start Breaks now jumps straight into the break screen after a focus session. Keep Screen Awake prevents the device from dimming during study time.")
                }

                Section {
                    Toggle("Sound Effects", isOn: $appSettings.soundEffects)
                    Toggle("Haptic Feedback", isOn: $appSettings.hapticFeedback)
                } header: {
                    Text("Feedback")
                } footer: {
                    Text("These play when a focus session is logged.")
                }

                Section {
                    Picker("Theme", selection: $appSettings.selectedTheme) {
                        ForEach(themes, id: \.self) { theme in
                            Text(theme)
                        }
                    }
                } header: {
                    Text("Appearance")
                } footer: {
                    Text("Theme updates the whole app immediately.")
                }

                Section {
                    settingsRow(title: "App Name", value: "Pomodachi")
                    settingsRow(title: "Version", value: "1.0")
                    settingsRow(title: "Mode", value: "Prototype Demo")
                } header: {
                    Text("About")
                }

                Section {
                    Button(role: .destructive) {
                        authManager.logout()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Log Out")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                } header: {
                    Text("Account")
                }
            }
            .scrollContentBackground(.hidden)
            .background(ScreenBackground())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .tint(AppTheme.primary)
        }
    }

    private func settingsRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(AppTheme.textPrimary)

            Spacer()

            Text(value)
                .foregroundStyle(AppTheme.textSecondary)
                .font(.footnote)
        }
    }
}

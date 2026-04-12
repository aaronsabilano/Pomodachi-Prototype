import SwiftUI

@main
struct PomodachiApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var studyStore = StudyStore()
    @StateObject private var appSettings = AppSettingsStore()

    var body: some Scene {
        WindowGroup {
            if authManager.isLoggedIn {
                ContentView()
                    .environmentObject(authManager)
                    .environmentObject(studyStore)
                    .environmentObject(appSettings)
                    .preferredColorScheme(appSettings.preferredColorScheme)
            } else {
                LoginView()
                    .environmentObject(authManager)
                    .environmentObject(studyStore)
                    .environmentObject(appSettings)
                    .preferredColorScheme(appSettings.preferredColorScheme)
            }
        }
    }
}

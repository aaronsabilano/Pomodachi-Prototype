import SwiftUI
import UIKit
import AudioToolbox

@MainActor
final class AppSettingsStore: ObservableObject {
    @Published var autoStartBreaks: Bool {
        didSet { UserDefaults.standard.set(autoStartBreaks, forKey: Keys.autoStartBreaks) }
    }
    @Published var keepScreenAwake: Bool {
        didSet {
            UserDefaults.standard.set(keepScreenAwake, forKey: Keys.keepScreenAwake)
            UIApplication.shared.isIdleTimerDisabled = keepScreenAwake
        }
    }
    @Published var soundEffects: Bool {
        didSet { UserDefaults.standard.set(soundEffects, forKey: Keys.soundEffects) }
    }
    @Published var hapticFeedback: Bool {
        didSet { UserDefaults.standard.set(hapticFeedback, forKey: Keys.hapticFeedback) }
    }
    @Published var selectedTheme: String {
        didSet { UserDefaults.standard.set(selectedTheme, forKey: Keys.selectedTheme) }
    }

    init() {
        let defaults = UserDefaults.standard
        self.autoStartBreaks = defaults.object(forKey: Keys.autoStartBreaks) as? Bool ?? true
        self.keepScreenAwake = defaults.object(forKey: Keys.keepScreenAwake) as? Bool ?? true
        self.soundEffects = defaults.object(forKey: Keys.soundEffects) as? Bool ?? true
        self.hapticFeedback = defaults.object(forKey: Keys.hapticFeedback) as? Bool ?? true
        self.selectedTheme = defaults.string(forKey: Keys.selectedTheme) ?? "System"
        UIApplication.shared.isIdleTimerDisabled = keepScreenAwake
    }

    var preferredColorScheme: ColorScheme? {
        switch selectedTheme {
        case "Light": return .light
        case "Dark": return .dark
        default: return nil
        }
    }

    func playCompletionFeedback() {
        if hapticFeedback {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }

        if soundEffects {
            AudioServicesPlaySystemSound(1113)
        }
    }

    private enum Keys {
        static let autoStartBreaks = "pomodachi_auto_start_breaks"
        static let keepScreenAwake = "pomodachi_keep_screen_awake"
        static let soundEffects = "pomodachi_sound_effects"
        static let hapticFeedback = "pomodachi_haptic_feedback"
        static let selectedTheme = "pomodachi_selected_theme"
    }
}

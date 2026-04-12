import SwiftUI

struct BreakTimeView: View {
    @EnvironmentObject var appSettings: AppSettingsStore

    var subject: String
    @State private var breakMinutes: Int = 5
    @State private var breakSecondsRemaining: Int = 5 * 60
    @State private var isBreakRunning = false
    @State private var timer: Timer? = nil

    var body: some View {
        ZStack {
            ScreenBackground()

            VStack(spacing: 18) {
                topTitle("POMODACHI")

                GradientPill(text: subject)

                MascotPlaceholder()

                Text("Break Time")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.textPrimary)

                SoftCard {
                    VStack(spacing: 12) {
                        Text(timeString(from: breakSecondsRemaining))
                            .font(.system(size: 46, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.textPrimary)

                        Text(isBreakRunning ? "Take a quick reset before jumping back in." : "Press start to begin your break.")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                }

                Button {
                    startBreak()
                } label: {
                    BigSoftButton(title: isBreakRunning ? "Break Running" : "Start Break", systemImage: "play.fill", bg: AppTheme.accent)
                }
                .buttonStyle(.plain)

                Button {
                    pauseBreak()
                } label: {
                    BigSoftButton(title: "Pause Break", systemImage: "pause.fill", bg: AppTheme.secondary)
                }
                .buttonStyle(.plain)

                Button {
                    resetBreak()
                } label: {
                    SecondarySoftButton(title: "Reset Break", systemImage: "arrow.counterclockwise")
                }
                .buttonStyle(.plain)

                Text("Ready to focus again?")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)

                NavigationLink {
                    HomeView()
                } label: {
                    SecondarySoftButton(title: "Return to Home", systemImage: "house.fill")
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.top, 8)
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
            isBreakRunning = false
        }
    }

    private func startBreak() {
        if breakSecondsRemaining <= 0 {
            breakSecondsRemaining = breakMinutes * 60
        }

        guard !isBreakRunning else { return }

        isBreakRunning = true
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if breakSecondsRemaining > 0 {
                breakSecondsRemaining -= 1
            } else {
                timer?.invalidate()
                timer = nil
                isBreakRunning = false
                appSettings.playCompletionFeedback()
            }
        }
    }

    private func pauseBreak() {
        isBreakRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func resetBreak() {
        pauseBreak()
        breakSecondsRemaining = breakMinutes * 60
    }

    private func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func topTitle(_ title: String) -> some View {
        HStack {
            Spacer()
            Text(title)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)
            Spacer()
            Image(systemName: "gearshape")
                .opacity(0)
                .padding(10)
        }
        .padding(.horizontal, 18)
    }
}

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var studyStore: StudyStore
    @EnvironmentObject var appSettings: AppSettingsStore

    @State private var focusMinutes: Int = 30
    @State private var secondsRemaining: Int = 30 * 60
    @State private var isRunning: Bool = false
    @State private var timer: Timer? = nil
    @State private var goToSessionComplete: Bool = false
    @State private var hasStartedSession: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                ScreenBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                    header(title: "POMODACHI")

                    VStack(spacing: 10) {
                        Text("Current Subject")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.textSecondary)

                        Menu {
                            ForEach(studyStore.subjects, id: \.self) { subject in
                                Button {
                                    studyStore.selectSubject(subject)
                                } label: {
                                    if subject == studyStore.selectedSubject {
                                        Label(subject, systemImage: "checkmark")
                                    } else {
                                        Text(subject)
                                    }
                                }
                            }
                        } label: {
                            GradientPill(text: studyStore.selectedSubject)
                        }
                        .buttonStyle(.plain)

                        Text("Tap to switch subjects")
                            .font(.caption)
                            .foregroundStyle(AppTheme.textSecondary)
                    }

                    MascotPlaceholder()

                    VStack(spacing: 4) {
                        Text("Focus Session")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppTheme.textPrimary)

                        Text("Stay locked in and finish one session at a time.")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.textSecondary)
                    }

                    SoftCard {
                        VStack(spacing: 16) {
                            Text(timeString(from: secondsRemaining))
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundStyle(AppTheme.textPrimary)

                            Text("Focus Length: \(focusMinutes) min")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.textSecondary)

                            HStack(spacing: 18) {
                                Button {
                                    guard !isRunning else { return }
                                    focusMinutes = max(1, focusMinutes - 1)
                                    secondsRemaining = focusMinutes * 60
                                } label: {
                                    Image(systemName: "minus")
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.textPrimary)
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 10)
                                        .background(Color.gray.opacity(0.10))
                                        .clipShape(Capsule())
                                }

                                Button {
                                    guard !isRunning else { return }
                                    focusMinutes = min(120, focusMinutes + 1)
                                    secondsRemaining = focusMinutes * 60
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.textPrimary)
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 10)
                                        .background(Color.gray.opacity(0.10))
                                        .clipShape(Capsule())
                                }
                            }
                            .opacity(isRunning ? 0.4 : 1.0)

                            if isRunning {
                                Label("Timer running for \(studyStore.selectedSubject)", systemImage: "sparkles")
                                    .font(.footnote)
                                    .foregroundStyle(AppTheme.secondary)
                            } else {
                                Text("Demo mode: stats only count the time you actually spent in session.")
                                    .font(.footnote)
                                    .foregroundStyle(AppTheme.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }

                    Button {
                        startTimer()
                    } label: {
                        BigSoftButton(title: isRunning ? "Focus Running" : (hasStartedSession ? "Resume Focus" : "Start Focus"), systemImage: isRunning ? "hourglass" : "play.fill", bg: AppTheme.primary)
                    }
                    .buttonStyle(.plain)
                    .disabled(isRunning)
                    .opacity(isRunning ? 0.85 : 1.0)

                    Button {
                        if isRunning {
                            pauseTimer()
                        } else {
                            stopFocusEarly()
                        }
                    } label: {
                        BigSoftButton(
                            title: isRunning ? "Pause Focus" : "Stop Focus Early",
                            systemImage: isRunning ? "pause.fill" : "stop.fill",
                            bg: AppTheme.secondary
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(!isRunning && !canStopEarly)
                    .opacity((!isRunning && !canStopEarly) ? 0.45 : 1.0)

                    Button {
                        completeSessionAndNavigate(didFinishFullSession: true)
                    } label: {
                        SecondarySoftButton(title: "Complete Focus Session (Demo)", systemImage: "flag.fill")
                    }
                    .buttonStyle(.plain)

                    Spacer(minLength: 28)
                }
                .padding(.top, 8)
                .padding(.bottom, 120)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $goToSessionComplete) {
                SessionCompleteView(subject: studyStore.selectedSubject)
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
                isRunning = false
            }
        }
    }

    @ViewBuilder
    private func header(title: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)

                Text("Your cozy focus buddy")
                    .font(.caption)
                    .foregroundStyle(AppTheme.textSecondary)
            }

            Spacer()

            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(AppTheme.primary)
                    .clipShape(Circle())
                    .shadow(color: AppTheme.primary.opacity(0.25), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 22)
    }

    private func startTimer() {
        guard !isRunning else { return }
        isRunning = true
        hasStartedSession = true

        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                pauseTimer()
                completeSessionAndNavigate(didFinishFullSession: true)
            }
        }
    }

    private var canStopEarly: Bool {
        let elapsedSeconds = (focusMinutes * 60) - secondsRemaining
        return elapsedSeconds > 0
    }

    private func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func stopFocusEarly() {
        guard canStopEarly else { return }
        completeSessionAndNavigate(didFinishFullSession: false)
    }

    private func completeSessionAndNavigate(didFinishFullSession: Bool) {
        pauseTimer()

        let loggedMinutes: Int
        if didFinishFullSession {
            loggedMinutes = focusMinutes
        } else {
            let elapsedSeconds = max(0, (focusMinutes * 60) - secondsRemaining)
            loggedMinutes = max(1, Int(ceil(Double(elapsedSeconds) / 60.0)))
        }

        studyStore.completeSession(minutes: loggedMinutes, subject: studyStore.selectedSubject)
        appSettings.playCompletionFeedback()
        hasStartedSession = false
        goToSessionComplete = true
    }

    private func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

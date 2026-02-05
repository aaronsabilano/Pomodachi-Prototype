import SwiftUI

struct HomeView: View {
    @State private var focusMinutes: Int = 30

    // Timer state
    @State private var secondsRemaining: Int = 30 * 60
    @State private var isRunning: Bool = false
    @State private var timer: Timer? = nil

    @State private var subject: String = "Math"

    // Controls navigation programmatically
    @State private var goToSessionComplete: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                header(title: "POMODACHI")

                GradientPill(text: subject)

                Circle()
                    .fill(Color.gray.opacity(0.25))
                    .frame(width: 110, height: 110)
                    .overlay(Text("Mascot").font(.caption).foregroundStyle(.gray))

                Text("Focus Session")
                    .foregroundStyle(.gray)

                SoftCard {
                    VStack(spacing: 12) {
                        Text(timeString(from: secondsRemaining))
                            .font(.system(size: 46, weight: .light))

                        // +/- adjusts the focus length ONLY when not running
                        HStack(spacing: 18) {
                            Button {
                                guard !isRunning else { return }
                                focusMinutes = max(1, focusMinutes - 1)
                                secondsRemaining = focusMinutes * 60
                            } label: {
                                Image(systemName: "minus")
                                    .font(.headline)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.15))
                                    .clipShape(Capsule())
                            }

                            Button {
                                guard !isRunning else { return }
                                focusMinutes = min(120, focusMinutes + 1)
                                secondsRemaining = focusMinutes * 60
                            } label: {
                                Image(systemName: "plus")
                                    .font(.headline)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.15))
                                    .clipShape(Capsule())
                            }
                        }
                        .opacity(isRunning ? 0.4 : 1.0)

                        if isRunning {
                            Text("Timer running…")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                    }
                }

                // ✅ Start Focus now starts the timer (no navigation)
                Button {
                    startTimer()
                } label: {
                    BigSoftButton(title: "Start Focus", systemImage: "play.fill", bg: .blue)
                }
                .buttonStyle(.plain)

                Button {
                    pauseTimer()
                } label: {
                    BigSoftButton(title: "Pause Focus", systemImage: "pause.fill", bg: .pink)
                }
                .buttonStyle(.plain)

                // Optional: manual “finish” button (handy for demos)
                Button {
                    endSessionAndNavigate()
                } label: {
                    Text("End Session (Demo)")
                        .font(.headline)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Capsule())
                        .padding(.horizontal, 28)
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.top, 8)
            .background(Color(.systemGroupedBackground))

            // ✅ Hidden navigation trigger
            .navigationDestination(isPresented: $goToSessionComplete) {
                SessionCompleteView(subject: subject)
            }

            // Clean up timer if you leave the screen
            .onDisappear {
                timer?.invalidate()
                timer = nil
                isRunning = false
            }
        }
    }

    // MARK: - Header
    @ViewBuilder
    private func header(title: String) -> some View {
        HStack {
            Spacer()
            Text(title).font(.headline)
            Spacer()

            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gearshape")
                    .font(.headline)
                    .padding(10)
            }
        }
        .padding(.horizontal, 18)
    }

    // MARK: - Timer functions
    private func startTimer() {
        guard !isRunning else { return }
        isRunning = true

        // Invalidate any old timer just in case
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                pauseTimer()
                endSessionAndNavigate()
            }
        }
    }

    private func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func endSessionAndNavigate() {
        pauseTimer()
        goToSessionComplete = true
    }

    private func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

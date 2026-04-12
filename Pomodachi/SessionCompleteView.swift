import SwiftUI

struct SessionCompleteView: View {
    @EnvironmentObject var studyStore: StudyStore
    @EnvironmentObject var appSettings: AppSettingsStore

    var subject: String
    @State private var goToBreak = false

    var body: some View {
        let subjectStats = studyStore.statsForSubject(subject)

        ZStack {
            ScreenBackground()

            VStack(spacing: 18) {
                topTitle("POMODACHI")

                MascotPlaceholder()

                Text("Great job!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(AppTheme.textPrimary)

                Text("Focus session complete")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)

                if appSettings.autoStartBreaks {
                    Label("Auto-start breaks is on", systemImage: "bolt.fill")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.secondary)
                }

                Text("\(subjectStats.totalSessions)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.primary)

                Text("total focus sessions completed for")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)

                GradientPill(text: subject)

                NavigationLink(isActive: $goToBreak) {
                    BreakTimeView(subject: subject)
                } label: {
                    EmptyView()
                }
                .hidden()

                NavigationLink {
                    BreakTimeView(subject: subject)
                } label: {
                    BigSoftButton(title: appSettings.autoStartBreaks ? "Break Ready" : "Start Break", systemImage: "cup.and.saucer.fill", bg: AppTheme.accent)
                }
                .buttonStyle(.plain)

                NavigationLink {
                    HomeView()
                } label: {
                    SecondarySoftButton(title: "Skip Break", systemImage: "forward.fill")
                }
                .buttonStyle(.plain)

                Spacer()
            }
            .padding(.top, 8)
        }
        .onAppear {
            guard appSettings.autoStartBreaks else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                goToBreak = true
            }
        }
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

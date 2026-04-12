import SwiftUI

struct StatsView: View {
    @EnvironmentObject var studyStore: StudyStore

    var body: some View {
        let selectedStats = studyStore.statsForSelectedSubject()
        let totalHours = Double(selectedStats.totalFocusMinutes) / 60.0
        let averageHours = selectedStats.averageMinutesPerActiveDay / 60.0
        let bestSubject = studyStore.sortedSubjectStats.max(by: { $0.totalFocusMinutes < $1.totalFocusMinutes })
        let weeklyTotal = selectedStats.lastSevenDaysTotalMinutes
        let streak = selectedStats.currentStreakDays

        NavigationStack {
            ZStack {
                ScreenBackground()

                ScrollView {
                    VStack(spacing: 18) {
                        header(title: "POMODACHI")

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

                        VStack(spacing: 6) {
                            Text("Your Study Progress")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(AppTheme.textPrimary)

                            Text("A cleaner snapshot of how your sessions are stacking up.")
                                .font(.footnote)
                                .foregroundStyle(AppTheme.textSecondary)
                        }

                        SoftCard {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("This Subject at a Glance")
                                    .font(.headline)
                                    .foregroundStyle(AppTheme.textPrimary)

                                HStack(spacing: 12) {
                                    MiniStatPill(value: "\(selectedStats.totalSessions)", label: "Sessions")
                                    MiniStatPill(value: String(format: "%.1f", totalHours), label: "Hours")
                                    MiniStatPill(value: "\(streak)", label: "Streak")
                                }
                            }
                        }

                        StatCard(
                            icon: "calendar.badge.clock",
                            value: "\(weeklyTotal)",
                            label: "Minutes in the last 7 days"
                        )

                        StatCard(
                            icon: "chart.line.uptrend.xyaxis",
                            value: String(format: "%.1f", averageHours),
                            label: "Avg daily hours on \(studyStore.selectedSubject)"
                        )

                        StatCard(
                            icon: "square.stack.3d.up.fill",
                            value: "\(studyStore.totalSessionsAllSubjects)",
                            label: "Sessions across all subjects"
                        )

                        StatCard(
                            icon: "calendar",
                            value: "\(selectedStats.activeStudyDays)",
                            label: "Active study days for \(studyStore.selectedSubject)"
                        )

                        if let bestSubject {
                            SoftCard {
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(AppTheme.secondary.opacity(0.14))
                                            .frame(width: 54, height: 54)

                                        Image(systemName: "crown.fill")
                                            .foregroundStyle(AppTheme.secondary)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Most focused subject")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(AppTheme.textPrimary)

                                        Text("\(bestSubject.subjectName) • \(bestSubject.totalFocusMinutes) min logged")
                                            .font(.footnote)
                                            .foregroundStyle(AppTheme.textSecondary)
                                    }

                                    Spacer()
                                }
                            }
                        }

                        SoftCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Subject Breakdown")
                                    .font(.headline)
                                    .foregroundStyle(AppTheme.textPrimary)

                                ForEach(studyStore.sortedSubjectStats, id: \.subjectName) { item in
                                    let share = studyStore.totalMinutesAllSubjects == 0 ? 0 : Double(item.totalFocusMinutes) / Double(studyStore.totalMinutesAllSubjects)

                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(item.subjectName)
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(AppTheme.textPrimary)

                                                Text("\(item.totalSessions) sessions • \(item.totalFocusMinutes) min")
                                                    .font(.caption)
                                                    .foregroundStyle(AppTheme.textSecondary)
                                            }

                                            Spacer()

                                            if item.subjectName == studyStore.selectedSubject {
                                                Text("Selected")
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(AppTheme.primary)
                                            }
                                        }

                                        GeometryReader { geo in
                                            ZStack(alignment: .leading) {
                                                Capsule()
                                                    .fill(Color.black.opacity(0.06))
                                                    .frame(height: 10)

                                                Capsule()
                                                    .fill(
                                                        LinearGradient(
                                                            colors: [AppTheme.primary, AppTheme.secondary],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                                    .frame(width: max(10, geo.size.width * share), height: 10)
                                            }
                                        }
                                        .frame(height: 10)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }

                        Spacer(minLength: 16)
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
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

                Text("Track your consistency")
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
            }
        }
        .padding(.horizontal, 22)
    }
}

struct StatCard: View {
    var icon: String
    var value: String
    var label: String

    var body: some View {
        SoftCard {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppTheme.primary.opacity(0.12))
                        .frame(width: 52, height: 52)

                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(AppTheme.primary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(value)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(AppTheme.textPrimary)

                    Text(label)
                        .font(.footnote)
                        .foregroundStyle(AppTheme.textSecondary)
                }

                Spacer()
            }
        }
    }
}

struct MiniStatPill: View {
    var value: String
    var label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(AppTheme.textPrimary)

            Text(label)
                .font(.caption2)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

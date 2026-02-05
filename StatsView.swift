import SwiftUI

struct StatsView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                header(title: "POMODACHI")

                GradientPill(text: "Math")

                StatCard(icon: "pencil", value: "100", label: "Study Sessions")
                StatCard(icon: "clock", value: "50", label: "Total Hours Studied")
                StatCard(icon: "arrow.triangle.2.circlepath", value: "1.5", label: "Daily Average Hours Spent\non Math")

                Spacer()
            }
            .padding(.top, 8)
            .background(Color(.systemGroupedBackground))
        }
    }

    @ViewBuilder
    private func header(title: String) -> some View {
        HStack {
            Spacer()
            Text(title).font(.headline)
            Spacer()
            NavigationLink { SettingsView() } label: {
                Image(systemName: "gearshape")
                    .font(.headline)
                    .padding(10)
            }
        }
        .padding(.horizontal, 18)
    }
}

struct StatCard: View {
    var icon: String
    var value: String
    var label: String

    var body: some View {
        SoftCard {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(label)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
            }
        }
    }
}

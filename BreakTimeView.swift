import SwiftUI

struct BreakTimeView: View {
    var subject: String
    @State private var breakMinutes: Int = 5

    var body: some View {
        VStack(spacing: 18) {
            topTitle("POMODACHI")

            GradientPill(text: subject)

            Circle()
                .fill(Color.gray.opacity(0.25))
                .frame(width: 110, height: 110)
                .overlay(Text("Mascot").font(.caption).foregroundStyle(.gray))

            Text("Break Time")
                .foregroundStyle(.gray)

            SoftCard {
                Text("\(breakMinutes):00")
                    .font(.system(size: 46, weight: .light))
            }

            Button {} label: {
                BigSoftButton(title: "Start Break", systemImage: "play.fill", bg: .blue)
            }
            .buttonStyle(.plain)

            Button {} label: {
                BigSoftButton(title: "Pause Focus", systemImage: "pause.fill", bg: .pink)
            }
            .buttonStyle(.plain)

            Text("Ready to focus again?")
                .font(.footnote)
                .foregroundStyle(.gray)

            // Back to home quickly
            NavigationLink {
                HomeView()
            } label: {
                Text("Return to Home")
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
    }

    private func topTitle(_ title: String) -> some View {
        HStack {
            Spacer()
            Text(title).font(.headline)
            Spacer()
            Image(systemName: "gearshape").opacity(0)
                .padding(10)
        }
        .padding(.horizontal, 18)
    }
}


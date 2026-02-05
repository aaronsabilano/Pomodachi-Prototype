import SwiftUI

struct SessionCompleteView: View {
    var subject: String
    @State private var sessionCount: Int = 1

    var body: some View {
        VStack(spacing: 18) {
            topTitle("POMODACHI")

            Circle()
                .fill(Color.gray.opacity(0.25))
                .frame(width: 110, height: 110)
                .overlay(Text("Mascot").font(.caption).foregroundStyle(.gray))

            Text("Great job!")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Focus session complete")
                .font(.subheadline)
                .foregroundStyle(.gray)

            Text("\(sessionCount)")
                .font(.system(size: 56, weight: .bold))

            Text("focus session completed for")
                .font(.footnote)
                .foregroundStyle(.gray)

            GradientPill(text: subject)

            NavigationLink {
                BreakTimeView(subject: subject)
            } label: {
                BigSoftButton(title: "Start Break", systemImage: "cup.and.saucer.fill", bg: .green)
            }
            .buttonStyle(.plain)

            Button {} label: {
                BigSoftButton(title: "Skip Break", systemImage: "forward.fill", bg: .yellow)
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
            Image(systemName: "gearshape").opacity(0) // keeps spacing similar
                .padding(10)
        }
        .padding(.horizontal, 18)
    }
}

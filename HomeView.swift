import SwiftUI

struct HomeView: View {
    @State private var focusMinutes: Int = 30
    @State private var subject: String = "Math"

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                header(title: "POMODACHI")

                GradientPill(text: subject)

                // Mascot placeholder
                Circle()
                    .fill(Color.gray.opacity(0.25))
                    .frame(width: 110, height: 110)
                    .overlay(Text("Mascot").font(.caption).foregroundStyle(.gray))

                Text("Focus Session")
                    .foregroundStyle(.gray)

                SoftCard {
                    VStack(spacing: 12) {
                        Text("\(focusMinutes):00")
                            .font(.system(size: 46, weight: .light))

                        HStack(spacing: 18) {
                            Button {
                                focusMinutes = max(1, focusMinutes - 1)
                            } label: {
                                Image(systemName: "minus")
                                    .font(.headline)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.15))
                                    .clipShape(Capsule())
                            }

                            Button {
                                focusMinutes = min(120, focusMinutes + 1)
                            } label: {
                                Image(systemName: "plus")
                                    .font(.headline)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.15))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }

                // Prototype navigation to next screen
                NavigationLink {
                    SessionCompleteView(subject: subject)
                } label: {
                    BigSoftButton(title: "Start Focus", systemImage: "play.fill", bg: .blue)
                }
                .buttonStyle(.plain)

                Button {} label: {
                    BigSoftButton(title: "Pause Focus", systemImage: "pause.fill", bg: .pink)
                }
                .buttonStyle(.plain)

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
}

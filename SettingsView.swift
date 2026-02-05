import SwiftUI

struct SettingsView: View {
    @State private var setting1On = true
    @State private var setting5On = true
    @State private var setting2Value = 1
    @State private var setting6Value = 1
    @State private var starred3 = false
    @State private var starred4 = true
    @State private var starred7 = false
    @State private var starred8 = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                header(title: "POMODACHI")

                List {
                    Toggle("Setting 1", isOn: $setting1On)

                    Stepper("Setting 2", value: $setting2Value, in: 0...10)

                    settingRow("Setting 3", isStarred: $starred3)
                    settingRow("Setting 4", isStarred: $starred4)

                    Toggle("Setting 5", isOn: $setting5On)

                    Stepper("Setting 6", value: $setting6Value, in: 0...10)

                    settingRow("Setting 7", isStarred: $starred7)
                    settingRow("Setting 8", isStarred: $starred8)
                }
            }
            .background(Color(.systemGroupedBackground))
        }
    }

    @ViewBuilder
    private func header(title: String) -> some View {
        HStack {
            Spacer()
            Text(title).font(.headline)
            Spacer()
            Image(systemName: "gearshape")
                .font(.headline)
                .padding(10)
                .opacity(0.9)
        }
        .padding(.horizontal, 18)
        .padding(.top, 8)
    }

    private func settingRow(_ title: String, isStarred: Binding<Bool>) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text("Detail")
                .font(.footnote)
                .foregroundStyle(.gray)
            Button {
                isStarred.wrappedValue.toggle()
            } label: {
                Image(systemName: isStarred.wrappedValue ? "star.fill" : "star")
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.plain)
        }
    }
}

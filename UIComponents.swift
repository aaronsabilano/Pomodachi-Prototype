import SwiftUI

struct GradientPill: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.headline)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.pink.opacity(0.6), Color.purple.opacity(0.35)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(radius: 6, y: 4)
            .padding(.horizontal, 28)
    }
}

struct SoftCard<Content: View>: View {
    var content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
            .padding(.horizontal, 22)
    }
}

struct BigSoftButton: View {
    var title: String
    var systemImage: String? = nil
    var bg: Color

    var body: some View {
        HStack {
            if let systemImage {
                Image(systemName: systemImage)
            }
            Text(title).font(.headline)
        }
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(bg.opacity(0.35))
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.10), radius: 10, x: 0, y: 6)
        .padding(.horizontal, 28)
    }
}

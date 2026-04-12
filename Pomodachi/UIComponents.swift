import SwiftUI

enum AppTheme {
    static let background = Color(red: 248/255, green: 244/255, blue: 255/255)
    static let card = Color.white
    static let primary = Color(red: 122/255, green: 92/255, blue: 255/255)
    static let secondary = Color(red: 255/255, green: 122/255, blue: 182/255)
    static let accent = Color(red: 120/255, green: 200/255, blue: 255/255)
    static let textPrimary = Color.black.opacity(0.85)
    static let textSecondary = Color.black.opacity(0.55)
}

struct ScreenBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                AppTheme.background,
                Color.white,
                Color(red: 240/255, green: 248/255, blue: 255/255)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

struct GradientPill: View {
    var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "book.fill")
                .font(.subheadline)

            Text(text)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .foregroundStyle(.white)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [AppTheme.primary, AppTheme.secondary],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(Capsule())
        .shadow(color: AppTheme.primary.opacity(0.25), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 24)
    }
}

struct SoftCard<Content: View>: View {
    var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(AppTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.8), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.08), radius: 14, x: 0, y: 8)
            .padding(.horizontal, 22)
    }
}

struct BigSoftButton: View {
    var title: String
    var systemImage: String? = nil
    var bg: Color

    var body: some View {
        HStack(spacing: 10) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.headline)
            }

            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .foregroundStyle(.white)
        .padding(.vertical, 15)
        .frame(maxWidth: .infinity)
        .background(bg)
        .clipShape(Capsule())
        .shadow(color: bg.opacity(0.25), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 28)
    }
}

struct SecondarySoftButton: View {
    var title: String
    var systemImage: String? = nil

    var body: some View {
        HStack(spacing: 10) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.headline)
            }

            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .foregroundStyle(AppTheme.textPrimary)
        .padding(.vertical, 15)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.9))
        .clipShape(Capsule())
        .overlay(
            Capsule().stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 28)
    }
}

struct MascotPlaceholder: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [AppTheme.primary.opacity(0.18), AppTheme.secondary.opacity(0.18)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 120)

            Image(systemName: "timer")
                .font(.system(size: 40, weight: .medium))
                .foregroundStyle(AppTheme.primary)
        }
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

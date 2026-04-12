import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager

    @State private var email = ""
    @State private var password = ""
    @State private var isCreatingAccount = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Spacer()

                Text("POMODACHI")
                    .font(.headline)

                Circle()
                    .fill(Color.gray.opacity(0.25))
                    .frame(width: 110, height: 110)
                    .overlay(Text("Mascot").font(.caption).foregroundStyle(.gray))

                Text(isCreatingAccount ? "Create Account" : "Log In")
                    .font(.title2)
                    .fontWeight(.semibold)

                VStack(spacing: 12) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 24)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.footnote)
                        .padding(.horizontal, 24)
                }

                Button {
                    handlePrimaryAction()
                } label: {
                    BigSoftButton(
                        title: isCreatingAccount ? "Create Account" : "Log In",
                        systemImage: "person.fill",
                        bg: AppTheme.primary
                    )
                }
                .buttonStyle(.plain)

                Button {
                    isCreatingAccount.toggle()
                    errorMessage = ""
                } label: {
                    Text(isCreatingAccount ? "Already have an account? Log In" : "Need an account? Sign Up")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.primary)
                }

                SoftCard {
                    VStack(spacing: 6) {
                        Text("Prototype sign-in")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppTheme.textPrimary)

                        Text("This build uses lightweight local demo auth so the focus flow can be previewed without a full backend yet.")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)

                        Divider()

                        Text("Demo account")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppTheme.textSecondary)

                        Text("demo@pomodachi.app")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.textPrimary)

                        Text("password123")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.textPrimary)
                    }
                }

                Spacer()
            }
            .padding(.top, 8)
            .background(Color(.systemGroupedBackground))
        }
    }

    private func handlePrimaryAction() {
        errorMessage = ""

        if isCreatingAccount {
            if let error = authManager.signUp(email: email, password: password) {
                errorMessage = error
            }
        } else {
            if let error = authManager.login(email: email, password: password) {
                errorMessage = error
            }
        }
    }
}

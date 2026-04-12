//
//  AuthManager.swift
//  Pomodachi
//
//  Created by Myles Romans on 2026-03-15.
//

import Foundation
import SwiftUI

struct AppUser: Codable, Equatable {
    let id: String
    let email: String
    let password: String
}

final class AuthManager: ObservableObject {
    @Published var currentUser: AppUser? = nil
    @Published var isLoggedIn: Bool = false

    private let usersKey = "pomodachi_users"
    private let currentUserKey = "pomodachi_current_user"

    init() {
        seedDemoUserIfNeeded()
        loadCurrentUser()
    }

    func signUp(email: String, password: String) -> String? {
        let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cleanedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanedEmail.isEmpty, !cleanedPassword.isEmpty else {
            return "Email and password cannot be empty."
        }

        var users = loadUsers()

        if users.contains(where: { $0.email == cleanedEmail }) {
            return "That email is already registered."
        }

        let newUser = AppUser(
            id: UUID().uuidString,
            email: cleanedEmail,
            password: cleanedPassword
        )

        users.append(newUser)
        saveUsers(users)

        currentUser = newUser
        isLoggedIn = true
        saveCurrentUser(newUser)

        return nil
    }

    func login(email: String, password: String) -> String? {
        let cleanedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cleanedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        let users = loadUsers()

        guard let matchedUser = users.first(where: {
            $0.email == cleanedEmail && $0.password == cleanedPassword
        }) else {
            return "Invalid email or password."
        }

        currentUser = matchedUser
        isLoggedIn = true
        saveCurrentUser(matchedUser)

        return nil
    }

    func logout() {
        currentUser = nil
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }

    private func seedDemoUserIfNeeded() {
        var users = loadUsers()

        let demoEmail = "demo@pomodachi.app"
        let demoPassword = "password123"

        if !users.contains(where: { $0.email == demoEmail }) {
            let demoUser = AppUser(
                id: UUID().uuidString,
                email: demoEmail,
                password: demoPassword
            )
            users.append(demoUser)
            saveUsers(users)
        }
    }

    private func loadUsers() -> [AppUser] {
        guard let data = UserDefaults.standard.data(forKey: usersKey),
              let users = try? JSONDecoder().decode([AppUser].self, from: data) else {
            return []
        }
        return users
    }

    private func saveUsers(_ users: [AppUser]) {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: usersKey)
        }
    }

    private func saveCurrentUser(_ user: AppUser) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: currentUserKey)
        }
    }

    private func loadCurrentUser() {
        guard let data = UserDefaults.standard.data(forKey: currentUserKey),
              let savedUser = try? JSONDecoder().decode(AppUser.self, from: data) else {
            currentUser = nil
            isLoggedIn = false
            return
        }

        currentUser = savedUser
        isLoggedIn = true
    }
}

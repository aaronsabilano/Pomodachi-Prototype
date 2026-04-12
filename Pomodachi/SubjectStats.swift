//
//  SubjectStats.swift
//  Pomodachi
//
//  Created by Maddox Duggan on 2026-04-11.
//


import Foundation
import SwiftUI

struct SubjectStats: Codable, Hashable {
    var subjectName: String
    var totalSessions: Int
    var totalFocusMinutes: Int
    var dailyMinutes: [String: Int]

    init(
        subjectName: String,
        totalSessions: Int = 0,
        totalFocusMinutes: Int = 0,
        dailyMinutes: [String: Int] = [:]
    ) {
        self.subjectName = subjectName
        self.totalSessions = totalSessions
        self.totalFocusMinutes = totalFocusMinutes
        self.dailyMinutes = dailyMinutes
    }

    var activeStudyDays: Int {
        max(1, dailyMinutes.keys.count)
    }

    var averageMinutesPerActiveDay: Double {
        guard !dailyMinutes.isEmpty else { return 0 }
        return Double(totalFocusMinutes) / Double(dailyMinutes.keys.count)
    }


    var lastSevenDaysTotalMinutes: Int {
        let calendar = Calendar.current
        return (0..<7).reduce(0) { partialResult, offset in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: Date()) else {
                return partialResult
            }
            let key = Self.dayFormatter.string(from: date)
            return partialResult + (dailyMinutes[key] ?? 0)
        }
    }

    var currentStreakDays: Int {
        let calendar = Calendar.current
        var streak = 0

        for offset in 0..<365 {
            guard let date = calendar.date(byAdding: .day, value: -offset, to: Date()) else { break }
            let key = Self.dayFormatter.string(from: date)

            if (dailyMinutes[key] ?? 0) > 0 {
                streak += 1
            } else {
                break
            }
        }

        return streak
    }

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

private struct StoredStudyData: Codable {
    var selectedSubject: String
    var subjects: [String]
    var stats: [String: SubjectStats]
}

final class StudyStore: ObservableObject {
    @Published var selectedSubject: String
    @Published var subjects: [String]
    @Published private(set) var stats: [String: SubjectStats]

    private let storageKey = "pomodachi_study_store"

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let stored = try? JSONDecoder().decode(StoredStudyData.self, from: data) {
            self.selectedSubject = stored.selectedSubject
            self.subjects = stored.subjects
            self.stats = stored.stats
        } else {
            let defaults = ["Math", "Science", "English", "History"]
            self.selectedSubject = "Math"
            self.subjects = defaults
            self.stats = Dictionary(
                uniqueKeysWithValues: defaults.map { ($0, SubjectStats(subjectName: $0)) }
            )
            save()
        }

        ensureValidState()
    }

    func selectSubject(_ subject: String) {
        guard subjects.contains(subject) else { return }
        selectedSubject = subject
        save()
    }

    @discardableResult
    func addSubject(_ subject: String) -> Bool {
        let cleaned = cleanSubject(subject)

        guard !cleaned.isEmpty else { return false }
        guard !subjects.contains(where: { $0.caseInsensitiveCompare(cleaned) == .orderedSame }) else {
            return false
        }

        subjects.append(cleaned)
        subjects.sort()
        stats[cleaned] = SubjectStats(subjectName: cleaned)

        if selectedSubject.isEmpty {
            selectedSubject = cleaned
        }

        save()
        return true
    }

    func completeSession(minutes: Int, subject: String? = nil) {
        let chosenSubject = subject ?? selectedSubject
        let safeMinutes = max(1, minutes)

        if !subjects.contains(chosenSubject) {
            subjects.append(chosenSubject)
            subjects.sort()
        }

        var existing = stats[chosenSubject] ?? SubjectStats(subjectName: chosenSubject)
        existing.totalSessions += 1
        existing.totalFocusMinutes += safeMinutes

        let todayKey = Self.dayFormatter.string(from: Date())
        existing.dailyMinutes[todayKey, default: 0] += safeMinutes

        stats[chosenSubject] = existing
        selectedSubject = chosenSubject
        save()
    }

    func statsForSelectedSubject() -> SubjectStats {
        statsForSubject(selectedSubject)
    }

    func statsForSubject(_ subject: String) -> SubjectStats {
        stats[subject] ?? SubjectStats(subjectName: subject)
    }

    var totalSessionsAllSubjects: Int {
        stats.values.reduce(0) { $0 + $1.totalSessions }
    }

    var totalMinutesAllSubjects: Int {
        stats.values.reduce(0) { $0 + $1.totalFocusMinutes }
    }

    var sortedSubjectStats: [SubjectStats] {
        subjects.map { statsForSubject($0) }
    }

    private func cleanSubject(_ subject: String) -> String {
        subject
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func ensureValidState() {
        if subjects.isEmpty {
            subjects = ["Math"]
        }

        for subject in subjects {
            if stats[subject] == nil {
                stats[subject] = SubjectStats(subjectName: subject)
            }
        }

        if !subjects.contains(selectedSubject) {
            selectedSubject = subjects[0]
        }

        save()
    }

    private func save() {
        let payload = StoredStudyData(
            selectedSubject: selectedSubject,
            subjects: subjects,
            stats: stats
        )

        if let data = try? JSONEncoder().encode(payload) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
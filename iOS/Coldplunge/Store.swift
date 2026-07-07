import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [Entry] = []
    @Published var categoryEnabled: Bool = true

    /// Free tier allows well above the seed count so a fresh install never hits the paywall immediately.
    static let freeLimit = 40

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Coldplunge", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
        if entries.isEmpty {
            entries = [
        Entry(seconds: "120", tempF: "50", notes: ""),
        Entry(seconds: "180", tempF: "45", notes: ""),
        Entry(seconds: "90", tempF: "55", notes: "")
            ]
            save()
        }
    }

    var canAddMore: Bool {
        entries.count < Store.freeLimit
    }

    func add(_ entry: Entry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: Entry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: Entry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Entry].self, from: data) {
            entries = decoded
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}

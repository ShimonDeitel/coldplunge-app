import Foundation

struct Entry: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var seconds: String
    var tempF: String
    var notes: String

    init(id: UUID = UUID(), date: Date = Date(), seconds: String = "", tempF: String = "", notes: String = "") {
        self.id = id
        self.date = date
        self.seconds = seconds
        self.tempF = tempF
        self.notes = notes
    }
}

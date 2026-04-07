import Foundation
import FirebaseFirestore

struct ToDoCollection: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var data: [ToDoType]
    var title: String
    @ServerTimestamp var updatedAt: Date?
    
    var safeId: String {
        return id ?? ""
    }
}

struct ToDoType: Codable, Identifiable, Hashable {
    var id: String?
    var text: String
    var isCompleted: Bool
    var date: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case isCompleted = "is_completed"
        case date
    }
}

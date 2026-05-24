import Foundation

struct Message: Identifiable, Equatable {
    let id = UUID()
    let role: Role
    let content: String
    let timestamp: Date
    var isStreaming: Bool

    enum Role {
        case user
        case assistant
    }

    init(role: Role, content: String, isStreaming: Bool = false) {
        self.role = role
        self.content = content
        self.timestamp = Date()
        self.isStreaming = isStreaming
    }
}

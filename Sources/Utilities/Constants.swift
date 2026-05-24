import Foundation

enum Constants {
    static let defaultKnowledgeBasePath = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent("knowledge-base").path

    static let claudeCLIPath = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".local/bin/claude").path

    enum UserDefaults {
        static let knowledgeBasePath = "knowledgeBasePath"
        static let claudeAPIKey = "claudeAPIKey"
        static let enableVoice = "enableVoice"
        static let enableProactiveMonitoring = "enableProactiveMonitoring"
    }
}

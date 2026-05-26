import Foundation

struct Skill: Codable, Identifiable {
    let id: String          // == name
    let name: String
    let description: String
    let type: String
    let frequency: String?
    let duration: String?
    let lastUpdated: String?
    let filePath: String    // Path to .md file

    init(name: String, description: String, type: String, frequency: String? = nil, duration: String? = nil, lastUpdated: String? = nil, filePath: String) {
        self.id = name
        self.name = name
        self.description = description
        self.type = type
        self.frequency = frequency
        self.duration = duration
        self.lastUpdated = lastUpdated
        self.filePath = filePath
    }
}

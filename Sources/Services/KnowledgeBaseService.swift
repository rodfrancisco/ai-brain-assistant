import Foundation

class KnowledgeBaseService {
    let basePath: String

    init(basePath: String) {
        self.basePath = basePath
    }

    func loadProfile() -> String? {
        loadFile(at: "context/profile.md")
    }

    func loadCurrentInitiatives() -> String? {
        loadFile(at: "context/work/current-initiatives.md")
    }

    func loadStakeholderMap() -> String? {
        loadFile(at: "context/communication/stakeholder-map.md")
    }

    func loadToneOfVoice() -> String? {
        loadFile(at: "context/tone-of-voice.md")
    }

    func loadTechnicalDomains() -> String? {
        loadFile(at: "context/work/technical-domains.md")
    }

    func loadTodaysSummary() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())

        return loadFile(at: "summaries/daily/start-day-\(today).md")
    }

    private func loadFile(at relativePath: String) -> String? {
        let fullPath = (basePath as NSString).appendingPathComponent(relativePath)
        return try? String(contentsOfFile: fullPath, encoding: .utf8)
    }
}

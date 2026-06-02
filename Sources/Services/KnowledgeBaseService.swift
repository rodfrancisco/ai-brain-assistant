import Foundation

class KnowledgeBaseService {
    let basePath: String

    // Cache storage
    private var cachedProfile: String?
    private var cachedInitiatives: String?
    private var cachedStakeholders: String?
    private var cachedToneOfVoice: String?
    private var cachedTechnicalDomains: String?
    private var cachedTodaysSummary: (date: String, content: String)?
    private var cacheLoadedAt: Date?

    private let cacheLifetime: TimeInterval = 300  // 5 minutes

    init(basePath: String) {
        self.basePath = basePath
    }

    // Public method to force cache refresh
    func refreshCache() {
        cachedProfile = nil
        cachedInitiatives = nil
        cachedStakeholders = nil
        cachedToneOfVoice = nil
        cachedTechnicalDomains = nil
        cachedTodaysSummary = nil
        cacheLoadedAt = nil
        print("[INFO] Knowledge base cache cleared")
    }

    // Check if cache is valid
    private func isCacheValid() -> Bool {
        guard let loadedAt = cacheLoadedAt else { return false }
        return Date().timeIntervalSince(loadedAt) < cacheLifetime
    }

    func loadProfile() -> String? {
        if isCacheValid(), let cached = cachedProfile {
            return cached
        }

        let content = loadFileSync(at: "context/profile.md")
        cachedProfile = content

        if cacheLoadedAt == nil {
            cacheLoadedAt = Date()
        }

        return content
    }

    func loadProfileAsync() async -> String? {
        if isCacheValid(), let cached = cachedProfile {
            return cached
        }

        let content = await loadFileAsync(at: "context/profile.md")
        cachedProfile = content

        if cacheLoadedAt == nil {
            cacheLoadedAt = Date()
        }

        return content
    }

    func loadCurrentInitiatives() -> String? {
        if isCacheValid(), let cached = cachedInitiatives {
            return cached
        }

        let content = loadFileSync(at: "context/work/current-initiatives.md")
        cachedInitiatives = content

        if cacheLoadedAt == nil {
            cacheLoadedAt = Date()
        }

        return content
    }

    func loadStakeholderMap() -> String? {
        if isCacheValid(), let cached = cachedStakeholders {
            return cached
        }

        let content = loadFileSync(at: "context/communication/stakeholder-map.md")
        cachedStakeholders = content

        if cacheLoadedAt == nil {
            cacheLoadedAt = Date()
        }

        return content
    }

    func loadToneOfVoice() -> String? {
        if isCacheValid(), let cached = cachedToneOfVoice {
            return cached
        }

        let content = loadFileSync(at: "context/tone-of-voice.md")
        cachedToneOfVoice = content

        if cacheLoadedAt == nil {
            cacheLoadedAt = Date()
        }

        return content
    }

    func loadTechnicalDomains() -> String? {
        if isCacheValid(), let cached = cachedTechnicalDomains {
            return cached
        }

        let content = loadFileSync(at: "context/work/technical-domains.md")
        cachedTechnicalDomains = content

        if cacheLoadedAt == nil {
            cacheLoadedAt = Date()
        }

        return content
    }

    func loadTodaysSummary() -> String? {
        let today = getCurrentDateString()

        if let cached = cachedTodaysSummary,
           cached.date == today {
            return cached.content
        }

        let content = loadFileSync(at: "summaries/daily/start-day-\(today).md")
        cachedTodaysSummary = (date: today, content: content ?? "")

        return content
    }

    private func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    // Synchronous file loading (for backward compatibility)
    private func loadFileSync(at relativePath: String) -> String? {
        let fullPath = (basePath as NSString).appendingPathComponent(relativePath)
        return try? String(contentsOfFile: fullPath, encoding: .utf8)
    }

    // Async file loading (runs on background thread)
    private func loadFileAsync(at relativePath: String) async -> String? {
        let fullPath = (basePath as NSString).appendingPathComponent(relativePath)
        return await Task.detached {
            try? String(contentsOfFile: fullPath, encoding: .utf8)
        }.value
    }

    // Async versions of all load methods
    func loadCurrentInitiativesAsync() async -> String? {
        if isCacheValid(), let cached = cachedInitiatives {
            return cached
        }

        let content = await loadFileAsync(at: "context/work/current-initiatives.md")
        cachedInitiatives = content

        if cacheLoadedAt == nil {
            cacheLoadedAt = Date()
        }

        return content
    }

    func loadStakeholderMapAsync() async -> String? {
        if isCacheValid(), let cached = cachedStakeholders {
            return cached
        }

        let content = await loadFileAsync(at: "context/communication/stakeholder-map.md")
        cachedStakeholders = content

        if cacheLoadedAt == nil {
            cacheLoadedAt = Date()
        }

        return content
    }

    func loadToneOfVoiceAsync() async -> String? {
        if isCacheValid(), let cached = cachedToneOfVoice {
            return cached
        }

        let content = await loadFileAsync(at: "context/tone-of-voice.md")
        cachedToneOfVoice = content

        if cacheLoadedAt == nil {
            cacheLoadedAt = Date()
        }

        return content
    }

    func loadTechnicalDomainsAsync() async -> String? {
        if isCacheValid(), let cached = cachedTechnicalDomains {
            return cached
        }

        let content = await loadFileAsync(at: "context/work/technical-domains.md")
        cachedTechnicalDomains = content

        if cacheLoadedAt == nil {
            cacheLoadedAt = Date()
        }

        return content
    }

    func loadTodaysSummaryAsync() async -> String? {
        let today = getCurrentDateString()

        if let cached = cachedTodaysSummary,
           cached.date == today {
            return cached.content
        }

        let content = await loadFileAsync(at: "summaries/daily/start-day-\(today).md")
        cachedTodaysSummary = (date: today, content: content ?? "")

        return content
    }
}

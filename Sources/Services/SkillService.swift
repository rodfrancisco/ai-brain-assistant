import Foundation

class SkillService {
    private let knowledgeBasePath: String
    var availableSkills: [Skill] = []

    init(knowledgeBasePath: String) {
        self.knowledgeBasePath = knowledgeBasePath
    }

    // Scan .claude/skills/ directory for *.md files
    func loadSkills() -> [Skill] {
        let skillsPath = (knowledgeBasePath as NSString).appendingPathComponent(".claude/skills")

        guard let fileURLs = try? FileManager.default.contentsOfDirectory(
            at: URL(fileURLWithPath: skillsPath),
            includingPropertiesForKeys: nil
        ) else {
            print("[WARN] Could not read skills directory: \(skillsPath)")
            return []
        }

        let markdownFiles = fileURLs.filter { $0.pathExtension == "md" && $0.lastPathComponent != "README.md" }

        availableSkills = markdownFiles.compactMap { url in
            parseSkill(filePath: url.path)
        }

        print("[INFO] Loaded \(availableSkills.count) skills: \(availableSkills.map { $0.name }.joined(separator: ", "))")

        return availableSkills
    }

    // Parse YAML frontmatter from markdown
    func parseSkill(filePath: String) -> Skill? {
        guard let content = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            print("[WARN] Could not read skill file: \(filePath)")
            return nil
        }

        // Extract YAML frontmatter between --- markers
        let lines = content.components(separatedBy: .newlines)
        guard lines.first == "---" else {
            print("[WARN] No frontmatter in: \(filePath)")
            return nil
        }

        // Find closing ---
        guard let closingIndex = lines.dropFirst().firstIndex(of: "---") else {
            print("[WARN] Unclosed frontmatter in: \(filePath)")
            return nil
        }

        let frontmatterLines = lines[1..<closingIndex]
        var metadata: [String: String] = [:]

        // Parse key: value pairs
        for line in frontmatterLines {
            let parts = line.split(separator: ":", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2 {
                metadata[parts[0]] = parts[1]
            }
        }

        // Extract required fields
        guard let name = metadata["name"],
              let description = metadata["description"],
              let type = metadata["type"] else {
            print("[WARN] Missing required fields in: \(filePath)")
            return nil
        }

        return Skill(
            name: name,
            description: description,
            type: type,
            frequency: metadata["frequency"],
            duration: metadata["duration"],
            lastUpdated: metadata["last_updated"],
            filePath: filePath
        )
    }

    // Execute skill via Claude Code CLI
    func executeSkill(name: String) async throws -> String {
        print("[INFO] Executing skill: \(name)")

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/Users/rfrancisco/.local/bin/claude")
        process.currentDirectoryURL = URL(fileURLWithPath: knowledgeBasePath)
        process.arguments = ["/\(name)"]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""

        print("[INFO] Skill \(name) completed with exit code: \(process.terminationStatus)")

        if process.terminationStatus != 0 {
            throw SkillExecutionError.executionFailed(name: name, output: output)
        }

        return output
    }
}

enum SkillExecutionError: Error {
    case executionFailed(name: String, output: String)

    var localizedDescription: String {
        switch self {
        case .executionFailed(let name, let output):
            return "Skill '\(name)' failed:\n\(output)"
        }
    }
}
